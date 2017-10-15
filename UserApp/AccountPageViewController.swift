//
//  AccountPageViewController.swift
//  UserApp
//
//  Created by Alex Yang on 6/23/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
class AccountPageViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }
    @IBAction func SignOutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    @IBAction func XButtonPressed(_ sender: UIBarButtonItem) {
        let tmpController :UIViewController! = self.presentingViewController;
        self.dismiss(animated: false, completion: {()->Void in
            tmpController.dismiss(animated: false, completion: nil);
        });
    }
    
}
