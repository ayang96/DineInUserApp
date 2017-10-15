//
//  GroupCell.swift
//  UserApp
//
//  Created by Alex Yang on 7/16/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import UIKit

class GroupCell: UICollectionViewCell {
    @IBOutlet weak var groupName: UILabel!
    @objc var groupID:String?
    @IBOutlet weak var XButton: UIButton!
    @objc var xbuttontapped: ((GroupCell) -> Void)?
    
    @IBAction func XButtonTapped(_ sender: Any) {
        xbuttontapped?(self)
    }
}
