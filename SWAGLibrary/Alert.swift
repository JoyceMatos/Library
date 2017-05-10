//
//  Alert.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/5/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation
import UIKit


// TODO: - This protocol is not in use, figure out a way to make it work
protocol AlertDelegate: class {
    func displayAlert(message type: AlertMessage, with handler: @escaping (Any?) -> Void)
    
}

struct AlertMessage {
    
    let title: String
    let message: String
    
}




