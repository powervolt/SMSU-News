//
//  SNFeed.swift
//  SMSU News
//
//  Created by Budhathoki,Bipin on 9/25/15.
//  Copyright © 2015 Bipin Budhathoki. All rights reserved.
//
class SNFeed {
    var name : String
    var url : String
    
    init(name:String, url: String){
        self.name = name;
        self.url = url;
    }
    
    static func parseFeedFromDictionar(dictionary: Dictionary<String, AnyObject>) ->[SNFeed]{
        let versionKey = "version"
        print("Feed Version \(dictionary[versionKey])")
        var feedArray = [SNFeed]()
        if let feeds  = dictionary["feeds"] as? [Dictionary<String, String>] {
            for feed in feeds {
                let name = feed["name"] as String!
                let url = feed["url"] as String!
                let snFeed = SNFeed(name: name, url: url)
                feedArray.append(snFeed)
            }
        }
        
        return feedArray;
    }
}
