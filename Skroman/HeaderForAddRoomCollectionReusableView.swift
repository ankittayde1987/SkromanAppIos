//
//  HeaderForAddRoomCollectionReusableView.swift
//  Skroman
//
//  Created by ananadmahajan on 9/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class HeaderForAddRoomCollectionReusableView: UICollectionReusableView {

	@IBOutlet weak var lblSelectIcon: UILabel!
	@IBOutlet weak var txtRoomName: UITextField!
	@IBOutlet weak var vwTxtRoomNameContainer: UIView!
	@IBOutlet weak var lblRoomNameTitle: UILabel!
	
	var objRoom = Room()
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		initCellComponents()
    }
	func initCellComponents()
	{
		lblRoomNameTitle.font = Font_SanFranciscoText_Regular_H16
		lblRoomNameTitle.text = SSLocalizedString(key: "room_name").uppercased()
		txtRoomName.tintColor = .white
		txtRoomName.font = Font_SanFranciscoText_Regular_H14
		txtRoomName.attributedPlaceholder = NSAttributedString(string: SSLocalizedString(key: "enter_room_name"),
															   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
		lblSelectIcon.font = Font_SanFranciscoText_Regular_H16
		lblSelectIcon.text = SSLocalizedString(key: "select_icon").uppercased()
		
		vwTxtRoomNameContainer.backgroundColor = UICOLOR_CONTAINER_BG
		txtRoomName.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
		
	}
	func configureCellWith(obj : Room)
	{
		self.objRoom = obj
		if !Utility.isEmpty(val: self.objRoom.room_name)
		{
			self.txtRoomName.text = self.objRoom.room_name
		}
	}
	@objc func textFieldDidChange(_ textField: UITextField) -> Bool {
		self.objRoom.room_name = self.txtRoomName.text
		return true
	}
}
