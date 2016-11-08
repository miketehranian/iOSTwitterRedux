//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Mike Tehranian on 11/7/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate {
    
    var tweets = [Tweet]()
    weak var navigator: HamburgerNavigator?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let tweetNib = UINib(nibName: "TweetTableViewCell", bundle: nil)
        tableView.register(tweetNib, forCellReuseIdentifier: "TweetTableViewCell")
        tableView.estimatedRowHeight = 124
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.title = "Mentions"
        navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x00B8ED)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        
        initializeTweetMentions()
    }
    
    func initializeTweetMentions() {
        TwitterClient.sharedInstance.userMentions(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print("Error: \(error.localizedDescription)")
        })
    }
    
}

extension MentionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        cell.showProfileDelegate = self
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
}

extension MentionsViewController: ShowProfileDelegate {
    func showProfile(forUser: User?) {
        navigator?.showProfileView(user: forUser)
    }
}
