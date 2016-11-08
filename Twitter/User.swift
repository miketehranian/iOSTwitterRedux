//
//  User.swift
//  Twitter
//
//  Created by Mike Tehranian on 10/28/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var descriptionText: String?
    
    var bannerUrl: URL?
    var numFollowing: Int?
    var numFollowers: Int?
    var numTweets: Int?
    
    var dictionary: NSDictionary?
    
    public static let userDidLogoutNotification = "UserDidLogout"
    public static let userDidLoginNotification = "UserDidLogin"
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: profileUrlString)!
        }
        
        descriptionText = dictionary["description"] as? String
        
        numTweets = dictionary["statuses_count"] as? Int ?? 0
        numFollowing = dictionary["friends_count"] as? Int ?? 0
        numFollowers = dictionary["followers_count"] as? Int ?? 0
        
        let backgroundUrlString = dictionary["profile_background_image_url_https"] as? String
        if let backgroundImageUrlString = backgroundUrlString {
            bannerUrl = URL(string: backgroundImageUrlString)
        }
        
        // Twitter API is weird, sometimes this is populated ¯\_(ツ)_/¯
        let bannerUrlString = dictionary["profile_banner_url_https"] as? String
        if let bannerImageUrlString = bannerUrlString {
            bannerUrl = URL(string: bannerImageUrlString)
        }
    }
    
    private static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
        }
        set {
            _currentUser = newValue
            
            let defaults = UserDefaults.standard
            
            if let user = newValue {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
}
