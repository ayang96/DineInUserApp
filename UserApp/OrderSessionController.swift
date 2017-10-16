//
//  MenuPopover.swift
//  UserApp
//
//  Created by Alex Yang on 7/21/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//
//This class controls the ordering and group adding...the group view controller has a segue to go here
import UIKit
import Firebase
class OrderSessionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    var groupObj: Group?
    var handle: UInt?
    @IBOutlet weak var PopupView: UIView!
    
    @IBOutlet var BackgroundView: UIView!
    
    @IBOutlet weak var GroupCollectionView: UICollectionView!
    
    @IBAction func DismissPopup(_ sender: Any) {
        dismiss(animated:true, completion: nil)
        detachGroupListener(groupObj: groupObj!, handle: handle!)
        print("PopupDetached")
    }
    
    @IBOutlet weak var NameOfGroup: UILabel!
    
    @IBOutlet weak var InviteCode: UITextView!
    @IBOutlet weak var RestaurantLabel: UILabel!
    
    @IBOutlet weak var ChosenFood: UILabel!
    @IBOutlet weak var GroupBorder: UIView!
    
    @objc var allOrdersReady = true
    @IBOutlet weak var SubmitOrderButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GroupCollectionView.delegate = self
        GroupCollectionView.dataSource = self
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"updateUsersandTheirFoodSelection"),
                       object:nil, queue:nil) {
                        notification in
                        self.allOrdersReady = true
                        print("reloading table in popup")
                        let serialQueue = DispatchQueue(label: "queuename")
                        serialQueue.sync {
                            self.GroupCollectionView.reloadData()
                           
                        }
                        
        }
        if(groupObj!.groupLeader != Auth.auth().currentUser?.uid){
            SubmitOrderButton.isHidden = true
        }
        
    }
    
    @IBOutlet weak var readyButton: UIButton!
    @IBAction func readyPressed(_ sender: Any) {
        if(readyButton.titleLabel?.text == "Ready"){
            readyCheck(check:true)
            readyButton.titleLabel?.text = "Not Ready"
        } else {
            readyCheck(check:false)
            readyButton.titleLabel?.text = "Ready"
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        PopupView.layer.cornerRadius = 10
        PopupView.layer.masksToBounds = true
        //print(groupObj?.restname)
        //RestaurantLabel.text = groupObj?.restname
        NameOfGroup.text = groupObj?.groupName
        InviteCode.text = groupObj?.link
        InviteCode.isUserInteractionEnabled = true
        InviteCode.isEditable = false
        SubmitOrderButton.isEnabled = false
        GroupBorder.layer.borderWidth = 1
        
        
        /*MOST IMPORTANT PART*/
        //Firebase method that allows updates ot the firebase to appear instantly to view
        handle = addGroupListener(groupObj: groupObj!)
        /*MOST IMPORTANT PART ABOVE THIS VERY LINE*/
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupObj!.uidlist.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupMember", for: indexPath) as! GroupMemberCell
        let keyarray = Array(groupObj!.uidlist.keys)
        let uid = keyarray[indexPath.item]
        let username = groupObj!.uidlist[uid]?["name"]

        cell.groupMemberName.text = username
        cell.userid = uid
        
        //On reload checks if user has selected a dish
        if let chosenfood = (groupObj!.uidlist[uid]?["order"]) {
            cell.orderStatus.text = "Ready"
            if(uid == Auth.auth().currentUser?.uid){
                ChosenFood.text = chosenfood
            }
        } else {
            allOrdersReady = false
            cell.orderStatus.text = "Not Ready"
            print("set text to nil")
        }
        
        if(groupObj!.uidlist.count-1==indexPath.item){
            if(self.allOrdersReady){
                self.SubmitOrderButton.isEnabled = true
                print("Submit Enabled")
            } else {
                self.SubmitOrderButton.isEnabled = false
                print("Submit Disabled")
            }

        }
        return cell
    }
    
    @IBAction func SelectPressed(_ sender: Any) {
        performSegue(withIdentifier: "PopoverToSelect", sender: self)
    }
    
    @IBAction func SubmitButtonPressed(_ sender: Any) {
        submitOrder(gp: groupObj!) {
            completion in
            if(completion) {
                self.SubmitOrderButton.isEnabled = false
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopoverToSelect" {
            if let destinationVC = segue.destination as? SelectFoodPopoverController {
                destinationVC.groupObj = groupObj
            }
        }
    }
    
    
    
    
}
