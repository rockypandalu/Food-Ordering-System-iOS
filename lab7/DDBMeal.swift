//
//  DDBMeal.swift
//  lab7
//
//  Created by Yan Lu on 16/4/19.
//  Copyright © 2016年 rocky. All rights reserved.
//

import Foundation
class DDBMeal :AWSDynamoDBObjectModel ,AWSDynamoDBModeling  {
    
    var mealId:String?
    var mealName:String?
    var restaurantId: String?
    var hotColdDrink:NSNumber?
    var price: NSNumber?
    
    class func dynamoDBTableName() -> String! {
        return "MealList"
    }
    
    
    // if we define attribute it must be included when calling it in function testing...
    class func hashKeyAttribute() -> String! {
        return "mealId"
    }
    
    
    
    class func ignoreAttributes() -> Array<AnyObject>! {
        return []
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