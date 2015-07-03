//
//  NoPaletteSelectedViewController.swift
//  KhromaPal
//
//  Created by PerryChen on 7/3/15.
//  Copyright (c) 2015 RayWenderlich. All rights reserved.
//

import UIKit

class NoPaletteSelectedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let svc = splitViewController {
            navigationItem.setLeftBarButtonItem(svc.displayModeButtonItem(), animated: true)
        }
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
