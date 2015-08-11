//
//  ViewController.swift
//  EyeBrowser
//
//  Created by PerryChen on 8/11/15.
//  Copyright (c) 2015 PerryChen. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    @IBOutlet weak var barBackgroundView: UIView!
    @IBOutlet weak var inputURLField: UITextField!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var stopReloadButton: UIBarButtonItem!
    
    
    var webView: WKWebView
    
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func goForward(sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func stopReload(sender: UIBarButtonItem) {
        if webView.loading {
            webView.stopLoading()
        } else {
            let request = NSURLRequest(URL: webView.URL!)
            webView.loadRequest(request)
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
        self.webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        barBackgroundView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
        
        view.insertSubview(webView, belowSubview: progressView)
        // disable auto-generated constraints so can create my own
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let widthConstraint = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraint)
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -44)
        view.addConstraint(heightConstraint);
        
        inputURLField.text = "http://raywenderlich.com"
        let URL = NSURL(string: inputURLField.text)
        let request = NSURLRequest(URL: URL!)
        
        // adding the class as an observer of the loading and estimatedProgress properties
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        progressView.setProgress(0.0, animated: false)
        
        webView.loadRequest(request)
        
        backButton.image = UIImage(named: "icon_back")
        forwardButton.image = UIImage(named: "icon_forward")
        stopReloadButton.image = UIImage(named: "icon_stop")
        backButton.enabled = false
        forwardButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        barBackgroundView.frame = CGRect(x: 0, y: 0, width: size.width, height: 30)
    }

    func cancel() {
        inputURLField.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        barBackgroundView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        inputURLField.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        barBackgroundView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
        webView.loadRequest(NSURLRequest(URL: NSURL(string: inputURLField.text)!))
        return false
    }
    
    // MARK - webview methods
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        println("Request \(navigationAction.request)")
        // the action is initiated by a tap and is not raywenderlich.com
        if ((navigationAction.navigationType == .LinkActivated) && (!navigationAction.request.URL?.host?.lowercaseString.hasPrefix("www.raywenderlich.com"))) {
//            if (navigationAction.navigationType == .LinkActivated && !navigationAction.request.URL?.host?.lowercaseString.hasPrefix("www.raywenderlich.com")) {
            UIApplication.sharedApplication().openURL(navigationAction.request.URL!)
            decisionHandler(.Cancel)
        } else {
            decisionHandler(.Allow)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "loading" {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = webView.loading
            if webView.loading == false {
                inputURLField.text = webView.URL!.absoluteString
            }
            backButton.enabled = webView.canGoBack
            forwardButton.enabled = webView.canGoForward
            stopReloadButton.image = webView.loading ? UIImage(named: "icon_stop") : UIImage(named: "icon_refresh")
        } else if keyPath == "estimatedProgress" {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
}


