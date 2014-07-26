//
//  HomeViewController.swift
//  aq
//
//  Created by Ye on 14-7-3.
//  Copyright (c) 2014 Ye Lin. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var connectionManager : ConnectionManager?
    var myArray: NSArray?
    
    var myOrange = UIColor(red: 1, green: 174/255, blue: 0, alpha: 1)
    var myGreen = UIColor(red: 0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
    @IBOutlet var myScroll: UIScrollView

    
    @IBOutlet var takePhotoBtn: UIButton
    @IBOutlet var myBGView: UIView
    
    @IBOutlet var labelOne: UILabel
    @IBOutlet var myCollection: UICollectionView
    /*
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }*/
    
    init(coder aDecoder: NSCoder!) {
        
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(animated: Bool){
        //println("DHJK")
        //self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.navigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        self.title = "MY PLACES"
        
        var btn = UIBarButtonItem(title: "WEB", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goToWeb"))
        btn.tintColor = UIColor(red: 1, green: 174/255, blue: 0, alpha: 1)
        self.navigationItem.rightBarButtonItem = btn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        var size = CGSizeMake(320, 568)
        myScroll.contentSize = size;
        myScroll.delegate = self
        //myScroll.pagingEnabled = true
        myScroll.showsHorizontalScrollIndicator = false
        myScroll.canCancelContentTouches = false
        myCollection.canCancelContentTouches = false
 
        labelOne.text = "My Places"
        labelOne.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        labelOne.textColor = UIColor.whiteColor()
        labelOne.textAlignment = NSTextAlignment.Center
        
        myBGView.backgroundColor = myOrange
        
        /*
        // page control
        myPageControl.numberOfPages = 3
        myPageControl.currentPage = 0
        myPageControl.addTarget(self, action: Selector("changePage:"), forControlEvents: UIControlEvents.ValueChanged)
        */
        
        // my collection
        //myCollection.delegate = self
        
        
        // core data
        var appDelegate = UIApplication.sharedApplication().delegate
        var contextStore = (appDelegate as AppDelegate).managedObjectContext
        
        var fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "MyPhoto")
        var myEntityDescription = NSEntityDescription.entityForName("MyPhoto", inManagedObjectContext: contextStore)
        
        var error: NSError? = nil
        myArray = contextStore.executeFetchRequest(fetchRequest, error: &error)
        
        
        // init data
        connectionManager = ConnectionManager.sharedInstance
        
    }
    

    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int{
        
        var num = myArray?.count
        return num!
    }
    /*
    func numberOfSectionsInCollectionView(_ collectionView: UICollectionView!) -> Int{
        return 1
    }
    */
    func collectionView(collectionView: UICollectionView!,
        cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!{

        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("myCell", forIndexPath: indexPath) as StreamCollectionViewCell
        cell.backgroundColor = UIColor.redColor()

        
            if (indexPath.item < myArray?.count) {
                
                var temp = connectionManager!.homeFilter[indexPath.item] as MySite
                
                cell.myImage.image = (myArray?.objectAtIndex(indexPath.item) as MyPhoto).smallPhoto as UIImage
                cell.myLocation.text = (myArray?.objectAtIndex(indexPath.item) as MyPhoto).name1
                cell.myLocation.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
                cell.myLocation2.text = (myArray?.objectAtIndex(indexPath.item) as MyPhoto).name2
                cell.myLocation2.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
                cell.myData.text = String(temp.data)
                cell.myData.font = UIFont(name: "HelveticaNeue-Light", size: 30)
                cell.myHealthyBG.layer.cornerRadius = 3
                cell.myHealthyBG.backgroundColor = UIColor.redColor()
                cell.myHealthyText.text = "Unhealthy"
                cell.myHealthyText.font =  UIFont.systemFontOfSize(8)
            }
            else {
            
                cell.myImage.image = (myArray?.objectAtIndex(0) as MyPhoto).smallPhoto as UIImage
                
            }
            
            
            
        return cell

    }
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView!){
        if(scrollView == myScroll){

            var x = scrollView.contentOffset.x
            changeBGColor(Int((x + 160)/320))
        }
    }*/
    /*
    @IBAction func changePage(sender: AnyObject) {
        
        var x = CGFloat(myPageControl.currentPage)*CGFloat(myScroll.frame.size.width)
        myScroll.setContentOffset(CGPointMake(x, 0), animated: true)
        //println(myPageControl.currentPage)
        
        changeBGColor(myPageControl.currentPage)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView!){
        //println(myScroll.contentOffset.x)
        var page = Int(myScroll.contentOffset.x / myScroll.frame.size.width )
        myPageControl.currentPage = page
        changeBGColor(page)
        
    }

    
    func changeBGColor(page: Int){
        
        UIView.animateWithDuration(0.5, animations: {
            if(page == 0){
                self.myBGView.backgroundColor = self.myOrange
            }
            else if(page == 1){
                self.myBGView.backgroundColor = self.myGreen
            }
            else if(page == 2){
                self.myBGView.backgroundColor = UIColor.redColor()
            }

        })
        
    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView!,
        didSelectItemAtIndexPath indexPath: NSIndexPath!){
            
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            var dataViewController = storyboard.instantiateViewControllerWithIdentifier("dataViewController") as DataViewController
            
            var currentCell = collectionView.cellForItemAtIndexPath(indexPath) as StreamCollectionViewCell
            dataViewController.tempImage =  currentCell.myImage.image
            //dataViewController.myImage.image = (currentCell as StreamCollectionViewCell).myImage.image
            
            self.navigationController.pushViewController(dataViewController as UIViewController, animated: true)
            
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        self.navigationController.popToRootViewControllerAnimated(true)
        
    }

    @IBAction func goWeb(sender: AnyObject) {
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var webViewController = storyboard.instantiateViewControllerWithIdentifier("webViewController") as WebViewController
        self.navigationController.pushViewController(webViewController as UIViewController, animated: true)
    }
    
    func goToWeb() {
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var webViewController = storyboard.instantiateViewControllerWithIdentifier("webViewController") as WebViewController
        self.navigationController.pushViewController(webViewController as UIViewController, animated: true)
    }
    
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView!){
        
        println(myScroll.contentOffset.x)
        var fractionalPage = myScroll.contentOffset.x / myScroll.frame.size.width
        //var curPage = NSInteger(lround(fractionalPage))
        //var page = lround(Int(fractionalPage))
        
        myPageControl.currentPage = Int(fractionalPage)
        println(fractionalPage)
        
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
