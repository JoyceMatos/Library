//
//  Endpoint.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation

// Change Endpoint and case names to something that makes more sense

protocol Path {
    
    var path: String { get }
    
}


enum Endpoint {
    
    static let baseURL = "http://prolific-interview.herokuapp.com/58ee814c433358000aae035d"
    
    case getLibrary
    case getBook(Int)
    case deleteLibrary
    
}

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

extension Endpoint {
    
    var url: URL? {
        switch self {
        case .getLibrary:
            return generateURL(with: self.path)
        case .getBook(let id):
            return generateURL(with: self.path)
        case .deleteLibrary:
            return generateURL(with: self.path)
        }
    }
    
}

extension Endpoint {
    
    func generateURL(with parameter: String) -> URL? {
        let string = Endpoint.baseURL + parameter
        return URL(string: string)
    }

}
