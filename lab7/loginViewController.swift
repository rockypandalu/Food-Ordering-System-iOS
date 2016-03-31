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
        update("Macdonald")
        update("Xian Famous Food")
        update("Panda Express")
        // Do any additional setup after loading the view.
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
                print("Average score of \(restaurant): \(score)")
                
                PFCloud.callFunctionInBackground("restaurantFeedbackUpdate", withParameters: ["restaurantName": restaurant,"score":score]) {
                    (response: AnyObject?, error: NSError?) -> Void in
                    if error == nil {
                        // This is working:
                        let message = response as!NSString
                        print("\(restaurant) update: \(message)")
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
