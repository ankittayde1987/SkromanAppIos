//
//  TextFieldContainerTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class TextFieldContainerTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var constantBtnSecureTextWidth: NSLayoutConstraint!
    @IBOutlet weak var btnSecureText: UIButton!
    @IBOutlet weak var vwTxtFieldContainer: UIView!
	@IBOutlet weak var txtFieldUsedFor: UITextField!
	@IBOutlet weak var vwBottomHorizontalSeprator: UIView!
	@IBOutlet weak var vwTopHorizontalSeprator: UIView!
	@IBOutlet weak var vwVerticalRightSeprator: UIView!
	@IBOutlet weak var vwVerticalLeftSeprator: UIView!
	@IBOutlet weak var topSeparatorHeight: NSLayoutConstraint!
	
	var objUser = User()
	var currentIndexPath : IndexPath!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		contentView.backgroundColor = UICOLOR_MAIN_BG
		vwVerticalLeftSeprator.backgroundColor = UICOLOR_SEPRATOR
		vwVerticalRightSeprator.backgroundColor = UICOLOR_SEPRATOR
		vwTopHorizontalSeprator.backgroundColor = UICOLOR_SEPRATOR
		vwBottomHorizontalSeprator.backgroundColor = UICOLOR_SEPRATOR
		vwTxtFieldContainer.backgroundColor = UICOLOR_CONTAINER_BG
		
		txtFieldUsedFor.font = Font_SanFranciscoText_Regular_H16
		txtFieldUsedFor.tintColor = .white
		
		txtFieldUsedFor.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        constantBtnSecureTextWidth.constant = 0
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func configureCellWithIndexPath(indexPath : IndexPath,obj : User)
	{
		self.objUser = obj
		currentIndexPath = indexPath
		
		if self.currentIndexPath.row == 0
		{
			// Show both
			topSeparatorHeight.constant = 1
		} else {
			// Show bottom
			topSeparatorHeight.constant = 0
		}
		
		
		//for placeholder and keyboard
		if self.currentIndexPath.row == 0
		{
			txtFieldUsedFor.keyboardType = .default
			if Utility.isEmpty(val: self.objUser.name)
			{
				txtFieldUsedFor.attributedPlaceholder = NSAttributedString(string: SSLocalizedString(key: "name"),
																		   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
			}
			else
			{
				txtFieldUsedFor.text = self.objUser.name
			}

		}
		else if self.currentIndexPath.row == 1
		{
			txtFieldUsedFor.keyboardType = .emailAddress
			if Utility.isEmpty(val: self.objUser.email)
			{
				txtFieldUsedFor.attributedPlaceholder = NSAttributedString(string: SSLocalizedString(key: "email"),
																		   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
			}
			else
			{
				txtFieldUsedFor.text = self.objUser.email
			}
		
		}
		else if self.currentIndexPath.row == 2
		{
			txtFieldUsedFor.keyboardType = .phonePad
			if Utility.isEmpty(val: self.objUser.phoneNumber)
			{
				txtFieldUsedFor.attributedPlaceholder = NSAttributedString(string: SSLocalizedString(key: "mobile_number"),
																		   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
			}
			else
			{
				txtFieldUsedFor.text = self.objUser.phoneNumber
			}
			
		}
		else if self.currentIndexPath.row == 3
		{
			txtFieldUsedFor.keyboardType = .default
			txtFieldUsedFor.isSecureTextEntry = true
            constantBtnSecureTextWidth.constant = 40
			if Utility.isEmpty(val: self.objUser.password)
			{
				txtFieldUsedFor.attributedPlaceholder = NSAttributedString(string: SSLocalizedString(key: "password"),
																		   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
			}
			else
			{
				txtFieldUsedFor.text = self.objUser.password
			}
		}
		else if self.currentIndexPath.row == 4
		{
            constantBtnSecureTextWidth.constant = 40
			txtFieldUsedFor.keyboardType = .default
			txtFieldUsedFor.isSecureTextEntry = true
			if Utility.isEmpty(val: self.objUser.confirm_password)
			{
				txtFieldUsedFor.attributedPlaceholder = NSAttributedString(string: SSLocalizedString(key: "confirm_password"),
																		   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
			}
			else
			{
				txtFieldUsedFor.text = self.objUser.confirm_password
			}
		}
	}
	
	@objc func textFieldDidChange(_ textField: UITextField) -> Bool
	{
		switch currentIndexPath.row {
		case 0:
			objUser.name = self.txtFieldUsedFor.text
			break
		case 1:
			objUser.email = self.txtFieldUsedFor.text
			break
		case 2:
			objUser.phoneNumber = self.txtFieldUsedFor.text
			break
		case 3:
			objUser.password = self.txtFieldUsedFor.text
			break
		case 4:
			objUser.confirm_password = self.txtFieldUsedFor.text
			break
		default:
			break
		}
		return true
	}
    
    @IBAction func tappedOnBtnSecureText(_ sender: Any) {
        if self.currentIndexPath.row == 3 || self.currentIndexPath.row == 4
        {
            self.btnSecureText.isSelected = !self.btnSecureText.isSelected
            self.txtFieldUsedFor.isSecureTextEntry = !self.txtFieldUsedFor.isSecureTextEntry
        }
    }
    
}
