//
//  SearchCell.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/19/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    weak var book: Book? {
        didSet {
            configureLabels()
        }
    }
    
    func configureLabels() {
        titleLabel.text = book?.title
        authorLabel.text = book?.author
    }
}
