//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Mike Tehranian on 11/5/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    
    var menuViewController: UIViewController! {
        // see 25:00 in video but may need to do same logic for contentView controller lifecycle stuff here too
        // This is only called once though in the app delegate when wiring the view controllers
        didSet {
            // Hack that forces call to viewDidLoad()
            view.layoutIfNeeded()
            menuViewController.willMove(toParentViewController: self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMove(toParentViewController: self)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }

            // Will call willAppear()
            contentViewController.willMove(toParentViewController: self)
            
            // Yanking the contentViewController.view from the controller
            // so bypassing view lifecyle methods
            contentView.addSubview(contentViewController.view)
            
            // MDT add this call below?
            // contentViewController.viewDidLoad()
            
            // Will call didAppear()
            contentViewController.didMove(toParentViewController: self)

            // MDT add this call below?
            // view.layoutIfNeeded() // call viewDidLoad before hitting the next line.
            
            UIView.animate(withDuration: 0.3, animations: {
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizerState.began {
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.changed {
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.ended {
            
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0 {
                    // Opening
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 50
                } else {
                    // Closing
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
            
        }
        
    }
    
}
