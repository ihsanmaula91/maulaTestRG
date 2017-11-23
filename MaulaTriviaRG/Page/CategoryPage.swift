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
    var questionList: QuestionListModel?
    var isRequestQuestionData: Bool = false
    var categoryName: String!
    
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
        if !Reachability.isConnectedToNetwork(){
            showPopupOffline()
        } else {
            let categoryId = categories[indexPath.row].id!
            categoryName = categories[indexPath.row].name!
            if !isRequestQuestionData {
                if UserDefaults.standard.object(forKey: "\(categories[indexPath.row].id!)") != nil {
                    self.questionList = QuestionListModel(dictionary: UserDefaults.standard.object(forKey: "\(categories[indexPath.row].id!)") as! NSDictionary)
                    self.performSegue(withIdentifier: "goToQuestionPage", sender: nil)
                } else {
                    getQuestionData(categoryId)
                }
            }
        }
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
    
    func getQuestionData(_ categoryId: Int) {
        isRequestQuestionData = true
        showSpinner()
        let url = URL(string: "https://opentdb.com/api.php?amount=20&category=\(categoryId)&type=multiple")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                self.isRequestQuestionData = false
                self.showErrorAlert()
                self.hideSpinner()
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    OperationQueue.main.addOperation({
                        self.hideSpinner()
                        self.isRequestQuestionData = false
                        self.questionList = QuestionListModel(dictionary: json as NSDictionary)
                        UserDefaults.standard.setValue(self.questionList?.toDictionary(), forKey: "\(categoryId)")
                        self.performSegue(withIdentifier: "goToQuestionPage", sender: nil)
                    })
                    
                }catch _ as NSError {
                    self.isRequestQuestionData = false
                    self.showErrorAlert()
                    self.hideSpinner()
                }
            }
        }).resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQuestionPage" {
            let questionPage = segue.destination as! QuestionPage
            questionPage.categoryName = categoryName
            questionPage.questionListModel = questionList
            questionPage.currentQuestion = (questionList?.questionList[0])!
        }
    }
    
    func showErrorAlert() {
        let message = "Oops! Something went wrong."
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showPopupOffline() {
        let message = "No internet connection."
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}

