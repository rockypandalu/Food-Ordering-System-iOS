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
        cell.RestaurantImage.image = UIImage(named: restaurant.photo)
        cell.ratingControl.rating=restaurant.rating
      //cell.ratingRatingControl.rating=restaurant.rating
        
        return cell
    }
    
    
    
    
    func getdata(){
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 10
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        dynamoDBObjectMapper.scan(DDBTableRow.self, expression: scanExpression).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
            if (task.result != nil){
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                for item in paginatedOutput.items as! [DDBTableRow] {
                    print(item)
                    print("hehe")
                    let R = Restaurant(name:item.UserName!, photo: item.UserName!, rating: Int(item.Rating),id: item.ObjectId!,distance: item.Distance!)
                    self.restaurants.append(R!)
                    self.tableView.reloadData()
                    self.tableRows?.append(item)
                }
            }
            return nil
            })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "restTOmeal"){
            let selectedIndex=self.tableView.indexPathForCell(sender as! RestaurantTableViewCell)
            let svc = segue.destinationViewController as! MealTableViewController;
            svc.toPassrest=restaurants[(selectedIndex!.row)].restaurantId;
            svc.toUser=toUser
            svc.hot = 0
            svc.cold = 0
            svc.Order = Order
            svc.drink = 0
            svc.price = 0
            svc.distance=restaurants[(selectedIndex!.row)].distance
        }
    }
    

}

