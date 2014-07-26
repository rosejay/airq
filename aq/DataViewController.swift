//
//  DataViewController.swift
//  aq
//
//  Created by Ye on 14-7-6.
//  Copyright (c) 2014 Ye Lin. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet var myImage: UIImageView
    @IBOutlet var myScroll: UIScrollView
    var tempImage : UIImage?
    /*
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }8*/
    
    override func viewWillAppear(animated: Bool){
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.navigationBar.translucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        var size = CGSizeMake(320, 368)
        myScroll.contentSize = size;
        
        myImage.image = tempImage
        // Do any additional setup after loading the view.
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
