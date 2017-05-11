//
//  AddBookVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

class AddBookVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var publisherField: UITextField!
    @IBOutlet weak var categoriesField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewVerticalConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    let client = LibraryAPIClient.sharedInstance
    var errorHandler: ErrorHandling?
    
    // MARK - View Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorHandler = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateLabels()
    }
    
    // MARK: - View Method
    
    // NOTE: - This animates the view
    func animateLabels() {
        let stackViewHeight = stackView.bounds.size.height
        stackView.transform = CGAffineTransform(translationX: 0, y: stackViewHeight)
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.stackView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    // MARK: - Alert Methods
    
    func unsavedChangesAlert() {
        let alert = UIAlertController(title: "", message: "Your changes will not be saved. Are you sure you want to leave?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Action Methods
    
    @IBAction func submitTapped(_ sender: Any) {
        validateSubmission()
    }
    
    
    @IBAction func doneTapped(_ sender: Any) {
        validateMissingFields()
    }
    
    // MARK: - API Method
    
    func add(_ book: Book, handler: @escaping (Bool) -> Void) {
        client.add(book, in: .getLibrary) { (success) in
            switch success {
            case false:
                DispatchQueue.main.async {
                    self.errorHandler?.displayErrorAlert(for: .addingBook)
                }
            case true:
                NotificationCenter.default.post(name: .update, object: nil)
                handler(true)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    // NOTE: - This checks to see if there are any unsaved changes b
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
    
    // NOTE
    func validateSubmission() {
        if titleField.text?.characters.count == 0 || authorField.text?.characters.count == 0 {
            self.errorHandler?.displayErrorAlert(for: .missingFields)
        } else {
            guard let title = titleField.text,
                let author = authorField.text,
                let publisher = publisherField.text,
                let categories = categoriesField.text else {
                    return
            }
            let bookInfo = ["title": title, "author": author, "publisher": publisher, "categories": categories]
            let book = Book(dictionary: bookInfo)
            
            guard let newBook = book else {
                return
            }
            
            add(newBook, handler: { (success) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
}

// MARK: - Error Method

extension AddBookVC: ErrorHandling {
    
    func displayErrorAlert(for type: ErrorType) {
        let alert = UIAlertController(title: type.errorMessage.title, message: type.errorMessage.message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
}
