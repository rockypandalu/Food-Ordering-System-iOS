//
//  Restaurant.swift
//  lab7
//
//  Created by rocky on 15/11/8.
//  Copyright © 2015年 rocky. All rights reserved.
//

import Foundation
import UIKit
class Restaurant {
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating : Int
    var restaurantId: String
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int, id: String) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        self.restaurantId = id
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty{
            return nil
        }
    }

}
