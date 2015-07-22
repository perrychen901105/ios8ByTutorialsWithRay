//
//  SelectionObject.swift
//  CustomPresentation
//
//  Created by PerryChen on 7/22/15.
//  Copyright (c) 2015 Fresh App Factory. All rights reserved.
//

import UIKit

class SelectionObject: NSObject {
    var originalCellPosition: CGRect
    var country: Country
    var selectedCellIndexPath: NSIndexPath
    
    init(country: Country, selectedCellIndexPath: NSIndexPath, originalCellPosition: CGRect) {
        self.country = country
        self.selectedCellIndexPath = selectedCellIndexPath
        self.originalCellPosition = originalCellPosition
    }
}
