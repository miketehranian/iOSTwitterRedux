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
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: { (error: Error) in
            print("Error: \(error.localizedDescription)")
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}
