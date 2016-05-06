//
//  ResultViewController.swift
//  lab7
//
//  Created by rocky on 15/11/9.
//  Copyright © 2015年 rocky. All rights reserved.
//

import UIKit
class ResultViewController: UIViewController {
    @IBOutlet weak var QRImageView: UIImageView!

    var toID: String!
    @IBOutlet weak var hehe: FeedbackControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        QRImageView.image={
            var qrCode=QRCode(toID)
            qrCode?.color=CIColor(rgba: "5a44ad")
            //qrCode?.backgroundColor = CIColor(rgba: "000")
            return qrCode!.image
            }()
        self.reloadInputViews()
        while toID==nil{
            sleep(1)
        }
        hehe.ID=toID
    }

    @IBAction func pickUpAction(sender: AnyObject) {
        httpPost(toID)
        
    }

    
    func httpPost(command:String){
        let request = NSMutableURLRequest(URL: NSURL(string:
            "http://128.59.46.47:5000/openbox")!); request.HTTPMethod = "POST"
        let postString = command
        //Show the message sent to PI on IOS device
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in if error != nil {
                print("error=\(error)")
                return}
            print("response = \(response)")
            let responseString = NSString(data: data!, encoding:
                NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
