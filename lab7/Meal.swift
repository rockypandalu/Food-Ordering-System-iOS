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
    var photo: UIImage?
    var price: Float
    var calorie: Int
    var majorNutrition: String
    var HotCold: Bool
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?,price: Float, calorie:Int, nutrition: String, HotCold: Bool) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.price=price
        self.calorie=calorie
        self.majorNutrition=nutrition
        self.HotCold=HotCold
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty{
            return nil
        }
    }
    
}
