//
//  Test.swift
//  SMSU News
//
//  Created by Budhathoki,Bipin on 9/28/15.
//  Copyright © 2015 Bipin Budhathoki. All rights reserved.
//

extension Dictionary {
    subscript(i:Int) -> (key:Key,value:Value) {
        get {
            return self[startIndex.advancedBy(i)]
        }
    }
}
