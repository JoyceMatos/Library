//
//  LibraryAPIClient.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

final class LibraryAPIClient {
    
    static let sharedInstance = LibraryAPIClient()
    
    private init() { }
    
    // MARK: - GET method for retrieving all books
    
    // NOTE: - This function is a GET by default
    func get(_ request: Endpoint, completion: @escaping ([JSON]?) -> Void) {
        guard let url = request.url else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as! [JSON] else {
                    completion(nil)
                    return
            }
            DispatchQueue.global(qos: .userInitiated).async {
                completion(responseJSON)
            }
        }
        task.resume()
    }
    
    // MARK: - POST method for adding a book
    
    // TODO: - Error checking and guard lets could be better
    func add(_ book: Book, in request: Endpoint, completion: @escaping (Bool) -> Void) {
        guard let title = book.title,
            let author = book.author,
            let publisher = book.publisher,
            let categories = book.categories else {
                completion(false)
                return
        }

        guard let url = request.url else {
            completion(false)
            return
        }
        
        let newBook = ["author": author, "categories": categories, "title": title, "publisher": publisher]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: newBook, options: []) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.addValue(Request.value, forHTTPHeaderField: Request.key )
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let data = data else {
                    print(error?.localizedDescription ?? "Error adding book")
                    completion(false)
                    return
                }
                
                completion(true)
            })
            task.resume()
        }
    }
    
    // MARK - PUT method for checking out a book
    
    // TODO:- Error checking could be better
    func checkout(by name: String, for id: Int, with request: Endpoint, completion: @escaping (JSON?) -> Void) {
        
        guard let url = request.url else {
            completion(nil)
            return
        }
        
        let updatedInfo = ["lastCheckedOutBy": name]
        var request = URLRequest(url: url)
        
        if let data = try? JSONSerialization.data(withJSONObject: updatedInfo, options: []) {
            request.httpMethod = HTTPMethod.put.rawValue
            request.addValue(Request.value, forHTTPHeaderField: Request.key)
            request.httpBody = data
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("ERROR 1: \(String(describing: error?.localizedDescription))")
                completion(nil)
            } else {
                guard let data = data,
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? JSON else {
                        completion(nil)
                        return
                }
                completion(responseJSON)
            }
        }
        task.resume()
    }
    
    // MARK: - PUT method for updating a book
    
    // TODO: - Error checking and guard let could be better
    func update(book title: String?, by author: String?, id: Int, publisher: String?, categories: String?, with request: Endpoint, completion: @escaping (Bool) -> Void) {
        
        guard let title = title,
            let author = author,
            let publisher = publisher,
            let categories = categories else {
                return
        }
        
        guard let url = request.url else {
            completion(false)
            return
        }
        
        let updatedInfo = ["title": title, "author": author, "publisher": publisher, "categories": categories]
        var request = URLRequest(url:url)
        if let data = try? JSONSerialization.data(withJSONObject: updatedInfo, options: []) {
            request.httpMethod = HTTPMethod.put.rawValue
            request.addValue(Request.value, forHTTPHeaderField: Request.key)
            request.httpBody = data
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print("ERROR 1: \(String(describing: error?.localizedDescription))")
                completion(false)
            }
            
            guard let data = data,
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? JSON else {
                    completion(false)
                    return
            }
            
            completion(true)
        }
        task.resume()
    }
    
    
    
    
    // MARK: - DELETE method for deleting a book
    
    // TODO: - Error checking could be better
    func delete(from request: Endpoint, completion: @escaping (Bool) -> Void) {
        guard let url = request.url else {
            completion(false)
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url:url)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                completion(false)
                print("ERROR 1: \(String(describing: error?.localizedDescription))")
            }
            
            guard let data = data else {
                return
            }
            completion(true)
            
        }
        task.resume()
    }
    
    // MARK: - DELETE method for deleting all books
    
    // TODO: - Error checking could be better
    func delete(from request: Endpoint, library completion: @escaping (Bool) -> Void) {
        guard let url = request.url else {
            completion(false)
            return
        }
        let session = URLSession.shared
        var request = URLRequest(url:url)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // TODO: - Change this, see prolific's style guide
            if error != nil {
                print("ERROR 1: \(String(describing: error?.localizedDescription))")
                completion(false)
            }
            
            if let data = data  {
                DispatchQueue.global(qos: .userInitiated).async {
                    completion(true)
                    
                }
            }
        }
        task.resume()
    }
    
    
}
