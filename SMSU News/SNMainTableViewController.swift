//
//  SNMainTableViewController.Swift
//  SMSU News
//
//  Created by Budhathoki,Bipin on 9/24/15.
//  Copyright © 2015 Bipin Budhathoki. All rights reserved.
//

import UIKit
import MBProgressHUD
import MWFeedParser
import Social

class SNMainTableViewController: UITableViewController, SNFeedRetrieverDelegate, MWFeedParserDelegate {
    
    private var hud : MBProgressHUD?
    
    static let CELL_IDENTIFIER = "SNMainTableViewCell"
    
    var feeds: [SNFeed]?
    var newsDict = Dictionary<String, [MWFeedItem]>()
    
    var sectionTitles : [String] = [String]()
    var currentCount = 0
    let newsRetriever = NewsRetriever()
    let feedsRetriever = SNFeedRetriever()
    
    var sportsHeaders :[(title:String, parameter:String)] = [
        ("Baseball","baseball"), ("Football", "football"),
        ("General", "gen"),("Men's Basketball", "mbball"),
        ("Mustang Booster Club","mbc"),("Softball","softball"),
        ("Vollyball", "vball"), ("Wheelchair Basketball", "wheelbball"),
        ("Women's Basketall", "wbball"),("Women's Golf", "wgolf"),
        ("Women's Soccer","wsoc"),("Women's Tennis","wten"),
        ("Wrestling","wrestling")
    ];
    
    var sportssectionTitles:[String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud?.labelText = "Loading News"
        //hud?.dimBackground = true;
        
        
        self.feedsRetriever.delegate = self
        self.feedsRetriever.loadSNFeeds();
        
        //add refresh controller
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.brownColor()
        self.refreshControl?.addTarget(self, action: "reloadData", forControlEvents: .ValueChanged)
        self.tableView.alwaysBounceVertical = true;
    }
    
    func reloadData() {
        if(self.refreshControl!.enabled) {
            self.newsDict = Dictionary<String, [MWFeedItem]>()
            self.sectionTitles = [String]()
            self.feeds = [SNFeed]()
            self.currentCount = 0
            self.feedsRetriever.loadSNFeeds();
            
            self.refreshControl?.enabled = false;
            
            self.tableView.reloadData()
        }
        
        self.refreshControl?.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: SNFeedRetrieverDelegate methods
    func didLoadSNFeed(feeds: [SNFeed]) {
        self.feeds = feeds;
        //seup for first section titles
        for feed:SNFeed in feeds {
            self.sectionTitles.append(feed.name)
        }
        
        //setup the sports feed
        let URL = self.feeds?.last.url
        if (URL != nil){
            for sports:(title:String, parameter:String) in self.sportsHeaders {
                let feed = SNFeed(name:sports.title, url: "\(URL!)?path=\(sports.parameter)")
                self.feeds?.append(feed)
            }
        }
        
        if self.feeds?.count > 0 {
            newsRetriever.delegate = self
            newsRetriever.loadNews([self.feeds![self.currentCount++]])
        }
        else {
            print("Empty Feeds")
            self.didFailLoadingSNFeed(nil)
        }
    }
    
    func didFailLoadingSNFeed(error: NSError!) {
        print("Failed Loading Feeds \(error?.description)")
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {(action:UIAlertAction!) -> Void in
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Retry", style: .Default, handler:{(action:UIAlertAction!) -> Void in
         self.viewDidLoad()
        }))
        
        presentViewController(alert, animated: true, completion: nil)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    // MARK: MWFeedParserDelegate methods
    
    func feedParserDidStart(parser: MWFeedParser) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        print("Downloading Feed")
    }
    
    func feedParserDidFinish(parser: MWFeedParser) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        print("Finish Downloading Feed")
        
        if(self.feeds?.count > self.currentCount) {
            newsRetriever.loadNews([self.feeds![self.currentCount++]])
        }
        
        //enable refresh control is all news are loaded
        if(self.newsDict.count == self.currentCount){
            self.refreshControl?.enabled = true;
        }
        
        dispatch_async(dispatch_get_main_queue(),{
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        let currentFeed = self.feeds![self.currentCount-1]
        self.newsDict[currentFeed.name] = [MWFeedItem]();
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        var key : String
        if(self.currentCount-1 < self.sectionTitles.count) {
            key = self.sectionTitles[self.currentCount-1]
        }
        else {
            key = self.sportsHeaders[self.currentCount-1-self.sectionTitles.count].title
        }
        self.newsDict[key]!.append(item);
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(self.newsDict.count == 0) {
            return 0
        }
        return 2;
    }
    
    func totalCountFor(sectionArray:[String]) -> Int{
        var count = 0
        for key: String in sectionArray {
            if(self.newsDict[key] != nil){
                count += self.newsDict[key]!.count
            }
        }
        
        return count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.newsDict.count == 0) {
            return 0
        }
        return section == 0 ? self.sectionTitles.count : self.sportsHeaders.count
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell : UITableViewCell!  = tableView.dequeueReusableCellWithIdentifier(SNMainTableViewController.CELL_IDENTIFIER)
            
            var key:String
            if(indexPath.section == 0){
                key = self.sectionTitles[indexPath.row]
            }
            else{
                key = self.sportsHeaders[indexPath.row].title
            }
            
            cell.textLabel?.text = key
            
            var newsCount = 0
            if(self.newsDict[key] != nil) {
                newsCount = self.newsDict[key]!.count
            }
            cell.detailTextLabel?.text = "(\(newsCount))"
            
            if(newsCount > 0){
                cell.userInteractionEnabled = true
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else {
                cell.userInteractionEnabled = false
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            
            return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "SMSU"
        }
        else {
            return "All Sports"
        }
    }
    
    override func tableView(tableView: UITableView,
        canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            return false;
    }
    
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let storyBoard = UIStoryboard(name: "SMSUNews", bundle: nil)
            let controller = storyBoard.instantiateViewControllerWithIdentifier(SNNewsListTableViewController.STORYBOARD_IDENTIFIER) as! SNNewsListTableViewController
            
            var key : String
            if indexPath.section == 0 {
                key = self.sectionTitles[indexPath.row]
                
            } else {
              key = self.sportsHeaders[indexPath.row].title
            }
            
            controller.newsTitle = key
            controller.newsList = self.newsDict[key]!
            
            self.navigationController?.pushViewController(controller, animated: true)
            
    }

    // MARK: Orientation Change
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
}

