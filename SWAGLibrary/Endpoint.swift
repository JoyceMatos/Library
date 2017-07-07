//
//  Endpoint.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation

// TODO: - Change Endpoint and case names to something that makes more sense


// NOTE: - This protocol will get the string value for any url endpoint

protocol Path {
    var path: String { get }
}


// NOTE: - This enum is used to determine what endpoint to retrieve

enum Endpoint {
    
    static let baseURL = "http://prolific-interview.herokuapp.com/"
    
    case getLibrary
    case getBook(Int)
    case deleteLibrary
    
}

// NOTE: - This returns the appropriate endpoint string for any given enum

extension Endpoint: Path {
    
    var path: String {
        switch self {
        case .getLibrary:
            return "/books"
        case .getBook(let id):
            return "/books/\(id)"
        case .deleteLibrary:
            return "/clean"
        }
    }
    
}

// NOTE: - This returns the url for each enum case based on it's value

extension Endpoint {
    
    var url: URL? {
        switch self {
        case .getLibrary:
            return generateURL(with: self.path)
        case .getBook:
            return generateURL(with: self.path)
        case .deleteLibrary:
            return generateURL(with: self.path)
        }
    }
    
}

// NOTE: - This generates a url from a string

extension Endpoint {
    
    func generateURL(with parameter: String) -> URL? {
        let string = Endpoint.baseURL + Secrets.serverClientID + parameter
        return URL(string: string)
    }

}
