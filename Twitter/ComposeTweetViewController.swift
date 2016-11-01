//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Mike Tehranian on 10/30/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

protocol ComposeTweetDelegate: class {
    func composeTweetFor(tweet: Tweet?)
}

class ComposeTweetViewController: UIViewController {
    
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    
    var replyTweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()
        
        self.profileImageView.setImageWith((User.currentUser?.profileUrl)!)
        self.profileImageView.layer.cornerRadius = 3
        self.profileImageView.layer.masksToBounds = true
        self.nameLabel.text = User.currentUser?.name
        self.screennameLabel.text = "@\(User.currentUser!.screenname!)"
        
        if replyTweet != nil {
            tweetTextView.text = "@\(replyTweet!.user!.screenname!)"
        }
        tweetTextView.becomeFirstResponder()
    }
    
    func initializeUI() {
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
        navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x00B8ED)
    }
    
    @IBAction func onCancelTap(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func onTweetTap(_ sender: Any) {
        let tweetText = tweetTextView.text
        if (tweetText?.characters.count == 0) {
            return
        }
        
        var params: NSDictionary!
        if let replyTweet = replyTweet {
            params = ["status": tweetText!, "in_reply_to_status_id": replyTweet.id!]
        } else {
            params = ["status": tweetText!]
        }
        
        TwitterClient.sharedInstance.composeNewTweet(params: params, success: { (tweet: Tweet) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Tweet.ComposeNewTweet), object: tweet)
        }, failure: { (error: Error) in
            NSLog("Error Composing new Tweet: \(error)")
        })
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}

extension UIColor {
    // Taken from: http://bit.ly/2f6Fvz3
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
