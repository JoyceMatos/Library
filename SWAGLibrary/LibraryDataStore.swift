//
//  LibraryDataStore.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation

final class LibraryDataStore {
    
    static let sharedInstance = LibraryDataStore()
    let libraryAPI = LibraryAPIClient.sharedInstance
    var books = [Book]()
    private init() { }
    
    // NOTE: - This is where I populate the data store
    
    func getBooks(completion: @escaping (Bool) -> Void) {
        books.removeAll()
        
        libraryAPI.get(.getLibrary) { (library) in
            let libraryQueue = DispatchQueue(label: "library", qos: .userInitiated)
            
            libraryQueue.async {
                guard let library = library else {
                    completion(false)
                    return
                }
                
                for element in library {
                    if let book = Book(dictionary: element) {
                        self.books.insert(book, at: 0)
                    }
                }
                completion(true)
            }
        }
    }
}
