//
//  StreamCollectionViewCell.swift
//  aq
//
//  Created by Ye on 14-7-5.
//  Copyright (c) 2014 Ye Lin. All rights reserved.
//

import UIKit

class StreamCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var myImage: UIImageView
    @IBOutlet var myLocation: UILabel
    @IBOutlet var myLocation2: UILabel
    @IBOutlet var myData: UILabel
    @IBOutlet var myHealthyBG: UIView
    @IBOutlet var myHealthyText: UILabel
    
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    
}
