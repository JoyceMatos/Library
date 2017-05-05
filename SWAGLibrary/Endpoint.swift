//
//  Endpoint.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation

protocol Library: Path {

    var baseURL: URL? { get }
}

protocol Path {
    
    var path: String { get }
    
}

enum Endpoint {
    
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

extension Endpoint: Library {
    
    var baseURL: URL? {
        return URL(string: "https://api.github.com")
    }

}

//func url(for route: Library) -> URL {
//    
//    if let baseURL = route.baseURL {
//        return baseURL.appendingPathComponent(route.path)
//    }
//}
