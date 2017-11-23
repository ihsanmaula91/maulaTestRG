//
//  ViewController.swift
//  MaulaTriviaRG
//
//  Created by Muhammad Ihsan Maula on 11/22/17.
//  Copyright © 2017 Muhammad Ihsan Maula. All rights reserved.
//

import UIKit

class CategoryPage: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var categories : [CategoryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        let flow: UICollectionViewFlowLayout = categoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        getCategoryData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.row]
        cell.categoryContentView.backgroundColor = UIColor(patternImage: UIImage(named: category.background!)!)
        cell.categoryIcon.image = UIImage(named: category.logo!)
        cell.categoryName.text = category.name!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width/2)-15, height: collectionView.bounds.size.height/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToQuestionPage", sender: nil)
    }
    
    func getCategoryData() {
        categories = []
        let path = Bundle.main.path(forResource:"Category", ofType: "json")
        var jsonData: Data?
        do {
            jsonData = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        } catch {
            jsonData = nil
        }
        do {
            let dictionaryResponse: NSDictionary = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            let categoriesData = dictionaryResponse.object(forKey: "trivia_categories") as! NSArray
            for category in categoriesData {
                categories.append(CategoryModel(dictionary: category as! NSDictionary))
            }
            categoryCollectionView.reloadData()
        } catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

