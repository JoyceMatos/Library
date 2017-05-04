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
       
        print("Before Dispatch")
            self.store.getBooks { (success) in
                DispatchQueue.main.async {

                print("Inside store.getbooks")
                    self.tableView.reloadData()
                }
            print("After reloading data")
        }
        
        print("Outside of dispatch")
        
        self.tableView.reloadData()

        
        
    }

}

extension LibraryVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookCell
//        let cell = Bundle.main.loadNibNamed("bookCell", owner: self, options: nil)?.first as! BookCell
       // let book = store.books[indexPath.row]
        
//        cell.titleLabel.text = book.title
//        cell.authorLabel.text = book.author
        
        print("Cell Created")
        
        return cell
    }
    
    
    
}

