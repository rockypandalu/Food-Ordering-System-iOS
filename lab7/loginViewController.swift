//
//  loginViewController.swift
//  lab7
//
//  Created by LanXing on 11/17/15.
//  Copyright © 2015 rocky. All rights reserved.
//

import UIKit
import Parse


class loginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        self.loginMethod()
    }
    
    @IBAction func signup(sender: AnyObject) {
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("signup") as! signupViewController
        
        self.presentViewController(secondViewController, animated: true, completion: nil)
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
//        let dynamoDBObjectMapper0 = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
//        let tasks0 = NSMutableArray()
//        let tableRow0 = DDBMeal()
//        tableRow0.mealId=NSUUID().UUIDString
//        tableRow0.mealName="Salad"
//        tableRow0.restaurantId="1"
//
//        tableRow0.hotColdDrink=2
//        tableRow0.price=3.99
//        tasks0.addObject(dynamoDBObjectMapper0.save(tableRow0))
//        print("done")
//        
//        let dynamoDBObjectMapper3 = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
//        let tasks3 = NSMutableArray()
//        let tableRow3 = DDBMeal()
//        tableRow3.mealId=NSUUID().UUIDString
//        tableRow3.mealName="Cola"
//        tableRow3.restaurantId="1"
//
//        tableRow3.hotColdDrink=3
//        tableRow3.price=2.99
//        tasks3.addObject(dynamoDBObjectMapper3.save(tableRow3))
//        print("done")
//        
//        let dynamoDBObjectMapper4 = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
//        let tasks4 = NSMutableArray()
//        let tableRow4 = DDBMeal()
//        tableRow4.mealId=NSUUID().UUIDString
//        tableRow4.mealName="Original Recipe"
//        tableRow4.restaurantId="1"
//        tableRow4.hotColdDrink=1
//        tableRow4.price=3.99
//        tasks4.addObject(dynamoDBObjectMapper4.save(tableRow4))
//        print("done")


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loginMethod(){
        PFUser.logInWithUsernameInBackground( username.text!, password: password.text!){(user:PFUser?, error:NSError?) -> Void in
            if user != nil{
                //Do stuff after successful login
                let restaurantViewController = self.storyboard!.instantiateViewControllerWithIdentifier("navi") as! UINavigationController
                self.presentViewController(restaurantViewController, animated: true, completion: nil)
                
            } else {
                let alertController = UIAlertController(title: "Log in Error", message:"Username or password is not correct", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
        
    }
    
    
    func update(restaurant: String){
        PFCloud.callFunctionInBackground("restaurantFeedback", withParameters: ["restaurantName": restaurant]) {
            (response: AnyObject?, error: NSError?) -> Void in
            if error == nil {
                // This is working:
                let score = response as!NSNumber
                
                PFCloud.callFunctionInBackground("restaurantFeedbackUpdate", withParameters: ["restaurantName": restaurant,"score":score]) {
                    (response: AnyObject?, error: NSError?) -> Void in
                    if error == nil {
                        // This is working:
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
