//
//  ELPopUpVC.swift
//  ellie-demo
//
//  Created by Alex Nguyen on 2016-06-15.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var popUpView: UIView!
    
    private var completion = {}
    private var cancelBlock = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showInView(aView: UIView,animated: Bool, withCompletion completion: () -> Void, withCancelBlock cancel : () -> Void){
        aView.addSubview(self.view)
        self.completion = completion
        self.cancelBlock = cancel
        if animated {
            self.showAnimate()
        }
    }
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.hidden = true
                }
        });
    }

    @IBAction func doneBtnPressed(sender: AnyObject) {
        removeAnimate()
        completion()
    }
    @IBAction func cancelBtnPressed(sender: AnyObject) {
        removeAnimate()
        cancelBlock()
    }
    
}
