//
//  WebViewController.swift
//  ProconApp
//
//  Created by ito on 2015/08/22.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit

class WebViewController: ViewController, UIWebViewDelegate {
    
    
    @IBOutlet weak var webView: UIWebView!
    
    var URL: NSURL? {
        didSet {
            loadWebViewIfNeeded()
        }
    }
    var currentRequest: NSURLRequest?
    
    func loadWebViewIfNeeded() {
        if currentRequest != nil {
            return
        }
        if let url = self.URL {
            let req = NSMutableURLRequest(URL: url)
            if webView != nil {
                webView.loadRequest(req)
                currentRequest = req
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadWebViewIfNeeded()
    }
    
    var currentURL: NSURL? {
        return NSURL(string: webView.stringByEvaluatingJavaScriptFromString("document.URL") ?? "")
    }
    
    var currentTitle: String {
        return webView.stringByEvaluatingJavaScriptFromString("document.title") ?? ""
    }
    
    @IBAction func actionTapped(sender: AnyObject) {
        if let url = self.currentURL ?? self.URL {
            let activity = UIActivityViewController(activityItems: [currentTitle, url], applicationActivities: nil)
            self.presentViewController(activity, animated: true, completion: nil)
        }
    }
    
    // MARK: Web View
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL {
            if let comp = NSURLComponents(URL: url, resolvingAgainstBaseURL: true) {
                if let query = comp.queryItems as? [NSURLQueryItem] {
                    for e in query {
                        if e.name == "open_in_browser" {
                            // TODO: Test
                            UIApplication.sharedApplication().openURL(url)
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        endContentsLoading()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        startContentsLoading()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        endContentsLoading()
    }
}
