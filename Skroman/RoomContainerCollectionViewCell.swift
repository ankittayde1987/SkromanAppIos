//
//  RoomContainerCollectionViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

protocol RoomContainerCollectionViewCellDelegate {
	func tappedOnDeleteRoom(obj : Room)
}

class RoomContainerCollectionViewCell: UICollectionViewCell {

	var delegate : RoomContainerCollectionViewCellDelegate?
	var objRoom = Room()
	@IBOutlet weak var btnDeleteRoom: UIButton!
	@IBOutlet weak var lblUsedFor: UILabel!
	@IBOutlet weak var imagUsedFor: UIImageView!
	@IBOutlet weak var vwContainer: UIView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		initCellComponents()
    }
	func initCellComponents()
	{
		lblUsedFor.font = Font_SanFranciscoText_Regular_H12
		vwContainer.backgroundColor = UICOLOR_CONTAINER_BG
        if !Utility.isIpad()
        {
            vwContainer.layer.cornerRadius = 3.0
            vwContainer.layer.borderWidth = 1.0
            vwContainer.layer.borderColor = UICOLOR_SELECTEDORON_BG.cgColor
        }
        self.btnDeleteRoom.isHidden = true
	}
    func configureCellWithRoom(objRoom:Room)
    {
		self.objRoom = objRoom
        lblUsedFor.text = self.objRoom.room_name
		
		if (self.objRoom.image?.contains(IMAGENAME))!
		{
			if !Utility.isImageNull(Utility.getCustomImageFromPath(image: self.objRoom.image!))
			{
				self.imagUsedFor.contentMode = .scaleAspectFit
				self.imagUsedFor.image = Utility.getCustomImageFromPath(image: self.objRoom.image!)
			}
		}
		else
		{
			if !Utility.isEmpty(val: self.objRoom.image)
			{
				self.imagUsedFor.image = UIImage.init(named:self.getActiveImageName())
			}
			else
			{
				self.imagUsedFor.image =  UIImage.init(named: self.objRoom.getDefaultImageName())
			}
		}
		
    }
	func getActiveImageName() -> String
	{
		return String(format: "%@_active",self.objRoom.image!)
	}
	
    @IBAction func tappedOnDeleteRoom(_ sender: Any) {
        if Utility.isRestrictOperation(){
            Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
        }
        else
        {
            self.delegate?.tappedOnDeleteRoom(obj: self.objRoom)
        }
    }
	
	
}
