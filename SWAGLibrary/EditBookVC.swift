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
    
    var errorHandler: ErrorHandling?
    var book: Book?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorHandler = self
        
        configureFields()
    }
    
    // MARK: - View Method
    
    func configureFields() {
        
        guard let book = book else {
            return
        }
        
        // TODO: - Let text be solid text, not place holders
        // TODO: - Add instructions: Tap field to edit text
        
        // Add default values if nil
        bookField.text = book.title
        authorField.text = book.author
        publisherField.text = book.publisher
        categoriesField.text = book.categories
        
    }
    
    // MARK: - Action Methods
    
    @IBAction func saveTapped(_ sender: Any) {
        
        // TODO: - Perform validators for text
        guard let title = bookField.text, let author = authorField.text, let publisher = publisherField.text, let categories = categoriesField.text, let id = book?.id as? Int else {
            return
        }
        
        LibraryAPIClient.sharedInstance.update(book: title, by: author, id: id, publisher: publisher, categories: categories) { (success) in
            if !success {
                let message = AlertMessage(title: "", message: "Had trouble updating book. Please try again later.")
                self.errorHandler?.displayErrorAlert(message: message)
            }
            NotificationCenter.default.post(name: .update, object: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: - Error Handling Method

extension EditBookVC: ErrorHandling {
    
    func displayErrorAlert(message type: AlertMessage) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
}