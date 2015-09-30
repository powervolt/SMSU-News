//
//  SNTableViewCell.swift
//  SMSU News
//
//  Created by Budhathoki,Bipin on 9/28/15.
//  Copyright © 2015 Bipin Budhathoki. All rights reserved.
//

import UIKit
import MWFeedParser

class SNTableViewCell: UITableViewCell {

    static let CELL_IDENTIFIER = "SNTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var dateFormatter : NSDateFormatter!
    
    override func prepareForReuse() {
        self.titleLabel.text = ""
        self.dateLabel.text = ""
        self.summaryLabel.text = ""
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.text = ""
        self.dateLabel.text = ""
        self.summaryLabel.text = ""
        
        //format date
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithItem(item: MWFeedItem) {
        self.titleLabel.text = String(htmlEncodedString: item.title).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.dateLabel.text = dateFormatter.stringFromDate(item.date)
        //let tempString = String(htmlEncodedString:item.summary).stringByReplacingOccurrencesOfString("\n", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
       // let components = tempString.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).filter { !$0.isEmpty }
        //self.summaryLabel.text = components.joinWithSeparator(" ")
        self.summaryLabel.text = String(htmlEncodedString:item.summary.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil))
        //print(self.summaryLabel.text)
    }
    
    private func removHTMLFromSring(string:String) -> String {
        let regex : NSRegularExpression = try! NSRegularExpression(pattern: "<[^>]+>",options:[NSRegularExpressionOptions.CaseInsensitive])
        let range = NSMakeRange(0, string.characters.count)
        let finalString = regex.stringByReplacingMatchesInString(string, options: NSMatchingOptions.Anchored, range: range, withTemplate: "")
        return finalString
    }
    
    
    
}
