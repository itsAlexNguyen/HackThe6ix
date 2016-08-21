//
//  SuggestionCell.swift
//  HackThe6ix
//
//  Created by Alex Nguyen on 2016-08-20.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import UIKit

class SuggestionCell: UICollectionViewCell {
    
    private var item : Item?
    @IBOutlet weak var suggestImageView: MaterialImageView!
    
    func configureCell(item : Item, img : UIImage?){
        self.item = item
        if img != nil {
            self.suggestImageView.image = img
        } else {
            downloadImage(item.itemURl)
        }
    }
    func downloadImage(url: NSURL){
        getDataFromUrl(url) { (data, response, error)  in
            guard let data = data where error == nil else { return }
            dispatch_async(dispatch_get_main_queue(), { 
                self.suggestImageView.image = UIImage(data: data)
                //InformationVC.imageCache.setObject(self.suggestImageView.image!, forKey: self.item!.itemURl.absoluteString)
            })
        }
    }
    func getDataFromUrl(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            if error != nil {
                print("Error Downloading")
            } else {
                print("downloaded")
            }
            completion(data: data, response: response, error: error)
        }.resume()
    }
}
