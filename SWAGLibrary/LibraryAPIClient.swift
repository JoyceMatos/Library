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

final class LibraryAPIClient {
    
    static let sharedInstance = LibraryAPIClient()
    
    // GET
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
                print("This is the response: \(responseJSON)")
                completion(responseJSON)
            }
        }
        task.resume()
    }
    
    // POST
    
    // TODO: - Perhaps call in a Book object instead of individual arguements
    // TODO: - Figure out whether or not you want to retrieve JSON from this method through it's completion
    
    //NOTE: - Function is posting but all values are null 
    func post(author: String, categories: String, title: String, publisher: String, completion: @escaping ([JSON]?) -> Void) {
        
        let urlString = "http://prolific-interview.herokuapp.com/58ee814c433358000aae035d/books"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let book = ["author": author, "categories": categories, "title": title, "publisher": publisher]
        
        if let data = try? JSONSerialization.data(withJSONObject: book, options: []) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            print("Hey look at this data y'all \(data)")
            
            
        }
        
    }
    
    
    // PUT
    // TODO: - Return JSON in completion
    func put(name: String, book: Int) {
        let urlString = "http://prolific-interview.herokuapp.com/58ee814c433358000aae035d/books/\(book)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url:url)
        request.httpMethod = "PUT"
        
        let updatedInfo = ["lastCheckedOutBy": name]
        
        if let data = try? JSONSerialization.data(withJSONObject: updatedInfo, options: []) {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            print("Hey look at who checked out this book: \(data)")
            
            
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in

            if error != nil {
                print("ERROR 1: \(error?.localizedDescription)") // ?? ErrorMessage.deletingError.rawValue)
            }
            
            guard let data = data else {
                return
            }
            
//            do {
//                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON else {
//                    return
//                }
//                
////                DispatchQueue.main.async {
////                    completion()
////                }
//                
//            } catch {
//                print("ERROR 2: \(error.localizedDescription)")
//            }
            
        }
        task.resume()

    }
    
    
    
}
