//
//  MenuViewController.swift
//  Twitter
//
//  Created by Mike Tehranian on 11/5/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var greenNavigationController: UIViewController!
    private var blueNavigationController: UIViewController!
    private var pinkNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        greenNavigationController = storyboard.instantiateViewController(withIdentifier: "GreenNavigationController")
        blueNavigationController = storyboard.instantiateViewController(withIdentifier: "BlueNavigationController")
        pinkNavigationController = storyboard.instantiateViewController(withIdentifier: "PinkNavigationController")
        
        viewControllers.append(greenNavigationController)
        viewControllers.append(blueNavigationController)
        viewControllers.append(pinkNavigationController)
        
        // Setting the initial view controller
        hamburgerViewController.contentViewController = greenNavigationController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let titles = ["Green", "Blue", "Pink"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        
        
        
    }

}
