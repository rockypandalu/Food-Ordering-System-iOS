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
    var hot:Int!
    var cold: Int!
    var drink: Int!
    var Order: ([String])?
    var distance: NSNumber!
    var price:Float!
    var pagniatedOutput: AWSDynamoDBPaginatedOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the sample data.
        //loadSampleMeals()
        getdata()

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
                        let R = Meal(name: item.mealName!, photo: item.mealName!, price:item.price as! Float, calorie:item.calorie as! Int, nutrition:item.majorNutrition!, HotCold: item.hotColdDrink as! Int)
                        self.meals.append(R!)
                        self.tableView.reloadData()
                    }

                }
            }
            return nil
        })
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
        cell.MealImageView.image = UIImage(named: meal.photo)
        cell.MealPriceLabel.text=NSString(format: "%.2f", meal.price) as String
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "ToPlaceOrder"){
        let selectedIndex=self.tableView.indexPathForCell(sender as! MealTableViewCell)
        let svc = segue.destinationViewController as! PlaceOrderViewController;
        print(hot)
        print(meals[(selectedIndex!.row)].HotCold)
        switch meals[(selectedIndex!.row)].HotCold{
        case 1:
            hot = hot+1
        case 2:
            cold = cold+1
        case 3:
            drink = drink+1
            
        default:
            print("hehe")
        }
        print(hot)

        svc.toPassMeal=meals[(selectedIndex!.row)].name
        svc.toPassPrice=price + Float(meals[(selectedIndex!.row)].price)

        svc.toPassRest=toPassrest
        svc.toUser=toUser
        svc.cold=cold
        svc.hot=hot
        svc.distance=distance
        Order?.append(meals[(selectedIndex!.row)].name)
        svc.Order = Order!
        svc.drink=drink

    }
    }

     
}
