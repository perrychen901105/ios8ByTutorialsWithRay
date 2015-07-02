//
//  PaletteContainer.swift
//  KhromaPal
//
//  Created by PerryChen on 7/2/15.
//  Copyright (c) 2015 RayWenderlich. All rights reserved.
//

import Foundation

@objc protocol PaletteDisplayContainer {
    // returns either the current palette or nil
    func rwt_currentlyDisplayedPalette() -> ColorPalette?
    
}

@objc protocol PaletteSelectionContainer {
    // determine whether or not a palette is selected
    func rwt_currentlySelectedPalette() -> ColorPalette?
}