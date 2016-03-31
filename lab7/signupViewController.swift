//
//  signupViewController.swift
//  lab7
//
//  Created by LanXing on 11/17/15.
//  Copyright © 2015 rocky. All rights reserved.
//

import UIKit
import Parse


class signupViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBAction func submit(sender: AnyObject) {
        self.signup()
    }
    
    
    @IBAction func goback(sender: AnyObject) {
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("login") as! loginViewController
        
        self.presentViewController(secondViewController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signup(){
        var user = PFUser()
        user.username = username.text
        user.password = password.text
        user.email = email.text //other fields can be set justlike
        
        user.signUpInBackgroundWithBlock{
            (succeeded:Bool, error:NSError?) -> Void in
            if let error = error{
                let alertController = UIAlertController(title: "Sign up Error", message:"Please enter username, password and email.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }else{
                let restaurantViewController = self.storyboard!.instantiateViewControllerWithIdentifier("navi") as! UINavigationController
                
                self.presentViewController(restaurantViewController, animated: true, completion: nil)
                
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
