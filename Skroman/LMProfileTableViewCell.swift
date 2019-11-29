//
//  LMProfileTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class LMProfileTableViewCell: UITableViewCell {
	var objUser = User()
	@IBOutlet weak var lblEmail: UILabel!
	@IBOutlet weak var lblUserName: UILabel!
	@IBOutlet weak var imagUser: BaseImageViewWithData!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		initCell()
	}
	func initCell()
	{
		self.contentView.backgroundColor = UICOLOR_ODD_CELL_BG
		lblEmail.font = Font_SanFranciscoText_Regular_H12
		lblUserName.font = Font_SanFranciscoText_Regular_H16
		
		//Temporary
//		imagUser.backgroundColor = UICOLOR_RED
		imagUser.layer.cornerRadius = imagUser.frame.size.width/2
		imagUser.layer.borderWidth = 1.0
		imagUser.layer.borderColor = UICOLOR_WHITE.cgColor
	}
	
	func configureCellWithUser(obj : User)
	{
		self.objUser = obj
		self.lblEmail.text = self.objUser.email
		self.lblUserName.text = self.objUser.name
		
//		self.imagUser.getImageWithURL(URL.init(string: self.objUser.image!), comefrom: .user)
		
		self.imagUser.getImageWithURL(self.objUser.image, comefrom: .user)
		
	}
	
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
