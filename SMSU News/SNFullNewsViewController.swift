//
//  SNFullNewsViewController.swift
//  SMSU News
//
//  Created by Budhathoki,Bipin on 9/30/15.
//  Copyright © 2015 Bipin Budhathoki. All rights reserved.
//

import UIKit

class SNFullNewsViewController: UIViewController, UIWebViewDelegate {

    static let STORYBOARD_IDENTIFIER = "SNFullNewsViewController"
    var newsURL : String?
    var newSummary : String?
    
    @IBOutlet weak var newsWebViewController: UIWebView!
    @IBOutlet weak var newLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: self.newsURL!)

        //self.newsWebViewController.loadRequest(NSURLRequest(URL: url!), cachePolicy: NSURLCacheStoragePolicy.Allowed, timeoutInterval: timeout)
        
        let data = try! NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: url!), returningResponse: nil)
        let string = NSString.init(data: data, encoding: NSUTF8StringEncoding) as! String
        
        //let newString = String(htmlEncodedString: string);
        
        self.newsWebViewController.loadHTMLString(string, baseURL: url)
        self.newsWebViewController.delegate = self
        self.newsWebViewController.scalesPageToFit = true
        self.newsWebViewController.mediaPlaybackRequiresUserAction = true
        self.newsWebViewController.allowsInlineMediaPlayback = true
        //self.newsWebViewController.allowsLinkPreview = true;
    }
    
    //MARK: UIWebViewDelegate Methods
    func webView(webView: UIWebView, shouldStartLoadWithRequest
        request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
            switch(navigationType){
            case .LinkClicked:
                print("linkClicked")
                break
            case .FormResubmitted:
                print("FormResubmitted")
                break
            case .Reload:
                print("Reload")
                break
            case .BackForward:
                 print("BackForward")
                break
            case .Other:
                 print("Other")
                break
            case .FormSubmitted:
                 print("FormSubmitted")
                break
            }
        return true;
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
     func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        webView
    }
    
    func webView(webView: UIWebView,
        didFailLoadWithError error: NSError?) {
            print("Failed to load url: \(self.newsURL)")
    }
}
