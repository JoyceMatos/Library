//
//  ViewController.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

// TODO: - The app should allow users to update a book information
// TODO: - The app should allow users to delete a specific book
// TODO: - The app should allow users to delete all books at once

class LibraryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let store = LibraryDataStore.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
      //  fetch()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
    
    func fetch() {
        self.store.getBooks { (success) in
            
            // TODO: - If success do something, if not do something else
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showDetail {
            let destVC = segue.destination as! DetailVC
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

        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            // TODO: - Protocol for alert controllers
            
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this book?", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
            let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in

                LibraryAPIClient.sharedInstance.delete(book: bookID)
                
            })
            
           
            alert.addAction(cancel)
            alert.addAction(yes)

            self.present(alert, animated: true, completion: nil)
            
            // TODO: - Work on reloading data 
            tableView.reloadData()

            
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Share") { (action, indexPath) in
           // TODO: - Display a window for editing
            
        }
        return [delete, edit]
    }
    
    
    
}

