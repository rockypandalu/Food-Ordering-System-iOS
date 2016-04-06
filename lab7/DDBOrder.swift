//
//  DDBOrder.swift
//  lab7
//
//  Created by Yan Lu on 16/4/5.
//  Copyright © 2016年 rocky. All rights reserved.
//

class DDBOrder :AWSDynamoDBObjectModel ,AWSDynamoDBModeling  {
    
    var ID:String?;
    var OrderTime:NSNumber? = 0
    var Restaurant:NSNumber? = 0
    var HotFood:NSNumber? = 0
    var ColdFood:NSNumber? = 0
    var Distance:NSNumber? = 0
    var DeliveryTime:NSNumber? = 0
    var Order:String?
    var Drink:NSNumber? = 0
    
    class func dynamoDBTableName() -> String! {
        return "Order"
    }
    
    
    // if we define attribute it must be included when calling it in function testing...
    class func hashKeyAttribute() -> String! {
        return "ID"
    }
    
    
    
    class func ignoreAttributes() -> Array<AnyObject>! {
        return ["DeliveryTime"]
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

