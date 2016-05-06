//
//  DDBTableRow.swift
//  lab7
//
//  Created by Yan Lu on 16/5/6.
//  Copyright © 2016年 rocky. All rights reserved.
//

import Foundation
class DDBTableRow :AWSDynamoDBObjectModel ,AWSDynamoDBModeling  {
    
    var Distance:NSNumber?
    var ObjectId:String?
    var Rating: Float=0
    var UserName:String?

    
    class func dynamoDBTableName() -> String! {
        return "SmartFoodDelivery"
    }
    
    
    // if we define attribute it must be included when calling it in function testing...
    class func hashKeyAttribute() -> String! {
        return "ObjectId"
    }
    
    
    
    class func ignoreAttributes() -> Array<AnyObject>! {
        return ["Ratingtime"]
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