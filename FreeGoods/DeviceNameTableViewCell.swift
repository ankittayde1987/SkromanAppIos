//
//  DeviceNameTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class DeviceNameTableViewCell: UITableViewCell {

	@IBOutlet weak var txtDeviceName: UITextField!
	@IBOutlet weak var vwTxtDeviceNameContainer: UIView!
	@IBOutlet weak var lblDeviceNameTitle: UILabel!
	var objHome = Home()
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		initCell()
    }
	func initCell()
	{
		self.contentView.backgroundColor = UICOLOR_MAIN_BG
		self.vwTxtDeviceNameContainer.backgroundColor = UICOLOR_TEXTFIELD_CONTAINER_BG
		self.vwTxtDeviceNameContainer.layer.borderWidth = 1.0
		self.vwTxtDeviceNameContainer.layer.borderColor = UICOLOR_TEXTFIELD_CONTAINER_BORDER.cgColor
		self.lblDeviceNameTitle.font = Font_SanFranciscoText_Regular_H16
		self.lblDeviceNameTitle.text = SSLocalizedString(key: "device_name").uppercased()
		self.txtDeviceName.font = Font_SanFranciscoText_Regular_H15
		self.txtDeviceName.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
	}
	func configureCell(obj : Home)
	{
		self.objHome = obj
		if !Utility.isEmpty(val: self.objHome.deviceName)
		{
			self.txtDeviceName.text = self.objHome.deviceName
		}
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	@objc func textFieldDidChange(_ textField: UITextField) -> Bool {
		self.objHome.deviceName = self.txtDeviceName.text
		return true
	}
    
}
