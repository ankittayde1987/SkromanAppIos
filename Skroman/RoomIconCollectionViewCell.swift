//
//  RoomIconCollectionViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 10/3/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
protocol RoomIconCollectionViewCellDelegate {
	func selectIconForRoom(obj: Room, selectedIconName: String, indexPath : IndexPath,isCustomIcon : Bool)
}
class RoomIconCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var imagUsedFor: UIImageView!
	@IBOutlet weak var vwContainer: UIView!
	
	var objRoom = Room()
	var currentIndexPath : IndexPath!
	var isAllowEditing : Bool? = false
	var currentImageName : String? = ""
	var isCustomIcon : Bool? = false
	var delegate : RoomIconCollectionViewCellDelegate?
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		// Initialization code
		vwContainer.backgroundColor = UICOLOR_MAIN_BG
		vwContainer.layer.cornerRadius = 3.0
		vwContainer.layer.borderWidth = 1.0
		vwContainer.layer.borderColor = UICOLOR_SWITCH_BORDER_COLOR_UNSELECTED.cgColor
		
		//Added tap gesture
		let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tappedView(_:)))
		self.vwContainer.addGestureRecognizer(tapGestureRecognizer)
    }
	
	func configureRoomIconCollectionViewCell(obj : Room, imageName:String, isAllowEditing: Bool,indexPath: IndexPath,isCustomIcon : Bool,attachImage : UIImage)
	{
		self.objRoom = obj
		self.isAllowEditing = isAllowEditing
		self.currentIndexPath = indexPath
		self.currentImageName = imageName
		self.isCustomIcon = isCustomIcon
		
		if isCustomIcon
		{
			if Utility.isImageNull(attachImage)
			{
				self.imagUsedFor.image = UIImage.init(named: self.currentImageName!)
			}
			else
			{
				self.imagUsedFor.contentMode = .scaleToFill
				self.imagUsedFor.image = attachImage
			}
			
		}
		else
		{
			if self.objRoom.image == self.currentImageName
			{
				self.imagUsedFor.image = UIImage.init(named: self.getActiveImageName())
			}
			else
			{
				self.imagUsedFor.image = UIImage.init(named: self.currentImageName!)
				
			}
		}
		
		self.vwContainer.layer.borderColor = self.getBorderColorForVwContainer().cgColor
	}
	func getActiveImageName() -> String
	{
		return String(format: "%@_active",self.currentImageName!)
	}
	func getBorderColorForVwContainer() -> UIColor
	{
		var borderColor = UICOLOR_SWITCH_BORDER_COLOR_UNSELECTED
		if self.objRoom.image == self.currentImageName
		{
			borderColor = UICOLOR_SWITCH_BORDER_COLOR_YELLOW
		}
		return borderColor
	}
	@objc func tappedView(_ sender : UIView)
	{
		if isCustomIcon!
		{
			SSLog(message: "warning")
			self.delegate?.selectIconForRoom(obj: self.objRoom, selectedIconName: self.currentImageName!, indexPath: self.currentIndexPath, isCustomIcon: isCustomIcon!)
		}
		else
		{
			//IF ICON ALREADY SELECTED THEN DO NOTHING
			if self.objRoom.image == self.currentImageName
			{
				return
			}
			else
			{
				self.delegate?.selectIconForRoom(obj: self.objRoom, selectedIconName: self.currentImageName!, indexPath: self.currentIndexPath, isCustomIcon: isCustomIcon!)
			}
		}
	}
}
