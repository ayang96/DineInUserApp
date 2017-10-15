//
//  ColorCreator.swift
//  UserApp
//
//  Created by Alex Yang on 6/23/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import Foundation
import UIKit
class ColorCreator{
    
    init() {
    }
    
    //A quick function to convert hexcode into UIColors
    func UIColorFromHex(hex: Int) -> UIColor {
        return UIColor(red: CGFloat((hex & 0xFF0000) >> 16)/CGFloat(255), green: CGFloat((hex & 0x00FF00) >> 8)/CGFloat(255), blue: CGFloat((hex & 0x0000FF) >> 0)/CGFloat(255), alpha: 1.0)
    }
}
