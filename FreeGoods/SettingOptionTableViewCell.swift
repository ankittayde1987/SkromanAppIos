//
//  SettingOptionTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class SettingOptionTableViewCell: UITableViewCell {

	@IBOutlet weak var imagRightIcon: UIImageView!
	@IBOutlet weak var lblOption: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		lblOption.font = Font_SanFranciscoText_Regular_H18
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureSettingOptionTableViewCellForSettingOptions(str:NSString)
    {
        self.lblOption.text = SSLocalizedString(key: str as String)
        
    }
}
