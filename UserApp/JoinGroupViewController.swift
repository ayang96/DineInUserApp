//
//  PopoverViewController.swift
//  UserApp
//
//  Created by Alex Yang on 7/16/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import UIKit
import Firebase
class JoinGroupViewController: UIViewController{
    
    @IBOutlet weak var PopupView: UIView!
    
    @IBOutlet var BackgroundView: UIView!
    
    
    @IBAction func DismissPopup(_ sender: Any) {
        dismiss(animated:true, completion: nil)
    }
    
    
    
    
    //JoinButtons
    @IBOutlet weak var JoinButtonJoin: UIButton!
    @IBOutlet weak var JoinGroupLabelJoin: UILabel!
    @IBOutlet weak var TextFieldJoin: UITextField!
    

    @IBAction func JoinGroupButtonPressed(_ sender: Any) {
        if(TextFieldJoin.text != "" && Auth.auth().currentUser != nil) {
            joinGroup(link: TextFieldJoin.text!) { (verdict) in
                if(verdict)! {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"updateGroupView"), object: nil)
                    self.dismiss(animated:true, completion: nil)

                } else {
                    let alertController = UIAlertController(title: "Error", message:
                        "Either you are already a part of this group, or the link is not valid", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        } else {
            print("text is either empty or youre not signed in")
        }
    }


    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        PopupView.layer.cornerRadius = 10
        PopupView.layer.masksToBounds = true

    }
    
    

    
}

