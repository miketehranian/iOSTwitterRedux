//
//  TweetsCell.swift
//  Twitter
//
//  Created by Mike Tehranian on 10/29/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

class TweetsCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    // MDT TODO add label for favorite and retweet counts
    
    var tweet: Tweet! {
        didSet {
//            if let profileImageUrl = tweet.profileImageUrl {
//                self.profileImageView.setImageWith(profileImageUrl)
//            }
            profileImageView.setImageWith((tweet?.user.profileUrl)!)
            nameLabel.text = tweet?.user.name
            screennameLabel.text = "@\((tweet?.user.screenname!)!)"
            tweetTextLabel.text = tweet?.text
            
            // MDT need to fix the formatting here
            //            if let timestamp = tweet.timestamp {
            //                timestampLabel.text = "\(timestamp)"
            //            }

            // timestampLabel.text = tweet?.timestamp.timeAgo()
            // MDT hard coding for now
            timestampLabel.text = "4h"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // MDT should I comment out below?
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
