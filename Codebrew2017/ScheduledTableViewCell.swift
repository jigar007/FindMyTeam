//
//  PickUpTableViewCell.swift
//  Getit
//
//  Created by Federico Malesani on 19/03/2016.
//  Copyright © 2016 UniMelb. All rights reserved.
//

import UIKit

class ScheduledTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailView: CalendarThumbnailView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
