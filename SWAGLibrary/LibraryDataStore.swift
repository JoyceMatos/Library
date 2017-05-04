//
//  LibraryDataStore.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation

// TODO: - Remove Sample books from code. This is only for testing Swift objects
// TODO: - Refactor DataStore 

final class LibraryDataStore {
    
    static let sharedInstance = LibraryDataStore()
    let libraryAPI = LibraryAPIClient.sharedInstance
    var books = [Book]()
    var sampleBooks = [SampleBook]()
    private init() { }
    
    func getBooks() {
        books.removeAll()
        sampleBooks.removeAll()
        
        libraryAPI.get { (library) in
            
            guard let library = library else {
                // Handle nil value
                return
            }

            // Map instead?
            for element in library {
                if let book = Book(dictionary: element) {
                    print("AUTHOR: \(book.author)")
                self.books.append(book)
            }
    
                // NOTE: - Just for testing
                let swiftBook = SampleBook(JSON: element)
                self.sampleBooks.append(swiftBook)
            }
            
            print("MY SWIFT BOOKS: \(self.sampleBooks)")
            print("MY BOOKS: \(self.books)")

        }
    }
    
    
    
    
    
}
