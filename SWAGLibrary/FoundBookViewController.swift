//
//  FoundBookViewController.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 7/7/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

// TODO: - Replace all ViewController name to be uniform

class FoundBookViewController: UIViewController {

    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("This is the retrieved book: \(book?.title)")

    }


}
