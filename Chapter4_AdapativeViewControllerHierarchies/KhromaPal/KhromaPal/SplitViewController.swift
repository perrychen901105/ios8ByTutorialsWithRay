//
//  SplitViewController.swift
//  KhromaPal
//
//  Created by chenzhipeng on 7/1/15.
//  Copyright (c) 2015 RayWenderlich. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // Do any additional setup after loading the view.
    }
    
    // called when a split view controller is collapsing down into a navigation controller, and governs the behavior of the detail view controller. Returning false enforces UIKit's default behavior, which is to push the detail view controller on top of the navigation stack. Here you're returning true, but not providing any other implementation. This means the detail view controller will be discarded on rotation of an iPhone from landscape to portrait.
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
