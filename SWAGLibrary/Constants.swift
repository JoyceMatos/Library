//
//  Constants.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation

struct Request {
    
    static let value = "application/json"
    static let key = "Content-Type"
    
}

enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
}

struct SegueIdentifier {
    
    static let showDetailVC = "showDetail"
    static let showEditVC = "showEditVC"
    static let showCheckoutVC = "showCheckoutVC"
    static let showFoundBookVC = "showRetrievedBook"
    static let unwindToDetailVC = "unwindToDetailVC"
    
}

struct CellIdentifier {
    
    static let bookCell = "bookCell"
    
}

// NOTE: - Really belongs in a separate file and added to the .gitignore

struct Secret {
    
    static let clientID = "58ee814c433358000aae035d"
    
}










