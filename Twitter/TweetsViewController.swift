//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Mike Tehranian on 10/28/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MDT I GOT HERE 1")
        
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            
            for tweet in tweets {
                print(tweet.text!)
            }
            print("MDT I GOT HERE 2")
            // call tableView.reloadData()
        }, failure: { (error: Error) -> () in
            print("MDT I GOT HERE 3")
            dump(error)
            NSLog("Error: \(error.localizedDescription)", [])
            print("Error: \(error.localizedDescription)")
            print("MDT I GOT HERE 4")
        })
        
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        // Do an animation from this view to get back to the previous screen
        TwitterClient.sharedInstance.logout()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
