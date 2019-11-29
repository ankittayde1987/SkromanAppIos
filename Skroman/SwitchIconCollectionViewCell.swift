//
//  SwitchIconCollectionViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
protocol SwitchIconCollectionViewCellDelegate {
	func selectIconForSwitch(obj: Switch, selectedIconName: String, indexPath : IndexPath)
}
class SwitchIconCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var imagUsedFor: UIImageView!
	@IBOutlet weak var vwContainer: UIView!
	
	var currentIndexPath : IndexPath!
	var delegate : SwitchIconCollectionViewCellDelegate?
	var objSwitch = Switch()
	var isAllowEditing : Bool? = false
	var currentImageName : String? = ""
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		vwContainer.backgroundColor = UICOLOR_ROOM_CELL_BG
		vwContainer.layer.cornerRadius = 3.0
		vwContainer.layer.borderWidth = 1.0
		vwContainer.layer.borderColor = UICOLOR_SWITCH_BORDER_COLOR_UNSELECTED.cgColor
		
		//Added tap gesture
		let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tappedView(_:)))
		self.vwContainer.addGestureRecognizer(tapGestureRecognizer)
    }
	func configureSwitchIconCollectionViewCell(obj : Switch, imageName:String, isAllowEditing: Bool,indexPath: IndexPath)
	{
		self.objSwitch = obj
		self.isAllowEditing = isAllowEditing
		self.currentImageName = imageName
		self.currentIndexPath = indexPath
		if isAllowEditing
		{
			if self.objSwitch.switch_icon == self.currentImageName
			{
				self.imagUsedFor.image = UIImage.init(named: self.getActiveImageName())
			}
			else
			{
				self.imagUsedFor.image = UIImage.init(named: self.currentImageName!)
				
			}
			self.vwContainer.layer.borderColor = self.getBorderColorForVwContainer().cgColor
		}
		else
		{
			vwContainer.layer.borderColor = UICOLOR_SWITCH_BORDER_COLOR_UNSELECTED.cgColor
			self.imagUsedFor.image = UIImage.init(named: self.objSwitch.getDefaultImageNameByType())
		}
		
	}
	@objc func tappedView(_ sender : UIView)
	{
		if isAllowEditing!
		{
			//IF ICON ALREADY SELECTED THEN DO NOTHING
			if self.objSwitch.switch_icon == self.currentImageName
			{
				return
			}
			else
			{
				self.delegate?.selectIconForSwitch(obj: self.objSwitch, selectedIconName: self.currentImageName!, indexPath: self.currentIndexPath)
			}
			
		}
	}
	func getActiveImageName() -> String
	{
		return String(format: "%@_active",self.currentImageName!)
	}
	func getBorderColorForVwContainer() -> UIColor
	{
		var borderColor = UICOLOR_SWITCH_BORDER_COLOR_UNSELECTED
		if self.objSwitch.switch_icon == self.currentImageName
		{
			if self.objSwitch.type == SWITCH_TYPE_LIGHT || self.objSwitch.type == SWITCH_TYPE_MOOD || self.objSwitch.type == SWITCH_TYPE_DIMMER
			{
				borderColor = UICOLOR_SWITCH_BORDER_COLOR_YELLOW
			}
			else if self.objSwitch.type == SWITCH_TYPE_FAN
			{
				borderColor = UICOLOR_SWITCH_BORDER_COLOR_BLUE
			}
		}
		return borderColor
	}
}
