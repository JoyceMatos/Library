//
//  EditBookVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/5/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

class EditBookVC: UIViewController {
    
    @IBOutlet weak var bookField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var publisherField: UITextField!
    @IBOutlet weak var categoriesField: UITextField!
    
    var book: Book?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureFields()
    }
    
    func configureFields() {

        guard let book = book else {
            return
        }
        
        // Add default values if nil
        bookField.placeholder = book.title
        authorField.placeholder = book.author
        publisherField.placeholder = book.publisher
        categoriesField.placeholder = book.categories
        
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        guard let book = book else {
            // handle
            return
        }
        
        LibraryAPIClient.sharedInstance.update(book) { (JSON) in
            
            print(JSON)
            
            // DO something with JSON ; Error check
        }
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    


}
