//
//  AddBookVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

// TODO: - Add  Done button to close screen. If there is text fields, confirm that user wants to leave with unsaved changes
class AddBookVC: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var publisherField: UITextField!
    @IBOutlet weak var categoriesField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        
        // TODO: - Create delegate for alert controller
        // TODO: - Fix Validator
        
        if titleField.text == nil || authorField.text == nil {
            
            print("HELLOOO")
            
            let alert = UIAlertController(title: "Missing fields", message: "Please type in the title and/or author", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in })
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {

        // NOTE: - Guard vs if lets
        if let title = titleField.text, let author = authorField.text, let publisher = publisherField.text, let categories = categoriesField.text {
            
            LibraryAPIClient.sharedInstance.post(author: author, categories: categories, title: title, publisher: publisher, completion: { (JSON) in
                
                print(JSON)
            })
            
            
        }
        
        dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
}
