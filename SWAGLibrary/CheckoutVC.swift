//
//  CheckoutVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/6/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

class CheckoutVC: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    
    let client = LibraryAPIClient.sharedInstance
    var errorHandler: ErrorHandling?
    var book: Book?
    
    // MARK: - View Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorHandler = self
    }
    
    // MARK: - Action Methods
    
    @IBAction func saveTapped(_ sender: Any) {
        checkoutBook()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Error Method
    
    func errorCheckingOutBook() {
        print("in error alert function")
        let message = AlertMessage(title: "", message: "Had trouble checking out book. Please try again later.")
        self.errorHandler?.displayErrorAlert(message: message)
    }
    
    
    // MARK: - API Method
    func checkoutBook() {
        guard let name = nameField.text, let bookID = book?.id as? Int else {
            return
        }
        
        // TODO: - Do something about these trailing brackets
        client.checkout(by: name, for: bookID, completion: { (JSON) in
            if JSON == nil {
                DispatchQueue.main.async {
                    self.errorCheckingOutBook()
                }
                print("Hellloooooo no JSON")
            } else {
                print("Uhhhh how did we get here with no wifi?")
                self.book = Book(dictionary: JSON)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .update, object: nil)
                    self.performSegue(withIdentifier: "unwindToDetailVC", sender: self)
                }
            }
        })
    }
}

// MARK: - Error Handling Method

extension CheckoutVC: ErrorHandling {
    
    func displayErrorAlert(message type: AlertMessage) {
        print("We are inside the alert y'all")
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
}
