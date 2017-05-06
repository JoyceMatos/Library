//
//  ViewController.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

// TODO: - Create an empty state for data
// TODO: - Update delete message: "Are you sure you want to delete "book" by "author"?
// TODO: - Consider using delegation as opposed to NotificationCenter
// TODO: - Change alpha when removing an item
// TODO: - Add instructions: Swipe to delete or edit


class LibraryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteLibraryButton: UIButton!
    @IBOutlet weak var addBookButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    let refresher = UIRefreshControl()
    
    let store = LibraryDataStore.sharedInstance
    var alertDelegate: AlertDelegate?
    var didDisplayOptions = false
    
    
    // MARK: - View Lifecyle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Attach these in storyboard?
        tableView.delegate = self
        tableView.dataSource = self
        
        alertDelegate = self
        
        fetch()
        observe()
        refresh()
        hideMenuButtons()
    }
    
    
    // MARK: - Refresh Methods
    
    func refresh() {
        if #available (iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
        
        refresher.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        
    }
    
    func refreshView() {
        fetch()
        refresher.endRefreshing()
    }
    
    // MARK: - Observe Methods
    
    // TODO: - Protocol for observing/reloading/refreshing
    func observe() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVC(notification:)), name: .update, object: nil)
    }
    
    func reloadVC(notification: NSNotification) {
        fetch()
    }
    
    // MARK: - Data Store Method
    
    func fetch() {
        self.store.getBooks { (success) in
            if !success {
                print("Uh oh, trouble fetching books")
                // Handle error
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - View Method
    
    // TODO: - Configure views called when validating menu button ; Setup enum for hiding buttons and switch
    func showMenuButtons() {
        deleteLibraryButton.isHidden = false
        addBookButton.isHidden = false
        
        // TODO: - Animate menu button state
    }
    
    func hideMenuButtons() {
        deleteLibraryButton.isHidden = true
        addBookButton.isHidden = true
        
        // TODO: - Animate menu button state

    }
    
    // MARK: - Action Methods
    
    @IBAction func menuPressed(_ sender: Any) {
        // TODO: - Create enum or function that validates this info 
        
        if didDisplayOptions == false {
            didDisplayOptions = true
            showMenuButtons()
            
        } else {
            didDisplayOptions = false
            hideMenuButtons()
        }
        
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "showFilterVC", sender: self)
    }
    

    
    
    
    @IBAction func deleteLibraryTapped(_ sender: Any) {
        // TODO: - Ask user: Are you sure you want to delete?
        
        LibraryAPIClient.sharedInstance.delete { (success) in
            if !success {
                print("Uh oh, could not delete library")
            }
            
            self.fetch()
            
        }
        
    }
    
    
    
    func alertAction(_ book: Int) {
        let deleteMessage = AlertMessage(title: "Delete", message: "Are you sure you want to delete this book?")
        self.alertDelegate?.displayAlert(message: deleteMessage, with: { _ in
            
            // Abstract this function even further?
            LibraryAPIClient.sharedInstance.delete(book: book, completion: { (success) in
                
                if !success {
                    print("Uh oh, could not delete book")
                }
                
                DispatchQueue.global(qos: .userInitiated).async {
                    self.fetch()
                }
            })
        })
    }
    
    
    // MARK: - Segue Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Switch on segue identifier
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case SegueIdentifier.showDetailVC:
            
            let destVC = segue.destination as! DetailVC
            guard let indexPath = tableView.indexPath(for: sender as! UITableViewCell) else {
                return
            }
            destVC.book = store.books[indexPath.row]
        case SegueIdentifier.showEditVC:
            let destVC = segue.destination as! EditBookVC
            guard let indexPath = tableView.indexPath(for: sender as! UITableViewCell) else {
                return
            }
            destVC.book = store.books[indexPath.row]
        default:
            print("Could not segue")
            // Handle
        }
    }
    
}

// MARK: - Table View Methods

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
            
            // Sender is tableviewcell
            self.performSegue(withIdentifier: "showEditVC", sender: tableView.cellForRow(at: indexPath))
        }
        return [delete, edit]
    }
    
    
}

// MARK: - Alert Delegate

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

