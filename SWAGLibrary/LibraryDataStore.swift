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
    let googleAPI = GoogleAPIClient.sharedInstance
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
    
    // TODO: - This function might be better on google api client
    func retrieve(scanned barcode: String, completion: @escaping (Bool) -> Void) {
        
        GoogleAPIClient.sharedInstance.get(barcode) { (bookInfo) in
            
            // TODO: - Create a new initializer for book and add this json
            print(bookInfo)
            let json = bookInfo?["items"] as! [JSON]
            let index = json[0]
            let volumeInfo = index["volumeInfo"] as! JSON
            let title = volumeInfo["title"] as! String
            let subtitle = volumeInfo["subtitle"] as! String
            let author = volumeInfo["authors"] as! [String]
            let publisher = volumeInfo["publisher"] as! String
            
            
 
            completion(true)

        }
        
        
        
    }
}
