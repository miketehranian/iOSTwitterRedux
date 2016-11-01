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
    var id: Int?
    
    var user: User!
    
    var favorited: Bool?
    var retweeted: Bool?
    
    public static let ComposeNewTweet = "ComposeNewTweet"
    public static let maxTweetCharacters = 140
    
    init(dictionary: NSDictionary) {
        super.init()
        initFrom(dictionary: dictionary)
    }
    
    func initFrom(dictionary: NSDictionary) {
        var realDictionary: NSDictionary = dictionary
        
        favorited = realDictionary.value(forKey: "favorited") as? Bool ?? false
        retweeted = realDictionary.value(forKey:"retweeted") as? Bool ?? false
        
        user = User(dictionary: realDictionary["user"] as! NSDictionary)
        id = (realDictionary["id"] as? Int) ?? 0
        
        if realDictionary["retweeted_status"] != nil {
            realDictionary = dictionary["retweeted_status"] as! NSDictionary
        } else {
            realDictionary = dictionary
        }
        
        text = realDictionary["text"] as? String
        
        retweetCount = (realDictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (realDictionary["favorite_count"] as? Int) ?? 0
        
        let timestampString = realDictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
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
