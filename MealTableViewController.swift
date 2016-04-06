//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 5/27/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information.
//

import UIKit
import Parse


class MealTableViewController: UITableViewController {
    // MARK: Properties
    var toPassrest: String!
    var meals = [Meal]()
    var toUser:String!
    var hot:Int = 0
    var cold:Int = 0
    var Order: ([String])?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the sample data.
        //loadSampleMeals()
        getdata()
//        let testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            print("Object has been saved.")
//        }
//        var query = PFQuery(className:"GameScore")
//        query.getObjectInBackgroundWithId("xWMyZEGZ") {
//            (gameScore: PFObject?, error: NSError?) -> Void in
//            if error == nil && gameScore != nil {
//                print(gameScore)
//            } else {
//                print(error)
//            }
//        }
        /*
        var gameScore = PFObject(className:"TestObject")
        gameScore["score"] = 1337
        gameScore["playerName"] = "Sean Plott"
        gameScore["cheatMode"] = false
        gameScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }*/
    }


    func getdata(){
        let imagePickerController:UIImagePickerController = UIImagePickerController()
        
        let query = PFQuery(className:"Meal")
        query.whereKey("restaurantName", equalTo: toPassrest)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects! as? [PFObject] {
                    for object in objects {
                        let restaurantImage=object["photo"] as! PFFile
                        restaurantImage.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                if let imageData = imageData {
                                    let image = UIImage(data:imageData)
                                    let R = Meal(name: object["mealName"] as! String, photo: image, price:object["price"] as! Float, calorie:object["Calorie"] as! Int, nutrition:object["MajorNutrition"] as! String, HotCold: object["HotCold"] as! Bool)
                                    self.meals.append(R!)
                                    self.tableView.reloadData()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        cell.MealLabel.text = meal.name
        cell.MealImageView.image = meal.photo
        cell.MealPriceLabel.text=NSString(format: "%.2f", meal.price) as String
        return cell
    }
    //var valueToPass: String!
   /* override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: (NSIndexPath!)) {
        //print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        //let indexPath = tableView.indexPathForSelectedRow;
        //let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
       ss
        valueToPass = meals[indexPath!.row].itemSecureNumber
        performSegueWithIdentifier("qrcode", sender: self)
        
    }*/

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "ToPlaceOrder"){
        let selectedIndex=self.tableView.indexPathForCell(sender as! MealTableViewCell)
        let svc = segue.destinationViewController as! PlaceOrderViewController;
        if (meals[(selectedIndex!.row)].HotCold){
            hot = hot + 1
        }
        else{
            cold = cold + 1
        }
        svc.toPassImage=meals[(selectedIndex!.row)].photo
        svc.toPassMeal=meals[(selectedIndex!.row)].name
        svc.toPassPrice=NSString(format: "%.2f", meals[(selectedIndex!.row)].price) as String
        svc.toPassCal=meals[(selectedIndex!.row)].calorie
        svc.toPassNut=meals[(selectedIndex!.row)].majorNutrition
        svc.toPassRest=toPassrest
        svc.toUser=toUser
        svc.cold=cold
        svc.hot=hot
        Order?.append(meals[(selectedIndex!.row)].name)
        svc.Order = Order!
//        svc.Order = Order.append("hehe")
//        svc.Order=Order.append(meals[(selectedIndex!.row)].name)
        
    }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
