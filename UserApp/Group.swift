//
//  Group.swift
//  UserApp
//
//  Created by Alex Yang on 7/16/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import Foundation

class Group {
    var groupName: String
    var gid: String
    var uidlist: [String:[String:String]]
    var link: String
    var groupLeader: String
    var mid: String
    var restname: String
    var rid: String
    
    init(groupName: String, gid: String, uidlist: [String:[String:String]], groupLeader: String, link: String, mid: String, restname: String, rid: String) {
        self.groupName = groupName
        self.gid = gid
        self.uidlist = uidlist
        self.groupLeader = groupLeader
        self.link = link
        self.mid = mid
        self.restname = restname
        self.rid = rid
    }
    
    func groupToDictionary() -> [String: Any] {
        let post = [ "groupName": groupName, "groupLeader" : groupLeader, "uidlist": uidlist, "link": link, "rid": rid, "mid": mid, "restname": restname] as [String : Any]
        return post
    }
    
    static func dictionaryToGroup(dictionary: [String: Any], key: String) -> Group? {
        let obj = Group.init(groupName: dictionary["groupName"] as! String, gid: key,  uidlist: dictionary["uidlist"] as! [String:[String:String]], groupLeader: dictionary["groupLeader"] as! String, link: dictionary["link"] as! String, mid: dictionary["mid"] as! String, restname: dictionary["restname"] as! String, rid: dictionary["rid"] as! String)
        return obj
    }

    
    
    
}
