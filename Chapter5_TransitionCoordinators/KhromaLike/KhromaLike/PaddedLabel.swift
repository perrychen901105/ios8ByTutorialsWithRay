//
//  PaddedLabel.swift
//  KhromaLike
//
//  Created by PerryChen on 7/14/15.
//  Copyright (c) 2015 RayWenderlich. All rights reserved.
//

import UIKit

class PaddedLabel: UILabel {
    // represents the current padding applied to the label.
    var verticalPadding = 0.0
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        if traitCollection.verticalSizeClass == .Compact {
            // No padding when vertically compact
            verticalPadding = 0.0
        } else {
            // Padding when have regular size class
            verticalPadding = 20.0
        }
        // Need to update the layout
        invalidateIntrinsicContentSize()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func intrinsicContentSize() -> CGSize {
        var intrinsicSize = super.intrinsicContentSize()
        // Add the padding
        intrinsicSize.height += CGFloat(verticalPadding)
        return intrinsicSize
    }
    
}
