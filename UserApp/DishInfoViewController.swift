//
//  DishInfoViewController.swift
//  UserApp
//
//  Created by Alex Yang on 10/14/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//
import Firebase
import UIKit
class DishInfoViewController: UIViewController{
    @IBOutlet weak var PopupView: UIView!
    
    @IBOutlet var BackgroundView: UIView!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var customInputTextBox: UITextView!
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishDescription: UILabel!
    var dishObj:Dish?
    var groupObj: Group?
    var restaurantObj: Restaurant?
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.navigationBar.isHidden = false
        dishName.text = dishObj!.dishName
        dishDescription.text = dishObj!.dishDescription
        PopupView.layer.cornerRadius = 10
        PopupView.layer.masksToBounds = true
    }
    @IBAction func dishSelected(_ sender: Any) {
        let titlestring = (Auth.auth().currentUser?.displayName)! + "'s Group"
        createGroup(groupName: titlestring, restObj: restaurantObj!) {
            (group) in
            self.groupObj = group
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"update"), object: nil)
        //dismiss(animated:false, completion: nil)
        performSegue(withIdentifier: "dishInfoToOrder", sender: self)
        
    }
    @IBAction func DismissPopup(_ sender: Any) {
        dismiss(animated:true, completion: nil)
        print("PopupDetached")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dishInfoToOrder" {
            if let destinationVC = segue.destination as? OrderSessionController {
                destinationVC.groupObj = groupObj
                //send chosen food
            }
        }
    }
    
}
