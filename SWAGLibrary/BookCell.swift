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
    @IBOutlet weak var bookView: UIView! {
        didSet {
            configureView()
        }
    }
    
    weak var book: Book? {
        didSet {
            configureLabels()
        }
    }
    
    func configureLabels() {
        titleLabel.text = book?.title
        authorLabel.text = book?.author
        
        // Something about these lines make my text overlap
//        titleLabel.sizeToFit()
//        authorLabel.sizeToFit()
    }
    
    func configureView() {
        bookView.layer.shadowColor = UIColor.lightGray.cgColor
        bookView.layer.shadowOffset = CGSize(width: 0, height: 10)
        bookView.layer.shadowOpacity = 0.09
        bookView.layer.shadowRadius = 20
        bookView.layer.cornerRadius = 6
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        authorLabel.text = nil
      //  bookView = nil
    }
    
    
}
