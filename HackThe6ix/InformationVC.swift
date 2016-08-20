//
//  InformationVC.swift
//  HackThe6ix
//
//  Created by Alex Nguyen on 2016-08-20.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
// 

import UIKit

class InformationVC: UIViewController {

    private var selectedImage : UIImage!
    
    @IBOutlet weak var selectedImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectedImgView.image = selectedImage
        selectedImgView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setup(withImage image : UIImage) {
        self.selectedImage = image
    }
}
