//
//  ThirdViewController.swift
//  aq
//
//  Created by Ye on 14-6-22.
//  Copyright (c) 2014 Ye Lin. All rights reserved.
//

import UIKit
import CoreData

class ThirdViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, UITextViewDelegate {
    
    let manager = AFHTTPRequestOperationManager()
    
    @IBOutlet var content: UITextField
    var connectionManager : ConnectionManager?

    var currentLat = 0.0
    var currentLng = 0.0
    
    var myColor = UIColor(red: 1, green: 174/255, blue: 0, alpha: 1)
    
    @lazy var data = NSMutableData()
    
    // button images
    var facebook_on : UIImage = UIImage(named: "facebook_on")
    var instagram_on : UIImage = UIImage(named: "instagram_on")
    
    @IBOutlet var facebookBtn: UIButton
    @IBOutlet var instagramBtn: UIButton
    @IBOutlet var myInput: UITextView
    
    @IBOutlet var myImg: UIImageView
    var tempMyImage : UIImage?
    var tempLeftImage : UIImage?
    var tempRightImage : UIImage?
    var currentFilter = Filter(data: -1, label: "", loc1: "", loc2: "", time1: "", time2: "", code: "")
    var currentRightFilter = Filter(data: -1, label: "", loc1: "", loc2: "", time1: "", time2: "", code: "")
    
    @IBOutlet var contentbg: UIView
    
    @IBOutlet var email: UITextField
    @IBOutlet var usernameBG: UIView
    @IBOutlet var username: UITextField
        /*
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }*/
    
