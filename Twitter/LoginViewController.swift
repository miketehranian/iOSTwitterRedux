//
//  LoginViewController.swift
//  Twitter
//
//  Created by Mike Tehranian on 10/28/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    @IBAction func onLoginButton(_ sender: Any) {
        TwitterClient.sharedInstance.login(
            success: {
                print("I've logged in!")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLoginNotification), object: nil)
        }, failure: { (error: Error) in
            print("Error: \(error.localizedDescription)")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
