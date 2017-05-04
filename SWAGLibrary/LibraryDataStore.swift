//
//  LibraryDataStore.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation

// TODO: - Refactor DataStore

final class LibraryDataStore {
    
    static let sharedInstance = LibraryDataStore()
    let libraryAPI = LibraryAPIClient.sharedInstance
    var books = [Book]()
    private init() { }
    
    func getBooks() {
        books.removeAll()
        
        libraryAPI.get { (library) in
            
            guard let library = library else {
                // Handle nil value
                return
            }
            
            // Map instead?
            for element in library {
                if let book = Book(dictionary: element) {
                    print("AUTHOR: \(book.lastCheckedOut)")
                    self.books.append(book)
                }
                
                print("MY BOOKS: \(self.books)")
                
            }
        }
    }
}
