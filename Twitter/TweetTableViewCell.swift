//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Mike Tehranian on 11/7/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

protocol ShowProfileDelegate: class {
    func showProfile(forUser: User?)
}

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    weak var showProfileDelegate: ShowProfileDelegate?
    
    var tweet: Tweet! {
        didSet {
            profileImageView.setImageWith((tweet?.user.profileUrl)!)
            nameLabel.text = tweet?.user.name
            screennameLabel.text = "@\((tweet?.user.screenname!)!)"
            tweetTextLabel.text = tweet?.text
            
            let dateFormatter = DateFormatter()
            timestampLabel.text = dateFormatter.timeSince(from: tweet.timestamp!, numericDates: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
        let profileImageTapGR = UITapGestureRecognizer(target: self, action: #selector(self.onTapProfileImage(_:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(profileImageTapGR)
    }
    
    func onTapProfileImage(_ sender: UITapGestureRecognizer) {
        showProfileDelegate?.showProfile(forUser: tweet.user)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// Found here:
// https://samoylov.tech/2016/09/19/implementing-time-since-function-in-swift-3/
extension DateFormatter {
    /**
     Formats a date as the time since that date (e.g., “Last week, yesterday, etc.”).
     
     - Parameter from: The date to process.
     - Parameter numericDates: Determines if we should return a numeric variant, e.g. "1 month ago" vs. "Last month".
     
     - Returns: A string with formatted `date`.
     */
    func timeSince(from: Date, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = from //(now > from ? from : now)
        let latest = now //earliest == now as Date ? from : now
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest)
        
        var result = ""
        
        if components.year! >= 2 {
            result = "\(components.year!)y"
        } else if components.year! >= 1 {
            if numericDates {
                result = "1y"
            } else {
                result = "Last year"
            }
        } else if components.month! >= 2 {
            result = "\(components.month!)m"
        } else if components.month! >= 1 {
            if numericDates {
                result = "1m"
            } else {
                result = "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            result = "\(components.weekOfYear!)w"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                result = "1w"
            } else {
                result = "Last week"
            }
        } else if components.day! >= 2 {
            result = "\(components.day!)d"
        } else if components.day! >= 1 {
            if numericDates {
                result = "1d"
            } else {
                result = "Yesterday"
            }
        } else if components.hour! >= 2 {
            result = "\(components.hour!)d"
        } else if components.hour! >= 1 {
            if numericDates {
                result = "1h"
            } else {
                result = "An hour ago"
            }
        } else if components.minute! >= 2 {
            result = "\(components.minute!)m"
        } else if components.minute! >= 1 {
            if numericDates {
                result = "1m"
            } else {
                result = "A minute ago"
            }
        } else if components.second! >= 3 {
            result = "\(components.second!)s"
        } else {
            result = "Just now"
        }
        
        return result
    }
}
