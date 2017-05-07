//
//  LibraryAPIClient.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

// TODO: - Create more abstraction with url paths
// TODO: - Check status ie: 200, 204
// TODO: - GCD for all functions - create custom queues (be wary of too many global queues)
// TODO: - Consider Alamofire for networking

// NOTE: - Books have url. Perhaps you could use this in your endpoints

final class LibraryAPIClient {
    
    // Is this necessary?
    static let sharedInstance = LibraryAPIClient()
    
    // MARK: - GET method for retrieving all books
    // NOTE: - This function is a GET by default
    func get(_ completion: @escaping ([JSON]?) -> Void) {
        let urlString = API.baseURL + Endpoint.getLibrary.path
        guard let url = URL(string: urlString) else {
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
    
    // TODO: - Perhaps call in a Book object instead of individual arguements
    // TODO: - Call in an HTTP method
    
    func post(_ author: String, categories: String, title: String, publisher: String, completion: @escaping (Bool) -> Void) {
        
        let urlString = API.baseURL + Endpoint.getLibrary.path
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        let book = ["author": author, "categories": categories, "title": title, "publisher": publisher]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: book, options: []) {
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
    
    // TODO: - Merge checkout & update function to avoid code repition (return book & JSON)
    func checkout(by name: String, for id: Int, completion: @escaping (JSON?) -> Void) {
        let urlString = API.baseURL + Endpoint.getBook(id).path
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let updatedInfo = ["lastCheckedOutBy": name]
        
        if let data = try? JSONSerialization.data(withJSONObject: updatedInfo, options: []) {
            var request = URLRequest(url:url)
            request.httpMethod = HTTPMethod.put.rawValue
            request.addValue(Request.value, forHTTPHeaderField: Request.key)
            request.httpBody = data
        }
        
        // let property may not be necessary
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
    
    func update(book title: String?, by author: String?, id: Int, publisher: String?, categories: String?, completion: @escaping (Bool) -> Void) {
        
        guard let title = title,
            let author = author,
            let publisher = publisher,
            let categories = categories else {
                // handle
                return
        }
        
        let urlString = API.baseURL + Endpoint.getBook(id).path
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        // TODO: - Remember to guard against nil values
        let updatedInfo = ["title": title, "author": author, "publisher": publisher, "categories": categories]
        
        if let data = try? JSONSerialization.data(withJSONObject: updatedInfo, options: []) {
            var request = URLRequest(url:url)
            request.httpMethod = HTTPMethod.put.rawValue
            request.addValue(Request.value, forHTTPHeaderField: Request.key)
            request.httpBody = data
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print("ERROR 1: \(String(describing: error?.localizedDescription))")
                completion(nil)
            }
            
            // NOTE: - Perhaps change to if let
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
    
    // TODO: - Return JSON in completion
    func delete(book id: Int, completion: @escaping (Bool) -> Void) {
        let urlString = API.baseURL + Endpoint.getBook(id).path
        guard let url = URL(string: urlString) else {
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
    
    // MARK: - Delete method for deleting all books
    
    // TODO: - Check to see if you are handling error correctly with completion
    func delete(library completion: @escaping (Bool) -> Void) {
        let urlString = API.baseURL + Endpoint.deleteLibrary.path
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        let session = URLSession.shared
        var request = URLRequest(url:url)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
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
