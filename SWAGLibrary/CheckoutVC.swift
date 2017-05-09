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
    
    
    // MARK: - API Method
    func checkoutBook() {
        guard let name = nameField.text,
            let bookID = book?.id as? Int else {
            return
        }
        // TODO: - Do something about these trailing brackets
        client.checkout(by: name, for: bookID, with: .getBook(bookID), completion: { (JSON) in
            if JSON == nil {
                DispatchQueue.main.async {
                    self.errorHandler?.displayErrorAlert(for: .checkingOut)
                }
            } else {
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
    
    func displayErrorAlert(for type: ErrorType) {
        let alert = UIAlertController(title: type.errorMessage.title, message: type.errorMessage.message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
}
