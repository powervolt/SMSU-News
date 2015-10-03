//
//  SNDate.swift
//  SMSU News
//
//  Created by Budhathoki,Bipin on 10/2/15.
//  Copyright © 2015 Bipin Budhathoki. All rights reserved.
//

import UIKit

extension NSDate {
    
    /**
     Returns the NSDate in news date format.
     */
    func getNewsDateString() -> String {
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        return dateFormatter.stringFromDate(self)
    }
}
