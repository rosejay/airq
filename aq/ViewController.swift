//
//  ViewController.swift
//  aq
//
//  Created by Joseph Williamson on 15/06/2014.
//  Copyright (c) 2014 Ye Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var myImage : UIImageView
    var tempImage: UIImage?
    
    
    override func viewDidLoad() {
        self.navigationController.navigationBar.hidden = false
        //self.navigationController.navigationBar
        self.title = "AQ FILTER"
        
        
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        //UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePhoto(sender : AnyObject) {
        doTakePhoto()
    }
    
    
    
    func doTakePhoto(){
        var camera = UIImagePickerController()
        camera.sourceType = UIImagePickerControllerSourceType.Camera
        camera.showsCameraControls = true
        camera.allowsEditing = true
        camera.delegate = self
        self.presentModalViewController(camera, animated: true)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController!,
        didFinishPickingMediaWithInfo info: NSDictionary!){
            
        tempImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        myImage.image = tempImage;
        //picker.dismissModalViewControllerAnimated(true)
            
            picker.dismissViewControllerAnimated(true, completion: {
                self.performSegueWithIdentifier("cameraSegue", sender: self)
                
                })
        
            
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
        var destVC = segue.destinationViewController as SecondViewController
        

        destVC.tempImage = tempImage;
        
    }

}