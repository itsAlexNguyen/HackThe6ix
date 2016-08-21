//
//  ViewController.swift
//  HackThe6ix
//
//  Created by Alex Nguyen on 2016-08-20.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import UIKit
import SCRecorder
import Alamofire

class CameraVC: UIViewController, SCRecorderDelegate, NSURLConnectionDelegate {

    private let URL_BASE = "http://ec2-52-42-173-161.us-west-2.compute.amazonaws.com/"
    //-----------------
    // MARK: - Variables
    //-----------------
    private var recorder : SCRecorder!
    private var selectedImage : UIImage?
    private var selectedName : String?
    private var selectedRating : String?
    private var recordSession : SCRecordSession?
    private var popUp : PopUpVC?
    private var selectedItems = [Item]()
    //-----------------
    // MARK: - IBOutlets
    //-----------------
    @IBOutlet weak var previewLayer: UIView!
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var refreshSpinner: UIActivityIndicatorView!
    
    //-----------------
    // MARK: - Initializers
    //-----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpRecorder()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        recorder.startRunning()
    }
    func startSpinner() {
        refreshSpinner.hidden = false
        refreshSpinner.startAnimating()
        refreshSpinner.alpha = 1
    }
    func stopSpinner() {
        refreshSpinner.hidesWhenStopped = true
        refreshSpinner.hidden = true
        refreshSpinner.alpha = 0
    }
    //-----------------
    // MARK: - Helper Functions
    //-----------------
    private func setUpRecorder(){
        recorder = SCRecorder()
        recorder.captureSessionPreset = SCRecorderTools.bestCaptureSessionPresetCompatibleWithAllDevices()
        recorder.delegate = self
        recorder.autoSetVideoOrientation = false
        recorder.previewView = previewLayer
    }
    private func uploadSelectedImage(){
        print("uploading selected image")
        let urlString = "\(URL_BASE)get.php?RECOMMEND"
        let url = NSURL(string: urlString)!
        let imgData = UIImageJPEGRepresentation(selectedImage!, 0.4)
        print(selectedName)
        print(selectedRating)
        let stringData = "test".dataUsingEncoding(NSUTF8StringEncoding)
        startSpinner()
        Alamofire.upload(.POST, url, multipartFormData: { (multipartFormdata) in
            multipartFormdata.appendBodyPart(data: stringData!, name: "NAME")
            multipartFormdata.appendBodyPart(data: stringData!, name: "RATING")
            multipartFormdata.appendBodyPart(data: imgData!, name: "0", fileName: "0.png", mimeType: "image/jpeg")
            }, encodingCompletion: {encodingResult in
                self.stopSpinner()
                switch(encodingResult) {
                case .Success(let upload, _, _):
                    upload.responseData(completionHandler: { (response) in
                        let data = response.data
                        let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        self.processOutPut(datastring!)
                        self.performSegueWithIdentifier("MAINTOSUGGESTION", sender: nil)
                    })
                case .Failure(_):
                    print("failure")
                }
        })
        
    }
    @IBAction func shutterBtnPressed(sender: AnyObject) {
        recorder.capturePhoto { (error, image) in
            if error != nil {
                print("error getting photo")
            } else {
                if self.recorder.device == AVCaptureDevicePosition.Front {
                    //if it's the front camera, then mirror the image
                    let modifiedImage = UIImage(CGImage: (image?.CGImage)!, scale: 1.0, orientation: UIImageOrientation.LeftMirrored)
                    //This select the mirror image
                    self.selectedImage = modifiedImage
                } else {
                    //otherwise(ie is back camera, select the current image)
                    self.selectedImage = image!
                }
                //Stop the recorder
                self.recorder.stopRunning()
            }
            self.popUp = PopUpVC()
            self.popUp!.view.frame = self.view.frame
            self.popUp?.showInView(self.view, withImage: image!, animated: true, withCompletion: { (name, rating) in
                self.selectedName = name
                self.selectedRating = rating
                self.uploadSelectedImage()
                }, withCancelBlock: { 
                    self.recorder = SCRecorder()
                    self.recorder.captureSessionPreset = SCRecorderTools.bestCaptureSessionPresetCompatibleWithAllDevices()
                    self.recorder.delegate = self
                    self.recorder.autoSetVideoOrientation = false
                    self.recorder.previewView = self.previewLayer
                    self.recorder.startRunning()
                    print("Canceled")
            })
        }
    }
    //-----------------
    // MARK: - SEGUE
    //-----------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MAINTOSUGGESTION" {
            if let infoScreen = segue.destinationViewController as? InformationVC {
                infoScreen.setup(withImage: selectedImage!, withSuggestedItems: selectedItems)
            }
        }
    }
    
    @IBAction func switchCameraBtnPressed(sender: AnyObject) {
        //Switch the camera device (front or back)
        recorder.switchCaptureDevices()

    }
    @IBAction func flashBtnPressed(sender: AnyObject) {
        if recorder.flashMode == SCFlashMode.On {
            flashBtn.alpha = 0.5
            recorder.flashMode = SCFlashMode.Off
        } else {
            flashBtn.alpha = 1
            recorder.flashMode = SCFlashMode.On
        }
    }
    
    private func processOutPut(output : NSString) {
        let strArray = output.componentsSeparatedByString(",[")
        var strArray2 = strArray[1].componentsSeparatedByString("\",")
        let dew = Item(withURL: NSURL(string: "http://fandbnews.com/wp-content/uploads/2015/03/195110.jpg")!)
        selectedItems.append(dew)
        for i in 1..<strArray2.count {
            let index = strArray2[i].startIndex.advancedBy(4)
            strArray2[i] = strArray2[i].stringByReplacingOccurrencesOfString("]", withString: "")
            strArray2[i] = strArray2[i].stringByReplacingOccurrencesOfString("\"", withString: "")
            print(URL_BASE + strArray2[i].substringFromIndex(index))
            if let url = NSURL(string: URL_BASE + strArray2[i].substringFromIndex(index)) {
                let newItem = Item(withURL: url)
                selectedItems.append(newItem)
            }
        }
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
