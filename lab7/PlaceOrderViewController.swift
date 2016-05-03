//
//  PlaceOrderViewController.swift
//  lab7
//
//  Created by rocky on 15/11/14.
//  Copyright © 2015年 rocky. All rights reserved.
//

import UIKit
import Parse
import Darwin
import Foundation
class PlaceOrderViewController: UIViewController {
    

    @IBOutlet weak var deliveryDataPicker: UIDatePicker!
    @IBOutlet weak var DispPlaceButton: UIButton!
    
    @IBOutlet weak var recommendation: UILabel!

    @IBOutlet weak var orderSummaryLabel: UILabel!
    
    @IBOutlet weak var recimage: UIImageView!
    
    var toPassRest: String!
    var toPassImage: UIImage?
    var toPass: String!
    var toPassMeal: String!
    var toPassPrice: String!
    var toPassCal: Int!
    var toPassNut: String!
    var toUser: String!
    var hot:Int!
    var cold:Int!
    var Order: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        var summaryOrder=""
        for order in Order{
            summaryOrder = summaryOrder+", "+order
        }
        orderSummaryLabel.text = String(summaryOrder.characters.dropFirst())
        recommend()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ToQrCode"){
            let svc = segue.destinationViewController as! ResultViewController;
            let itemSecureNumber=Int(arc4random_uniform(99999999))
            svc.toPass = NSString(format: "%d",itemSecureNumber) as String
            svc.toPassMeal=toPassMeal
            svc.toPassPrice=toPassPrice
            let orderinfo = PFObject(className:"Order")
            orderinfo["restaurantName"] = toPassRest
            orderinfo["meal"]=toPassMeal
            let price=toPassPrice as NSString
            orderinfo["price"]=price.floatValue
            orderinfo["calorie"]=toPassCal
            orderinfo["majorNutrition"]=toPassNut
            orderinfo["securenumber"]=svc.toPass
            orderinfo["isdone"] = 0
            orderinfo["user"]=toUser
            orderinfo["feedback"]=(-1)
            orderinfo.saveInBackgroundWithBlock { (success, error) -> Void in
                if (success) {
                    svc.toID=orderinfo.objectId
                }
                else {
                    //  Log details of the failure
                    print("failure - didRegisterForRemoteNotificationsWithDeviceToken")
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
            let tasks = NSMutableArray()
            let tableRow = DDBOrder()
            let uuid = NSUUID().UUIDString
            let date=deliveryDataPicker.date
            let calendar = NSCalendar.currentCalendar()
            let curTime = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute] , fromDate: date)
            
            tableRow.ID = uuid;
            tableRow.OrderTime = curTime.hour*60+curTime.minute
            tableRow.Restaurant = 1
            tableRow.HotFood = cold
            tableRow.ColdFood = hot
            tableRow.Distance = 1000
            tableRow.Drink = 2
            tableRow.Order = Order.joinWithSeparator(";")
            tasks.addObject(dynamoDBObjectMapper.save(tableRow))

            
            while orderinfo.objectId==nil{
                usleep(100)
            }
            svc.toID=orderinfo.objectId

//            let dynamoDBObjectMapper0 = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
//            let tasks0 = NSMutableArray()
//            let tableRow0 = DDBMeal()
//            tableRow0.mealId=NSUUID().UUIDString
//            tableRow0.mealName="Salad"
//            tableRow0.restaurantId="3"
//            tableRow0.calorie=600
//            tableRow0.majorNutrition="Vitamin"
//            tableRow0.hotColdDrink=2
//            tableRow0.image="hehe"
//            tableRow0.price=4.99
//            tasks0.addObject(dynamoDBObjectMapper0.save(tableRow0))
//            print("done")
//            
//            let dynamoDBObjectMapper3 = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
//            let tasks3 = NSMutableArray()
//            let tableRow3 = DDBMeal()
//            tableRow3.mealId=NSUUID().UUIDString
//            tableRow3.mealName="Cola"
//            tableRow3.restaurantId="3"
//            tableRow3.calorie=600
//            tableRow3.majorNutrition="Sugar"
//            tableRow3.hotColdDrink=3
//            tableRow3.image="hehe"
//            tableRow3.price=1.99
//            tasks3.addObject(dynamoDBObjectMapper3.save(tableRow3))
//            print("done")
//            
//            let dynamoDBObjectMapper4 = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
//            let tasks4 = NSMutableArray()
//            let tableRow4 = DDBMeal()
//            tableRow4.mealId=NSUUID().UUIDString
//            tableRow4.mealName="Beef Pizza"
//            tableRow4.restaurantId="3"
//            tableRow4.calorie=2500
//            tableRow4.majorNutrition="Protein"
//            tableRow4.hotColdDrink=1
//            tableRow4.image="hehe"
//            tableRow4.price=7.99
//            tasks4.addObject(dynamoDBObjectMapper4.save(tableRow4))
//            print("done")
//            
//            let dynamoDBObjectMapper5 = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
//            let tasks5 = NSMutableArray()
//            let tableRow5 = DDBMeal()
//            tableRow5.mealId=NSUUID().UUIDString
//            tableRow5.mealName="Chicken Pizza"
//            tableRow5.restaurantId="3"
//            tableRow5.calorie=2400
//            tableRow5.majorNutrition="Protein"
//            tableRow5.hotColdDrink=1
//            tableRow5.price=7.49
//            tableRow5.image="hehe"
//            tasks5.addObject(dynamoDBObjectMapper5.save(tableRow5))
//            print("done")
            
//            Used to add restaurant data
            
//            let dynamoDBObjectMapper1 = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
//            let tasks1 = NSMutableArray()
//            let tableRow1 = DDBTableRow()
//            tableRow1.ObjectId="4"
//            tableRow1.UserName="McDonald's"
//            tableRow1.Rating=2
//            tasks1.addObject(dynamoDBObjectMapper1.save(tableRow1))
//            print("done")
            
        }
        if (segue.identifier == "AddMore"){
            let svc = segue.destinationViewController as! MealTableViewController;
            svc.toPassrest = toPassRest
            svc.toUser=toUser
            svc.cold=cold
            svc.hot=hot
            svc.Order=Order

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func recommend(){
        PFCloud.callFunctionInBackground("recommendation", withParameters: ["meal": toPassMeal]) {
            (response: AnyObject?, error: NSError?) -> Void in
            
            if error == nil {
                // This is working:
                let rec = response as!NSString
                //print("People order this may also like: \(objects)")
                if rec == "No result"{
                    self.recommendation.hidden = true
                    self.recimage.hidden = true
                }
                else{
                    self.recommendation.text="Customers who ordered this also like:\n \(rec)"
                    
                    let query = PFQuery(className:"Meal")
                    query.whereKey("mealName", equalTo: rec)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        if error == nil {
                            // Do something with the found objects
                            if let objects = objects! as? [PFObject] {
                                for object in objects {
                                    let restaurantImage=object["photo"] as! PFFile
                                    restaurantImage.getDataInBackgroundWithBlock {
                                        (imageData: NSData?, error: NSError?) -> Void in
                                        if error == nil {
                                            if let imageData = imageData {
                                                self.recimage.image = UIImage(data:imageData)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        } else {
                            // Log details of the failure
                            print("Error: \(error!) \(error!.userInfo)")
                        }
                    }
                    
                }
            }
            
        }
        
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
