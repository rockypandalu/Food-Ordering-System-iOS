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
    
    @IBOutlet weak var MealImageView: UIImageView!
    @IBOutlet weak var DispNameLabel: UILabel!
    @IBOutlet weak var DispPriceLabel: UILabel!
    @IBOutlet weak var DispPlaceButton: UIButton!
    @IBOutlet weak var DispNutLabel: UILabel!
    @IBOutlet weak var DispCalLabel: UILabel!
    
    @IBOutlet weak var recommendation: UILabel!
    
    @IBOutlet weak var recimage: UIImageView!
    
    var toPassRest: String!
    var toPassImage: UIImage?
    var toPass: String!
    var toPassMeal: String!
    var toPassPrice: String!
    var toPassCal: Int!
    var toPassNut: String!
    var toUser: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let price="Price: "+toPassPrice
        let Nutrition="Major Nutrition: "+toPassNut
        let Calrolie=NSString(format:"Calorie: %d KJ",toPassCal) as String
        // Do any additional setup after loading the view.
        MealImageView.image=toPassImage
        DispNameLabel.text=toPassMeal
        DispPriceLabel.text=price
        DispCalLabel.text=Calrolie
        DispNutLabel.text=Nutrition as String
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
            let tableRow = DDBOrder();
            tableRow.ID = "Good";
            tableRow.OrderTime = 1305;
            tableRow.Restaurant = 1;
            tableRow.HotFood = 1;
            tableRow.ColdFood = 0;
            tableRow.Distance = 1000;

            tasks.addObject(dynamoDBObjectMapper.save(tableRow))
            

            
            
            while orderinfo.objectId==nil{
                usleep(100)
            }
            svc.toID=orderinfo.objectId
            
            
            
            
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
