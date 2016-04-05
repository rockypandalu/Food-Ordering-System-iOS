//
//  RestaurantTableViewController.swift
//  lab7
//
//  Created by rocky on 15/11/8.
//  Copyright © 2015年 rocky. All rights reserved.
//

import UIKit
import Parse
class RestaurantTableViewController: UITableViewController {
// MARK: Properties
    var restaurants = [Restaurant]()
    //************只需要给toUser赋予传过来的username就大功告成了！
    var pagniatedOutput: AWSDynamoDBPaginatedOutput?
    var tableRows:Array<DDBTableRow>?

    var toUser=PFUser.currentUser()!.username
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadSampleRestaurants()
        getdata()
        
    }
    
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("login") as! loginViewController
        self.presentViewController(secondViewController, animated: true, completion: nil)        
        
    }
    
    
        func loadSampleRestaurants() {
            
            let photo1 = UIImage(named: "Image")!
            let R1 = Restaurant(name: "Xian Famous Food", photo: photo1, rating:5)!
            let photo2 = UIImage(named: "Image-1")!
            let R2 = Restaurant(name: "Macdonald", photo: photo2, rating: 4)!
            let photo3 = UIImage(named: "Image-2")!
            let R3 = Restaurant(name: "Panda Express", photo: photo3, rating:2)!
            restaurants+=[R1,R2,R3]
        }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return restaurants.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "RestaurantTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RestaurantTableViewCell

        // Configure the cell...
        let restaurant=restaurants[indexPath.row]
        cell.RestaurantLabel.text=restaurant.name
        cell.RestaurantImage.image=restaurant.photo
        cell.ratingControl.rating=restaurant.rating
      //cell.ratingRatingControl.rating=restaurant.rating
        
        return cell
    }
    func upLoadRestaurantInfo(){
        //used only when upload a restaurant info
        let photo1 = UIImage(named: "Image-1")!
        let imageData = UIImagePNGRepresentation(photo1)
        let imageFile = PFFile(name:"image.png", data:imageData!)
        
        let userPhoto = PFObject(className:"Restaurant")
        userPhoto["restaurantName"] = "Macdonald"
        userPhoto["score"]=2
        userPhoto["photo"] = imageFile
        userPhoto.saveInBackground()

    }

    func getdata(){
        print("good");
        let dynamodbMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper();
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.hashKeyValues = "1";
        queryExpression.hashKeyAttribute = "ObjectId";
        dynamodbMapper.query(DDBTableRow.self, expression: queryExpression) .continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
            if (task.error != nil) {
//                print("Error: \(task.error)")
                
                let alertController = UIAlertController(title: "Failed to query a test table.", message: task.error!.description, preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action:UIAlertAction) -> Void in
                })
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                if (task.result != nil) {
                    print("hehe");
                    self.pagniatedOutput = task.result as? AWSDynamoDBPaginatedOutput
                    print(self.pagniatedOutput!.items)
                    for item in self.pagniatedOutput!.items as! [DDBTableRow] {
                        self.tableRows?.append(item)
                        print(self.tableRows);
                    }
                }
                self.performSegueWithIdentifier("unwindToMainSegue", sender: self)
            }
            return nil
        })
        dynamodbMapper.query(DDBTableRow.self, expression: queryExpression)
//        queryExpression.hashKeyValues = self.
        let query = PFQuery(className:"Restaurant")
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
                                    let R = Restaurant(name: object["restaurantName"] as! String, photo: image, rating:object["score"] as! Int)
                                    self.restaurants.append(R!)
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

    //override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //CODE TO BE RUN ON CELL TOUCH
        //self.performSegueWithIdentifier("RestaurantViewController", sender: self)
    //}
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "restTOmeal"){
            let selectedIndex=self.tableView.indexPathForCell(sender as! RestaurantTableViewCell)
            let svc = segue.destinationViewController as! MealTableViewController;
            svc.toPassrest=restaurants[(selectedIndex!.row)].name
            svc.toUser=toUser
        }
    }

}
