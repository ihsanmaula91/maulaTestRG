//
//  BaseViewController.swift
//  MaulaTriviaRG
//
//  Created by Muhammad Ihsan Maula on 11/23/17.
//  Copyright © 2017 Muhammad Ihsan Maula. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var spinnerWidget: SpinnerWidget!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let changeTitle = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = changeTitle
        navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#9012fe")
        navigationController?.navigationBar.tintColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    /**
     This method is called to show spinner.
     */
    func showSpinner() {
        spinnerWidget = SpinnerWidget()
        spinnerWidget.showSpinner(contentView: self)
    }
    
    /**
     This method is called to remove spinner.
     */
    func hideSpinner() {
        spinnerWidget.hideSpinner()
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
