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
    
    override func adaptivePresentationStyleForTraitCollection(traitCollection: UITraitCollection!) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.OverFullScreen
    }

    override func frameOfPresentedViewInContainerView() -> CGRect {
        return containerView.bounds
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView.bounds
        presentedView().frame = containerView.bounds
    }
    
}
