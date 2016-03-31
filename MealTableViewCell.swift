//
//  MealTableViewCell.swift
//  lab7
//
//  Created by rocky on 15/11/9.
//  Copyright © 2015年 rocky. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    @IBOutlet weak var MealImageView: UIImageView!
    @IBOutlet weak var MealLabel: UILabel!
    @IBOutlet weak var MealPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
