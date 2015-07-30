//
//  ShareViewController.swift
//  Imgvue Upload
//
//  Created by PerryChen on 7/30/15.
//  Copyright (c) 2015 Ray Wenderlich LLC. All rights reserved.
//

import UIKit
import Social
import ImgvueKit
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    var imageToShare: UIImage?
    
    override func viewDidLoad() {
        // 1 
        // Capture the inputItems from extensionContext into the items local constant, and create a local variable for itemProvider. An NSItemProvider is a class that represents an arbitrary object that will be shared, in this case the image to be shared
        let items = extensionContext?.inputItems
        var itemProvider: NSItemProvider?
        
        // 2
        if items != nil && items!.isEmpty == false {
            let item = items![0] as! NSExtensionItem
            if let attachments = item.attachments {
                if !attachments.isEmpty {
                    // 3
                    itemProvider = attachments[0] as? NSItemProvider
                }
            }
        }
        
        // 4
        //  kUTTypeImage is a system-defined string constant for core uniform type identifiers. These types are defined in the MobileCoreServices framework you imported earlier. When working with extensions, these string constants are used to identify the attachment types.
        let imageType = kUTTypeImage as NSString as String
        if itemProvider?.hasItemConformingToTypeIdentifier(imageType) == true {
            // 5
            itemProvider?.loadItemForTypeIdentifier(imageType, options: nil) {
                item, error in
                if error == nil {
                    // 6
                    let url = item as! NSURL
                    if let imageData = NSData(contentsOfURL: url) {
                        self.imageToShare = UIImage(data: imageData)
                    }
                } else {
                    // 7
                    let title = "Unable to load image"
                    let message = "Please try again or choose a different image."
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                    
                    let action = UIAlertAction(title: "Bummer", style: .Cancel, handler: { _ -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func shareImage() {
        // 1
        
        let defaultSession = ImgurService.sharedService.session
        let defaultConfig = defaultSession.configuration
        let defaultHeaders = defaultConfig.HTTPAdditionalHeaders
        
        // 2
        // background session
        let sessionId = "com.raywenderlich.imgvue.backgroundsession"
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(sessionId)
        
        config.sharedContainerIdentifier = "group.com.aodshop.swift.imgvue"
        config.HTTPAdditionalHeaders = defaultHeaders
        
        // 3
        let backgroundSession = NSURLSession(configuration: config, delegate: ImgurService.sharedService, delegateQueue: NSOperationQueue.mainQueue())
        
        // 4
        let completion: (ImgurImage?, NSError?) -> () = {
            image, error in
            if error == nil {
                if let imageLink = image?.link {
                    UIPasteboard.generalPasteboard().URL = imageLink
                    NSLog("Image shared: %@", imageLink.absoluteString!)
                }
            } else {
                NSLog("Error sharing image: %@", error!)
            }
        }
        
        // 5
        let progressCallback: (Float) -> () = {
            progress in
            println("Upload progress for extension: \(progress)")
        }
        
        // 6
        let title = contentText
        
        ImgurService.sharedService.uploadImage(imageToShare!, title: title, session: backgroundSession, completion: completion, progressCallback: progressCallback)
        
        // 7
        self.extensionContext?.completeRequestReturningItems([], completionHandler: nil)
        
    }
    
    // inspect the extensionContext property to validate any attachments and the value of contentText.
    // if content  is valid return true
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        if imageToShare == nil {
            return false
        }
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        shareImage()
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        let configItem = SLComposeSheetConfigurationItem()
        configItem.title = "URL will be copied to clipboard"
        return [configItem]
    }

}
