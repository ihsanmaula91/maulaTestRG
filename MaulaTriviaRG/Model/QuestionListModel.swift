//
//  QuestionListModel.swift
//  MaulaTriviaRG
//
//  Created by Muhammad Ihsan Maula on 11/23/17.
//  Copyright © 2017 Muhammad Ihsan Maula. All rights reserved.
//

import UIKit

class QuestionListModel: NSObject {
    var questionList: [QuestionModel] = []
    
    override init() {
        super.init()
        
    }
    
    init(dictionary: NSDictionary) {
        super.init()
        fromDictionary(dictionary)
    }
    
    func toDictionary() -> NSMutableDictionary {
        let dictionary: NSMutableDictionary = NSMutableDictionary()
        let listOfQuestion: NSMutableArray = NSMutableArray()
        for question in questionList{
            listOfQuestion.add(question.toDictionary())
        }
        dictionary.setValue(listOfQuestion, forKey: "results")
        return dictionary
    }
    
    func fromDictionary(_ dictionary: NSDictionary) {
        let data = dictionary.object(forKey: "results") != nil && dictionary.object(forKey: "results") is NSArray ? dictionary.object(forKey: "results") as! NSArray : []
        for question in data {
            let questionModel = QuestionModel(dictionary: question as! NSDictionary)
            questionList.append(questionModel)
        }
    }
}
