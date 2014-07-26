//
//  SecondViewController.swift
//  aq
//
//  Created by Ye on 14-6-15.
//  Copyright (c) 2014 Ye Lin. All rights reserved.
//

import UIKit
import customViews
import CoreImage
import CoreGraphics

class SecondViewController: UIViewController, NSURLConnectionDelegate {
    
    var connectionManager : ConnectionManager?
    var currentLat = 0.0
    var currentLng = 0.0
    
    // json data
    @lazy var data = NSMutableData()
    
    // ui
    @IBOutlet var controlView : UIScrollView
    @IBOutlet var controlView2: UIScrollView
    @IBOutlet var controlView3: UIScrollView
    
    @IBOutlet var aqImage : UIImageView
    
    
    @IBOutlet var leftImg: UIImageView
    @IBOutlet var rightImg: UIImageView
    var leftOrigin : UIImage?
    var rightOrigin : UIImage?
    
    @IBOutlet var filterBtn1: UIButton
    @IBOutlet var filterBtn2: UIButton
    @IBOutlet var filterBtn3: UIButton
    
    
    @IBOutlet var filterContent: UIView
    @IBOutlet var leftFilter: UIView
    @IBOutlet var rightFilter: UIView
    
    var touchLayer = UIView(frame: CGRectMake(0, 0, 320, 320))

    
    var tempImage : UIImage?
    
    var leftHealthyBG = UIView(frame: CGRectMake(20, 270, 90, 26))
    var leftHealthyText = UILabel(frame: CGRectMake(0, 0, 90, 26))
    var leftData = UILabel(frame: CGRectMake(20, 190, 140, 100))
    
    var leftLocation = UILabel(frame: CGRectMake(20, 20, 140, 25))
    var leftLocation2 = UILabel(frame: CGRectMake(20, 42, 140, 25))
    var leftTime = UILabel(frame: CGRectMake(20, 64, 140, 20))
    var leftTime2 = UILabel(frame: CGRectMake(20, 81, 140, 20))
    
    var rightHealthyBG = UIView(frame: CGRectMake(210, 270, 90, 26))
    var rightHealthyText = UILabel(frame: CGRectMake(0, 0, 90, 26))
    var rightData = UILabel(frame: CGRectMake(160, 190, 140, 100))
    
    var rightLocation = UILabel(frame: CGRectMake(160, 20, 140, 25))
    var rightLocation2 = UILabel(frame: CGRectMake(160, 42, 140, 25))
    var rightTime = UILabel(frame: CGRectMake(160, 64, 140, 20))
    var rightTime2 = UILabel(frame: CGRectMake(160, 81, 140, 20))
    
    // button images
    var btn1_on : UIImage = UIImage(named: "btn1_on")
    var btn1_off : UIImage = UIImage(named: "btn1_off")
    var btn2_on : UIImage = UIImage(named: "btn2_on")
    var btn2_off : UIImage = UIImage(named: "btn2_off")
    var btn3_on : UIImage = UIImage(named: "btn3_on")
    var btn3_off : UIImage = UIImage(named: "btn3_off")
    
    var btnArray : UIView[] = []
    
    var currentFilter = Filter(data: 80, label: "", loc1: "Euston", loc2: "London", time1: "NO2 µg/m3", time2: "", code: "")
    var currentRightFilter = Filter(data: 0, label: "", loc1: "", loc2: "", time1: "", time2: "", code: "")
    
