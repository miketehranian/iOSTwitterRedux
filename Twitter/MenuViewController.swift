//
//  MenuViewController.swift
//  Twitter
//
//  Created by Mike Tehranian on 11/5/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

// MDT Rename to hamburger navigator
protocol MenuViewNavigator: class {
    func navigateToProfileView(user: User?)
}

class MenuViewController: UIViewController {
    
    var viewControllers: [UIViewController] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var hamburgerViewController: HamburgerViewController!
    
    var profileViewController: UIViewController!
    var mentionsViewController: UIViewController!
    var timelineViewController: UIViewController!
    
    let menuItems = ["Home", "Mentions",  "Profile"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        timelineViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        mentionsViewController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        
        // MDT replace this with a for-loop
        if let tvc = timelineViewController.childViewControllers[0] as? TweetsViewController {
            tvc.navigator = self
        }
        if let mvc = mentionsViewController.childViewControllers[0] as? MentionsViewController {
            mvc.navigator = self
        }
        if let pvc = profileViewController.childViewControllers[0] as? ProfileViewController {
            pvc.navigator = self
        }
        
        viewControllers.append(profileViewController)
        viewControllers.append(mentionsViewController)
        viewControllers.append(timelineViewController)
        
        showTweetsView(user: User.currentUser)
    }
    
    func showTweetsView(user: User?) {
        hamburgerViewController.contentViewController = timelineViewController
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
            showTweetsView(user: User.currentUser)
        } else if indexPath.row == 1 {
            // Mentions
            showMentionsView(user: User.currentUser)
        } else if indexPath.row == 2 {
            // Profile
            navigateToProfileView(user: User.currentUser)
        }
    }
}

extension MenuViewController: MenuViewNavigator {
    
    func navigateToProfileView(user: User?) {
        if let pvc = profileViewController.childViewControllers[0] as? ProfileViewController {
            pvc.user = user
            pvc.title = user?.name!
            
            styleNavigationBar(viewController: pvc)
            
            hamburgerViewController.contentViewController = profileViewController
            pvc.refreshView()
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

