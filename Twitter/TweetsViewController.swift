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
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()
        loadTweetTimeline()
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
        
        // Attach the refresh control to the table view
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadTweetTimeline), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        
        // MDT TODO Set up infinit scrolling loading indicator below

    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        // Do an animation from this view to get back to the previous screen
        TwitterClient.sharedInstance.logout()
    }
    
    func loadTweetTimeline() {
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }, failure: { (error: Error) -> () in
            print("Error: \(error.localizedDescription)")
            self.refreshControl.endRefreshing()
        })
    }
    
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






