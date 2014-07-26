//
//  BtnView.swift
//  aq
//
//  Created by Ye on 14-6-15.
//  Copyright (c) 2014 Ye Lin. All rights reserved.
//

import UIKit

@IBDesignable class BtnView: UIView {

    
    var dataLabel: UILabel = UILabel()
    var textLabel: UILabel = UILabel()
    var squareView = UIView( frame: CGRectMake( 10, 20, 60, 60))
    var filterId : Int = 0
    var filterIndex : Int = 0
    var current = UIView(frame: CGRectMake(0, 121, 80, 3))
    
    init(frame: CGRect) {
        
        super.init(frame: frame)
        // Initialization code
        
        var grey = CGFloat(22.0/255.0)
        var bgColor = UIColor(red: grey, green: grey, blue: grey, alpha: 1.0)
        self.backgroundColor = bgColor

        //self.backgroundColor = UIColor.blackColor()
    }
    
    convenience init(frame: CGRect, myData: String, myText: String, id: Int, index: Int) {
        
        self.init(frame: frame)
        setBtnView(myData, myText: myText, id: id, index: index)
        self.setup()
    }
    
    func setBtnView(myData: String, myText: String, id: Int, index: Int){
        
        var num = myData.toInt()
        
        if id == 0 && index == 0 {
            dataLabel.text = ""
        }
        else {
            dataLabel.text = myData
        }
        
        if(num <= 40){ // blue
            squareView.backgroundColor = UIColor(red: 0, green: 174/255, blue: 1, alpha: 1)
            squareView.alpha = CGFloat(getAlpha(num!))
        }
        else{ // brown
            squareView.backgroundColor = UIColor(red: 170/255, green: 118/255, blue: 27/255, alpha: 1)
            squareView.alpha = CGFloat(getAlpha(num!))
        }
        
        textLabel.text = myText
        filterId = id
        filterIndex = index
    }
    
    func hidCurrent(){
        current.hidden = false
    }
    func showCurrent(){
        current.hidden = true
    }
    
    // calculate alpha
    func getAlpha(num:Int) -> Double{
        
        if(num <= 40){
            return -1/80 * Double(num) + 1
        }
        else if(num > 40 && num <= 100){
            return -1/80 * Double(num) + 1.5
        }
        else{
            return -1/80 * 100 + 1.5
        }
    }
    
    init(coder aDecoder: NSCoder!) {

        super.init(coder: aDecoder)
        self.setup()
    }
        
    func setup(){
        /*
        var tapRecogniser = UITapGestureRecognizer(target: self, action: "tapped")
        tapRecogniser.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapRecogniser)
        */
        
        //squareView.backgroundColor =  UIColor.orangeColor()
        squareView.layer.cornerRadius = 3
        self.addSubview(squareView)
        
        //label.text = "98"
        dataLabel.frame =  CGRectMake(10, 30, 60, 40)
        //dataLabel.font =  UIFont.systemFontOfSize(30)
        dataLabel.alpha = 0.2
        dataLabel.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        dataLabel.textAlignment = NSTextAlignment.Center
        dataLabel.textColor =  UIColor.whiteColor()
        self.addSubview(dataLabel)
        
        //label2.text = "Now"
        
        textLabel.frame = CGRectMake(0, 90, 80, 20)
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.textColor =  UIColor.whiteColor()
        textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        //textLabel.font =  UIFont.systemFontOfSize(14)
        self.addSubview(textLabel)
        
        
        current.backgroundColor = UIColor(red: 1, green: 174/255, blue: 0, alpha: 1)
        self.addSubview(current)
    }
    /*
    
    func tapped() {
        println("tapped")
    }
    */
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
