//
//  FirebaseListeners.swift
//  UserApp
//
//  Created by Alex Yang on 10/5/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//
import Foundation
import Firebase
import UIKit
import FirebaseStorage
import FirebaseDatabase

//Adds a listener to check for updates to the uidlist, returns the handle so the listener can be detached


//To be used by SelectGroupController to automatically sync added groupmembers
func addGroupListener(groupObj: Group) -> UInt{
    let key = groupObj.gid
    let dbRef = Database.database().reference()
    let handle = dbRef.child("Groups").child(key).child("uidlist").observe(DataEventType.value, with: { (snapshot) in
        let postDict = snapshot.value as? [String : [String:String]] ?? [:]
        // ...
        groupObj.uidlist = postDict
        activegroupObj?[key] = groupObj
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"updateUsersandTheirFoodSelection"), object: nil)
        print("sending update")
    })
    return handle
}

func detachGroupListener(groupObj: Group, handle:UInt) {
    let key = groupObj.gid
    let dbRef = Database.database().reference()
    dbRef.child("Groups").child(key).child("uidlist").removeObserver(withHandle: handle)
}

//Btw probably not necessary ot call getGroups after this...getGroups should only be called once

//Used by GroupViewController to reload the groups the user is apart of
func addUserSpecificGroupListener() -> UInt{
    let dbRef = Database.database().reference()
    let userid = Auth.auth().currentUser?.uid
    let handle = dbRef.child("users").child(userid!).child("Groups").observe(DataEventType.value, with: { (snapshot) in
        let postDict = snapshot.value as? [String:String] ?? [:]
        let gidlist = postDict
        for(key,_) in activegroupObj! {
            let keyExists = gidlist[key] != nil
            if(!keyExists){
                activegroupObj?.removeValue(forKey: key)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"reloadGroupTable"), object: nil)
    })
    return handle
}

func detachUserSpecificGroupListener(handle:UInt) {
    let dbRef = Database.database().reference()
    let user = Auth.auth().currentUser
    detachListener(dbRef: dbRef.child("users").child((user?.uid)!).child("Groups"), handle: handle)
    
}
func detachListener(dbRef: DatabaseReference, handle: UInt){
    dbRef.removeObserver(withHandle: handle)
}
