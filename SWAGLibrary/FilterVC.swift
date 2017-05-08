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

class FilterVC: UIViewController {
    
    var didFilterTitle = false

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
        }
    }
    
    @IBAction func authorTapped(_ sender: Any) {
    }
    
    @IBAction func pubisherTapped(_ sender: Any) {
    }
    
    @IBAction func categoryTapped(_ sender: Any) {
    }
    
    @IBAction func ascendingTapped(_ sender: Any) {
    }
    
    @IBAction func descendingTapped(_ sender: Any) {
    }
    
    @IBAction func applyAllTapped(_ sender: Any) {
        
        
    }
    
  

}
