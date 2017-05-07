//
//  DetailVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit
import Social

class DetailVC: UIViewController {
    
    // TODO : - didSet properties for labels so you don't have to configure views
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var checkedOutLabel: UILabel!
    
    let client = LibraryAPIClient.sharedInstance
    var alertDelegate: AlertDelegate?
    var errorHandler: ErrorHandling?
    var book: Book?  {
        didSet {
            
            // may willSet?
            // configureViews()
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertDelegate = self
        errorHandler = self
        
        configureViews()
        
    }
    
    // MARK: - View Method
    
    func configureViews() {
        guard let book = book else {
            return
        }
        
        // TODO: - Create validator for unwrapping values ie: function that unwraps and returns a proper book for labels , book = book , then add didSet
        // TODO: - Format date label
        
        let checkOutBy = nullToNil(book.lastCheckedOutBy) as? String ?? ""
        let checkedOut = nullToNil(book.lastCheckedOut) as? String ?? "Not checked out"
        
        if checkOutBy == "" && checkedOut == "Not checked out" {
            checkedOutLabel.text = checkedOut
        } else {
            
            // TODO: - Work on formatting date and create a function for it
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM-dd-yyyy"
            let date = dateformatter.date(from: checkedOut)
            
            print("This is the date \(String(describing: date))")
            print(checkedOut)
            print(dateformatter.date(from: checkedOut) ?? "No date value") // yyyy-MM-dd HH:mm:ss zzz
            
            // Include @ sign?
            checkedOutLabel.text = checkOutBy + " at " + "\(checkedOut)"
            
        }
        
        titleLabel.text = book.title
        authorLabel.text = book.author // // Use Null to nil here
        publisherLabel.text = book.publisher // Use Null to nil here
        
    }
    
    // MARK: - Helper Method
    
    func nullToNil(_ value: AnyObject?) -> AnyObject? {
        switch value {
        case is NSNull:
            return nil
        default:
            return value
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func checkoutTapped(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifier.showCheckoutVC, sender: self)
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        guard let title = book?.title, let author = book?.author else {
            return
        }
        
        presentSharing(for: title, by: author)
    }
    
    // MARK: - Error Method
    
    func errorCheckingOutBook() {
        let message = AlertMessage(title: "", message: "Had trouble checking out book. Please try again later.")
        self.errorHandler?.displayErrorAlert(message: message)
    }
    
    // MARK: - Sharing Capabilities
    
    func presentSharing(for book: String, by author: String) {
        let alertController = UIAlertController(title: "Share on social media", message: "", preferredStyle: .actionSheet)
        
        let fbButton = UIAlertAction(title: "Share on Facebook", style: .default, handler: { (action) -> Void in
            self.share(book, by: author, on: .fb)
        })
        
        let twitterButton = UIAlertAction(title: "Share on Twitter", style: .default, handler: { (action) -> Void in
            self.share(book, by: author, on: .twitter)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        
        alertController.addAction(fbButton)
        alertController.addAction(twitterButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func share(_ title: String, by author: String, on platform: SocialMedia) {
        if SLComposeViewController.isAvailable(forServiceType: platform.type) {
            let share = SLComposeViewController(forServiceType: platform.type)
            share?.setInitialText("Hey, check out \(title) by \(author).")
            if let shareBook = share {
                self.present(shareBook, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a \(platform.typeName) account.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
}


// MARK: - Segue Methods

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueIdentifier.showCheckoutVC {
        let destVC = segue.destination as! CheckoutVC
        destVC.book = book
    }
}

@IBAction func unwindToDetailVC(sender: UIStoryboardSegue) {
    DispatchQueue.global(qos: .userInitiated).async {
        if let sourceViewController = sender.source as? CheckoutVC {
            self.book = sourceViewController.book
            DispatchQueue.main.async {
                // Find a way to use didSets instead of configuring views over and over
                self.configureViews()
            }
        }
    }
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
            alertController.addAction(save)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - Error Handling Method
extension DetailVC: ErrorHandling {
    
    func displayErrorAlert(message type: AlertMessage) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
}
