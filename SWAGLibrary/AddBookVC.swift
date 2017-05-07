//
//  AddBookVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

class AddBookVC: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var publisherField: UITextField!
    @IBOutlet weak var categoriesField: UITextField!
    
    let client = LibraryAPIClient.sharedInstance
    var alertDelegate: AlertDelegate?
    var errorHandler: ErrorHandling?
    
    // MARK - View Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertDelegate = self
        errorHandler = self
    }
    
    // MARK: - Error Method
    
    func error(_ type: ErrorType) {
        self.errorHandler?.displayErrorAlert(message: type.errorMessage)
    }
    
    // MARK: - Alert Methods
    // TODO: - Work on these alerts, they're excessive a
    
    func unsavedChangesAlert() {
        let unsavedMessage = AlertMessage(title: "", message: "Your changes will not be saved. Are you sure you want to leave?")
        alertDelegate?.displayAlert(message: unsavedMessage, with: { (noValue) in
        })
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        validateSubmission()
    }
    
    
    @IBAction func doneTapped(_ sender: Any) {
        validateMissingFields()
    }
    
    // MARK: - API Method
    
    func addBook(by author: String, title: String, publisher: String, categories: String, handler: @escaping (Bool) -> Void) {
        client.post(author, categories: categories, title: title, publisher: publisher, completion: { (success) in
            switch success {
            case false:
                DispatchQueue.main.async {
                    self.error(.addingBook)
                }
            case true:
                NotificationCenter.default.post(name: .update, object: nil)
                handler(true)
            }
        })
    }
    
    // MARK: - Helper Method
    
    func validateMissingFields() {
        guard let title = titleField.text,
            let author = authorField.text,
            let publisher = publisherField.text,
            let categories = categoriesField.text else {
                return
        }
        
        if title.characters.count > 0 || author.characters.count > 0 || publisher.characters.count > 0 || categories.characters.count > 0 {
            unsavedChangesAlert()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // NOTE: - To consider: If you can create a book with just a title and author, find out what values you will have for publisher and categories and guard against them if they are nil
    
    func validateSubmission() {
        if titleField.text?.characters.count == 0 || authorField.text?.characters.count == 0 {
            error(.missingFields)
        } else {
            
            guard let title = titleField.text,
                let author = authorField.text,
                let publisher = publisherField.text,
                let categories = categoriesField.text else {
                    return
            }
            // TODO: - Find a way to clean these trailing brackets
            
            addBook(by: author, title: title, publisher: publisher, categories: categories, handler: { (success) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
}

// TODO: - Figure out how to add 2 alert controllers with this protocol ; Perhaps make a UIAlertAction factory (Function that takes in array of UIAlertActions) ie: AlertActions can be enums
extension AddBookVC: AlertDelegate {
    
    func displayAlert(message type: AlertMessage, with handler: @escaping (Any?) -> Void) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
            handler(nil)
        })
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
}

extension AddBookVC: ErrorHandling {
    
    func displayErrorAlert(message type: AlertMessage) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
}
