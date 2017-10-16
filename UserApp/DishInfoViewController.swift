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
    var selectedIndex: Int?
    var dishObj:Dish?
    var groupObj: Group?
    var restaurantObj: Restaurant?
    var orderCreated: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.navigationBar.isHidden = false
        dishName.text = dishObj!.dishName
        dishDescription.text = dishObj!.dishDescription
        PopupView.layer.cornerRadius = 10
        PopupView.layer.masksToBounds = true
    }
    @IBAction func dishSelected(_ sender: Any) {
        if((groupObj) != nil){
            appendOrderToGroupList(index: self.selectedIndex!, group: self.groupObj!)
            dismiss(animated:true, completion: nil)
        } else {
            if(orderCreated == false) {
                let titlestring = (Auth.auth().currentUser?.displayName)! + "'s Group"
                createGroup(groupName: titlestring, restObj: restaurantObj!) {
                    (group) in
                    self.groupObj = group
                    appendOrderToGroupList(index: self.selectedIndex!, group: self.groupObj!)
                    self.dismiss(animated:true, completion: nil)
                    //FIX HERE ALEX...ORDER NOT BEING CREATED
                }
            }
        }

        
        
        
        //performSegue(withIdentifier: "dishInfoToOrder", sender: self)
        
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
