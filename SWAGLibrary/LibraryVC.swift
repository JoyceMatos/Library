//
//  ViewController.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

// TODO: - Go over arguement labels and Swifty syntax
// TODO: - The app should allow users to update a book information
// TODO: - The app should allow users to delete all books at once
// TODO: - Remove notification at some point

class LibraryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteLibraryButton: UIButton!
    @IBOutlet weak var addBookButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    let store = LibraryDataStore.sharedInstance
    var alertDelegate: AlertDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        alertDelegate = self
        
        observe()        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
    
    
    // TODO: - Protocol for observing/reloading/refreshing
    func observe() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVC(notification:)), name: .dismiss, object: nil)
        
    }
    
    func reloadVC(notification: NSNotification) {
        fetch()
    }
    
    func fetch() {
        self.store.getBooks { (success) in
            
            // TODO: - If success do something, if not do something else
            print("inside fetching")
            DispatchQueue.main.async {
                print("about to reload data")
                self.tableView.reloadData()
            }
            print("data has been reloaded")
        }
    }
    
    
    // TODO: - Configure views called when validating menu button ; Setup enum for hiding buttons and switch
    
    func configureViews() {
        
        deleteLibraryButton.isHidden = true
        addBookButton.isHidden = true
        
        }
    
    @IBAction func menuPressed(_ sender: Any) {
        
        
    }
    
    
    
    @IBAction func deleteLibraryTapped(_ sender: Any) {
        // TODO: - Ask: Are you sure you want to delete?
        
        LibraryAPIClient.sharedInstance.delete {
            DispatchQueue.global().async {
                
                // TODO: - Refresh Screen
                self.fetch()
            }
        }
    }
    
    
    
    
    func alertAction(_ book: Int) {
        let deleteMessage = AlertMessage(title: "Delete", message: "Are you sure you want to delete this book?")
        self.alertDelegate?.displayAlert(message: deleteMessage, with: { _ in
            
            // Abstract this function even further?
            LibraryAPIClient.sharedInstance.delete(book: book, completion: { (success) in
                
                // TODO: - handle if not success
                
                if success {
                    DispatchQueue.global(qos: .userInitiated).async {
                        self.fetch()
                    }
                }
            })
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Switch on segue identifier
        if segue.identifier == SegueIdentifier.showDetail {
            let destVC = segue.destination as! DetailVC
            guard let indexPath = tableView.indexPath(for: sender as! UITableViewCell) else {
                return
            }
            destVC.book = store.books[indexPath.row]
        }
        
        if segue.identifier == "showEditVC" {
            let destVC = segue.destination as! EditBookVC
            guard let indexPath = tableView.indexPath(for: sender as! UITableViewCell) else {
                return
            }
            destVC.book = store.books[indexPath.row]
        }
    }
    
}

extension LibraryVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.bookCell, for: indexPath) as! BookCell
        let book = store.books[indexPath.row]
        
        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.author
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let bookID = self.store.books[indexPath.row].id as! Int
        
        // Refactor?
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                self.alertAction(bookID)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // TODO: - Display a window for editing
            
            // Sender is tableviewcell
            self.performSegue(withIdentifier: "showEditVC", sender: tableView.cellForRow(at: indexPath))
        }
        return [delete, edit]
    }

    
}

extension LibraryVC: AlertDelegate {
    
    func displayAlert(message type: AlertMessage, with handler: @escaping (Any?) -> Void) {
        
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in

                handler(nil)
        })
        
        alert.addAction(cancel)
        alert.addAction(yes)
        
        self.present(alert, animated: true, completion: nil)
 
    }   
    
}

