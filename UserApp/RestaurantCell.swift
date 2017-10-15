//
//  RestaurantCell.swift
//  UserApp
//
//  Created by Alex Yang on 5/31/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    @IBOutlet weak var RestaurantName: UILabel!
    @IBOutlet weak var restrauntHours: UILabel!
    @IBOutlet weak var restrauntType: UILabel!
    @IBOutlet weak var restrauntRating: UILabel!
    @IBOutlet weak var blurImageView: UIImageView!
    
    //can delete maybe
    var restinfo:Restaurant?
}
