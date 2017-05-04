//
//  LibraryAPIClient.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

// TODO: - Make arguement labels more swifty
// TODO: - Create more abstraction with url paths
// TODO: - Store string literals in constants
// TODO: - Check status ie: 200, 204
// TODO: - GCD for all functions

final class LibraryAPIClient {
    
    // Is this necessary?
    static let sharedInstance = LibraryAPIClient()
    
    // MARK - GET method for retrieving all books
    func get(completion: @escaping ([JSON]?) -> Void) {
        
        let urlString = "http://prolific-interview.herokuapp.com/58ee814c433358000aae035d/books"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        // NOTE: - Default is get but perhaps include url request
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
    
    // MARK: - POST method for retrieving a book
    
    // TODO: - Perhaps call in a Book object instead of individual arguements
    // TODO: - Figure out whether or not you want to retrieve JSON from this method through it's completion
    
    func post(author: String, categories: String, title: String, publisher: String, completion: @escaping ([JSON]?) -> Void) {
        
        let urlString = "http://prolific-interview.herokuapp.com/58ee814c433358000aae035d/books"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let book = ["author": author, "categories": categories, "title": title, "publisher": publisher]
        var request = URLRequest(url: url)
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: book, options: []) {
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let data = data else {
                    print(error?.localizedDescription) //?? ErrorMessage.uploadingError.rawValue)
                    return
                }
                
                // TODO: - Handle Error differently
                guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as! JSON else {
                    return
                }
                
            })
            task.resume()
        }
        
    }
    
    // MARK - PUT method for updating a book
    
    //TODO: - Return JSON
    func put(name: String, book: Int, completion: @escaping (JSON?) -> Void) {
        let urlString = "http://prolific-interview.herokuapp.com/58ee814c433358000aae035d/books/\(book)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url:url)
        request.httpMethod = "PUT"
        
        let updatedInfo = ["lastCheckedOutBy": name]
        
        if let data = try? JSONSerialization.data(withJSONObject: updatedInfo, options: []) {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print("ERROR 1: \(error?.localizedDescription)") // ?? ErrorMessage.deletingError.rawValue)
            }
            
            // NOTE: - Perhaps change to if let
            guard let data = data,
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? JSON else {
                    completion(nil)
                return
            }
            
            completion(responseJSON)
        }
        task.resume()
        
    }
    
    
    
    // MARK: - DELETE method for deleting a book
    
    // TODO: - Return JSON in completion
    func delete(book path: Int) {
        let urlString = "http://prolific-interview.herokuapp.com/58ee814c433358000aae035d/books/\(path)"
        guard let url = URL(string: urlString) else {
            //  completion(nil)
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url:url)
        request.httpMethod = "DELETE"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print("ERROR 1: \(error?.localizedDescription)") // ?? ErrorMessage.deletingError.rawValue)
            }
            
            guard let data = data else {
                return
            }
            
        }
        task.resume()
    }
    
    // MARK: - Delete method for deleting all books
    
    // TODO: - Pass some value into completion (if necessary)
    func delete(all completion: () -> Void) {
        let urlString = "http://prolific-interview.herokuapp.com/58ee814c433358000aae035d/clean"
        guard let url = URL(string: urlString) else {
            //  completion(nil)
            return
        }
        let session = URLSession.shared
        var request = URLRequest(url:url)
        request.httpMethod = "DELETE"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print("ERROR 1: \(error?.localizedDescription)") // ?? ErrorMessage.deletingError.rawValue)
            }
            
            guard let data = data else {
                return
            }
            
        }
        task.resume()
        
        
    }
    
    
    
    
    
    
    
}
