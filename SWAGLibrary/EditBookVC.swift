//
//  EditBookVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/5/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

// TODO: - Clean validator function

class EditBookVC: UIViewController {
    
    @IBOutlet weak var bookField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var publisherField: UITextField!
    @IBOutlet weak var categoriesField: UITextField!
    @IBOutlet weak var addTitleLabel: UILabel!
    @IBOutlet weak var addAuthorLabel: UILabel!
    
    let client = LibraryAPIClient.sharedInstance
    var errorHandler: ErrorHandling?
    var book: Book?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorHandler = self
        configureFields()
    }
    
    // MARK: - View Methods
    
    func configureFields() {
        guard let book = book else {
            return
        }
        
        // Title and Author ALWAYS exist
        bookField.text = book.title
        authorField.text = book.author
        publisherField.text = book.publisher ?? ""
        categoriesField.text = book.categories ?? ""
        
        addTitleLabel.isHidden = true
        addAuthorLabel.isHidden = true
    }
    
    func higlightTitle() {
        bookField.borderStyle = .line
        bookField.layer.borderColor = UIColor.red.cgColor
        bookField.layer.borderWidth = 1
        addTitleLabel.isHidden = false
    }
    
    func highlightAuthor() {
        authorField.borderStyle = .line
        authorField.layer.borderColor = UIColor.red.cgColor
        authorField.layer.borderWidth = 1
        authorField.layer.cornerRadius = 2
        addAuthorLabel.isHidden = false
    }
    
    // MARK: - API Method
    
    func update(book title: String, by author: String, for id: Int, publisher: String, categories: String, handler: @escaping (Bool) -> Void) {
        client.update(book: title, by: author, id: id, publisher: publisher, categories: categories, with: .getBook(id)) { (success) in
            if !success {
                DispatchQueue.main.async {
                    self.errorHandler?.displayErrorAlert(for: .updatingBook)
                }
            } else {
                NotificationCenter.default.post(name: .update, object: nil)
                handler(true)
            }
        }
    }
    // MARK: - Action Methods
    
    @IBAction func saveTapped(_ sender: Any) {
     validate()
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Method
    
    // TODO: - Perhaps add this function while user is typing
    func validate() {
        let title = bookField.text?.characters.count
        let author = authorField.text?.characters.count
        
        if title == 0 {
            higlightTitle()
            highlightAuthor()
            
        } else if author == 0 {
            highlightAuthor()
            
        } else {
            guard let title = bookField.text,
                let author = authorField.text,
                let publisher = publisherField.text,
                let categories = categoriesField.text,
                let id = book?.id as? Int else {
                return
            }
            
            update(book: title, by: author, for: id, publisher: publisher, categories: categories) { (success) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
}



// MARK: - Error Handling Method

extension EditBookVC: ErrorHandling {

    func displayErrorAlert(for type: ErrorType) {
        let alert = UIAlertController(title: type.errorMessage.title, message: type.errorMessage.message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
}
