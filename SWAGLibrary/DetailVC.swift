//
//  DetailVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    
    // TODO : - didSet properties for labels so you don't have to configure views
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var checkedOutLabel: UILabel!
    
    var alertDelegate: AlertDelegate?
    var errorHandler: ErrorHandling?
    var book: Book?  {
        didSet {
         // configureViews()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertDelegate = self
        errorHandler = self
        
        configureViews()
        
    }
    
    func configureViews() {
        
        guard let book = book else {
            return
        }
        
        // TODO: - Format date label
        
        var checkOutBy = nullToNil(book.lastCheckedOutBy) as? String ?? ""
        var checkedOut = nullToNil(book.lastCheckedOut) as? String ?? "Not checked out"
        
        if checkOutBy == "" && checkedOut == "Not checked out" {
            
            // Display default text on label
        } else {
           
            
            // TODO: - Work on formatting date and create a function for it
            var dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM-dd-yyyy"

            let date = dateformatter.date(from: checkedOut)
            
            print("This is the date \(date)")
            print(checkedOut)
            print(dateformatter.date(from: checkedOut)) // yyyy-MM-dd HH:mm:ss zzz
            
            // Include @ sign?
            checkedOutLabel.text = checkOutBy + " at " + "\(checkedOut)"

            

            // Format label
        }
        
        titleLabel.text = book.title
        authorLabel.text = book.author // // Use Null to nil here
        publisherLabel.text = book.publisher // Use Null to nil here
        
    }
    
    // TODO: - Make function Swiftier or convert to protocol/extension
    func nullToNil(_ value: AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    
    func alertAction() {
        
        let checkOutMessage = AlertMessage(title: "Check Out", message: "Please enter your name")
        alertDelegate?.displayAlert(message: checkOutMessage, with: { (textField) in
            
            guard let bookID = self.book?.id, let name = textField else {
                // Do something for nil value
                return
            }
            
            // Abstract even more?
            LibraryAPIClient.sharedInstance.checkout(by: name as! String, for: bookID as! Int, completion: { (JSON) in
                
                if JSON == nil {
                    let message = AlertMessage(title: "", message: "Had trouble checking out book. Please try again later.")
                    self.errorHandler?.displayErrorAlert(message: message)
                    
                }
                
                self.book = Book(dictionary: JSON)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .update, object: nil)
                    self.configureViews()
                }
            })
        })
    }
    
    
    @IBAction func checkoutTapped(_ sender: Any) {
        
        alertAction()
        
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        
        // TODO: - Share to Facebook/Twitter
        
        guard let title = book?.title else {
            // Handle this
            return
        }
        
        guard let author = book?.author else {
            // Handle this
            return
        }
        
        let shareMessage = ["Hey, check out \(title) by \(author)."]
        
        let activityController = UIActivityViewController(activityItems: [shareMessage], applicationActivities: nil)
        
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityController, animated: true, completion: nil)
        
    }
    
    
}

extension DetailVC: AlertDelegate {
    
    func displayAlert(message type: AlertMessage, with handler: @escaping (Any?) -> Void) {
        
        let alertController = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            
            let textField = alertController.textFields![0] as UITextField
            
            handler(textField.text)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Your Name"
        }
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

extension DetailVC: ErrorHandling {
    
    func displayErrorAlert(message type: AlertMessage) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
}