//
//  ProfileTableViewCell.swift
//  Twitter
//
//  Created by Mike Tehranian on 11/7/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var user: User! {
        didSet {
            if user.bannerUrl != nil {
                backgroundImageView.setImageWith(user.bannerUrl!)
            } else {
                backgroundImageView.image = nil
            }
            
            profileImageView.setImageWith(user.profileUrl!)
            nameLabel.text = user.name
            screennameLabel.text = "@\(user.screenname!)"
            followingLabel.text = "\(user.numFollowing!)"
            followersLabel.text = "\(user.numFollowers!)"
            descriptionLabel.text = "\(user.descriptionText!)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        backgroundImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
