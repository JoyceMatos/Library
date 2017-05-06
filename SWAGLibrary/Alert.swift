//
//  Alert.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/5/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation
import UIKit

protocol AlertDelegate: class {
    func displayAlert(message type: AlertMessage, with handler: @escaping (Any?) -> Void)
    
    // TODO: - Add actionAlert for more customization
}


struct AlertMessage {
    
    let title: String
    let message: String
    
}

enum AlertType {
    
    case missingFields
    case checkout
    case deleteBook
    
}


protocol TestAlert: class {
    func displayAlert(message type: AlertMessage, for alert: AlertType, performing action: UIAlertAction, with handler: @escaping (Any?) -> Void)

}

extension TestAlert {
    
    func displayAlert(message type: AlertMessage, for alert: AlertType, performing action: UIAlertAction, with handler: @escaping (Any?) -> Void) {
        
//        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
//        
//        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
//        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
//            
//            
//            self.dismiss(animated: true, completion: nil)
//            handler(nil)
//        })
//        
//        alert.addAction(cancel)
//        alert.addAction(confirm)
//        
//        self.present(alert, animated: true, completion: nil)
//
//        
        
        
    }
}


// TODO: - Create enum with Alert types
// Create a function that switches on enum and displays alert depending on each one
// Function takes in array of custom actions

// What about custom actions?



