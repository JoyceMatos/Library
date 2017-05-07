//
//  Error.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/6/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation
import UIKit


// TODO: - Check if this is proper naming convention for protocol
protocol ErrorHandling: class {
    func displayErrorAlert(message type: AlertMessage)
//    func generateMessage(for alert: AlertType) -> AlertMessage
}

enum ErrorType {
    
    case retrievingBooks
    case deletingBook
    case deletingLibrary
    case edittingBook
    case addingBook
    
}


// TODO: - display error based on type
// TODO: - Create Alert Message constants

