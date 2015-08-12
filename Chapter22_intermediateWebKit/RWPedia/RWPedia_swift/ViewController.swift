/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/


import UIKit
import WebKit

let AuthorSelected = "authorSelected"
let MessageHandler = "didFetchAuthors"

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
  
  var webView: WKWebView
    var authorsWebView: WKWebView?
    
    var authors: [Author] = []
    
  @IBOutlet weak var authorsButton: UIBarButtonItem!
  @IBOutlet weak var backButton: UIBarButtonItem!
  @IBOutlet weak var forwardButton: UIBarButtonItem!
  @IBOutlet weak var stopReloadButton: UIBarButtonItem!
  
//  required init(coder aDecoder: NSCoder) {
//    self.webView = WKWebView(frame: CGRectZero)
//    super.init(coder: aDecoder)
//    self.webView.navigationDelegate = self
//  }

    required init(coder aDecoder: NSCoder) {
        // 1
        // Create an instance of WKWebViewConfiguration
        let configuration = WKWebViewConfiguration()
        // 2
        // load the javaScript from a file into an instance of NSString
        let hideBioScriptURL = NSBundle.mainBundle().pathForResource("hideBio", ofType: "js")
        let hideBioJS = String(contentsOfFile: hideBioScriptURL!, encoding: NSUTF8StringEncoding, error: nil)
        // 3
        // Wrap the java script in an instance of WKUserScript
        let hideBioScript = WKUserScript(source: hideBioJS!, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
        // 4
        // Add the user script to the configurations userContentController
        configuration.userContentController.addUserScript(hideBioScript)
        // 5
        self.webView = WKWebView(frame: CGRectZero, configuration: configuration)
        super.init(coder: aDecoder)
        self.webView.navigationDelegate = self
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    authorsButton.enabled = false
    backButton.enabled = false
    forwardButton.enabled = false;
    view.addSubview(webView)
    webView.setTranslatesAutoresizingMaskIntoConstraints(false)
    let widthConstraint = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
    view.addConstraint(widthConstraint)
    let heightConstraint = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -44)
    view.addConstraint(heightConstraint)
    webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
    webView.addObserver(self, forKeyPath: "title", options: .New, context: nil)
    let URL = NSURL(string:"http://www.raywenderlich.com")
    let request = NSURLRequest(URL:URL!)
    webView.loadRequest(request)
    
    // 1
    let authorsWebViewConfiguration = WKWebViewConfiguration()
    // 2
    let scriptURL = NSBundle.mainBundle().pathForResource("fetchAuthors", ofType: "js")
    let jsScript = String(contentsOfFile: scriptURL!, encoding: NSUTF8StringEncoding, error: nil)
    // 3
    let fetchAuthorsScript = WKUserScript(source: jsScript!, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
    // 4
    authorsWebViewConfiguration.userContentController.addUserScript(fetchAuthorsScript)
    // 5
    // sets the view controller as the handler for any messages dispatched from authorsWebView
    authorsWebViewConfiguration.userContentController.addScriptMessageHandler(self, name: MessageHandler)
    // 6
    authorsWebView = WKWebView(frame: CGRectZero, configuration: authorsWebViewConfiguration)
    // 7
    let authorsURL = NSURL(string: "http://www.raywenderlich.com/about")
    let authorsRequest = NSURLRequest(URL: authorsURL!)
    authorsWebView!.loadRequest(authorsRequest)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "authorSelected:", name: AuthorSelected, object: nil)
  }
  
    func authorSelected(notification: NSNotification) {
        webView.loadRequest(NSURLRequest())
        let author = notification.object as? Author
        let title = author?.authorName
        let stringURL = author?.authorURL
        let URL = NSURL(string: stringURL!)
        let request = NSURLRequest(URL: URL!)
        webView.loadRequest(request)
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if (message.name == MessageHandler) {
            if let resultArray = message.body as? [Dictionary<String, String>] {
                for d in resultArray {
                    let author = Author(dictionary: d)
                    authors.append(author)
                }
                println("author = \(authors.debugDescription)")
                authorsButton.enabled = true
            }
        }
        
    }
    
  override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
    if (keyPath == "loading") {
      forwardButton.enabled = webView.canGoForward
      backButton.enabled = webView.canGoBack
      stopReloadButton.image = webView.loading ? UIImage(named: "icon_stop") : UIImage(named: "icon_refresh")
      UIApplication.sharedApplication().networkActivityIndicatorVisible = webView.loading
    } else if (keyPath == "title") {
      if (webView.URL!.absoluteString?.hasPrefix("http://www.raywenderlich.com/u") != nil) {
        title = webView.title!.stringByReplacingOccurrencesOfString("Ray Wenderlich | ", withString: "")
      }
    }
  }
  
  func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation, withError error: NSError) {
    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {
    if (navigationAction.navigationType == .LinkActivated && navigationAction.request.URL?.host?.lowercaseString.hasPrefix("www.raywenderlich.com") == nil) {
      UIApplication.sharedApplication().openURL(navigationAction.request.URL!);
      decisionHandler(.Cancel)
    } else {
      decisionHandler(.Allow)
    }
  }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAuthors" {
            let navController = segue.destinationViewController as! UINavigationController
            let authorsViewController = navController.topViewController as! AuthorsTableViewController
            authorsViewController.authors = authors
        }
    }
    
    
  @IBAction func authorsButtonTapped(sender: UIBarButtonItem) {
    println("Authors tapped")
  }
  
  @IBAction func goBack(sender: UIBarButtonItem) {
    webView.goBack()
  }
  
  
  @IBAction func goForward(sender: UIBarButtonItem) {
    webView.goForward()
  }
  
  @IBAction func stopReload(sender: UIBarButtonItem) {
    if (webView.loading) {
      webView.stopLoading()
    } else {
      let request = NSURLRequest(URL:webView.URL!)
      webView.loadRequest(request)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

