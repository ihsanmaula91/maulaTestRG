//
//  SpinnerWidget.swift
//  MaulaTriviaRG
//
//  Created by Muhammad Ihsan Maula on 11/24/17.
//  Copyright © 2017 Muhammad Ihsan Maula. All rights reserved.
//

import UIKit

class SpinnerWidget: UIViewController {

    public var navigationHeight: CGFloat = 0.00
    public var containerView: UIViewController!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        loadFromXibWithCurrentClassName()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFromXibWithCurrentClassName() {
        let xibName: String? = NSStringFromClass(type(of: self)).components(separatedBy: ".").last
        let widget: UIViewController? = Bundle.main.loadNibNamed(xibName!, owner: self, options: nil)?[0] as? UIViewController
        
        if widget != nil {
            addChildViewController(widget!)
            view.addSubview(widget!.view)
        }
    }
    
    public func showSpinner(contentView: UIViewController!) {
        containerView = contentView
        let frame = CGRect(x: contentView.view.frame.minX, y: navigationHeight, width: contentView.view.frame.width, height: UIScreen.main.bounds.height)
        self.view.frame = frame
        self.view.layer.zPosition = 1000
        containerView.navigationController?.view.addSubview(self.view)
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    public func hideSpinner() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion:{(finished : Bool)  in
            if finished {
                self.view.removeFromSuperview()
            }
        });
    }

}
