//
//  DetailVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    // TODO: -  Check every alert controller and make sure buttons and colors are correct
    // TODO : - didSet properties for labels so you don't have to configure views
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var checkedOutLabel: UILabel!
    
    var alertDelegate: AlertDelegate?
    var errorHandler: ErrorHandling?
    var book: Book?  {
        didSet {
            
            // may willSet?
            // configureViews()
        }
    }
    
    // MARK: - View Lifecycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertDelegate = self
        errorHandler = self
        
        configureViews()
        observe()
        
    }
    
    func observe() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVC(notification:)), name: .updateDetail, object: nil)
    }
    
    func reloadVC(notification: NSNotification) {
        
        print("Helllooooo notification should configure")
        configureViews()
    }
    // MARK: - View Method
    
    func configureViews() {
        guard let book = book else {
            return
        }
        
        // TODO: - Create validator for unwrapping values ie: function that unwraps and returns a proper book for labels , book = book , then add didSet
        // TODO: - Format date label
        
        var checkOutBy = nullToNil(book.lastCheckedOutBy) as? String ?? ""
        var checkedOut = nullToNil(book.lastCheckedOut) as? String ?? "Not checked out"
        
        if checkOutBy == "" && checkedOut == "Not checked out" {
            checkedOutLabel.text = checkedOut
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
            
        }
        
        titleLabel.text = book.title
        authorLabel.text = book.author // // Use Null to nil here
        publisherLabel.text = book.publisher // Use Null to nil here
        
    }
    
    // MARK: - Helper Method
    
    // TODO: - Make function Swiftier or convert to protocol/extension
    func nullToNil(_ value: AnyObject?) -> AnyObject? {
        switch value {
        case is NSNull:
            return nil
        default:
            return value
        }
    }
    
    // MARK: - Action Methods
    
    func alertAction() {
        
        // ALERT
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
        performSegue(withIdentifier: SegueIdentifier.showCheckoutVC, sender: self)
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        
        // TODO: - Share to Facebook/Twitter
        
        guard let title = book?.title, let author = book?.author else {
            // Handle this
            return
        }

        share(book: title, by: author)
        
    }
    
    // MARK: - Sharing Capabilities
    
    func share(book title: String, by author: String) {
        let shareMessage = ["Hey, check out \(title) by \(author)."]
        let activityController = UIActivityViewController(activityItems: [shareMessage], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityController, animated: true, completion: nil)
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
        let okayAction = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
}
