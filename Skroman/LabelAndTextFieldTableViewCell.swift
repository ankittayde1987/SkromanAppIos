//
//  LabelAndTextFieldTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class LabelAndTextFieldTableViewCell: UITableViewCell {

	@IBOutlet weak var txtFieldContainer: UITextField!
	@IBOutlet weak var vwTxtFieldContainer: UIView!
	@IBOutlet weak var lblUsedFor: UILabel!
	
	var objUser = User()
	var isUsedForChangePassword : Bool? = false
	var currentIndexPath : IndexPath!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		lblUsedFor.font = Font_SanFranciscoText_Regular_H16
		txtFieldContainer.font = Font_SanFranciscoText_Regular_H14
		txtFieldContainer.tintColor = UICOLOR_WHITE
		contentView.backgroundColor = UICOLOR_MAIN_BG
		vwTxtFieldContainer.backgroundColor = UICOLOR_CONTAINER_BG
		self.txtFieldContainer.isUserInteractionEnabled = true
		txtFieldContainer.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	func configureCellWithIndexPathForChangePassword(indexPath : IndexPath,obj : User)
	{
		self.objUser = obj
		currentIndexPath = indexPath
		isUsedForChangePassword = true
		txtFieldContainer.keyboardType = .default
		txtFieldContainer.isSecureTextEntry = true
		
		//for placeholder and keyboard
		if self.currentIndexPath.row == 0
		{
			self.lblUsedFor.text = SSLocalizedString(key: "old_passwod").uppercased()
			if !Utility.isEmpty(val: self.objUser.old_password)
			{
				txtFieldContainer.text = self.objUser.old_password
			}
		}
		else if self.currentIndexPath.row == 1
		{
			self.lblUsedFor.text = SSLocalizedString(key: "new_passwod").uppercased()
			if !Utility.isEmpty(val: self.objUser.password)
			{
				txtFieldContainer.text = self.objUser.password
			}
		}
		else if self.currentIndexPath.row == 2
		{
			self.lblUsedFor.text = SSLocalizedString(key: "confirm_passwod").uppercased()
			if !Utility.isEmpty(val: self.objUser.confirm_password)
			{
				txtFieldContainer.text = self.objUser.confirm_password
			}
		}
		
	}
	func configureCellForMyProfileVC(obj: User,indexPath : IndexPath)
	{
		self.objUser = obj
		self.currentIndexPath = indexPath
		self.isUsedForChangePassword = false
		
		
		//for placeholder and keyboard
		if self.currentIndexPath.row == 0
		{
			self.lblUsedFor.text = SSLocalizedString(key: "name").uppercased()
			if !Utility.isEmpty(val: self.objUser.name)
			{
				txtFieldContainer.text = self.objUser.name
			}
		}
		else if self.currentIndexPath.row == 1
		{
			self.txtFieldContainer.isUserInteractionEnabled = false
			self.lblUsedFor.text = SSLocalizedString(key: "email").uppercased()
			if !Utility.isEmpty(val: self.objUser.email)
			{
				txtFieldContainer.text = self.objUser.email
			}
		}
		else if self.currentIndexPath.row == 2
		{
			self.lblUsedFor.text = SSLocalizedString(key: "mobile_number").uppercased()
			if !Utility.isEmpty(val: self.objUser.phoneNumber)
			{
				txtFieldContainer.text = self.objUser.phoneNumber
			}
		}
		
	}
	@objc func textFieldDidChange(_ textField: UITextField) -> Bool
	{
		if isUsedForChangePassword!
		{
			switch currentIndexPath.row {
			case 0:
				objUser.old_password = self.txtFieldContainer.text
				break
			case 1:
				objUser.password = self.txtFieldContainer.text
				break
			case 2:
				objUser.confirm_password = self.txtFieldContainer.text
				break
			default:
				break
			}
		}
		else
		{
			switch currentIndexPath.row {
			case 0:
				objUser.name = self.txtFieldContainer.text
				break
			case 1:
				objUser.email = self.txtFieldContainer.text
				break
			case 2:
				objUser.phoneNumber = self.txtFieldContainer.text
				break
			default:
				break
			}
		}
		
		return true
	}
    
}
