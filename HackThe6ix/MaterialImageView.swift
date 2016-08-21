//
//  MaterialImageView.swift
//  HackThe6ix
//
//  Created by Alex Nguyen on 2016-08-20.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import UIKit

class MaterialImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        let SHADOW_COLOUR: CGFloat = 157.0/255.0
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor(red: SHADOW_COLOUR, green: SHADOW_COLOUR, blue: SHADOW_COLOUR, alpha: 1.0).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }

}
