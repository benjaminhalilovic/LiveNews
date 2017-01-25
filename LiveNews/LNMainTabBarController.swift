//
//  LNMainTabBarController.swift
//  LiveNews
//
//  Created by mac on 19/01/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import UIKit

class LNMainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        
        let tabViewControllers = tabBarController.viewControllers!
        let fromView = tabBarController.selectedViewController!.view
        let toView = viewController.view
        
        if (fromView == toView) {
            return false
        }
        
        let fromIndex = tabViewControllers.indexOf(tabBarController.selectedViewController!)
        let toIndex = tabViewControllers.indexOf(viewController)
        
        let offScreenRight = CGAffineTransformMakeTranslation(toView.frame.width, 0)
        let offScreenLeft = CGAffineTransformMakeTranslation(-toView.frame.width, 0)
        
        // start the toView to the right of the screen
        
        
        if (toIndex < fromIndex) {
            toView.transform = offScreenLeft
            fromView.transform = offScreenRight
        } else {
            toView.transform = offScreenRight
            fromView.transform = offScreenLeft
        }
        
        fromView.tag = 124
        toView.addSubview(fromView)
        
        self.view.userInteractionEnabled = false
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            toView.transform = CGAffineTransformIdentity
            
            }, completion: { finished in
                
                let subViews = toView.subviews
                for subview in subViews{
                    if (subview.tag == 124) {
                        subview.removeFromSuperview()
                    }
                }
                tabBarController.selectedIndex = toIndex!
                self.view.userInteractionEnabled = true
                
        })
        
        return true
    }
    
}
