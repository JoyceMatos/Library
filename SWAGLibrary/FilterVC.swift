//
//  FilterVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/6/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

// TODO: - Research outlet collection
// TODO: - Add functionality to buttons

enum FilterType {
    
    case title
    case author
    case publisher
    case categories
    
}

enum SortType {
    
    case ascending
    case descending
    
}

class FilterVC: UIViewController {
    
    var filteredBooks = [Book]()
    var didFilterTitle = false
    var didFilterAuthor = false
    var didFilterPublisher = false
    var didFilterCategories = false
    var didSortByAsc = false
    var didSortByDesc = false 

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        
        
    }
    
    @IBAction func titleTapped(_ sender: Any) {
        
        if didFilterTitle {
            didFilterTitle = false
        }
        else {
            didFilterTitle = true

    
            
            
            
            let filteredItems = LibraryDataStore.sharedInstance.books
            
//            for item in filteredItems {
//                
//                if let book = item {
//                    
//                }
//            }
//            
            
            let filter = filteredItems.sorted(by: {$0.title! > $1.title!})
            
                
            
            for item in filter {
                print("1: \(item.title)")
            }
            
            
            
           // print(filteredItems.description)
            
        }
        
        
        
        
        
        
    }
    
    @IBAction func authorTapped(_ sender: Any) {
        
        if didFilterTitle {
            didFilterTitle = false
        }
        else {
            didFilterTitle = true
        }
        
    }
    
    @IBAction func pubisherTapped(_ sender: Any) {
        
        if didFilterTitle {
            didFilterTitle = false
        }
        else {
            didFilterTitle = true
        }
    }
    
    @IBAction func categoryTapped(_ sender: Any) {
        
        if didFilterTitle {
            didFilterTitle = false
        }
        else {
            didFilterTitle = true
        }
        
    }
    
    @IBAction func ascendingTapped(_ sender: Any) {
        
        if didFilterTitle {
            didFilterTitle = false
        }
        else {
            didFilterTitle = true
        }
    }
    
    @IBAction func descendingTapped(_ sender: Any) {
        
        if didFilterTitle {
            didFilterTitle = false
        }
        else {
            didFilterTitle = true
        }
        
    }
    
    @IBAction func applyAllTapped(_ sender: Any) {
        
       
        
    }
    
    
    
    
  

}
