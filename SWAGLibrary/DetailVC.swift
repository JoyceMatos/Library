//
//  DetailVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit
import Social
import SwiftDate

// TODO: - didSets
// TODO: - Unwrap value function
// TODO: - Create protocol for animation
// TODO: - Animate cancel button

class DetailVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var lastCheckedOutLabel: UILabel!
    @IBOutlet weak var checkedOutLabel: UILabel!
    @IBOutlet weak var checkOutButton: UIButton!
    
    
    let client = LibraryAPIClient.sharedInstance
    var book: Book?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateViews()
    }
    
    
    // MARK: - View Methods
    
    func animateViews() {
        let height = view.bounds.size.height
        var delayCounter = 0
        
        // NOTE: - This animates the label
        let views = [titleLabel, authorLabel, publisherLabel, categoriesLabel, lastCheckedOutLabel,checkedOutLabel]
        
        for item in views {
            item?.transform = CGAffineTransform(translationX: 0, y: height * 0.22)
        }
        
        for item in views {
            UIView.animate(withDuration: 0.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                item?.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
        
        // NOTE: - This animates the checkout button
        checkOutButton.transform = CGAffineTransform(translationX: 0, y: height * 0.55)
        
        UIView.animate(withDuration: 0.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.checkOutButton.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }
    
    func configureViews() {
        guard let book = book else {
            return
        }
        
        // TODO: - Create function that unwraps values, returns book, sets new book to current book didset
        
        let publisher = nullToNil(book.publisher) as? String ?? "Publisher: N/A"
        let categories = nullToNil(book.categories) as? String ?? "Categories: N/A"
        let checkOutBy = nullToNil(book.lastCheckedOutBy) as? String ?? ""
        let checkedOut = nullToNil(book.lastCheckedOut) as? String ?? "Not checked out"
        
        
        if checkOutBy == "" && checkedOut == "Not checked out" {
            checkedOutLabel.text = checkedOut
        } else {
            guard let formattedDate = format(checkedOut) else {
                // handle this nil
                return
            }
            checkedOutLabel.text = checkOutBy + " @ " + "\(formattedDate)"
        }
        
        if publisher == "" {
            publisherLabel.text = "Publisher: N/A"
        } else {
            publisherLabel.text = "Publisher: \(publisher)"
        }
        
        if categories == "" {
            categoriesLabel.text = "Categories: N/A"
        } else {
            categoriesLabel.text = "Categories: \(categories)"
        }
        
        titleLabel.text = book.title
        authorLabel.text = book.author
        
        titleLabel.sizeToFit()
        authorLabel.sizeToFit()
        publisherLabel.sizeToFit()
        checkedOutLabel.sizeToFit()
        
    }
    
    // MARK: - Helper Methods
    
    func nullToNil(_ value: Any?) -> Any? {
        switch value {
        case is NSNull:
            return nil
        default:
            return value
        }
        
        // value is NSNull ? return nil : return value
        
    }
    
    func format(_ date: String) -> DateInRegion? {
        let formattedDate = try? DateInRegion(string: date, format: .custom("yyyy-MM-dd HH:mm:ss"))
        return formattedDate
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
            let alert = UIAlertController(title: "Login Required", message: "Please login to a \(platform.typeName) account.", preferredStyle: UIAlertControllerStyle.alert)
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

