//
//  Tweet.swift
//  Twitter
//
//  Created by Mike Tehranian on 10/28/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    //    var screenName: String!
    //    var realName: String?
    //    var profileImageUrl: URL?
    //    var retweetedByName: String?
    
    var user: User
    
    public static let ComponseNewTweet = "ComposeNewTweet"
    public static let maxTweetCharacters = 140
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
            // print("Time stamp string: \(timestampString)")
        }
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        // MDT add these later
//        numberOfRetweets = dictionary["retweet_count"] as Int
//        numberOfFavorites = dictionary["favorite_count"] as Int
        
        // MDT remove below
        //        if let userDictionary = dictionary["user"] as? Dictionary<String, Any> { // MDT try ANYObject here
        //            if let screenNameString = userDictionary["screen_name"] as? String {
        //                print("Screen Name: \(screenNameString)")
        //                screenName = screenNameString
        //            }
        //            if let realNameString = userDictionary["name"] as? String {
        //                print("Real Name: \(realNameString)")
        //                self.realName = realNameString
        //
        //            }
        //            if let profileImageUrlString = userDictionary["profile_image_url_https"] as? String {
        //                if let realUrl = URL(string: profileImageUrlString) {
        //                    print("Image URL: \(realUrl)")
        //                    self.profileImageUrl = realUrl
        //                }
        //            }
        //    }
        
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
    
}
