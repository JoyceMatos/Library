//
//  ViewController.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

class LibraryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    
    let store = LibraryDataStore.sharedInstance

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fetch()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
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
        if segue.identifier == "showDetail" {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookCell
//        let cell = Bundle.main.loadNibNamed("bookCell", owner: self, options: nil)?.first as! BookCell
        let book = store.books[indexPath.row]
        
       // if let bookTitle = book.title, let bookAuthor = book.author {
        
        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.author
        //  }
        print(book.title)
        print(book.author)

        
        return cell
    }
    
    
    
}

