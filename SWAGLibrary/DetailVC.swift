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
        
        // NOTE: - App crashes because of null value. Research: Inheriting objc objects in swift
        
        guard let title = book?.title,
        let author = book?.author,
        let publisher = book?.publisher,
            let checkedOut = book?.lastCheckedOut else {
                // Handle nils
                return
                
        }
        
    print(book?.lastCheckedOut)
        if book?.lastCheckedOut is NSNull {
            book?.lastCheckedOut = nil
        }
        
        print(book?.lastCheckedOut)

        // TODO: Give nils default value or guard against them somehow
        titleLabel.text = book?.title
        authorLabel.text = book?.author
        publisherLabel.text = book?.publisher
     //   checkedOutLabel.text = book?.lastCheckedOut as? String ?? "Never checked out"
        
    }
    
    
    @IBAction func checkoutTapped(_ sender: Any) {
        
        // TODO: - Ask for name and update details
        
    }
    
    
    
}
