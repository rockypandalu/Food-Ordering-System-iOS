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
    

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderSummaryLabel: UILabel!
    
    
    var toPassRest: String!
    var toPassImage: UIImage?
    var toPass: String!
    var toPassMeal: String!
    var toPassPrice: Float!
    var toUser: String!
    var hot:Int!
    var cold:Int!
    var drink: Int!
    var Order: [String] = []
    var distance: NSNumber!

    override func viewDidLoad() {
        super.viewDidLoad()
        var summaryOrder=""
        for order in Order{
            summaryOrder = summaryOrder+", "+order
        }
        priceLabel.text=NSString(format: "%.2f", toPassPrice) as String
        orderSummaryLabel.text = String(summaryOrder.characters.dropFirst())
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ToQrCode"){
            let svc = segue.destinationViewController as! ResultViewController;
//            let itemSecureNumber=Int(arc4random_uniform(99999999))
//            svc.toPass = NSString(format: "%d",itemSecureNumber) as String
            let uuid = NSUUID().UUIDString
            svc.toID=uuid
            let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
            let tasks = NSMutableArray()
            let tableRow = DDBOrder()
            let date=deliveryDataPicker.date
            let calendar = NSCalendar.currentCalendar()
            let curTime = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute] , fromDate: date)
            tableRow.ID = uuid;
            tableRow.OrderTime = curTime.hour*60+curTime.minute
            var rid=Int(toPassRest)!%2
            if (rid==0){
                rid=1
            }
            tableRow.Restaurant = rid
            print(tableRow.Restaurant)
            tableRow.HotFood = hot
            tableRow.ColdFood = cold
            tableRow.Distance = distance
            tableRow.Drink = drink
            tableRow.Order = Order.joinWithSeparator(";")
            tasks.addObject(dynamoDBObjectMapper.save(tableRow))
            
            
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
            svc.drink=drink
            svc.distance=distance
            svc.price = toPassPrice
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func recommend(){
//        PFCloud.callFunctionInBackground("recommendation", withParameters: ["meal": toPassMeal]) {
//            (response: AnyObject?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // This is working:
//                let rec = response as!NSString
//                //print("People order this may also like: \(objects)")
//                if rec == "No result"{
//                    self.recommendation.hidden = true
//                    self.recimage.hidden = true
//                }
//                else{
//                    self.recommendation.text="Customers who ordered this also like:\n \(rec)"
//                    
//                    let query = PFQuery(className:"Meal")
//                    query.whereKey("mealName", equalTo: rec)
//                    query.findObjectsInBackgroundWithBlock {
//                        (objects: [PFObject]?, error: NSError?) -> Void in
//                        if error == nil {
//                            // Do something with the found objects
//                            if let objects = objects! as? [PFObject] {
//                                for object in objects {
//                                    let restaurantImage=object["photo"] as! PFFile
//                                    restaurantImage.getDataInBackgroundWithBlock {
//                                        (imageData: NSData?, error: NSError?) -> Void in
//                                        if error == nil {
//                                            if let imageData = imageData {
//                                                self.recimage.image = UIImage(data:imageData)
//                                            }
//                                        }
//                                    }
//                                    
//                                }
//                            }
//                        } else {
//                            // Log details of the failure
//                            print("Error: \(error!) \(error!.userInfo)")
//                        }
//                    }
//                    
//                }
//            }
//            
//        }
//        
//        
//        
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
