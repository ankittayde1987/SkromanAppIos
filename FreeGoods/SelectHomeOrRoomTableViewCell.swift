//
//  SelectHomeOrRoomTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

protocol SelectHomeOrRoomTableViewCellDelegate {
	func tappedOnSelectHome(obj : Home)
	func tappedOnSelectRoom(obj : Home)
}

class SelectHomeOrRoomTableViewCell: UITableViewCell {
	var delegate : SelectHomeOrRoomTableViewCellDelegate?
	@IBOutlet weak var btnHomeOrRoomName: UIButton!
	@IBOutlet weak var imagDownArrow: UIImageView!
	@IBOutlet weak var vwButtonContainer: UIView!
	@IBOutlet weak var lblSelectHomeOrRoomTitle: UILabel!
	
	var currentIndexPath : IndexPath!
	
	var objHome = Home()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		initCell()
    }
	func initCell()
	{
		self.contentView.backgroundColor = UICOLOR_MAIN_BG
		self.vwButtonContainer.backgroundColor = UICOLOR_TEXTFIELD_CONTAINER_BG
		self.vwButtonContainer.layer.borderWidth = 1.0
		self.vwButtonContainer.layer.borderColor = UICOLOR_TEXTFIELD_CONTAINER_BORDER.cgColor
		self.lblSelectHomeOrRoomTitle.font = Font_SanFranciscoText_Regular_H16
		self.btnHomeOrRoomName.titleLabel?.font = Font_SanFranciscoText_Regular_H14
	}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	func configureSelectHomeOrRoomTableViewCell(indexPath : IndexPath, obj:Home)
	{
		self.currentIndexPath = indexPath
		self.objHome = obj
		if self.currentIndexPath.row == 0
		{
			self.lblSelectHomeOrRoomTitle.text = SSLocalizedString(key: "select_home").uppercased()
			//Select Home
			if Utility.isEmpty(val: self.objHome.home_name)
			{
				self.btnHomeOrRoomName.setTitle("", for: .normal)
				self.btnHomeOrRoomName.setTitle("", for: .selected)
			}
			else
			{
				self.btnHomeOrRoomName.setTitle(self.objHome.home_name, for: .normal)
				self.btnHomeOrRoomName.setTitle(self.objHome.home_name, for: .selected)
			}
		}
		else
		{
			self.lblSelectHomeOrRoomTitle.text = SSLocalizedString(key: "select_room").uppercased()
			//Select Room
			if Utility.isEmpty(val: self.objHome.roomToAdd?.room_name)
			{
				self.btnHomeOrRoomName.setTitle("", for: .normal)
				self.btnHomeOrRoomName.setTitle("", for: .selected)
			}
			else
			{
				self.btnHomeOrRoomName.setTitle(self.objHome.roomToAdd?.room_name, for: .normal)
				self.btnHomeOrRoomName.setTitle(self.objHome.roomToAdd?.room_name, for: .selected)
			}

		}
	}
	//MARK : - IBAction
	@IBAction func tappedOnSelectHomeOrRoom(_ sender: Any) {
		if self.currentIndexPath.row == 0
		{
			//Select Home
			SSLog(message: "tappedOnSelectHome")
			self.delegate?.tappedOnSelectHome(obj: self.objHome)
		}
		else
		{
			//Select Room
			SSLog(message: "tappedOnSelectRoom")
			self.delegate?.tappedOnSelectRoom(obj: self.objHome)
		}
	}
}
