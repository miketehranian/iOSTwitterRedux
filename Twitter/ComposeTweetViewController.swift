//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Mike Tehranian on 10/30/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {
    
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()
        
        self.profileImageView.setImageWith((User.currentUser?.profileUrl)!)
        self.profileImageView.layer.cornerRadius = 3
        self.profileImageView.layer.masksToBounds = true
        self.nameLabel.text = User.currentUser?.name
        self.screennameLabel.text = "@\(User.currentUser!.screenname!)"
        
        //        NotificationCenter.default.addObserverForName(UIKeyboardDidShowNotification, object: nil, queue: nil) { (notification: NSNotification!) -> Void in
        //            let userInfo = notification.userInfo!
        //            let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        //            self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y)
        //        }
        //
        //        NotificationCenter.default.addObserverForName(UIKeyboardDidHideNotification, object: nil, queue: nil) { (notification: NSNotification!) -> Void in
        //            let userInfo = notification.userInfo!
        //            let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        //            self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y)
        //        }
        //
        //        self.remainingCharactersLabel.text = "\(MAX_CHARACTERS_ALLOWED)"
        //
        //        self.textView.becomeFirstResponder()
        
    }
    
    func initializeUI() {
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
        // MDT need to set navigation bar color and font color here
    }
    
    @IBAction func onCancelTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetTap(_ sender: Any) {
        // Make a call to twitter api
        
        let tweetText = tweetTextView.text
        // MDT change to a guard statement
        if (tweetText?.characters.count == 0) {
            return
        }
        
        TwitterClient.sharedInstance.composeNewTweet(params: [ "status": tweetText! ], success: { (tweet: Tweet) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Tweet.ComponseNewTweet), object: tweet)
            //            self.dismiss(animated: true, completion: nil)
        }, failure: { (error: Error) in
            NSLog("Error Composing new Tweet: \(error)")
        })
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //    func adjustScrollViewContentSize() {
    //        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: tweetTextView.frame.origin.y + tweetTextView.frame.size.height)
    //    }
    
    //    override func viewDidLayoutSubviews() {
    //        self.adjustScrollViewContentSize()
    //    }
}

//extension ComposeTweetViewController: UITextViewDelegate {
//
//    func textViewDidChange(_ textView: UITextView) {
//        //        let status = textView.text
//        // MDT add later
//        //        let charactersRemaining = Tweet.maxTweetCharacters - (status?.characters.count)!
//        //        self.remainingCharactersLabel.text = "\(charactersRemaining)"
//        //        self.remainingCharactersLabel.textColor = charactersRemaining >= 0 ? .lightGrayColor() : .redColor()
////        adjustScrollViewContentSize()
//    }
//}
