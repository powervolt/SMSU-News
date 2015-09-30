//
//  SNString.swift
//  SMSU News
//
//  Created by Budhathoki,Bipin on 9/29/15.
//  Copyright © 2015 Bipin Budhathoki. All rights reserved.
//

import UIKit

extension String {
    init(htmlEncodedString: String) {
        let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        let attributedString = try! NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
        self.init(attributedString.string)
    }
    
    /**
    Removes whitespace from both ends of a string
    */
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}
