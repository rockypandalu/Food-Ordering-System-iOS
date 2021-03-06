//
//  Meal.swift
//  lab7
//
//  Created by rocky on 15/11/8.
//  Copyright © 2015年 rocky. All rights reserved.
//


import UIKit

class Meal {
    // MARK: Properties
    
    var name: String
    var photo: String
    var price: Float
    var HotCold: Int
    // MARK: Initialization
    
    init?(name: String, photo: String,price: Float, HotCold: Int) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.price=price

        self.HotCold=HotCold
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty{
            return nil
        }
    }
    
}
