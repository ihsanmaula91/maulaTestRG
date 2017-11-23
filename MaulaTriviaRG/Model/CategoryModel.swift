//
//  CategoryModel.swift
//  MaulaTriviaRG
//
//  Created by Muhammad Ihsan Maula on 11/23/17.
//  Copyright © 2017 Muhammad Ihsan Maula. All rights reserved.
//

import UIKit

class CategoryModel: NSObject {
    var id: Int?
    var name: String?
    var background: String?
    var logo: String?
    
    
    init(dictionary: NSDictionary) {
        super.init()
        fromDictionary(dictionary: dictionary)
    }
    
    override init() {
        super.init()
    }
    
    func fromDictionary(dictionary: NSDictionary) {
        id = dictionary.object(forKey: "id") != nil ? dictionary.object(forKey: "id") as! Int : 0
        name = dictionary.object(forKey: "name") != nil ? dictionary.object(forKey: "name") as! String : ""
        background = dictionary.object(forKey: "background") != nil ? dictionary.object(forKey: "background") as! String : ""
        logo = dictionary.object(forKey: "logo") != nil ? dictionary.object(forKey: "logo") as! String : ""
    }
}
