//
//  LeftMenuOptionsTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class LeftMenuOptionsTableViewCell: UITableViewCell {

	@IBOutlet weak var lblOption: UILabel!
	@IBOutlet weak var imagUsedFor: UIImageView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		lblOption.font = Font_SanFranciscoText_Regular_H16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	func configureCell(iconImage: UIImage, title: String)
	{
		self.imagUsedFor.image = iconImage
		self.lblOption.text = title
	}
    
}
