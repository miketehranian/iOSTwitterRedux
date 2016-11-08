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
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    //MDT do I really need this?
    weak var navigator: MenuViewNavigator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Tweet.ComposeNewTweet), object: nil,
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
        
        let tweetNib = UINib(nibName: "TweetTableViewCell", bundle: nil)
        tableView.register(tweetNib, forCellReuseIdentifier: "TweetTableViewCell")
        
        navigationItem.title = "Timeline"
        navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x00B8ED)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        // Attach the refresh control to the table view
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadTweetTimeline), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }
    
    @IBAction func onComposeButton(_ sender: Any) {
        composeTweetFor(tweet: nil)
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
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        cell.showProfileDelegate = self
        // MDT commented out below because tweet cell has no compose functionality
        //        cell.composer = self
        return cell
    }
}

extension TweetsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TweetDetailViewController") as! TweetDetailViewController
        controller.tweet = tweets[indexPath.row]
        controller.composeTweetDelegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension TweetsViewController: ComposeTweetDelegate {
    func composeTweetFor(tweet: Tweet?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ComposeTweetViewController") as! ComposeTweetViewController
        if let sourceTweet = tweet {
            controller.replyTweet = sourceTweet
        } else {
            controller.replyTweet = nil
        }
        
        // MDT may need to wrap compose (and maybe all MVCs) in Nav controllers for this to work
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension TweetsViewController: ShowProfileDelegate {
    func showProfile(forUser: User?) {
        navigator?.navigateToProfileView(user: forUser)
    }
}
