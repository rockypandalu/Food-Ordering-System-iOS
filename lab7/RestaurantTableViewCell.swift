//
//  RestaurantTableViewCell.swift
//  lab7
//
//  Created by rocky on 15/11/8.
//  Copyright © 2015年 rocky. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
// MARK: Properties
    @IBOutlet weak var RestaurantLabel: UILabel!
    @IBOutlet weak var RestaurantImage: UIImageView!
   // @IBOutlet weak var ratingRatingControl: RatingControl!
    @IBOutlet weak var ratingControl: RatingControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
