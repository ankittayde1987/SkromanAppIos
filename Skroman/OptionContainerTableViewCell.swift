//
//  OptionContainerTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/24/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class OptionContainerTableViewCell: UITableViewCell {

	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var lblOptionTitle: UILabel!
	@IBOutlet weak var btnOptionSelectDeselect: UIButton!
	var objRoom = Room()
	var objHome = Home()
	var objSwitchBox = SwitchBox()
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.contentView.backgroundColor = UICOLOR_MAIN_BG
		self.lblOptionTitle.font = Font_SanFranciscoText_Regular_H16
		self.vwSeprator.backgroundColor = UICOLOR_TEXTFIELD_CONTAINER_BORDER
    }
	func configureCellWithRoom(obj : Room)
	{
		self.objRoom = obj
		self.lblOptionTitle.text = self.objRoom.room_name
	}
	func configureCellWithSwitchBox(obj : SwitchBox)
	{
		self.objSwitchBox = obj
		self.lblOptionTitle.text = self.objSwitchBox.name
	}
	func configureCellWithHome(obj : Home)
	{
		self.objHome = obj
		self.lblOptionTitle.text = self.objHome.home_name
	}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
