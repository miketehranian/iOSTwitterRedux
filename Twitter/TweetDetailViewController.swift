//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Mike Tehranian on 10/30/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweet: Tweet?
    
    weak var composer: ComposeTweetDelegate?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    let twitterBlue = UIColor(netHex: 0x00B8ED)
    let red = UIColor.red
    
    @IBAction func onRetweetTap(_ sender: Any) {
        if (tweet?.retweeted!)! {
            updateRetweetCount(increment: false)
        } else {
            updateRetweetCount(increment: true)
        }
        retweetTweet()
    }
    
    @IBAction func onFavoriteTap(_ sender: Any) {
        if (tweet?.favorited!)! {
            updateFavoriteCount(increment: false)
        } else {
            updateFavoriteCount(increment: true)
        }
        favoriteTweet()
    }
    
    @IBAction func onReplyTap(_ sender: Any) {
        composer?.composeTweetFor(tweet: tweet!)
    }
    
    func updateFavoriteCount(increment: Bool) {
        if increment {
            favoriteCountLabel.text = updateLabelCount(existingCount: favoriteCountLabel.text, number: 1)
            favoriteButton.setTitleColor(red, for: .normal)
        } else {
            favoriteCountLabel.text = updateLabelCount(existingCount: favoriteCountLabel.text, number: -1)
            favoriteButton.setTitleColor(twitterBlue, for: .normal)
        }
    }
    
    func updateRetweetCount(increment: Bool) {
        if increment {
            retweetCountLabel.text = updateLabelCount(existingCount: retweetCountLabel.text, number: 1)
            retweetButton.setTitleColor(red, for: .normal)
        } else {
            retweetCountLabel.text = updateLabelCount(existingCount: retweetCountLabel.text, number: -1)
            retweetButton.setTitleColor(twitterBlue, for: .normal)
        }
    }
    
    func retweetTweet() {
        let params: NSDictionary = ["id": tweet!.id!]
        TwitterClient.sharedInstance.retweet(unRetweet: tweet!.retweeted!, params: params, success: { (tweet: NSDictionary) in
            self.tweet!.initFrom(dictionary: tweet)
        }, failure: { (error: Error) in
            print("Retweet Error: \(error.localizedDescription)")
        })
    }
    
    func updateLabelCount(existingCount: String?, number: Int) -> String? {
        if let existingCountInt = Int(existingCount!) {
            let newLabelCount = existingCountInt + number
            return "\(newLabelCount)"
        } else {
            return nil
        }
    }
    
    func favoriteTweet() {
        let params: NSDictionary = ["id": tweet!.id!]
        TwitterClient.sharedInstance.favoriteTweet(destroy: tweet!.favorited!, params: params, success: { (tweet: NSDictionary) in
            self.tweet!.initFrom(dictionary: tweet)
        }, failure: { (error: Error) in
            print("Error: \(error.localizedDescription)")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Tweet"
        profileImageView.setImageWith((tweet?.user.profileUrl!)!)
        profileImageView.layer.cornerRadius = 3.0
        profileImageView.layer.masksToBounds = true
        nameLabel.text = tweet?.user.name
        screenNameLabel.text = "@\(tweet!.user.screenname!)"
        tweetTextLabel.text = tweet?.text
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy 'at' h:mm aaa"
        dateLabel.text = formatter.string(from: tweet!.timestamp!)
        
        retweetCountLabel.text = "\(tweet!.retweetCount)"
        favoriteCountLabel.text = "\(tweet!.favoritesCount)"
        
        replyButton.setTitleColor(twitterBlue, for: .normal)
        
        if tweet!.retweeted! {
            retweetButton.setTitleColor(red, for: .normal)
        } else {
            retweetButton.setTitleColor(twitterBlue, for: .normal)
        }
        
        if tweet!.favorited! {
            favoriteButton.setTitleColor(red, for: .normal)
        } else {
            favoriteButton.setTitleColor(twitterBlue, for: .normal)
        }
    }
}
