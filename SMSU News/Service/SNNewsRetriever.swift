//
//  NewsRetriever.swift
//  SMSU News
//
//  Created by Budhathoki,Bipin on 9/25/15.
//  Copyright © 2015 Bipin Budhathoki. All rights reserved.
//

import UIKit
import MWFeedParser

class NewsRetriever :NSObject {
    
    weak var delegate : MWFeedParserDelegate?
    
    func loadNews(feeds:[SNFeed]) {
        
        for feed : SNFeed in feeds {
            let url : NSURL = NSURL(string:feed.url ) as NSURL!
            let feedParser = MWFeedParser(feedURL: url);
            feedParser.delegate = delegate
            feedParser.feedParseType = ParseTypeFull
            feedParser.connectionType = ConnectionTypeAsynchronously
            feedParser.parse()
        }
        
    }
}
