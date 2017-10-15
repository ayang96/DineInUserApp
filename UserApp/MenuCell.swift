//
//  MenuCell.swift
//  UserApp
//
//  Created by Alex Yang on 5/31/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var DishName: UILabel!
    @IBOutlet weak var dishLabel: UILabel!
    //can delete maybe
    @IBOutlet weak var dishPrice: UILabel!
    var dishinfo:Dish?
}
