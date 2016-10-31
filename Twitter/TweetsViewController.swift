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
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Tweet.ComponseNewTweet), object: nil,
                                               queue: OperationQueue.main,
                                               using: { (notification: Notification) -> Void in
                                                let tweet = notification.object as! Tweet
                                                self.tweets?.insert(tweet, at: 0)
                                                self.tableView.reloadData()
        })
        
        
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
        
        
        // MDT TODO Set up infinite scrolling loading indicator below
        
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        // MDT Can do an animation from this view to get back to the previous screen
        TwitterClient.sharedInstance.logout()
    }
    
    //MDT probably don't need something like this again, but may be useful
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let navigationController = segue.destination as! UINavigationController
    //
    //        switch navigationController.topViewController {
    //        case is ComposeTweetViewController:
    //            let composeTweetViewController = navigationController.topViewController as! ComposeTweetViewController
    //            filtersViewController.delegate = self
    //            filtersViewController.categoriesSwitchStates = categoryStates
    //            filtersViewController.distancesSwitchStates = distancesStates
    //            filtersViewController.sortBySwitchStates = sortByStates
    //            filtersViewController.hasDealsState = hasDealState
    //        case is MapViewController:
    //            let mapViewController = navigationController.topViewController as! MapViewController
    //            mapViewController.businesses = businesses
    //        default:
    //            break
    //        }
    //    }
    
    func loadTweetTimeline() {
        // MDT maybe include this
        // MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }, failure: { (error: Error) -> () in
            print("Error: \(error.localizedDescription)")
            self.refreshControl.endRefreshing()
        })
        // MDT maybe include and this
        // MBProgressHUD.hideHUDForView(self.view, animated: true)
        
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