    override func viewWillAppear(animated: Bool){
        self.navigationController.setNavigationBarHidden(false, animated: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool{
        
        var nextTag = textField.tag + 1
        
        // Try to find next responder
        var nextResponder = textField.superview.viewWithTag(nextTag)
        if nextResponder {
            println("found")
            // Found next responder, so set it
            nextResponder.becomeFirstResponder()
        }
        else{
            println("else")
            // Not found, so remove keyboard
            nextResponder.resignFirstResponder()
        }
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField!){
        
        println("hjkhsuhes")
        if textField == myInput {
            println("myInput")

        }
        else if textField == username {
            println("username")

        }
        else if textField == email {
            println("email")

        }
        //textField.endEditing(true)
        
        myInput.endEditing(true)
        email.endEditing(true)
        username.endEditing(true)

        
        
        myInput.resignFirstResponder()
        email.resignFirstResponder()
        username.resignFirstResponder()

        
    }

        
    func viewDidAppear(){
        
        //self.navigationController.navigationBarHidden = false
        //println("hsjkefhseuhefhsejkhfejsjefhs")
        
    
    }
    
    
    
    override func viewDidLoad() {
        
        //self.view.backgroundColor = UIColor.whiteColor()
        self.title = ""
        
        //self.navigationController.navigationBarHidden = false
        //println("navigation bar is \(self.navigationController.navigationBarHidden)")
        
        self.navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController.navigationBar.tintColor = UIColor.whiteColor()

        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        //myInput.sizeToFit()


        myInput.tintColor = myColor
        myInput.contentOffset = CGPointMake(0.0, 0.0)
        myInput.font = UIFont.systemFontOfSize(16)
        myInput.text = ""
        
        myImg.image = tempMyImage
        
        var btn = UIBarButtonItem(title: "SHARE", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goHome"))
        btn.tintColor = UIColor(red: 1, green: 174/255, blue: 0, alpha: 1)
        self.navigationItem.rightBarButtonItem = btn

        username.placeholder = "Username"
        email.placeholder = "Email (Optional)"
        username.delegate = self
        email.delegate = self
        myInput.delegate = self
        
        email.returnKeyType = UIReturnKeyType.Done
        username.returnKeyType = UIReturnKeyType.Next
        myInput.returnKeyType = UIReturnKeyType.Next
        
        email.clearButtonMode = UITextFieldViewMode.WhileEditing
        username.clearButtonMode = UITextFieldViewMode.WhileEditing
        
        username.tag = 1
        email.tag = 2

    }
    
    func goHome(){
        

        // to home view controller
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var homeViewController = storyboard.instantiateViewControllerWithIdentifier("homeViewController") as HomeViewController
        //self.navigationController.popViewControllerAnimated(true)
        
        sendData()
        
        // core data
        var appDelegate = UIApplication.sharedApplication().delegate
        var contextStore = (appDelegate as AppDelegate).managedObjectContext
       
        var entity = NSEntityDescription.insertNewObjectForEntityForName("MyPhoto", inManagedObjectContext: contextStore) as MyPhoto
        entity.num = NSNumber.numberWithInt(56)
        entity.photo = myImg.image
        entity.smallPhoto = resizeImage(tempMyImage!, width: 640, height: 640)
        entity.code = currentFilter.code
        entity.name1 = currentFilter.loc1
        entity.name2 = currentFilter.loc2
        contextStore.save(nil)

        connectionManager = ConnectionManager.sharedInstance
        connectionManager!.getAddedHomeViewCode()
        
        
        
        //
        self.navigationController.pushViewController(homeViewController as UIViewController, animated: true)
        
        
    }
    
    func sendData(){
        
        var originImg = resizeImage(tempMyImage!, width: 800 , height: 800)
        var originImgData = UIImageJPEGRepresentation(originImg, 1.0)
        var originEncodedString = "data:image/png;base64," + originImgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        
        var leftImg = resizeImage(tempLeftImage!, width: 400 , height: 800)
        var leftImgData = UIImageJPEGRepresentation(leftImg, 1.0)
        var leftEncodedString = "data:image/png;base64," + leftImgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        
        var rightImg = resizeImage(tempRightImage!, width: 400 , height: 800)
        var rightImgData = UIImageJPEGRepresentation(rightImg, 1.0)
        var rightEncodedString = "data:image/png;base64," + rightImgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        
        //let data1 = String((currentFilter as Filter).data)
        //let data2 = String((currentRightFilter as Filter).data)
        
        
        manager.requestSerializer.setValue("608c6c08443c6d933576b90966b727358d0066b4", forHTTPHeaderField: "X-Auth-Token")
        
        var parameters = ["username" : username.text,
            "email" : email.text,
            "content" : myInput.text,
            "originImg": originEncodedString,
            "leftImg" : leftEncodedString,
            "rightImg" : rightEncodedString,
            "leftData" : String(currentFilter.data),
            "leftLoc1" : currentFilter.loc1,
            "leftLoc2" : currentFilter.loc2,
            "leftTime1" : currentFilter.time1,
            "leftTime2" : currentFilter.time2,
            "leftLat" : String(currentLat),
            "leftLng" : String(currentLng),
            "leftCod" : currentFilter.code,
            "rightData" : String(currentRightFilter.data),
            "rightLoc1" : currentRightFilter.loc1,
            "rightLoc2" : currentRightFilter.loc2,
            "rightTime1" : currentRightFilter.time1,
            "rightTime2" : currentRightFilter.time2 ]
        
        manager.POST( "http://192.168.1.7:18080/send",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                println("JSON: " + responseObject.description)
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
            })
        
    }
    
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }
    func connectionDidFinishLoading(connection: NSURLConnection!) {

        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(self.data, options:    NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        println("hell got it \(jsonResult)")
        
    }
    
    func resizeImage(img: UIImage, width: Int, height: Int) -> UIImage{
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        img.drawInRect(CGRectMake(0, 0, CGFloat(width), CGFloat(height)))
        var newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImg
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookClicked(sender: AnyObject) {
        
        if(facebookBtn.selected){
            facebookBtn.selected = false
        }
        else{
            facebookBtn.selected = true
        }
        
    }
    @IBAction func instagramClicked(sender: AnyObject) {
        
        if(instagramBtn.selected){
            instagramBtn.selected = false
        }
        else{
            instagramBtn.selected = true
        }
    }
    @IBAction func dismissKeyboard(sender: AnyObject) {
        
        println("HJSHEJKHE")
        //sender.endEditing(true)
        myInput.resignFirstResponder()
        email.resignFirstResponder()
        username.resignFirstResponder()
        content.resignFirstResponder()
    }
    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
