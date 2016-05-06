//
//  DDBFeedback.swift
//  lab7
//
//  Created by Yan Lu on 16/5/3.
//  Copyright © 2016年 rocky. All rights reserved.
//

class DDBFeedback :AWSDynamoDBObjectModel ,AWSDynamoDBModeling  {
    
    var ID:String?;
    var Rating:NSNumber? = 0

    
    class func dynamoDBTableName() -> String! {
        return "Order"
    }
    
    
    // if we define attribute it must be included when calling it in function testing...
    class func hashKeyAttribute() -> String! {
        return "ID"
    }
    
    
    
    class func ignoreAttributes() -> Array<AnyObject>! {
        return ["ColdFood","Distance","Drink","HotFood","Order","OrderTime","Restaurant"]
    }
    
    //MARK: NSObjectProtocol hack
    //Fixes Does not conform to the NSObjectProtocol error
    
    override func isEqual(object: AnyObject?) -> Bool {
        return super.isEqual(object)
    }
    
    override func `self`() -> Self {
        return self
    }
}