    var myFilter1 = [Filter(data: -99, label: "None", loc1: "", loc2: "", time1: "", time2: "", code: "")]
    var myFilter1Append = [
        Filter(data: 12, label: "Cambridge", loc1: "Roadside", loc2: "Cambridge", time1: "61.7 miles", time2: "Annual Mean", code: ""),
        Filter(data: 32, label: "Sheffield", loc1: "Central", loc2: "Sheffield", time1: "168 miles", time2: "Annual Mean", code: ""),
        Filter(data: 16, label: "York", loc1: "Roadside", loc2: "York", time1: "209 miles", time2: "Annual Mean", code: ""),
        Filter(data: 7, label: "Glasgow", loc1: "City", loc2: "Glasgow", time1: "414 miles", time2: "Annual Mean", code: ""),
        
        Filter(data: 21, label: "Paris", loc1: "Élysées", loc2: "Paris", time1: "284 miles", time2: "Annual Mean", code: ""),
        Filter(data: 16, label: "Berlin", loc1: "Brandenburg", loc2: "Berlin", time1: "677 miles", time2: "Annual Mean", code: ""),
        Filter(data: 26, label: "Madrid", loc1: "Central", loc2: "Madrid", time1: "951 miles", time2: "Annual Mean", code: ""),
        
        Filter(data: 20, label: "Beijing", loc1: "TianAnMen", loc2: "Beijing", time1: "5176 miles", time2: "Annual Mean", code: ""),
        Filter(data: 11, label: "New York", loc1: "", loc2: "New York", time1: "3466 miles", time2: "Annual Mean", code: ""),
        Filter(data: 1, label: "Los Angeles", loc1: "", loc2: "Los Angeles", time1: "4986 miles", time2: "Annual Mean", code: ""),
        Filter(data: 2, label: "Sydney", loc1: "", loc2: "Sydney", time1: "7592 miles", time2: "Annual Mean", code: "")]
    
    var myFilter2 : Filter[] = []
    var myFilter3 = [Filter(data: 40, label: "EU Limit", loc1: "EU Limit", loc2: "Of NO2", time1: "Annual Mean", time2: "", code: ""),
        Filter(data: 93, label: "London", loc1: "50% Sites", loc2: "Exceeded", time1: "EU Limit", time2: "in London 2013", code: ""),
        Filter(data: 121, label: "NO2", loc1: "95%", loc2: "NO2", time1: "Comes From", time2: "Diesel Exhausts", code: ""),
        Filter(data: 130, label: "Busy Roads", loc1: "30%-100%", loc2: "Higher NO2", time1: "Within 50 Meters", time2: "Of Heavy Traffic", code: ""),
        Filter(data: 92, label: "1998", loc1: "Cars", loc2: "Dieselisation", time1: "Less CO2 More NO2", time2: "In London", code: ""),
        Filter(data: 463, label: "Oxford St.", loc1: "Oxford St.", loc2: "Highest NO2", time1: "Worst In The World", time2: "Peak Time (µg/m3)", code: ""),
        Filter(data: 20, label: "Beijing", loc1: "Better NO2", loc2: "Worse PM2.5", time1: "PM2.5 & PM10", time2: "Visible Pollutants", code: ""),
        Filter(data: 12, label: "Bus Retrofit", loc1: "Bus Retrofit", loc2: "88% Less", time1: "Retrofit 1000 Buses", time2: "88% reduction", code: ""),
        Filter(data: 27, label: "Walk", loc1: "Walk On", loc2: "Quiet Streets", time1: "Exposed To", time2: "50% Less NO2", code: ""),
        Filter(data: 35, label: "Green Bus", loc1: "Hydrogen Bus", loc2: "Electric Bus", time1: "No Tailpipe Emission", time2: "Zero Emission In 2018", code: "")]
    
    
    init(coder aDecoder: NSCoder!){
        super.init(coder: aDecoder)
    }
    

