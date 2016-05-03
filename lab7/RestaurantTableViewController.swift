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
    var hot = 0;
    var cold = 0;
    var Order: [String] = []
    //************只需要给toUser赋予传过来的username就大功告成了！
    var pagniatedOutput: AWSDynamoDBPaginatedOutput?
    var tableRows:Array<DDBTableRow>?
    var toUser=PFUser.currentUser()!.username
    var outimage: UIImage?
    var downloadRequests = Array<AWSS3TransferManagerDownloadRequest?>()
    var downloadFileURLs = Array<NSURL?>()
    let downloadRequest = AWSS3TransferManagerDownloadRequest()
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
//        cell.RestaurantImage.image=restaurant.photo
        cell.RestaurantImage.image = UIImage(named: "Uncle Luo Yang")
        cell.ratingControl.rating=restaurant.rating
      //cell.ratingRatingControl.rating=restaurant.rating
        
        return cell
    }
    
    
    
//    func download(downloadRequest: AWSS3TransferManagerDownloadRequest) {
//        switch (downloadRequest.state) {
//        case .NotStarted, .Paused:
//            let downloadingFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("restaurantsmart").URLByAppendingPathComponent("a.JPG")
//            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
//            transferManager.download(downloadRequest).continueWithBlock({ (task) -> AnyObject! in
//                if let error = task.error {
//                    if error.domain == AWSS3TransferManagerErrorDomain as String
//                        && AWSS3TransferManagerErrorType(rawValue: error.code) == AWSS3TransferManagerErrorType.Paused {
//                        print("Download paused.")
//                    } else {
//                        print("download failed1: [\(error)]")
//                    }
//                } else if let exception = task.exception {
//                    print("download failed: [\(exception)]")
//                } else {
//                    let data = NSData(contentsOfURL: downloadingFileURL)
//                    self.outimage = UIImage(data: data!)
//                }
//                return nil
//            })
//            
//            break
//        default:
//            break
//        }
//    }
    
    
    func getdata(){
        print("good")
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 10
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        dynamoDBObjectMapper.scan(DDBTableRow.self, expression: scanExpression).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
            if (task.result != nil){
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                for item in paginatedOutput.items as! [DDBTableRow] {
                    let R = Restaurant(name:item.UserName!, photo: self.outimage, rating: item.Rating as! Int,id: item.ObjectId!)
                    self.restaurants.append(R!)
                    self.tableView.reloadData()
                    self.tableRows?.append(item)
                    print(self.tableRows)
                }
            }
            return nil
            })

        var getimage:UIImage?
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
                                    getimage = UIImage(data:imageData)
                                    let image = UIImage(data:imageData)
                                    let R = Restaurant(name: object["restaurantName"] as! String, photo: image, rating:object["score"] as! Int, id: "" )
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
            svc.toPassrest=restaurants[(selectedIndex!.row)].restaurantId;
            svc.toUser=toUser
            svc.hot = hot
            svc.cold = cold
            svc.Order = Order
        }
    }
    

}

