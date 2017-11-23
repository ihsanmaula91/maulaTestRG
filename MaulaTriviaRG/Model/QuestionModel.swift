//
//  QuestionModel.swift
//  MaulaTriviaRG
//
//  Created by Muhammad Ihsan Maula on 11/23/17.
//  Copyright © 2017 Muhammad Ihsan Maula. All rights reserved.
//

import UIKit

class QuestionModel: NSObject {
    
    var question: String?
    var correctAnswer: String?
    var incorrectAnswers: [String] = []
    var answersList: [String] = []
    
    override init() {
        super.init()
        
    }
    
    init(dictionary: NSDictionary) {
        super.init()
        fromDictionary(dictionary)
    }
    
    func toDictionary() -> NSMutableDictionary {
        let dictionary: NSMutableDictionary = NSMutableDictionary()
        dictionary.setValue(question, forKey: "question")
        dictionary.setValue(correctAnswer, forKey: "correctAnswer")
        dictionary.setValue(incorrectAnswers, forKey: "incorrectAnswers")
        
        return dictionary
    }
    
    func fromDictionary(_ dictionary: NSDictionary) {
        question = dictionary.object(forKey: "question") as! String
        correctAnswer = dictionary.object(forKey: "correct_answer") as! String
        if dictionary.object(forKey: "incorrect_answers") != nil {
            let incorrectAnswerList = dictionary.object(forKey: "incorrect_answers") as! NSArray
            for incorrectAnswer in incorrectAnswerList {
                incorrectAnswers.append(incorrectAnswer as! String)
            }
        }
        
        answersList.append(correctAnswer!)
        answersList.append(contentsOf: incorrectAnswers)
        answersList.shuffle()
    }

}
