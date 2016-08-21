//
//  InformationVC.swift
//  HackThe6ix
//
//  Created by Alex Nguyen on 2016-08-20.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
// 

import UIKit

class InformationVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //-----------------
    // MARK: - Variables
    //-----------------
    private var selectedImage : UIImage!
    private var suggestedItems : [Item]!
    static var imageCache = NSCache() //Makes photos load a little faster
    //-----------------
    // MARK: - IBOutlets
    //-----------------
    @IBOutlet weak var selectedImgView: UIImageView!
    
    //-----------------
    // MARK: - Initializers
    //-----------------
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
    
    func setup(withImage image : UIImage, withSuggestedItems items : [Item]) {
        self.selectedImage = image
        self.suggestedItems = items
    }
    //-----------------
    // MARK: - Collection View Delagates
    //-----------------
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestedItems.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SuggestionCell", forIndexPath: indexPath) as? SuggestionCell{
            var img : UIImage?
            img = InformationVC.imageCache.objectForKey(suggestedItems[indexPath.row].itemURl.absoluteString) as? UIImage
            cell.configureCell(suggestedItems[indexPath.row], img: img)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    @IBAction func backBtnPressed(sender: AnyObject) {
        performSegueWithIdentifier("BACK", sender: nil)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.frame.width/3-20, self.view.frame.width/3-20)
    }
}
