//
//  GroupViewController.swift
//  UserApp
//
//  Created by Alex Yang on 7/16/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import UIKit
class GroupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var ActiveIndicator: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"updateGroupView"),
                       object:nil, queue:nil) {
                        notification in
                        self.updateData()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var handletouserspecificgrouplistener: UInt?
    override func viewWillDisappear(_ animated: Bool) {
        detachUserSpecificGroupListener(handle: handletouserspecificgrouplistener!)
    }
    override func viewWillAppear(_ animated: Bool) {
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"reloadTable"),
                       object:nil, queue:nil) {
                        notification in
                        self.collectionView.reloadData()
                        
        }
        
        handletouserspecificgrouplistener = addUserSpecificGroupListener()
        updateData()
    }
    
    //propabably move this to your first view
    @objc func updateData() {
        getGroups() { (completion) in
            if(completion){
                self.collectionView.reloadData()
            } else {
                self.collectionView.reloadData()
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = (activegroupObj?.count)!
        if(count==0) {
            ActiveIndicator.isHidden = false
        } else {
            ActiveIndicator.isHidden = true
        }

        return count
    }
    @objc var keyarray: [String]?
    
    //attaches group attributes to each cell, button implementation for each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activeGroupCell", for: indexPath) as! GroupCell
        
        keyarray = Array(activegroupObj!.keys)
        cell.groupID = keyarray?[indexPath.item]
        cell.groupName.text = activegroupObj?[cell.groupID!]?.groupName
        
        //Remove the group from the database
        cell.xbuttontapped = { (selectedCell) -> Void in
            print(selectedCell.groupID ?? "")
            deleteGroup(gid: selectedCell.groupID!) {
                (completion) in
                if(completion) {
                    self.updateData()
                } else {
                   //not sure atm but it means that there was no group to delete
                }
            }
        }
        if(EditButton.title == "Edit"){
            cell.XButton.isHidden = true
        } else {
            cell.XButton.isHidden = false
        }
        return cell
    }
    
    @IBOutlet weak var EditButton: UIBarButtonItem!
 
    @IBAction func EditButtonPressed(_ sender: Any) {
        
        if EditButton.title == "Edit" {
            self.collectionView.reloadData()
            EditButton.title = "Cancel"

            
        } else {
            self.collectionView.reloadData()
            EditButton.title = "Edit"

        }

        
    }

    var indexatselection: Int?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexatselection = indexPath.item
        performSegue(withIdentifier: "GroupToGroupSession", sender: GroupCell.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GroupToGroupSession" {
                if let destinationVC = segue.destination as? OrderSessionController {
                    let key = keyarray?[indexatselection!]
                    let group = activegroupObj?[key!]
                    destinationVC.groupObj = group
                }
        }
    }
}
