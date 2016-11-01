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
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"twitterdemo://oauth")!, scope: nil,
                          success: { (requestToken: BDBOAuth1Credential?) in
                            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
                            UIApplication.shared.open(url)
        }, failure: { (error: Error?) in
            print("Error: \(error?.localizedDescription)) ")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
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
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func composeNewTweet(params: NSDictionary?, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let status = Tweet(dictionary: response as! NSDictionary)
            success(status)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func retweet(unRetweet: Bool = false, params: NSDictionary, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        let url = (unRetweet ? "1.1/statuses/unretweet/" : "1.1/statuses/retweet/")+"\(params["id"]!).json"
        post(url,parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success(response as! NSDictionary)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func unretweet(params: NSDictionary, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        let getTweetUrl = "1.1/statuses/show/\(params["id"]!).json?include_my_retweet=1"
        get(getTweetUrl, parameters: nil, progress: nil, success: {
            (task: URLSessionDataTask, response: Any?) -> Void in
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func favoriteTweet(destroy: Bool = false, params: NSDictionary, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        let url = (destroy ? "1.1/favorites/destroy.json" : "1.1/favorites/create.json")
        post(url, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success(response as! NSDictionary)
        }) { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
}
