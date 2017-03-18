//
//  MatchTableViewCell.swift
//  Codebrew2017
//
//  Created by Federico Malesani on 18/3/17.
//  Copyright © 2017 University of Melbourne. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
        
        @IBOutlet weak var sportTypeLable: UILabel!
        @IBOutlet weak var timeLabel: UILabel!
        @IBOutlet weak var locationLabel: UILabel!
        @IBOutlet weak var priceLabel: UILabel!
        @IBOutlet weak var organizerImageView: UIImageView!
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
        
}
