//
//  FirebaseManager.swift
//  UserApp
//
//  Created by Alex Yang on 5/31/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import FirebaseStorage
import FirebaseDatabase

var restaurants: [Restaurant] = []
var dishes: [Dish] = []
var profileImage: UIImage?


//[gid:groupName]
//NEED TO REPLACE ACTIVEGROUPLIST WITH ACTIVEGROUPOBJ
var activegrouplist: [String:String]? = [:]

//[gid:groupObj]
var activegroupObj: [String: Group]? = [:]

func addOrder(dishname: String, oid: String) {
    let dbRef = Database.database().reference()
    
    let dictionary: [String:String] = [
        "uid": "u1",
        "dish": dishname
    ]
    dbRef.child("Orders").child(oid).setValue(dictionary)
}

func passwordMaker() -> String {
    let passwordCharacters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".characters)
    let len = 5
    //define and empty string password
    
    var password = ""
    //create a loop to gennerate your random characters
    
    for _ in 0..<len {
        // generate a random index based on your array of characters count
        let rand = arc4random_uniform(UInt32(passwordCharacters.count))
        // append the random character to your string
        password.append(passwordCharacters[Int(rand)])
    }
    return password
}

func submitOrder(gp: Group, completion: @escaping (Bool) -> Void) {
    let dbRef = Database.database().reference()
    dbRef.child("orders").child(gp.rid).childByAutoId().setValue(["rid": gp.rid, "uidlist":gp.uidlist, "gid":gp.gid] as? Any)
    completion(true)
}




func getRestaurant( completion: @escaping ([Restaurant]?) -> Void) {
    let dbRef = Database.database().reference()
    var restaurantObj:Restaurant?
    var restaurantArray: [Restaurant] = []
    // YOUR CODE HERE
    dbRef.child("Restaurants").observeSingleEvent(of: .value, with: { (snapshot) in
        if(snapshot.exists() == false) {
            completion(nil)
            return
        }
        if(snapshot.value == nil) {
            completion(nil)
            return
        }
        
        let restDict = snapshot.value as! [String:AnyObject]
        //to Fix
        for (key,value) in restDict{//go through posts
            let mid = (value as! [String:String])["mid"]
            let restaurantName = (value as! [String:String])["name"]
            let hours = (value as! [String:String])["hours"]
            let type = (value as! [String:String])["type"]
            let rating = (value as! [String:String])["rating"]

            restaurantObj = Restaurant(name: restaurantName!, rid: key, mid: mid!, hours: hours!, rating: rating!, type: type!)
            
            restaurantArray.append(restaurantObj!)
        }
        completion(restaurantArray)
        
    })
}



func getMenu(mid:String, completion: @escaping ([Dish]?) -> Void) {
    let dbRef = Database.database().reference()
    var dishobj:Dish?
    var disharray: [Dish] = []
    // YOUR CODE HERE
    dbRef.child("Menu").child(mid).child("didlist").observeSingleEvent(of: .value, with: { (snapshot) in
        if(snapshot.exists() == false) {
            completion(nil)
            return
        }
        if(snapshot.value == nil) {
            completion(nil)
            return
        }
        dbRef.child("Dishes").observeSingleEvent(of: .value, with: { (snapshotDish) in
            let menu = snapshot.value as! [String:Bool]
            let dishDict = snapshotDish.value as! [String:AnyObject]
            for (did,bool) in menu{
                let dish = dishDict[did]
                //if let dish = dishDict[value] as? [String:AnyObject]{
                    dishobj = Dish(description: dish?["DishDescription"] as! String, name: dish?["DishName"] as! String, rating: dish?["Rating"] as! Int, rid: dish?["rid"] as! String, price: dish?["Price"] as! Int)
                    disharray.append(dishobj!)
                //}
            }
            completion(disharray)
        })
        
    })
}
