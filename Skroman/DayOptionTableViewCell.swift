//
//  DayOptionTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/21/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class DayOptionTableViewCell: UITableViewCell {

	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var imagSelectDeselect: UIImageView!
	@IBOutlet weak var lblDayName: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.contentView.backgroundColor = UICOLOR_MAIN_BG
		self.lblDayName.font = Font_SanFranciscoText_Regular_H15
		self.vwSeprator.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
