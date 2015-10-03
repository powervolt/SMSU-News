//
//  SNFeedRetriever.swift
//  SMSU News
//
//  Created by Budhathoki,Bipin on 9/25/15.
//  Copyright © 2015 Bipin Budhathoki. All rights reserved.
//

import AFNetworking

protocol SNFeedRetrieverDelegate : class {
    func didLoadSNFeed(feeds:[SNFeed])
    func didFailLoadingSNFeed(error: NSError!)
}

class SNFeedRetriever {

    let feedURL : String = "https://raw.githubusercontent.com/powervolt/SMSU-NEWS-RSS/master/feeds.json"
    
    weak var delegate : SNFeedRetrieverDelegate?
    
    func loadSNFeeds() {
         UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer();
        manager.responseSerializer.acceptableContentTypes = Set(["text/plain"])
        manager.GET( self.feedURL,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    let feedArray = SNFeed.parseFeedFromDictionar(jsonResult)
                    self.delegate?.didLoadSNFeed(feedArray)
                }
                else{
                    print("Failed parsing feed response")
                    self.delegate?.didFailLoadingSNFeed(nil)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
                print("Failed loading feeds \(error.description)")
                self.delegate?.didFailLoadingSNFeed(error)
        })
    }
}
