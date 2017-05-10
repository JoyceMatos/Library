//
//  CheckoutVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/6/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

// TODO: - Trailing brackets

class CheckoutVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var checkoutView: UIView!
    @IBOutlet weak var nameField: UITextField!
    
    // MARK: - Properties
    
    let client = LibraryAPIClient.sharedInstance
    var errorHandler: ErrorHandling?
    var book: Book?
    
    // MARK: - View Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorHandler = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateView()

    }
    
    // MARK: - View Method
    
    func animateView() {
        let height = view.bounds.size.height * 0.9
        checkoutView?.transform = CGAffineTransform(translationX: 0, y: height)
        UIView.animate(withDuration: 0.75, delay: 0.0 * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.checkoutView.transform = CGAffineTransform.identity
        }, completion: nil)
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
