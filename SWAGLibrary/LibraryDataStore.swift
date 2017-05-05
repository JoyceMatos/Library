//
//  LibraryDataStore.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation

// TODO: - Refactor DataStore
// TODO: - Sort books?

final class LibraryDataStore {
    
    static let sharedInstance = LibraryDataStore()
    let libraryAPI = LibraryAPIClient.sharedInstance
    var books = [Book]()
    private init() { }
    
    func getBooks(completion: @escaping (Bool) -> Void) {
        books.removeAll()
        libraryAPI.get { (library) in
            let libraryQueue = DispatchQueue(label: "library", qos: .userInitiated)
            libraryQueue.async {
                guard let library = library else {
                    completion(false)
                    // Handle nil value
                    return
                }
                
                // Map instead?
                for element in library {
                    if let book = Book(dictionary: element) {
                        self.books.append(book)
                    }
                    
                }
                
                completion(true)
            }
           
        }
        
    }
}
