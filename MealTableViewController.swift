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
    var pagniatedOutput: AWSDynamoDBPaginatedOutput?

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
        
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 10
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        dynamoDBObjectMapper.scan(DDBMeal.self, expression: scanExpression).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
            if (task.result != nil){
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                for item in paginatedOutput.items as! [DDBMeal] {

                    if (item.restaurantId! == self.toPassrest){
                        let R = Meal(name: item.mealName!, photo: nil, price:item.price as! Float, calorie:item.calorie as! Int, nutrition:item.majorNutrition!, HotCold: 2)
                        self.meals.append(R!)
                        self.tableView.reloadData()
                    }
//                    let R = Meal(name: item.mealName!, photo: nil, price:item.price as! Float, calorie:item.calorie as! Int, nutrition:item.majorNutrition!, HotCold: item.hotColdDrink!)

//                    let R = Restaurant(name:item.UserName!, photo: nil, rating: item.Rating as! Int)
//                    self.restaurants.append(R!)
//                    self.tableView.reloadData()
//                    self.tableRows?.append(item)
//                    print(self.tableRows)
                }
            }
            return nil
        })
//        let dynamodbMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper();
//        let queryExpression = AWSDynamoDBQueryExpression()
//        queryExpression.hashKeyValues = toPassrest!;
//        print(toPassrest)
//        queryExpression.hashKeyAttribute = "restaurantId";
//        dynamodbMapper.query(DDBMeal.self, expression: queryExpression) .continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
//            if (task.error != nil) {
//                //                print("Error: \(task.error)")
//                
//                let alertController = UIAlertController(title: "Failed to query a test table.", message: task.error!.description, preferredStyle: UIAlertControllerStyle.Alert)
//                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action:UIAlertAction) -> Void in
//                })
//                alertController.addAction(okAction)
//                self.presentViewController(alertController, animated: true, completion: nil)
//            } else {
//                if (task.result != nil) {
//                    print("hehe");
//                    self.pagniatedOutput = task.result as? AWSDynamoDBPaginatedOutput
//                    print(self.pagniatedOutput!.items)
////                    for item in self.pagniatedOutput!.items as! [DDBTableRow] {
////                        
////                    }
//                }
//                else{
//                    print("None")
//                }
//                self.performSegueWithIdentifier("unwindToMainSegue", sender: self)
//            }
//            return nil
//        })
        
        
//        let imagePickerController:UIImagePickerController = UIImagePickerController()
//        
//        let query = PFQuery(className:"Meal")
//        query.whereKey("restaurantName", equalTo: toPassrest)
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            if error == nil {
//                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) scores.")
//                // Do something with the found objects
//                if let objects = objects! as? [PFObject] {
//                    for object in objects {
//                        let restaurantImage=object["photo"] as! PFFile
//                        restaurantImage.getDataInBackgroundWithBlock {
//                            (imageData: NSData?, error: NSError?) -> Void in
//                            if error == nil {
//                                if let imageData = imageData {
//                                    let image = UIImage(data:imageData)
//                                    let R = Meal(name: object["mealName"] as! String, photo: image, price:object["price"] as! Float, calorie:object["Calorie"] as! Int, nutrition:object["MajorNutrition"] as! String, HotCold: object["HotCold"] as! Bool)
//                                    self.meals.append(R!)
//                                    self.tableView.reloadData()
//                                }
//                            }
//                        }
//                        
//                    }
//                }
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
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
        switch meals[(selectedIndex!.row)].HotCold{
        case 1:
            hot = hot+1
        case 2:
            cold = cold+1
        default:
            print("hehe")
        }
//        if (meals[(selectedIndex!.row)].HotCold){
//            hot = hot + 1
//        }
//        else{
//            cold = cold + 1
//        }
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
