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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithItem(item: MWFeedItem) {
        self.titleLabel.text = String(htmlEncodedString: item.title).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        self.dateLabel.text = item.date.getNewsDateString()
        
        //remove html from string
        let noHTMLString = item.summary.stringByReplacingOccurrencesOfString("<[^>]+>",
            withString: "", options: .RegularExpressionSearch, range: nil)
        
        //convert Ampersnad character codes to real character
        self.summaryLabel.text = String(htmlEncodedString:noHTMLString)
    }
}
