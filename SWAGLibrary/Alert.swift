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
    func displayAlert(message type: AlertMessage, with handler: @escaping () -> Void)
    
    // TODO: - Add actionAlert for more customization
}

struct AlertMessage {
    
    let title: String
    let message: String
    
}

// TODO: - Create enum with Alert types

