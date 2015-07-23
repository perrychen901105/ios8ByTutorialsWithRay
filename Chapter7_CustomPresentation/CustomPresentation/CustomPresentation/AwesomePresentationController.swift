//
//  AwesomePresentationController.swift
//  CustomPresentation
//
//  Created by PerryChen on 7/22/15.
//  Copyright (c) 2015 Fresh App Factory. All rights reserved.
//

import UIKit

class AwesomePresentationController: UIPresentationController, UIViewControllerTransitioningDelegate {
    var dimmingView: UIView = UIView()
    var flagImageView: UIImageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 160.0, height: 93.0)))
    var selectionObject: SelectionObject?
    var isAnimating = false
    
    override init(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
        dimmingView.backgroundColor = UIColor.clearColor()
        flagImageView.contentMode = UIViewContentMode.ScaleAspectFill
        flagImageView.clipsToBounds = true
        flagImageView.layer.cornerRadius = 4.0
    }

    // configure the flagImageView with the necessary image and position.
    func configureWithSelectionObject(selectionObject: SelectionObject) {
        self.selectionObject = selectionObject
        var image: UIImage = UIImage(named: selectionObject.country.imageName)!
        flagImageView.image = image
        flagImageView.frame = selectionObject.originalCellPosition
    }
    
//    override func adaptivePresentationStyleForTraitCollection(traitCollection: UITraitCollection!) -> UIModalPresentationStyle {
//        return UIModalPresentationStyle.OverFullScreen
//    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.OverFullScreen
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return containerView.bounds
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView.bounds
        presentedView().frame = containerView.bounds
    }
    
    func scaleFlagAndPositionFlag() {
        var flagFrame = flagImageView.frame
        var containerFrame = containerView.frame
        var originYMultiplier: CGFloat = 0.0
        var cellSize = selectionObject!.originalCellPosition.size
        
        if containerFrame.size.width > containerFrame.size.height {
            // Smaller sized flag
            flagFrame.size.width = cellSize.width * 1.5
            flagFrame.size.height = cellSize.height * 1.5
        
            originYMultiplier = 0.25
        } else {
            // Larger sized flag
            flagFrame.size.width = cellSize.width * 1.8
            flagFrame.size.height = cellSize.height * 1.8
            
            originYMultiplier = 0.333
        }
        
        flagFrame.origin.x = (containerFrame.size.width / 2) - (flagFrame.size.width / 2)
        flagFrame.origin.y = (containerFrame.size.height * originYMultiplier) - (flagFrame.size.height / 2)
        
        flagImageView.frame = flagFrame
    }
    
    // uses scaleFlagAndPositionFlag() to adjust the image view if the animation has finished. otherwise back to original position
    func moveFlagToPresentedPosition(presentedPosition: Bool) {
        let containerFrame = containerView.frame
        
        if presentedPosition {
            // Expand flag and center
            scaleFlagAndPositionFlag()
        } else {
            // Move flag back to original position
            var flagFrame = flagImageView.frame
            flagFrame = selectionObject!.originalCellPosition
            flagImageView.frame = flagFrame
        }
    }
    
    func animateFlagToPresentedPosition(presentedPosition: Bool) {
        let coordinator = presentedViewController.transitionCoordinator()
        
        coordinator!.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.moveFlagToPresentedPosition(presentedPosition)
            }, completion: { (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.isAnimating = false
        })
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        // 1
        // assign ture to isAnimating and move flagImageView to its original position
        isAnimating = true
        moveFlagToPresentedPosition(false)
        
        // 2
        // Add flagImageView as a subview of dimmingView, and then add dimmingView as a subview of containerView.
        dimmingView.addSubview(flagImageView)
        containerView.addSubview(dimmingView)
        
//        animateFlagToPresentedPosition(true)
        animateFlagWithBounceToPresentedPosition(true)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        isAnimating = true
//        animateFlagToPresentedPosition(false)
        animateFlagWithBounceToPresentedPosition(false)
    }
    
    func animateFlagWithBounceToPresentedPosition(presentedPosition: Bool) {
        UIView.animateWithDuration(0.7, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.moveFlagToPresentedPosition(presentedPosition)
            }) { (value: Bool) -> Void in
            self.isAnimating = false
        }
    }
    
}
