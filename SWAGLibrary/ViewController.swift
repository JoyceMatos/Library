//
//  ViewController.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    LibraryAPIClient.sharedInstance.get { (JSON) in
        print("JSON: \(JSON)")
        
        // Check to see whether JSON is nil or not

        
        }
        
//        LibraryAPIClient.sharedInstance.post(author: "Joan Didion", categories: "Nonfiction", title: "Slouching Towards Bethlehem", publisher: "Penguin") { (JSON) in
//            
//        //
//        }
        
        LibraryAPIClient.sharedInstance.put(name: "Christina", book: 4)
    
    }

  


}

