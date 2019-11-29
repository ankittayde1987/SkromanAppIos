//
//  MoodButtonCollectionViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/25/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

protocol MoodButtonCollectionViewCellDelegate {
	func tappedOnMoodBtn(obj : Mood,indexPath : IndexPath)
	func longPressOnButtonMood(_ sender: UIButton, obj : Mood)
}

class MoodButtonCollectionViewCell: UICollectionViewCell {
	var delegate: MoodButtonCollectionViewCellDelegate?
	var objMood = Mood()
	var currentIndexPath : IndexPath!
	@IBOutlet weak var btnMoodName: UIButton!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.btnMoodName.layer.cornerRadius = 3.0
		self.btnMoodName.titleLabel?.font = Font_SanFranciscoText_Regular_H14
		self.btnMoodName.layer.borderWidth = 1.0
		self.btnMoodName.layer.borderColor = UICOLOR_ADDED_MOOD_CLR.cgColor
		self.btnMoodName.backgroundColor = UICOLOR_MAIN_BG
		self.btnMoodName.setTitleColor(UICOLOR_ADDED_MOOD_CLR, for: .normal)
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))
		tapGesture.numberOfTapsRequired = 1
		self.btnMoodName.addGestureRecognizer(tapGesture)
		
		let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
		self.btnMoodName.addGestureRecognizer(longGesture)
    }
	
	func configureCellWith(obj:Mood,indexPath : IndexPath)
	{
		self.objMood = obj
		self.currentIndexPath = indexPath
		if self.objMood.mood_id == DUMMY_MOOD_ID
		{
			self.btnMoodName.setTitleColor(UICOLOR_WHITE, for: .normal)
			self.btnMoodName.layer.borderColor = UIColor.clear.cgColor
			self.btnMoodName.backgroundColor = UICOLOR_ADD_MOOD_BG
		}
		else
		{
			if self.objMood.mood_status == 1
			{
				self.btnMoodName.layer.borderColor = UICOLOR_ADDED_MOOD_CLR.cgColor
				self.btnMoodName.backgroundColor = UICOLOR_ADDED_MOOD_CLR
				self.btnMoodName.setTitleColor(UICOLOR_WHITE, for: .normal)
			}
			else
			{
				self.btnMoodName.backgroundColor = UIColor.clear
				self.btnMoodName.layer.borderColor = UICOLOR_ADDED_MOOD_CLR.cgColor
				self.btnMoodName.setTitleColor(UICOLOR_ADDED_MOOD_CLR, for: .normal)
			}
		}
		self.btnMoodName.setTitle(self.objMood.mood_name, for: .normal)
		self.btnMoodName.setTitle(self.objMood.mood_name, for: .selected)
	}
    
    
	@objc func normalTap(_ sender: UIGestureRecognizer){
		print("Normal tap")
		
		if self.objMood.mood_id == DUMMY_MOOD_ID
		{
			self.delegate?.tappedOnMoodBtn(obj: self.objMood, indexPath: self.currentIndexPath)
		}
		else
		{
			var changeStatus = 1
			if objMood.mood_status == 1
			{
				changeStatus = 0
			}
			//TO CHANGE DATA MVC
			self.objMood.mood_status = changeStatus
			self.delegate?.tappedOnMoodBtn(obj: self.objMood, indexPath: self.currentIndexPath)
		}
		
	}
	
	@objc func longTap(_ sender: UIGestureRecognizer){
		if sender.state == .ended {
			self.delegate?.longPressOnButtonMood(self.btnMoodName, obj: self.objMood)
			//Do Whatever You want on End of Gesture
		}
		else if sender.state == .began {
			//Do Whatever You want on Began of Gesture
		}
	}

}
