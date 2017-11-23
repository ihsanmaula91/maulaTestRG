//
//  QuestionPage.swift
//  MaulaTriviaRG
//
//  Created by Muhammad Ihsan Maula on 11/23/17.
//  Copyright © 2017 Muhammad Ihsan Maula. All rights reserved.
//

import UIKit

class QuestionPage: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var rightAnswerCountLabel: UILabel!
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    var questionListModel: QuestionListModel?
    var currentQuestion: QuestionModel?
    var questionCount: Int = 1
    var rightQuestionCount: Int = 0
    var categoryName: String?
    var selectedIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = categoryName!
        questionCollectionView.delegate = self
        questionCollectionView.dataSource = self
        let flow: UICollectionViewFlowLayout = questionCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        setQuestionLabel()
        setQuestionNumber()
        setRightQuestionNumber()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentQuestion!.answersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let answer = currentQuestion?.answersList[index]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCollectionViewCell", for: indexPath as IndexPath) as! QuestionCollectionViewCell
        cell.multipleChoiceLabel.text = index == 0 ? "A" : index == 1 ? "B" : index == 2 ? "C" : "D"
        if selectedIndex == -1 {
            cell.answerLabel.text = answer
            cell.answerLabel.textColor = UIColor.black
            cell.multipleChoiceLabel.textColor = UIColor.black
            cell.answerContentView.backgroundColor = UIColor.white
        } else {
            if answer == currentQuestion?.correctAnswer {
                cell.answerLabel.text = answer! + "\nCorrect Answer"
                cell.answerLabel.textColor = UIColor.white
                cell.multipleChoiceLabel.textColor = UIColor(hexString: "#50e3c2")
                cell.answerContentView.backgroundColor = UIColor(hexString: "#50e3c2")
            } else {
                if selectedIndex == index && answer != currentQuestion?.correctAnswer {
                    cell.answerLabel.textColor = UIColor.white
                    cell.answerLabel.text = answer! + "\nWrong Answer!"
                    cell.multipleChoiceLabel.textColor = UIColor(hexString: "#fb4040")
                    cell.answerContentView.backgroundColor = UIColor(hexString: "#fb4040")
                } else {
                    cell.answerLabel.text = answer
                    cell.answerLabel.textColor = UIColor.black
                    cell.multipleChoiceLabel.textColor = UIColor.black
                    cell.answerContentView.backgroundColor = UIColor.white
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width/2)-15, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex == -1 {
            selectedIndex = indexPath.row
            if currentQuestion?.answersList[selectedIndex] == currentQuestion?.correctAnswer {
                rightQuestionCount += 1
                setRightQuestionNumber()
            }
            collectionView.reloadData()
        }
    }
    
    func setQuestionLabel() {
         questionLabel.text = currentQuestion?.question
    }
    
    func setQuestionNumber() {
        questionNumber.text = "Question no." + String(questionCount)
    }
    
    func setRightQuestionNumber() {
        rightAnswerCountLabel.text = String(rightQuestionCount) + " Right Answers"
    }
    
    func changeButtonTitle() {
        nextButton.setTitle("FINISH", for: .normal)
    }

    @IBAction func onNextButtonClicked(_ sender: Any) {
        if selectedIndex != -1 {
            selectedIndex = -1
            questionCount += 1
            if questionCount <= (questionListModel?.questionList.count)! {
                currentQuestion = questionListModel?.questionList[questionCount-1]
                setQuestionLabel()
                setQuestionNumber()
                if questionCount == questionListModel?.questionList.count {
                    changeButtonTitle()
                }
                questionCollectionView.reloadData()
            } else {
                showFinishAlert()
            }
        } else {
            showPleaseChooseAlert()
        }
    }
    
    func showFinishAlert() {
        let message = "Congratulation, you got \(rightQuestionCount) Points"
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showPleaseChooseAlert() {
        let message = "Please choose the answer."
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
