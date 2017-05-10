//
//  BookCell.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit


class BookCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel! 
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookView: UIView!
    
    
   // var book: Book?
//        didSet {
//            titleLabel.text = book?.title
//            authorLabel.text = book?.author
//        
//        }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        titleLabel.text = nil
//        authorLabel.text = nil
    }
    
    
}
