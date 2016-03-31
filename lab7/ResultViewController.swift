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
    @IBOutlet weak var ResultPriceLabel: UILabel!
    @IBOutlet weak var ResultMealLabel: UILabel!
    var toPass: String!
    var toPassMeal: String!
    var toPassPrice: String!
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
        ResultMealLabel.text=toPassMeal
        ResultPriceLabel.text=toPassPrice
        self.reloadInputViews()
        while toID==nil{
            sleep(1)
        }
        hehe.ID=toID
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
