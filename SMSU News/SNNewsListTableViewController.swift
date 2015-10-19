//
//  ViewController.swift
//  SMSU News
//
//  Created by Budhathoki,Bipin on 9/24/15.
//  Copyright © 2015 Bipin Budhathoki. All rights reserved.
//

import UIKit
import MWFeedParser

class SNNewsListTableViewController: UITableViewController {
    
    static let STORYBOARD_IDENTIFIER = "SNTableViewController"
    
    var newsList:[MWFeedItem] = [MWFeedItem]()
    var newsTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.newsTitle
        
        let cellNib = UINib.init(nibName: SNTableViewCell.CELL_IDENTIFIER, bundle:nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: SNTableViewCell.CELL_IDENTIFIER)
    
        //setup tableview
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 91.0
        tableView.allowsMultipleSelectionDuringEditing = false;
        
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : SNTableViewCell = tableView.dequeueReusableCellWithIdentifier(SNTableViewCell.CELL_IDENTIFIER) as! SNTableViewCell
        
        cell .configureCellWithItem(self.newsList[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView,
        canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            return true;
    }
    
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
    }
    
    override func tableView(tableView: UITableView,
        editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
            let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Share", handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                let item = self.newsList[indexPath.row]
                let activity = UIActivityViewController(activityItems: ["Shared using SMSU News iOS app",NSURL(string: item.link)!], applicationActivities: nil)
                activity.completionWithItemsHandler = {(activityType, completion, items, error) -> Void in
                    self.endEditing()
                    
                    if(error != nil) {
                        print(error?.description)
                    }
                }
                self.presentViewController(activity, animated: true, completion: nil)
            })
            
            shareAction.backgroundColor = self.view.tintColor
            
            let flagAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Flag", handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                //add the 
                
                self.endEditing()
            })
            
            flagAction.backgroundColor = UIColor.orangeColor()
            
            return [shareAction, flagAction]
    }
    
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        self.endEditing()
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let storyBoard = UIStoryboard(name: "SMSUNews", bundle: nil)
            let controller = storyBoard.instantiateViewControllerWithIdentifier(SNFullNewsViewController.STORYBOARD_IDENTIFIER) as! SNFullNewsViewController
            
            controller.newsItem = newsList[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: Helper Method
    
    func endEditing() {
        tableView.setEditing(false, animated: true)
    }
    
    
    // MARK: Orientation
    
   override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
   
}

