//
//  ViewController.swift
//  HackThe6ix
//
//  Created by Alex Nguyen on 2016-08-20.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import UIKit
import SCRecorder

class CameraVC: UIViewController, SCRecorderDelegate {

    
    //-----------------
    // MARK: - Variables
    //-----------------
    private var recorder : SCRecorder!
    private var selectedImage : UIImage?
    private var recordSession : SCRecordSession?
    private var popUp : PopUpVC?

    //-----------------
    // MARK: - IBOutlets
    //-----------------
    @IBOutlet weak var previewLayer: UIView!
    @IBOutlet weak var flashBtn: UIButton!
    
    
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
            self.popUp!.showInView(self.view, animated: true, withCompletion: { 
                    self.performSegueWithIdentifier("MAINTOSUGGESTION", sender: nil)
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
                infoScreen.setup(withImage: selectedImage!)
            }
        }
    }
    
    @IBAction func switchCameraBtnPressed(sender: AnyObject) {
        
    }
    @IBAction func flashBtnPressed(sender: AnyObject) {
        
    }
    
}

