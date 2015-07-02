//
//  UIViewControllerShow.swift
//  KhromaPal
//
//  Created by PerryChen on 7/2/15.
//  Copyright (c) 2015 RayWenderlich. All rights reserved.
//

import Foundation

extension UIViewController {
    
    // use targetViewControllerForAction(_, sender:) to walk the view controller hierarchy and try to find an ancestor which implements the method in question. If it does, then return the result of calling that method on the view controller discovered to implement it.
    
    // otherwise, return false will present view controller
    func rwt_showVCWillResultInPush(sender: AnyObject?) -> Bool {
        if let target = targetViewControllerForAction("rwt_showVCWillResultInPush:", sender: sender) {
            return target.rwt_showVCWillResultInPush(sender)
        } else {
            return false
        }
    }
    
    func rwt_showDetailVCWillResultInPush(sender: AnyObject?) -> Bool {
        if let target = targetViewControllerForAction("rwt_showDetailVCWillResultInPush:", sender: sender) {
            return target.rwt_showDetailVCWillResultInPush(sender)
        } else {
            return false
        }
    }
}


extension UINavigationController {
    override func rwt_showVCWillResultInPush(sender: AnyObject?) -> Bool {
        return true
    }
}


extension UISplitViewController {
    override func rwt_showDetailVCWillResultInPush(sender: AnyObject?) -> Bool {
        if collapsed {
            if let primaryVC = viewControllers.last as? UIViewController {
                return primaryVC.rwt_showVCWillResultInPush(sender)
            }
            return false
        } else {
            return false 
        }
    }
}
