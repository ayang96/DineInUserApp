//
//  Restaurants.swift
//  UserApp
//
//  Created by Alex Yang on 5/31/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import Foundation

class Restaurant {
    
    var mid:String?
    var rid:String?
    var name:String?
    var hours:String?
    var rating:String?
    var type:String?
    
    init(name: String, rid: String, mid: String, hours: String, rating: String, type: String){
        self.name = name
        self.rid = rid
        self.mid = mid
        self.hours = hours
        self.rating = rating
        self.type = type

        
    }
}
