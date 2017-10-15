//
//  Dishes.swift
//  UserApp
//
//  Created by Alex Yang on 5/31/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import Foundation

class Dish {
    //Make sure to change stuff to "let" eventually
    var dishDescription:String?
    var dishName:String?
    var rating:Int?
    var rid:String?
    var price: Int?
    init(description: String,name:String,rating:Int,rid:String, price: Int ){
        self.dishDescription = description
        self.dishName = name
        self.rating = rating
        self.rid = rid
        self.price = price
    }
}
