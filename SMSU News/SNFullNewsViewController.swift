//
//  SNFullNewsViewController.swift
//  SMSU News
//
//  Created by Budhathoki,Bipin on 9/30/15.
//  Copyright © 2015 Bipin Budhathoki. All rights reserved.
//

import UIKit
import WebKit
import MWFeedParser

class SNFullNewsViewController: UIViewController, WKNavigationDelegate {
    
    static let STORYBOARD_IDENTIFIER = "SNFullNewsViewController"
    static let LOADING_NOTIFICATION = "loading"
    static let PROGRESS_NOTIFICATION = "estimatedProgress"
    
    var newsItem : MWFeedItem?
    
    var newsWebView: WKWebView
    var retryButton: UIBarButtonItem!
    
    var inWebView: Bool = false
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    required init?(coder aDecoder: NSCoder) {
        self.newsWebView = WKWebView()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add retry button
        retryButton = UIBarButtonItem(image: UIImage(named: "Refresh"), style: .Plain, target: self, action: "reloadWebsite")
        navigationItem.rightBarButtonItem = retryButton
        self.retryButton.enabled = false;
        
        self.backButton.enabled = false
        
        //setup segmented control
        let text = UIImage(named: "Word")
        let web = UIImage(named: "Web")
        
        let segmentedControl = UISegmentedControl(items: [text!,web!])
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.contentMode = .ScaleAspectFit
        segmentedControl.addTarget(self, action: "segmentedControlTapped:", forControlEvents: .ValueChanged)
        navigationItem.titleView = segmentedControl

        
        progressView.setProgress(0, animated: false)
        
        newsWebView.addObserver(self, forKeyPath: SNFullNewsViewController.LOADING_NOTIFICATION, options: .New, context: nil)
        newsWebView.addObserver(self, forKeyPath: SNFullNewsViewController.PROGRESS_NOTIFICATION, options: .New, context: nil)
        
        self.newsWebView.navigationDelegate = self
        newsWebView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(newsWebView, belowSubview: progressView)
        
        let height = NSLayoutConstraint(item: newsWebView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        
        let width = NSLayoutConstraint(item: newsWebView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        
        view.addConstraints([height, width])
        
        loadHTMLSummary()
    }
    
    func reloadWebsite(){
        self.newsWebView.reload()
    }
    
    func segmentedControlTapped(control: UISegmentedControl) {
        if (control.selectedSegmentIndex == 0){
           loadHTMLSummary()
        } else {
            loadWebPage()
        }
    }
    
    func loadHTMLSummary() {
        let newsDate = newsItem?.date.getNewsDateString()
        var fontSize : Int
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad){
            fontSize = 20;
        } else {
            fontSize = 45;
        }
        
        newsWebView.loadHTMLString(
            "</br><b><font size=\"\(fontSize)\">\(newsItem!.title)</b></font><font size=\"\(fontSize-15)\"> - \(newsDate!)</br>\(newsItem!.summary)</br></font>",
            baseURL: nil
        )
        retryButton.enabled = false
        
        inWebView = false
    }
    
    func loadWebPage() {
        let url = NSURL(string: newsItem!.link)
         newsWebView.loadRequest(NSURLRequest(URL: url!))
         inWebView = true
        
       
    }
    
    @IBAction func back(sender: AnyObject) {
        newsWebView.goBack()
    }
    
    @IBAction func share(sender: AnyObject) {
        let activity = UIActivityViewController(activityItems: ["Shared using SMSU News iOS app",NSURL(string: newsItem!.link)!], applicationActivities: nil)
        activity.completionWithItemsHandler = {(activityType, completion, items, error) -> Void in
            if(error != nil) {
                print(error?.description)
            }
        }
        self.presentViewController(activity, animated: true, completion: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == SNFullNewsViewController.LOADING_NOTIFICATION) {
            backButton.enabled = newsWebView.canGoBack
            self.retryButton.enabled = false;
        }
        if (keyPath == SNFullNewsViewController.PROGRESS_NOTIFICATION) {
            progressView.hidden = newsWebView.estimatedProgress == 1
            progressView.setProgress(Float(newsWebView.estimatedProgress), animated: true)
        }
    }
    
    
    //MARK: WKNavigationDelegate
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        self.retryButton.enabled = inWebView;
         UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
         UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
    }
    
    func webView(webView: WKWebView,
        didFailNavigation navigation: WKNavigation!,withError error: NSError) {
            print("Failed to load url: \(newsItem?.link)")
             UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
            if(inWebView) {
                self.retryButton.enabled = true;
                
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
    }

    deinit{
       
            newsWebView.removeObserver(self, forKeyPath: SNFullNewsViewController.PROGRESS_NOTIFICATION)
            newsWebView.removeObserver(self, forKeyPath: SNFullNewsViewController.LOADING_NOTIFICATION)
      
    }
}
