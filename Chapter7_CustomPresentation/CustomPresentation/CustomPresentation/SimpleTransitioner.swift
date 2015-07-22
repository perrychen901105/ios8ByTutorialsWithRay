//
//  SimpleTransitioner.swift
//  CustomPresentation
//
//  Created by PerryChen on 7/22/15.
//  Copyright (c) 2015 Fresh App Factory. All rights reserved.
//

import UIKit

class SimpleAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresentation: Bool = false    // determine if the presentation animation is presenting
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromView = fromViewController!.view
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toViewController!.view
    
        var containerView: UIView = transitionContext.containerView()
        if isPresentation {
            containerView.addSubview(toView)
        }
    
        // 1
        // Determine which view controller to animate based on the value of isPresentation
        var animationViewController = isPresentation ? toViewController : fromViewController
        var animatingView = animationViewController!.view
        // 2
        // appearedFrame and dismissedFrame are the start and end positions of the view, respectively. If the content is being presented then slide the view up; otherwise, slide it down.
        var appearedFrame = transitionContext.finalFrameForViewController(animationViewController!)
        var dismissdFrame = appearedFrame
        dismissdFrame.origin.y += dismissdFrame.size.height
        // 3
        // Set up initialFrame and finalFrame based on the current value of isPresentation. These are the frames that will be used by the animation.
        let initialFrame = isPresentation ? dismissdFrame : appearedFrame
        let finalFrame = isPresentation ? appearedFrame : dismissdFrame
        animatingView.frame = initialFrame
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 300.0, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            animatingView.frame = finalFrame
            }) { (value: Bool) -> Void in
                if !self.isPresentation {
                    fromView.removeFromSuperview()
                }
                transitionContext.completeTransition(true)
        }
    }
}

class SimpleTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        // manages the presentation process when presenting a view controller
        let presentationController = SimplePresentationController(presentedViewController: presented, presentingViewController: presenting)
        return presentationController
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var animationController = SimpleAnimatedTransitioning()
        animationController.isPresentation = true
        return animationController
    }
    
    
}

