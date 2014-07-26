//
//  WebViewController.swift
//  aq
//
//  Created by Ye on 14-7-22.
//  Copyright (c) 2014 Ye Lin. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    /*
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }*/

    @IBOutlet var myWeb: UIWebView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = "http://talentap.me"
        var myurl: NSURL = NSURL(string: url)
        
        var request: NSURLRequest = NSURLRequest(URL: myurl)
        myWeb.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool){
        //println("DHJK")
        self.navigationController.navigationBarHidden = false
        self.navigationController.navigationBar.backItem.title = "Back"
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
