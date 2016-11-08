//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Mike Tehranian on 11/7/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet] = []
    var user: User?
    weak var navigator: HamburgerNavigator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let tweetTableCellXib = UINib(nibName: "TweetTableViewCell", bundle: nil)
        let profileTableCellXib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(tweetTableCellXib, forCellReuseIdentifier: "TweetTableViewCell")
        tableView.register(profileTableCellXib, forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.estimatedRowHeight = 124
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func refreshView() {
        loadTweets()
    }
    
    func loadTweets() {
        TwitterClient.sharedInstance.userTimeline(screenname: user!.screenname!, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print("Error: \(error.localizedDescription)")
        })
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Add one for the profile photo and details cell
        return tweets.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            cell.selectionStyle = .none
            cell.user = user
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
            cell.tweet = tweets[indexPath.row - 1]
            cell.showProfileDelegate = self
            return cell
        }
    }
}

extension ProfileViewController: ShowProfileDelegate {
    func showProfile(forUser: User?) {
        navigator?.showProfileView(user: forUser)
    }
}
