//
//  NavigationViewController.swift
//  KhromaPal
//
//  Created by PerryChen on 7/2/15.
//  Copyright (c) 2015 RayWenderlich. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController, PaletteDisplayContainer
                                                        , PaletteSelectionContainer{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func rwt_currentlyDisplayedPalette() -> ColorPalette? {
        if let tvc = topViewController as? PaletteDisplayContainer {
            return tvc.rwt_currentlyDisplayedPalette()
        }
        return nil
    }
    
    func rwt_currentlySelectedPalette() -> ColorPalette? {
        if let tvc = topViewController as? PaletteSelectionContainer {
            return tvc.rwt_currentlySelectedPalette()
        }
        return nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
