//
//  TraitOverrideViewController.swift
//  KhromaPal
//
//  Created by chenzhipeng on 7/1/15.
//  Copyright (c) 2015 RayWenderlich. All rights reserved.
//

import UIKit

class TraitOverrideViewController: UIViewController {

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        var traitOverride: UITraitCollection? = nil
        if size.width > 414 {
            traitOverride = UITraitCollection(horizontalSizeClass: .Regular)
        }
        setOverrideTraitCollection(traitOverride, forChildViewController: childViewControllers[0] as! UIViewController)
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
