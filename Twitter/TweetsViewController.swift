//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Mike Tehranian on 10/28/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate {
    
    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()
        
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            
            //            for tweet in tweets {
            //                print(tweet.text!)
            //            }
            self.tableView.reloadData()
        }, failure: { (error: Error) -> () in
            print("Error: \(error.localizedDescription)")
        })
        
    }
    
    func initializeUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        // Used for estimating scroll bar height
        tableView.estimatedRowHeight = 120
        
        navigationController?.navigationBar.barTintColor = UIColor.blue // MDT figure out how to extract RGB or Hex for this
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        // MDT TODO Set up infinit scrolling loading indicator below
        
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

extension TweetsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetsCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
}


//extension TweetsViewController: UITableViewDelegate {
//
//}






