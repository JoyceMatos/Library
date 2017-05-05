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
    
    var book: Book?  {
        didSet {
          //  configureViews()
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  configureViews()
    }
    
    func configureViews() {
        
        // TODO: - Refactor
//        guard let title = book?.title,
//            let author = book?.author,
//            let publisher = book?.publisher,
//            let checkedOut = book?.lastCheckedOut else {
//                // Handle nils
//                return
//                
//        }
        
        guard let book = book else {
            return
        }
        
        // TODO: - Format date label
        
        titleLabel.text = book.title
        authorLabel.text = book.author
        publisherLabel.text = book.publisher
        checkedOutLabel.text = nullToNil(book.lastCheckedOut) as? String ?? "Not checked out"
        
    }
    
    // TODO: - Make function Swiftier or convert to protocol/extension
    func nullToNil(_ value: AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    
    

    @IBAction func checkoutTapped(_ sender: Any) {
        
        // Alert
        let alertController = UIAlertController(title: "Check Out", message: "Please enter your name", preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let textField = alertController.textFields![0] as UITextField
            
            
            // Update Library
            guard let bookID = self.book?.id, let name = textField.text else {
                // Do something for nil value
                
                return
            }
            
            LibraryAPIClient.sharedInstance.put(name: name, book: bookID as! Int, completion: { (JSON) in
 
                // TODO: - Return book to  update view OR didSet property, OR notificationCenter    

                DispatchQueue.main.async {
                    self.configureViews()
                }
                
            })
            
            })
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Your Name"
        }
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)

}
    
    @IBAction func shareTapped(_ sender: Any) {
        
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
