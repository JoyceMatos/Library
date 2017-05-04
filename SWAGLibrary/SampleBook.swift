//
//  SampleBook.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation

// NOTE: - Sample Book to be converted to Obj-c

struct SampleBook {
    
    let author: String
    let categories: String
    let id: Int
    let publisher: String
    let title: String
    let url: String
    var lastCheckedOut: String? = nil
    var lastCheckedOutBy: String? = nil

    init(JSON: JSON) {
        self.author = JSON["author"] as! String
        self.categories = JSON["categories"] as! String
        self.id = JSON["id"] as! Int
        self.publisher = JSON["publisher"] as! String
        self.title = JSON["title"] as! String
        self.url = JSON["url"] as! String
        
//       guard let self.lastCheckedOut = JSON["lastCheckedOut"] as! String?,
//        let self.lastCheckedOutBy = JSON["lastCheckedOutBy"] as! String? else {
//            self.lastCheckedOut = nil
//            self.lastCheckedOutBy = nil
//            
//        }
    }
    
}
