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
        
        // TODO: - Perform validators for text
        guard let title = bookField.text, let author = authorField.text, let publisher = publisherField.text, let categories = categoriesField.text, let id = book?.id as? Int else {
            return
        }
        
        LibraryAPIClient.sharedInstance.update(book: title, by: author, id: id, publisher: publisher, categories: categories) { (JSON) in
            
            // Do something with JSON?
            print(JSON)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    


}
