//
//  TwitterClient.swift
//  Twitter
//
//  Created by Mike Tehranian on 10/28/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "QjxveJgRWYxhPAW7uUSMXXf6B", consumerSecret: "Qaiv7Dd3LllCj0OTSoPEhYT4IrH0yOOU6NfA3pDOfsywUfnIaA")!
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"twitterdemo://oauth")!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url)
            
        }, failure: { (error: Error?) in
            print("Error: \(error?.localizedDescription)) ")
            self.loginFailure?(error!)
        })
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            self.loginSuccess?()
        }, failure: { (error: Error?) in
            print("Error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> () , failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func currentAccount() {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("account: \(response)")
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            print("name: \(user.name)")
            print("screenname: \(user.screenname)")
            print("profile url: \(user.profileUrl)")
            print("description: \(user.tagline)")
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            
        })
    }
    
    //            homeTimeline(success: { (tweets: [Tweet]) in
    //                for tweet in tweets {
    //                    print(tweet.text!)
    //                }
    //            }, failure: { (error: Error) in
    //                print(error.localizedDescription)
    //            })
    //
    //            currentAccount()
    
}
