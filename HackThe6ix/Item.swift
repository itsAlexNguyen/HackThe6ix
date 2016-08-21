//
//  Item.swift
//  HackThe6ix
//
//  Created by Alex Nguyen on 2016-08-21.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import Foundation

class Item {
    private var imageItemURL : NSURL?
    
    var itemURl : NSURL {
        return imageItemURL!
    }
    
    init(withURL URL : NSURL){
        imageItemURL = URL
    }
}