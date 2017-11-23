//
//  QuestionCollectionViewCell.swift
//  MaulaTriviaRG
//
//  Created by Muhammad Ihsan Maula on 11/23/17.
//  Copyright © 2017 Muhammad Ihsan Maula. All rights reserved.
//

import UIKit

class QuestionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var answerContentView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var multipleChoiceLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        answerContentView.layer.borderColor = UIColor.black.cgColor
        answerContentView.layer.borderWidth = 1
        answerContentView.layer.cornerRadius = 20
        circleView.layer.borderColor = UIColor.gray.cgColor
        circleView.layer.borderWidth = 1
        circleView.layer.cornerRadius = circleView.bounds.size.width/2
        circleView.layer.masksToBounds = true
    }
    
}
