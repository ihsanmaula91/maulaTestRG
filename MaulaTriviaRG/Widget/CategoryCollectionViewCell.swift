//
//  CategoryCollectionViewCell.swift
//  MaulaTriviaRG
//
//  Created by Muhammad Ihsan Maula on 11/22/17.
//  Copyright © 2017 Muhammad Ihsan Maula. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryContentView: UIView!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryContentView.layer.cornerRadius = 5
    }
    
}
