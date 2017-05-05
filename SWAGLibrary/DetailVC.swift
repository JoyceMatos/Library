//
//  DetailVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    // TODO: - Add sharing capabilities
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var checkedOutLabel: UILabel!
    
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()

    }
    
    func configureViews() {
        
        // TODO: - Refactor
        guard let title = book?.title,
        let author = book?.author,
        let publisher = book?.publisher,
        let checkedOut = book?.lastCheckedOut else {
                // Handle nils
                return
                
        }

        titleLabel.text = book?.title
        authorLabel.text = book?.author
        publisherLabel.text = book?.publisher
        checkedOutLabel.text = nullToNil(book?.lastCheckedOut) as? String ?? "Not checked out"
        
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
        
        // TODO: - Ask for name and update details
        
    }
    
    
    
}

