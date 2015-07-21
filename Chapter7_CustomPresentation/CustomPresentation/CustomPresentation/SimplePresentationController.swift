//
//  SimplePresentationController.swift
//  CustomPresentation
//
//  Created by PerryChen on 7/21/15.
//  Copyright (c) 2015 Fresh App Factory. All rights reserved.
//

import UIKit

// 1 Declares that the view controller adopts the UIAdaptivePresentationControllerDelegate protocol.
class SimplePresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
   // 2 Creates a UIView property called dimmingView that will be used as the chrome
    var dimmingView: UIView = UIView()
    
    override init(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        // 3
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        dimmingView.alpha = 0.0
    }
    
    override func presentationTransitionWillBegin() {
        // 1
        // The container view is the view where the presentation will take place, and is a property of UIPresentationController.
        dimmingView.frame = self.containerView.bounds
        dimmingView.alpha = 0.0
        containerView.insertSubview(dimmingView, atIndex: 0)
        
        // 2
        let coordinator = presentedViewController.transitionCoordinator()
        if coordinator != nil {
            // 3
            coordinator!.animateAlongsideTransition({ (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha = 1.0
            }, completion: nil)
        } else {
            dimmingView.alpha = 1.0
        }
    }
    
}
