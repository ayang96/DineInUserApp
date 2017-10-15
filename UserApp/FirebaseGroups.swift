//
//  FirebaseGroups.swift
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

//adds the dishname to the uidlist under a new child named "order"
//called in the selectFoodPopoverController
func appendOrderToGroupList(index: Int, group: Group) {
    let dbRef = Database.database().reference()
    if let user = Auth.auth().currentUser {
        //need to update with did
        let childUpdates = ["/Groups/\(group.gid)/uidlist/\(user.uid)/order":dishes[index].dishName] as [String: Any]
        activegroupObj?[group.gid]?.uidlist[user.uid]?["order"] = dishes[index].dishName
        
        dbRef.updateChildValues(childUpdates)
        
    }
    
}
// Creates group with the password and everything
// Called in the restaurant page

func createGroup(groupName: String, restObj: Restaurant, completion: @escaping (Group?) -> Void) {
    let dbRef = Database.database().reference()
    
    // YOUR CODE HERE
    if let user = Auth.auth().currentUser {
        let link = "dinein.com/" + passwordMaker()
        
        let key = dbRef.child("Groups").childByAutoId().key
        
        let groupObj = Group.init(groupName: groupName, gid: key, uidlist: [user.uid:["name":user.displayName!]], groupLeader: user.uid, link: link, mid: restObj.mid!, restname: restObj.name!, rid:restObj.rid!)
        
        activegroupObj?[key] = groupObj
        
        let post = groupObj.groupToDictionary()
        let childUpdates = ["/Groups/\(key)":post,
                            "/users/\(user.uid)/Groups/\(key)": groupName] as [String : Any]
        dbRef.updateChildValues(childUpdates)
        
        //handle updates
        
        completion(groupObj)
    }
    
}

//get groupps current user is apart of
//performance upgrade:do seperate indiv queries instead of one that gets all the groups in the database
func getGroups(completion: @escaping (Bool) -> Void) {
    let dbRef = Database.database().reference()
    if let user = Auth.auth().currentUser {
        dbRef.child("users").child((user.uid)).child("Groups").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if(snapshot.value is NSNull||snapshot.value == nil||snapshot.exists() == false){
                completion(false)
                return
                // break
            } else {
                //list of all groups the user is in
                let groupDict = snapshot.value as! [String:String]
                
                dbRef.child("Groups").observeSingleEvent(of: .value, with: {(snapshotGroup) in
                    
                    if(snapshotGroup.value is NSNull||snapshotGroup.value == nil||snapshotGroup.exists() == false){
                        completion(false)
                        return
                    }
                    //list of all groups on the firebase
                    let totalgrouplist = snapshotGroup.value as! [String:Any]
                    //run for loop to check for similarity between user's group and all groups
                    for(key,_) in groupDict{
                        for(gkey,dict) in totalgrouplist{
                            if key == gkey {
                                let groupObj = Group.dictionaryToGroup(dictionary: dict as! [String : Any],key: gkey)
                                activegroupObj?[gkey] = groupObj
                            }
                        }
                    }
                    
                    //test if we found any groups
                    let counter = activegroupObj?.count
                    if counter!>0 {
                        completion(true)
                    }
                    
                })
                
                
            }
            
        })
    }
}


//performance upgrade needed: index by links
func joinGroup(link: String, completion: @escaping (Bool?) -> Void) {
    let dbRef = Database.database().reference()
    //loop through associated gids to get group info
    if let user = Auth.auth().currentUser {
        dbRef.child("users").child((user.uid)).child("Groups").observeSingleEvent(of: .value, with: {(snapshot) in
            var mygroups = [String: String]()
            
            if(snapshot.value is NSNull || snapshot.value == nil || snapshot.exists() == false){  //if Ive never joined a group yet
            } else {
                mygroups = snapshot.value as! [String:String]
            }
            dbRef.child("Groups").observeSingleEvent(of: .value, with: {(groupshot) in
                if(groupshot.exists() == false) {
                    completion(nil)
                }
                if(groupshot.value == nil) {
                    completion(nil)
                }
                let specificgroupDict = groupshot.value as! [String:Any]
                let sgd = specificgroupDict
                /*let newgroup = (Group.init(groupName: sgd["groupName"]! as! String, gid: gid, uidlist: sgd["uidlist"]! as! [String : String], groupLeader: sgd["groupLeader"]! as! String, link: sgd["link"]! as! String))*/
                for(key,dict) in sgd{
                    let group = dict as! [String:Any]
                    if link == (group["link"] as! String) {
                        //if i'm not a part of this group yet
                        if mygroups[key] == nil {
                            let childUpdates = ["/Groups/\(key)/uidlist/\(user.uid)/name":user.displayName,
                                                "/users/\(user.uid)/Groups/\(key)": group["groupName"] as! String!] as! [String : String]
                            //NEED TO CREATE A GROUPOBJ let groupObj = Group.init(groupName: groupName, gid: key, uidlist: [user.uid:user.displayName!], groupLeader: user.uid, link: link)
                            
                            dbRef.updateChildValues(childUpdates)
                            completion(true)
                        }
                        //i'm already a part of this group
                        completion(false)
                    }
                }
                //I looped through all groups but couldnt find a match
                completion(false)
                
            })
        }
        )}
    
}

func deleteGroup(gid: String, completion: @escaping (Bool) -> Void) {
    let dbRef = Database.database().reference()
    let currentuser = Auth.auth().currentUser
    dbRef.child("Groups").child(gid).observeSingleEvent(of: .value, with: { (snapshot) in
        if(snapshot.value is NSNull || snapshot.value == nil || snapshot.exists() == false){  //if this group doesn't exist
            completion(false)//just remove the group from the local list(ie nothing to worry about)
        } else {
            let groupToDelete = snapshot.value as! [String:Any]
            let groupObjToDelete = Group.dictionaryToGroup(dictionary: groupToDelete, key: gid)
            //if I am the groupLeader delete everything...eventually change to designating random leader
            if groupObjToDelete?.groupLeader ==  currentuser?.uid {
                for (uid,_) in (groupObjToDelete?.uidlist)!{
                    dbRef.child("users").child(uid).child("Groups").child(gid).removeValue()
                    dbRef.child("Groups").child(gid).removeValue()
                    
                }
            } else { //I am not the groupleader so just remove my reference from the group
                dbRef.child("users").child((currentuser?.uid)!).child("Groups").child(gid).removeValue()
                dbRef.child("Groups").child(gid).child("uidlist").child((currentuser?.uid)!).removeValue()
            }
            completion(true)
            //add listener in each user's node
        }
    })
}