    /*{
    didSet{
    
    if (tempImage) {
    println("has tempimage")
    }
    
    if (aqImage) {
    println("has aqimage")
    }
    //aqImage.image = tempImage
    }
    
    /*
    get{
    return self.tempImage
    }
    set (temp){
    self.tempImage = temp!
    aqImage.image = tempImage
    }
    */
    }*/
    
    /*
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    // Custom initialization
    }*/
    
    
    override func viewDidLoad() {
        
        //self.setNeedsStatusBarAppearanceUpdate()
        self.view.backgroundColor = UIColor.blackColor()
        self.navigationController.navigationBarHidden = false
        self.title = "EXPLORE"
        
        
        self.navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController.navigationBar.tintColor = UIColor.whiteColor()
        
        super.viewDidLoad()
        var backButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        //self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.backBarButtonItem = backButtonItem
        
        
        var imageBtn : UIImage = UIImage(named: "icon")
        var rightbutton = UIBarButtonItem(image: imageBtn, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        var pressbtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: nil)
        var btn = UIBarButtonItem(title: "SEND", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goToThird"))
        btn.tintColor = UIColor(red: 1, green: 174/255, blue: 0, alpha: 1)
        self.navigationItem.rightBarButtonItem = btn
        
        
        // init scrollView
        var grey = CGFloat(22.0/255.0)
        var bgColor = UIColor(red: grey, green: grey, blue: grey, alpha: 1.0)
        controlView.backgroundColor = UIColor.blackColor()
        controlView2.backgroundColor = UIColor.blackColor()
        controlView3.backgroundColor = UIColor.blackColor()
        
        
        var imgWidth = (tempImage as UIImage).size.width
        var imgHeight = (tempImage as UIImage).size.height
        UIGraphicsBeginImageContext(CGSize(width: imgWidth, height: imgWidth))
        (tempImage as UIImage).drawInRect(CGRectMake(0, -146, imgWidth, imgHeight))
        var newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        aqImage.image = newImg
        aqImage.alpha = 0
        
        UIGraphicsBeginImageContext(CGSize(width: imgWidth/2, height: imgWidth))
        (tempImage as UIImage).drawInRect(CGRectMake(0, -146, imgWidth, imgHeight))
        leftOrigin = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        leftImg.image = leftOrigin
        
        UIGraphicsBeginImageContext(CGSize(width: imgWidth/2, height: imgWidth))
        (tempImage as UIImage).drawInRect(CGRectMake(-imgWidth/2, -146, imgWidth, imgHeight))
        rightOrigin = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        rightImg.image = rightOrigin
        println("init2")

        println(currentFilter.code)
        
        
        // init data
        connectionManager = ConnectionManager.sharedInstance
        
        initFilterBtn()
        addBtn()
        
        // set filter1 selected
        showFilter1(self)
        
        initFilter()
        setLeftFilter(currentFilter)
        setRightFilter(0, filterIndex: 0)
        println("init1")

    }

    func initFilterBtn(){
        
        for var index = 0; index < connectionManager!.filterSites.count; ++index {
            
            var temp = connectionManager!.filterSites[index] as MySite
            if(temp.data != -1){
                //var distance = Int(temp.distance!)
                var distance = NSString(format:"%.2f", temp.distance!)
                var newData : Filter = Filter(data: temp.data, label: temp.name, loc1: temp.name, loc2: "London", time1: String(distance) + " mile", time2: connectionManager!.todayDate?.todayString, code: temp.code!)
                myFilter1 += newData
            }
            
        }
        for var index = 0; index < myFilter1Append.count; ++index {
            myFilter1Append[index].time2 = connectionManager!.todayDate?.todayString
        }
        myFilter1 += myFilter1Append
        for var index = 0; index < connectionManager!.dateArray.count; ++index {
            
            var temp = connectionManager!.dateFilter[index] as MySite
            if(temp.data != -1){
                var myString = connectionManager!.stringArray[index]
                var loc1 = myString.substringToIndex(7)
                var loc2 = myString.substringFromIndex(7)
                
                var newData : Filter = Filter(data: temp.data, label: connectionManager!.stringArray[index], loc1: loc1, loc2: loc2, time1: currentFilter.loc1, time2: currentFilter.loc2, code: temp.code!)
                myFilter2 += newData
            }
            
        }
    }
    
    func initFilter(){
        
        leftFilter.backgroundColor = UIColor.brownColor()
        rightFilter.backgroundColor = UIColor.brownColor()
        filterContent.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        // left
        //leftData.text = "80"
        leftData.font = UIFont(name: "HelveticaNeue-Light", size: 60)
        leftData.textColor = UIColor.whiteColor()
        filterContent.addSubview(leftData)
        // healthy & unhealthy BG
        leftHealthyBG.layer.cornerRadius = 3
        leftHealthyBG.backgroundColor = UIColor.redColor()
        filterContent.addSubview(leftHealthyBG)
        // healthy & unhealthy text
        leftHealthyText.text = "Unhealthy"
        leftHealthyText.textAlignment = NSTextAlignment.Center
        leftHealthyText.font =  UIFont.systemFontOfSize(16)
        leftHealthyText.textColor = UIColor.whiteColor()
        leftHealthyBG.addSubview(leftHealthyText)
        
        
        //leftLocation.text = "Euston"
        leftLocation.textColor = UIColor.whiteColor()
        //leftLocation.font =  UIFont.systemFontOfSize(28)
        leftLocation.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        filterContent.addSubview(leftLocation)
        
        //leftLocation2.text = "London"
        leftLocation2.textColor = UIColor.whiteColor()
        //leftLocation2.font =  UIFont.systemFontOfSize(28)
        leftLocation2.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        filterContent.addSubview(leftLocation2)
        
        //leftTime.text = "7:27am"
        leftTime.textColor = UIColor.whiteColor()
        leftTime.font =  UIFont.systemFontOfSize(14)
        filterContent.addSubview(leftTime)
        
        //leftTime2.text = "30 June, 2014"
        leftTime2.textColor = UIColor.whiteColor()
        leftTime2.font =  UIFont.systemFontOfSize(14)
        filterContent.addSubview(leftTime2)
        
        
        // right
        //rightData.text = "40"
        rightData.font = UIFont(name: "HelveticaNeue-Light", size: 60)
        rightData.textAlignment = NSTextAlignment.Right
        rightData.textColor = UIColor.whiteColor()
        filterContent.addSubview(rightData)
        // healthy & unhealthy BG
        rightHealthyBG.layer.cornerRadius = 3
        rightHealthyBG.backgroundColor = UIColor.redColor()
        filterContent.addSubview(rightHealthyBG)
        // healthy & unhealthy text
        rightHealthyText.text = "Unhealthy"
        rightHealthyText.textAlignment = NSTextAlignment.Center
        rightHealthyText.font =  UIFont.systemFontOfSize(16)
        rightHealthyText.textColor = UIColor.whiteColor()
        rightHealthyBG.addSubview(rightHealthyText)
        
        //rightLocation.text = "NO2"
        rightLocation.textColor = UIColor.whiteColor()
        //rightLocation.font =  UIFont.systemFontOfSize(28)
        rightLocation.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        rightLocation.textAlignment = NSTextAlignment.Right
        filterContent.addSubview(rightLocation)
        
        //rightLocation2.text = "EU Limit"
        rightLocation2.textColor = UIColor.whiteColor()
        //rightLocation2.font =  UIFont.systemFontOfSize(28)
        rightLocation2.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        rightLocation2.textAlignment = NSTextAlignment.Right
        filterContent.addSubview(rightLocation2)
        
        //rightTime.text = "µg/m3"
        rightTime.textColor = UIColor.whiteColor()
        rightTime.font =  UIFont.systemFontOfSize(14)
        rightTime.textAlignment = NSTextAlignment.Right
        filterContent.addSubview(rightTime)
        
        //rightTime2.text = "Annual Mean"
        rightTime2.textColor = UIColor.whiteColor()
        rightTime2.font =  UIFont.systemFontOfSize(14)
        rightTime2.textAlignment = NSTextAlignment.Right
        filterContent.addSubview(rightTime2)
        
        filterContent.addSubview(touchLayer)
        
        var holdRecogniser = UILongPressGestureRecognizer(target: self, action: Selector("holdedAction:"))
        holdRecogniser.minimumPressDuration = 1
        touchLayer.addGestureRecognizer(holdRecogniser)
    }
    
    
    func holdedAction(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Began {
            UIView.animateWithDuration(0.05, animations: {
                self.aqImage.alpha = 1
                })
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.05, animations: {
                self.aqImage.alpha = 0
                })
        }
    }
    
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
    
    
    func goToThird(){
        
        // to third view controller
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var thirdViewController = storyboard.instantiateViewControllerWithIdentifier("thirdViewController") as ThirdViewController
        thirdViewController.tempMyImage = aqImage.image
        thirdViewController.tempLeftImage = leftImg.image
        thirdViewController.tempRightImage = rightImg.image
        thirdViewController.currentFilter = currentFilter
        thirdViewController.currentRightFilter = currentRightFilter
        thirdViewController.currentLat = currentLat
        thirdViewController.currentLng = currentLng
        
        self.navigationController.pushViewController(thirdViewController as UIViewController, animated: true)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController.navigationBar.hidden = false
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        //aqImage.image = tempImage
        
        
        
        //currentFilter = tempData
        
        /*
        // crop image
        var cropRect = CGRectMake(0, 0, (tempImage as UIImage).size.width, (tempImage as UIImage).size.width)
        var imageRef = CGImageCreateWithImageInRect((tempImage as UIImage).CGImage, cropRect)
        aqImage.image = UIImage(CGImage: imageRef)
      */
        /*
        UIImage(CGImage: imageRef.posterImage().takeUnretainedValue())
        
        var newImg = imageRef.
        CGImageRelease(imageRef)
        
        
        // add text
        var myImg : UIImage = UIImage(named: "avatar")
        myImg.CGImage
        var newImg = drawText("hua", img: tempImage!, atPoint: CGPoint(x: 0, y: 0))
        aqImage.image = newImg
        */
        
        
        
    }
    /*
    func startConnection(){
        let urlPath: String = "http://api.erg.kcl.ac.uk/AirQuality/Data/Site/SiteCode=BG1/StartDate=2014-06-18/EndDate=2014-06-19/Json"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        connection.start()
        //println("start2")
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        println("2 connection")
        self.data.appendData(data)
        //println("2 connection")
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        println(jsonResult.objectForKey("AirQualityData").objectForKey("@SiteCode"))
    }
    */
    
    
    override func viewWillDisappear(animated: Bool) {
        //self.navigationController.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBtn(){

        doAddBtn(myFilter1, myView: controlView, filterId: 0)
        doAddBtn(myFilter2, myView: controlView2, filterId: 1)
        doAddBtn(myFilter3, myView: controlView3, filterId: 2)
        
    }
    
    
    
    
    func doAddBtn(myFilter: Filter[], myView:UIScrollView, filterId: Int){
        
        var itemNum = myFilter.count
        var size = CGSizeMake(CGFloat(82 * Double(itemNum)), 128)
        myView.contentSize = size;
        
        for var index = 0; index < itemNum; ++index {
            
            var x = CGFloat(Double(index)*82.0)
            var rect : CGRect = CGRectMake(x, 0, 80, 124)
            var btn : BtnView?
            if filterId == 0 && Int(index) == 0 {
                btn = BtnView(frame: rect, myData: String(currentFilter.data), myText: myFilter[index].label!, id: filterId, index: Int(index))
            }
            else {
                btn = BtnView(frame: rect, myData: String(myFilter[index].data), myText: myFilter[index].label!, id: filterId, index: Int(index))
            }
            myView.addSubview(btn)
            (btn as BtnView).current.hidden = true
            
            var tapRecogniser = UITapGestureRecognizer(target: self, action: Selector("tapped:"))
            tapRecogniser.numberOfTapsRequired = 1
            (btn as BtnView).addGestureRecognizer(tapRecogniser)
            btnArray.append(btn!)
            
        }
        
        
    }
    
    
    func tapped(sender: UITapGestureRecognizer) {
        
        hideAllCurrent()
        (sender.view as BtnView).current.hidden = false
        
        var id = (sender.view as BtnView).filterId
        var index = (sender.view as BtnView).filterIndex
        
        setRightFilter(id, filterIndex: index)
        //println(myFilter[id])
    }
    func setRightFilter(filterId: Int, filterIndex: Int){
        
        var myData : Filter[] = myFilter1
        if(filterId == 0){
            myData = myFilter1
        }
        else if(filterId == 1){
            myData = myFilter2
        }
        else{
            myData = myFilter3
        }
        
        currentRightFilter = (myData[filterIndex] as Filter)
        
        var num = currentRightFilter.data
        //rightFilter.alpha = CGFloat(getAlpha(num))
        //rightFilter.alpha = 0
        
        if(num == -99){ // empty
            num = currentFilter.data
            rightHealthyText.text = ""
            rightHealthyBG.alpha = 0
            rightData.text = ""
            
            leftLocation.frame.size.width = 280

        }
        else {
            
            leftLocation.frame.size.width = 140
            
            if num <= 40 { // healthy
                rightHealthyBG.alpha = 1
                rightHealthyBG.backgroundColor = UIColor(red: 0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
                rightHealthyText.text = "Healthy"
            }
            else{ // unhealthy
                rightHealthyBG.alpha = 1
                rightHealthyBG.backgroundColor = UIColor.redColor()
                rightHealthyText.text = "Unhealthy"
            }
            
            // right
            rightData.text = String(num)
            
        }
        
        rightLocation.text = currentRightFilter.loc1
        rightLocation2.text = currentRightFilter.loc2
        rightTime.text = currentRightFilter.time1
        rightTime2.text = currentRightFilter.time2
        
        rightFilter.alpha = CGFloat(getAlpha(num))
        rightImg.image = filterPhoto(rightOrigin!, num: num)
        
        if filterId == 1 {
            
            var myString = currentFilter.time1
            var loc1 = myString?.substringToIndex(7)
            var loc2 = myString?.substringFromIndex(7)
            
            leftLocation.text = loc1
            leftLocation2.text = loc2
            leftTime.text = currentFilter.loc1
            leftTime2.text = currentFilter.loc2
            
            
        }
        else {
            
            leftLocation.text = currentFilter.loc1
            leftLocation2.text = currentFilter.loc2
            leftTime.text = currentFilter.time1
            leftTime2.text = currentFilter.time2
        }
    }
    
    func setLeftFilter(data: Filter){

        var num = data.data
        leftFilter.alpha = CGFloat(getAlpha(num))
        //leftFilter.alpha = 0
        if(num <= 40){ // healthy
            leftHealthyBG.backgroundColor = UIColor(red: 0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
            leftHealthyText.text = "Healthy"
        }
        else{ // unhealthy
            leftHealthyBG.backgroundColor = UIColor.redColor()
            leftHealthyText.text = "Unhealthy"
        }
        
        // right
        leftData.text = String(num)
        leftLocation.text = data.loc1
        leftLocation2.text = data.loc2
        leftTime.text = data.time1
        leftTime2.text = data.time2

        leftImg.image = filterPhoto(leftOrigin!, num: num)
    }
    
    
    func hideAllCurrent(){
        for index in 0...btnArray.count-1 {
            (btnArray[index] as BtnView).current.hidden = true
        }
    }
    
    
    @IBAction func showFilter1(sender: AnyObject) {
        
        filterBtn1.setImage(btn1_on, forState: UIControlState.Normal)
        filterBtn2.setImage(btn2_off, forState: UIControlState.Normal)
        filterBtn3.setImage(btn3_off, forState: UIControlState.Normal)
        
        controlView.hidden = false
        controlView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        controlView2.hidden = true
        controlView3.hidden = true
        
        hideAllCurrent()
        (btnArray[0] as BtnView).current.hidden = false
        setRightFilter(0, filterIndex: 0)
        
    }
    
    @IBAction func showFilter2(sender: AnyObject) {
        
        filterBtn1.setImage(btn1_off, forState: UIControlState.Normal)
        filterBtn2.setImage(btn2_on, forState: UIControlState.Normal)
        filterBtn3.setImage(btn3_off, forState: UIControlState.Normal)
        
        controlView.hidden = true
        controlView2.hidden = false
        controlView2.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        controlView3.hidden = true
        
        hideAllCurrent()
        (btnArray[myFilter1.count] as BtnView).current.hidden = false
        setRightFilter(1, filterIndex: 0)
    }
    
    @IBAction func showFilter3(sender: AnyObject) {
        
        filterBtn1.setImage(btn1_off, forState: UIControlState.Normal)
        filterBtn2.setImage(btn2_off, forState: UIControlState.Normal)
        filterBtn3.setImage(btn3_on, forState: UIControlState.Normal)
        
        controlView.hidden = true
        controlView2.hidden = true
        controlView3.hidden = false
        controlView3.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        hideAllCurrent()
        (btnArray[myFilter1.count + myFilter2.count] as BtnView).current.hidden = false
        setRightFilter(2, filterIndex: 0)
    }
    
    func drawText(text: NSString, img: UIImage, atPoint: CGPoint) -> UIImage{
        
        UIGraphicsBeginImageContext(CGSize(width: img.size.width, height: img.size.height))
        var context = UIGraphicsGetCurrentContext()
        // set text color to white
        CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1, 1, 1, 1))
        
        img.drawInRect(CGRectMake(0, 0, img.size.width, img.size.height))
        
        var font = UIFont(name: "HelveticaNeue-Light", size: 30)
        var rectText = CGRectMake(0, 0, img.size.width, img.size.height)
        text.drawInRect(rectText, withFont: font)
        
        var newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        println(newImg.size.width, newImg.size.height)
        return newImg
    }
    
    func filterPhoto(img: UIImage, num: Int) -> UIImage{
        
        var value1 : Double = 0.0
        var value2 : Double = 0.0
        
        if(num <= 40){
            value1 = -10/400.0 * Double(num) + 0.3
            value2 = -1/40.0 * Double(num) + 1
        }
        else{
            value1 = -1/320.0 * Double(num) + 1/8.0
            value2 = -1/160.0 * Double(num) + 1/4.0
        }
        println("value \(value1) \(value2)")
        
        var ciimg = CIImage(CGImage: img.CGImage)
        var myPhotoFilter = CIFilter(name: "CIExposureAdjust")
        myPhotoFilter.setValue(ciimg, forKey: "inputImage")
        myPhotoFilter.setValue(value1, forKey: "inputEV") // -1 ~ 1
        
        var myPhotoFilter2 = CIFilter(name: "CIVibrance")
        myPhotoFilter2.setValue(myPhotoFilter.outputImage, forKey: "inputImage")
        myPhotoFilter2.setValue(value2, forKey: "inputAmount")
        
        var myPhotoFilter3 : CIFilter?
        if(num <= 40){
            myPhotoFilter3 = CIFilter(name: "CIPhotoEffectChrome")
            myPhotoFilter3?.setValue(myPhotoFilter2.outputImage, forKey: "inputImage")
            
        }
        else{
            println("thurd")
            myPhotoFilter3 = CIFilter(name: "CIColorMonochrome")
            myPhotoFilter3?.setValue(myPhotoFilter2.outputImage, forKey: "inputImage")
            myPhotoFilter3?.setValue(CIColor(red: 153/255.0, green: 102/255.0, blue: 0, alpha: 1.0), forKey: "inputColor") // -1 ~ 1
            myPhotoFilter3?.setValue(-value2, forKey: "inputIntensity")
        }
        
        
        
        var temp = myPhotoFilter3?.outputImage
        return UIImage(CIImage: temp)
    }
    /*
    func drawFilter(leftF: Filter, rightF: Filter, img: UIImage) -> UIImage{
        
        UIGraphicsBeginImageContext(CGSize(width: img.size.width, height: img.size.height))
        var context = UIGraphicsGetCurrentContext()
        // set text color to white
        CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1, 1, 1, 1))
        
        img.drawInRect(CGRectMake(0, 0, img.size.width, img.size.height))
        
        
        /*
        var leftHealthyBG = UIView(frame: CGRectMake(20, 270, 90, 26))
        var leftHealthyText = UILabel(frame: CGRectMake(0, 0, 90, 26))
        var leftData = UILabel(frame: CGRectMake(20, 190, 140, 100))
        */
        
        var font = UIFont(name: "HelveticaNeue-Light", size: 60)
        var rectText = CGRectMake(20, 190, 140, 100)
        //(leftF.data as NSString).drawInRect(rectText, withFont: font)
        
        
        var newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //println(newImg.size.width, newImg.size.height)
        return newImg
    }
    */
    
    /*
    @IBAction func show1(sender : AnyObject) {
    
    /*
    if v1.hidden {
    v1.hidden = false
    }
    else {
    v1.hidden = true
    }*/
    
    UIView.animateWithDuration(1.0, animations: {
    
    
    
    })
    
    UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
    
    //self.v1.frame = CGRectMake(200, 400, 10, 10)
    
    }, completion: nil)
    
    }
    
    @IBAction func show2(sender : AnyObject) {
    
    /*
    if v2.hidden {
    v2.hidden = false
    }
    else {
    v2.hidden = true
    }
    */
    }
    */
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}

struct Filter {
    var data = 0
    var label: String?
    var loc1: String?
    var loc2: String?
    var time1: String?
    var time2: String?
    var code = ""
}
