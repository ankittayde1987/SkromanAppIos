//
//  MoodNameContainerCollectionViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
protocol MoodNameContainerCollectionViewCellDelegate {
	func tappedOnMoodBtnFromDeviceMood(obj : Mood,indexPath : IndexPath)
	func longPressOnButtonMoodFromDeviceMood(_ sender: UIButton, obj : Mood,indexPath : IndexPath)
}
class MoodNameContainerCollectionViewCell: UICollectionViewCell {
	var delegate : MoodNameContainerCollectionViewCellDelegate?
	@IBOutlet weak var btnMoodName: UIButton!
	var objMood = Mood()
	var currentIndexPath : IndexPath!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.btnMoodName.layer.cornerRadius = 3.0
		self.btnMoodName.layer.borderWidth = 1.0
		self.btnMoodName.titleLabel?.font = Font_Titillium_Regular_H16
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))
		tapGesture.numberOfTapsRequired = 1
		self.btnMoodName.addGestureRecognizer(tapGesture)
		
		let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
		self.btnMoodName.addGestureRecognizer(longGesture)
    }
	
	func configureCellWith(obj : Mood, indexPath : IndexPath)
	{
		self.objMood = obj
		self.currentIndexPath = indexPath
		self.btnMoodName.setTitle(objMood.mood_name, for: .normal)
		self.btnMoodName.setTitle(objMood.mood_name, for: .selected)
		if self.objMood.mood_status == 1
		{
			self.btnMoodName.layer.borderColor = UICOLOR_ADDED_MOOD_CLR.cgColor
			self.btnMoodName.backgroundColor = UICOLOR_ADDED_MOOD_CLR
			self.btnMoodName.setTitleColor(UICOLOR_WHITE, for: .normal)
			self.btnMoodName.setTitleColor(UICOLOR_WHITE, for: .selected)
		}
		else
		{
			self.btnMoodName.backgroundColor = UICOLOR_WHITE
			self.btnMoodName.layer.borderColor = UICOLOR_ADDED_MOOD_CLR.cgColor
			self.btnMoodName.setTitleColor(UICOLOR_ADDED_MOOD_CLR, for: .normal)
			self.btnMoodName.setTitleColor(UICOLOR_ADDED_MOOD_CLR, for: .selected)
		}
	}
    
   func setMoodNotificationCentre(){
        
    NotificationCenter.default.addObserver(self, selector: #selector(self.updateMoodButtonColorNotification), name: .updateMoodButtonColorNotification ,
            object: nil)

    }
	
	@objc func normalTap(_ sender: UIGestureRecognizer){
		print("Normal tap")
		var changeStatus = 1
		if objMood.mood_status == 1{
			changeStatus = 0
		}
		//TO CHANGE DATA MVC
		self.objMood.mood_status = changeStatus
		self.delegate?.tappedOnMoodBtnFromDeviceMood(obj: self.objMood, indexPath: self.currentIndexPath)
	}
	
	@objc func longTap(_ sender: UIGestureRecognizer){
		if sender.state == .ended {
			self.delegate?.longPressOnButtonMoodFromDeviceMood(self.btnMoodName, obj: self.objMood, indexPath: self.currentIndexPath)
			//Do Whatever You want on End of Gesture
		}
		else if sender.state == .began {
			//Do Whatever You want on Began of Gesture
		}
	}
    
    @objc func updateMoodButtonColorNotification(notification:NSNotification){
        
        var userInfo = NSDictionary()
        userInfo = notification.userInfo! as NSDictionary

        let moodColor : String = userInfo.value(forKey: "moodColor") as! String

//        if moodColor == nil {
//
//            self.btnMoodName.backgroundColor = .red
//        }
//        else{
//
//        }
        
//
//        self.setUpRightNavigationBarButton(connectionMqtt: connectionMqtt)
    }

}
