//
//  NavigationController.swift
//  aq
//
//  Created by Ye on 14-6-22.
//  Copyright (c) 2014 Ye Lin. All rights reserved.
//

import UIKit
import CoreLocation
import Darwin

class NavigationController: UINavigationController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{
    
    // CoreLocation
    var locationManager: CLLocationManager?
    var currentLat = 0.0
    var currentLng = 0.0
    
    
    var isStart = true
    
    var tempImage: UIImage?
    var filterLayer = UIView(frame: CGRectMake(0, 19, 320, 320))
    var contentLayer = UIView(frame: CGRectMake(0, 19, 320, 320))
    var touchLayer = UIView(frame: CGRectMake(0, 19, 320, 320))
    
    var leftHealthyBG = UIView(frame: CGRectMake(20, 270, 90, 26))
    var leftHealthyText = UILabel(frame: CGRectMake(0, 0, 90, 26))
    var leftData = UILabel(frame: CGRectMake(20, 190, 140, 100))
    
    var leftLocation = UILabel(frame: CGRectMake(20, 20, 280, 25))
    var leftLocation2 = UILabel(frame: CGRectMake(20, 42, 280, 25))
    var leftTime = UILabel(frame: CGRectMake(20, 64, 140, 20))
    var leftTime2 = UILabel(frame: CGRectMake(20, 81, 140, 20))
    
    var currentData = Filter(data: -1, label: "", loc1: "", loc2: "London", time1: "", time2: "NO2 Unit: µg/m3", code: "")
    
    var myTimer : NSTimer = NSTimer()
    var checkTimer : NSTimer = NSTimer()
    var startTimer : NSTimer = NSTimer()
    var startNum = 0
    
