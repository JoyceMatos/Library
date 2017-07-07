//
//  GoogleAPIClient.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/23/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation

// TODO: - Refactor

final class GoogleAPIClient {
    
    static let sharedInstance = GoogleAPIClient()
    
    private init() { }
    
    func get(_ isbn: String, completion: @escaping (JSON?) -> Void) {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn + "&key=" + Secrets.googleAPIKey) else {
            // Handle
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as! JSON else {
                    completion(nil)
                    return
            }
            DispatchQueue.global(qos: .userInitiated).async {
                completion(responseJSON)
            }
        }
        task.resume()
        
        
        
        
    }
    
}
