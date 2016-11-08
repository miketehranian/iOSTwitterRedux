//
//  MenuViewController.swift
//  Twitter
//
//  Created by Mike Tehranian on 11/5/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

protocol HamburgerNavigator: class {
    func showProfileView(user: User?)
}

class MenuViewController: UIViewController {
    
    var viewControllers = [UIViewController]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var hamburgerViewController: HamburgerViewController!
    
    var profileViewController: UIViewController!
    var mentionsViewController: UIViewController!
    var tweetsViewController: UIViewController!
    
    let menuItems = ["Home", "Mentions",  "Profile", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tweetsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        mentionsViewController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        
        if let tweetsVC = tweetsViewController.childViewControllers[0] as? TweetsViewController {
            tweetsVC.navigator = self
        }
        if let mentionsVC = mentionsViewController.childViewControllers[0] as? MentionsViewController {
            mentionsVC.navigator = self
        }
        if let profileVC = profileViewController.childViewControllers[0] as? ProfileViewController {
            profileVC.navigator = self
        }
        
        viewControllers.append(profileViewController)
        viewControllers.append(mentionsViewController)
        viewControllers.append(tweetsViewController)
        
        hamburgerViewController.contentViewController = tweetsViewController
    }
    
    func showMentionsView(user: User?) {
        mentionsViewController.navigationItem.title = "Mentions"
        mentionsViewController.navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x00B8ED)
        mentionsViewController.navigationController?.navigationBar.tintColor = UIColor.white
        mentionsViewController.navigationController?.navigationBar.isTranslucent = false
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        mentionsViewController.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        hamburgerViewController.contentViewController = mentionsViewController
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.menuTitleLabel.text = menuItems[indexPath.row]
        
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // Tweets
            hamburgerViewController.contentViewController = tweetsViewController
        } else if indexPath.row == 1 {
            // Mentions
            showMentionsView(user: User.currentUser)
        } else if indexPath.row == 2 {
            // Profile
            showProfileView(user: User.currentUser)
        } else if indexPath.row == 3 {
            // Logout
            TwitterClient.sharedInstance.logout()
        }
    }
}

extension MenuViewController: HamburgerNavigator {
    
    func showProfileView(user: User?) {
        if let profileView = profileViewController.childViewControllers[0] as? ProfileViewController {
            profileView.user = user
            profileView.title = user?.name!
            
            styleNavigationBar(viewController: profileView)
            
            hamburgerViewController.contentViewController = profileViewController
            profileView.refreshView()
        }
    }
}

func styleNavigationBar(viewController: UIViewController) {
    // Twitter Blue background with white text
    
    viewController.navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x00B8ED)
    viewController.navigationController?.navigationBar.tintColor = UIColor.white
    viewController.navigationController?.navigationBar.isTranslucent = false
    
    let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
    viewController.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
}