    var connectionManager : ConnectionManager?
    
    
    var hideLayer = UIView(frame: CGRectMake(0, 88, 320, 480))
    var hideLayer2 = UIView(frame: CGRectMake(0, 88, 320, 480))
    var hideLayer3 = UIView(frame: CGRectMake(0, 88, 320, 480))
    var blackBG = UIView(frame: CGRectMake(0, 480, 320, 88))
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController!){
        
        
        myTimer.invalidate()
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var homeViewController = storyboard.instantiateViewControllerWithIdentifier("homeViewController") as HomeViewController
        self.pushViewController(homeViewController as UIViewController, animated: true)
        
    }
    
    func navigationController(_ navigationController: UINavigationController!,
        willShowViewController viewController: UIViewController!,
        animated animated: Bool){
            
            //println("navigation!!!")
            //if (viewController.isEqual(self.viewControllers[0])) {
                //println("dhjk")
            

                //println("navigation!!!")
            /*
                UIView.animateWithDuration(2.0, animations: {}, completion: {(value: Bool) in
                    self.initFilter()
                    })
*/
                //startTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("initFilter"), userInfo: nil, repeats: false)
                //filterTimer.fire()
            
            self.navigationBarHidden = true
            connectionManager = ConnectionManager.sharedInstance
            println("init")
            
            
            
            checkTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("checkData"), userInfo: nil, repeats: true)
            
            
            //}
            /*
            if(viewController.isKindOfClass(UIImagePickerController)){
                println("dhjk")
                self.navigationBarHidden = true
            }*/
    }
    
    init(coder aDecoder: NSCoder!) {
        
        super.init(coder: aDecoder)
        
        var camera = self.viewControllers[0] as UIImagePickerController
        camera.sourceType = UIImagePickerControllerSourceType.Camera
        camera.title = ""
        camera.showsCameraControls = true
        //camera.allowsEditing = true
        camera.showsCameraControls = true
        camera.delegate = self
        
        
        // camera overlay overall
        var overlayview = UIView(frame: CGRectMake(0, 69, 320, 429))
        
        // filter layer
        filterLayer.backgroundColor = UIColor.brownColor()
        filterLayer.alpha = 0
        overlayview.addSubview(filterLayer)
        
        // upper black layer
        var upperLayer = UIView(frame: CGRectMake(0, 0, 320, 19))
        upperLayer.backgroundColor = UIColor.blackColor()
        // lower black layer
        var lowerLayer = UIView(frame: CGRectMake(0, 339, 320, 90))
        lowerLayer.backgroundColor = UIColor.blackColor()
        
        
        contentLayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        // add two
        overlayview.addSubview(upperLayer)
        overlayview.addSubview(lowerLayer)
        overlayview.addSubview(contentLayer)
        
        
        // left
        //leftData.text = "80"
        leftData.font = UIFont(name: "HelveticaNeue-Light", size: 60)
        leftData.textColor = UIColor.whiteColor()
        contentLayer.addSubview(leftData)
        // healthy & unhealthy BG
        leftHealthyBG.layer.cornerRadius = 3
        leftHealthyBG.backgroundColor = UIColor.redColor()
        leftHealthyBG.hidden = true
        contentLayer.addSubview(leftHealthyBG)
        // healthy & unhealthy text
        //leftHealthyText.text = "Unhealthy"
        leftHealthyText.textAlignment = NSTextAlignment.Center
        leftHealthyText.font =  UIFont.systemFontOfSize(16)
        leftHealthyText.textColor = UIColor.whiteColor()
        leftHealthyBG.addSubview(leftHealthyText)
        
        //leftLocation.text = "Euston"
        leftLocation.textColor = UIColor.whiteColor()
        //leftLocation.font =  UIFont.systemFontOfSize(28)
        leftLocation.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        contentLayer.addSubview(leftLocation)
        
        //leftLocation2.text = "London"
        leftLocation2.textColor = UIColor.whiteColor()
        //leftLocation2.font =  UIFont.systemFontOfSize(28)
        leftLocation2.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        contentLayer.addSubview(leftLocation2)
        
        //leftTime.text = "NO2 µg/m3"
        leftTime.textColor = UIColor.whiteColor()
        leftTime.font =  UIFont.systemFontOfSize(14)
        contentLayer.addSubview(leftTime)
        
        //leftTime2.text = ""
        leftTime2.textColor = UIColor.whiteColor()
        leftTime2.font =  UIFont.systemFontOfSize(14)
        contentLayer.addSubview(leftTime2)
        
        contentLayer.addSubview(touchLayer)
        
        
        camera.cameraOverlayView = overlayview
        
        
        
        println(isStart)

        if isStart {
            
            initHideLayer()
            initEULimit()
            initCurrent()
            blackBG.backgroundColor = UIColor.blackColor()
            self.view.addSubview(blackBG)
            UIView.animateWithDuration(0.1, animations: {
                self.hideLayer.alpha = 1
                })
        }
        else {
            
            
        }
        
        

        
        
        
        self.navigationBarHidden = true

        initCoreLocation()
        
    }
    func showNext(){
        
        UIView.animateWithDuration(1, animations: {
            self.hideLayer.alpha = 0
            }, completion: {(value: Bool) in
                
                UIView.animateWithDuration(0.1, animations: {
                    self.hideLayer2.alpha = 1
                    })
                var nextTimer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: Selector("showNext2"), userInfo: nil, repeats: false)
            })
        
    }
    
    func showNext2(){
        
        UIView.animateWithDuration(1, animations: {
            self.hideLayer2.alpha = 0
            }, completion: {(value: Bool) in
                
                UIView.animateWithDuration(0.1, animations: {
                    self.hideLayer3.alpha = 1
                    })
                var nextTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("showRealData"), userInfo: nil, repeats: false)
            })
        
    }
    
    func showRealData(){
        
        UIView.animateWithDuration(0.1, animations: {
            self.hideLayer3.alpha = 0
            }, completion: {(value: Bool) in
                
                // show real data!!
                self.initFilter()
                self.blackBG.hidden = true
                self.isStart = false
            })
        
    }
    
    
    func initHideLayer(){
        
        var text1 = UILabel(frame: CGRectMake(20, 150, 200, 160))
        text1.numberOfLines = 0
        text1.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        text1.textColor = UIColor.whiteColor()
        text1.attributedText = regBoldText("How Is The NO2 Level At Your Current Position?", fontsize: 30, color: UIColor.whiteColor(), range: NSMakeRange(11, 3))
        
        var text2 = UILabel(frame: CGRectMake(20, 330, 270, 20))
        text2.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        text2.textColor = UIColor(white: 0.5, alpha: 1.0)
        text2.attributedText = regBoldText("* Waiting to get data from London Air", fontsize: 12, color: UIColor(white: 0.5, alpha: 1.0), range: NSMakeRange(27, 10))
        
        hideLayer.addSubview(text1)
        hideLayer.addSubview(text2)
        
        self.view.addSubview(hideLayer)
        hideLayer.alpha = 0
    }
    
    func initEULimit(){
        
        var text1 = UILabel(frame: CGRectMake(0, 120, 320, 40))
        text1.textAlignment = NSTextAlignment.Center
        text1.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        text1.textColor = UIColor.whiteColor()
        text1.attributedText = regBoldText("The EU Limit of", fontsize: 30, color: UIColor.whiteColor(), range: NSMakeRange(4, 8))
        
        var text2 = UILabel(frame: CGRectMake(0, 160, 320, 40))
        text2.textAlignment = NSTextAlignment.Center
        text2.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        text2.textColor = UIColor.whiteColor()
        text2.attributedText = regBoldText("NO2 is 40 µg/m3", fontsize: 30, color: UIColor.whiteColor(), range: NSMakeRange(7, 2))
        
        hideLayer2.addSubview(text1)
        hideLayer2.addSubview(text2)
        self.view.addSubview(hideLayer2)
        hideLayer2.alpha = 0
    }
    
    func initCurrent(){
        
        var text1 = UILabel(frame: CGRectMake(20, 136, 280, 24))
        text1.text = "The Current NO2 level is"
        text1.textAlignment = NSTextAlignment.Center
        text1.font = UIFont(name: "HelveticaNeue", size: 20)
        text1.textColor = UIColor.whiteColor()
        
        
        var text2 = UILabel(frame: CGRectMake(20, 160, 280, 24))
        text2.text = "... ..."
        text2.textAlignment = NSTextAlignment.Center
        text2.font = UIFont(name: "HelveticaNeue", size: 20)
        text2.textColor = UIColor.whiteColor()
        
        hideLayer3.addSubview(text1)
        hideLayer3.addSubview(text2)
        self.view.addSubview(hideLayer3)
        hideLayer3.alpha = 0
    }
    
    
    
    func regBoldText(text: NSString, fontsize: Int, color: UIColor, range: NSRange) -> NSMutableAttributedString{
        
        var mytext = text
        var boldFont = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(fontsize))
        var regularFont = UIFont(name: "HelveticaNeue-Light", size: CGFloat(fontsize))
        var foregroundColor = color
        
        // Create the attributes
        var attrs = NSDictionary(objects: [regularFont, foregroundColor], forKeys: [NSFontAttributeName, NSForegroundColorAttributeName])
        var subAttrs = NSDictionary(object: boldFont, forKey: NSFontAttributeName)
        var myrange = range
        var attributedT = NSMutableAttributedString(string: text, attributes: attrs)
        attributedT.setAttributes(subAttrs, range: myrange)
        
        return attributedT
    }
    
    
    
    func initCoreLocation() {
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Restricted) {
            
        }
        else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined) {
            
            locationManager = CLLocationManager()

            if (locationManager) {
                locationManager!.delegate = self
                locationManager!.distanceFilter = kCLDistanceFilterNone; // whenever we move
                locationManager!.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
                locationManager!.startUpdatingLocation()
            }
        }
        else {
            
            locationManager = CLLocationManager()
            
            if (locationManager) {
                locationManager!.delegate = self
                locationManager!.distanceFilter = kCLDistanceFilterNone; // whenever we move
                locationManager!.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
                locationManager!.startUpdatingLocation()
            }
            
            printLocaiont()
        }
        
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            if (status == CLAuthorizationStatus.Authorized || status == CLAuthorizationStatus.AuthorizedWhenInUse) {
                printLocaiont()
            }
    }
    
    
    func printLocaiont() {
        
        var geocoder : CLGeocoder = CLGeocoder()
        var p:CLPlacemark?
        
        geocoder.reverseGeocodeLocation(locationManager?.location, completionHandler: {
            (placemarks, error) in
            let pm = placemarks as? CLPlacemark[]
            if (pm && pm?.count > 0){
                p = placemarks[0] as? CLPlacemark
            }
            
            self.currentData.loc1 = (p?.addressDictionary as NSDictionary).objectForKey("Street") as NSString
            self.currentData.loc2 = (p?.addressDictionary as NSDictionary).objectForKey("City") as NSString
            println("Location coordinate is \(self.locationManager?.location.coordinate.latitude) \(self.locationManager?.location.coordinate.longitude) administrative area \(p?.addressDictionary)")
            
            var lat = self.locationManager?.location.coordinate.latitude
            var lng = self.locationManager?.location.coordinate.longitude
            
            self.currentLat = lat!
            self.currentLng = lng!
        
            
            self.connectionManager?.setCurrentLocation(lat!, lng: lng!)
            
        })
        
        
        
    }

    
    func imagePickerController(_ picker: UIImagePickerController!,
        didFinishPickingMediaWithInfo info: NSDictionary!){
            
            tempImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
            //tempImage = cropImage(tempImage!)
            //picker.dismissModalViewControllerAnimated(true)
            // picker.dismissViewControllerAnimated(true, completion: {
            //self.performSegueWithIdentifier("cameraSegue", sender: self)
            
            
            myTimer.invalidate()
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            var secondViewController = storyboard.instantiateViewControllerWithIdentifier("secondViewController") as SecondViewController
            secondViewController.tempImage = tempImage
            secondViewController.currentFilter = currentData
            secondViewController.currentLat = currentLat
            secondViewController.currentLng = currentLng
            //println(tempImage?.size)
            self.pushViewController(secondViewController as UIViewController, animated: true)
            
               // })
            
            
    }
    

    
    override func viewDidLoad() {

        super.viewDidLoad()
        
    }


    // init start animation
    func initFilter(){
        //println(startNum)
        UIView.animateWithDuration(0.02, animations: {
            self.updateFilterContent(self.startNum)
            }, completion: {(value: Bool) in
                if (self.startNum < self.currentData.data){
                    ++self.startNum
                    self.initFilter()
                }
                else{
                    self.myTimer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: Selector("updateFilter"), userInfo: nil, repeats: true)
                }
        })
    }
    
    
    
    func updateFilterContent(num: Int){
 
        //var num = currentData.data
        if(num != -1){

            // visible and update
            filterLayer.hidden = false
            contentLayer.hidden = false
            leftHealthyBG.hidden = false
            
            leftData.text = String(num)
            filterLayer.alpha = CGFloat(getAlpha(num))
            leftHealthyBG.hidden = false
            if(num <= 40){ // healthy
                leftHealthyBG.backgroundColor = UIColor(red: 0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
                leftHealthyText.text = "Healthy"
            }
            else{ // unhealthy
                leftHealthyBG.backgroundColor = UIColor.redColor()
                leftHealthyText.text = "Unhealthy"
            }
            
            leftLocation.text = currentData.loc1
            leftLocation2.text = currentData.loc2
            leftTime.text = currentData.time1
            leftTime2.text = currentData.time2

            
        }
        else{
            
            // invisible
            filterLayer.hidden = true
            contentLayer.hidden = true
            leftHealthyBG.hidden = true
        }

        
    }
    
    //
    func updateFilter(){

        if (connectionManager!.currentData.data != -1) {

            getCurrentData()
            var num = Int(arc4random_uniform(10))
            updateFilterContent(currentData.data + num)
        }
    }
    
    
    
    
    // check if the connectionManager has got the current AQ data
    func checkData(){
        
        if (connectionManager!.currentData.data == -1) {
            
            getCurrentData()
            // start animation
            
            if isStart == true {
                
                UIView.animateWithDuration(2.0, animations: {}, completion: {(value: Bool) in
                    //self.initFilter()
                    var nextTimer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: Selector("showNext"), userInfo: nil, repeats: false)
                    })
            }
            else{
                
                initFilter()
            }
            
            checkTimer.invalidate()
        }
    }
    
    // get data from connectionManager
    func getCurrentData(){
        
        var data = connectionManager!.currentData.data
        currentData.data = Int(data)
        //var name = connectionManager!.currentData.loc1
        //currentData.loc1 = name
        
        var code = connectionManager!.currentData.code
        currentData.code = code
        
        var time1 = connectionManager!.currentData.time2
        currentData.time1 = time1
    }
    
    // get filter alpha value
    func getAlpha(num:Int) -> Double{
        
        if(num <= 40){
            return 0
        }
        else if(num > 40 && num <= 120){
            return 3/800.0 * Double(num) - 1/20.0
        }
        else{
            return 0.5
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
