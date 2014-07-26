//
//  MyPhoto.swift
//  aq
//
//  Created by Ye on 14-7-5.
//  Copyright (c) 2014 Ye Lin. All rights reserved.
//

import Foundation
import CoreData

@objc(MyPhoto)
class MyPhoto: NSManagedObject {
    
    @NSManaged var num : NSNumber
    @NSManaged var photo : AnyObject?
    @NSManaged var smallPhoto : AnyObject?
    @NSManaged var location : AnyObject?
    @NSManaged var code : String?
    @NSManaged var name1 : String?
    @NSManaged var name2 : String?
}
