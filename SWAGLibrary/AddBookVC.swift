//
//  AddBookVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

// TODO: - Add  Done button to close screen. If there is text fields, confirm that user wants to leave with unsaved changes
// TODO: - Capitalize each letter for textfield

class AddBookVC: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var publisherField: UITextField!
    @IBOutlet weak var categoriesField: UITextField!
    
    var alertDelegate: AlertDelegate?
    var errorHandler: ErrorHandling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertDelegate = self
        errorHandler = self
        
    }
    
    func missingFieldAction() {
        
        let missingFieldMessage = AlertMessage(title: "", message: "Your changes will not be saved. Are you sure you want to leave?")
        alertDelegate?.displayAlert(message: missingFieldMessage, with: { (noValue) in
            
            // Figure out what to do here (This gives me no value)
        })
        
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        
        // TODO: - Create delegate for alert controller
        
        // NOTE: - To consider: If you can create a book with just a title and author, find out what values you will have for publisher and categories and guard against them if they are nil
        
        if titleField.text?.characters.count == 0 || authorField.text?.characters.count == 0 {
            
            let alert = UIAlertController(title: "Missing fields", message: "Please type in the title and/or author", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in })
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            // NOTE: - Guard vs if lets
            if let title = titleField.text, let author = authorField.text, let publisher = publisherField.text, let categories = categoriesField.text {
                
                LibraryAPIClient.sharedInstance.post(author, categories: categories, title: title, publisher: publisher, completion: { (success) in
                    
                    if !success {
                        let message = AlertMessage(title: "", message: "Had trouble adding book. Please try again later.")
                        self.errorHandler?.displayErrorAlert(message: message)
                    }
                    
                    self.postNotification()
                })
            }
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        
        guard let title = titleField.text, let author = authorField.text, let publisher = publisherField.text, let categories = categoriesField.text else {
            return
        }
        
        validateFields()
        
    }
    
    func validateFields() {
        
        guard let title = titleField.text, let author = authorField.text, let publisher = publisherField.text, let categories = categoriesField.text else {
            return
        }
        
        // Perhaps switch instead
        if title.characters.count > 0 || author.characters.count > 0 || publisher.characters.count > 0 || categories.characters.count > 0 {
            missingFieldAction()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func postNotification() {
        NotificationCenter.default.post(name: .update, object: nil)
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
        let okayAction = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
}
