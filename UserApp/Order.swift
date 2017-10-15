//
//  Order.swift
//  UserApp
//
//  Created by Alex Yang on 5/22/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import Foundation
import UIKit

/*class Order {
    
    /// Boolean indicating whether or not the post has been read
    var read: Bool = false
    /// Username of the poster
    let username: String
    
    /// The thread the the post was added to
    let thread: String
    
    /// The date that the snap was posted
    let date: Date
    
    /// The image path of the post
    let postImagePath: String
    
    /// The ID of the post, generated automatically on Firebase
    let postId: String
    /*
    init(id: String, username: String, postImagePath: String, thread: String, dateString: String, read: Bool) {
    }*/
    
    func getTimeElapsedString() -> String {
        let secondsSincePosted = -date.timeIntervalSinceNow
        let minutes = Int(secondsSincePosted / 60)
        if minutes == 1 {
            return "\(minutes) minute ago"
        } else if minutes < 60 {
            return "\(minutes) minutes ago "
        } else if minutes < 120 {
            return "1 hour ago"
        } else if minutes < 24 * 60 {
            return "\(minutes / 60) hours ago"
        } else if minutes < 48 * 60 {
            return "1 day ago"
        } else {
            return "\(minutes / 1440) days ago"
        }
        
    }
    
}
*/
