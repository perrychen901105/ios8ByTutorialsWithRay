//
//  Author.swift
//  RWPedia_swift
//
//  Created by PerryChen on 8/12/15.
//  Copyright (c) 2015 Cesare Rocchi. All rights reserved.
//

import UIKit

class Author: NSObject, Printable {
    var authorName: String = ""
    var authorURL: String = ""
    override var description: String {
        return "name: \(authorName) URL: \(authorURL)"
    }
    
    init(dictionary: NSDictionary) {
        self.authorName = dictionary["authorName"] as! String
        self.authorURL = dictionary["authorURL"] as! String
        super.init()
    }
}
