//
//  SwitchForMoodSettingCollectionViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/21/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
protocol SwitchForMoodSettingCollectionViewCellDelegate {
	func tappedOnSwitch(obj: Mood, status: String, indexPath : IndexPath)
	func longPressOnSteapperView(obj: Mood)
}
class SwitchForMoodSettingCollectionViewCell: UICollectionViewCell {
	var delegate: SwitchForMoodSettingCollectionViewCellDelegate?
	
	@IBOutlet weak var vwSteapper: UIView!
	@IBOutlet weak var labelBottomSpace: NSLayoutConstraint! // 8 or 0
	@IBOutlet weak var spaceBetweenProgressBarAndLabel: NSLayoutConstraint! // 4 or 0
	@IBOutlet weak var progressView: UIProgressView!
	@IBOutlet weak var lblSwitchNumber: UILabel!
	
	@IBOutlet weak var constantProgressViewHight: NSLayoutConstraint!
	@IBOutlet weak var lblUsedFor: UILabel!
	@IBOutlet weak var imagUsedFor: UIImageView!
	@IBOutlet weak var vwContainer: UIView!

	var objMood = Mood()
	var isAllowEditing : Bool? = false
	var currentIndexPath : IndexPath!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		initCellComponents()
    }
	func initCellComponents()
	{
		lblUsedFor.font = Font_SanFranciscoText_Regular_H12
		vwContainer.backgroundColor = UICOLOR_ROOM_CELL_BG
		vwContainer.layer.cornerRadius = 3.0
		vwContainer.layer.borderWidth = 1.0
		vwContainer.layer.borderColor = UICOLOR_SWITCH_BORDER_COLOR_UNSELECTED.cgColor
		lblSwitchNumber.layer.cornerRadius = lblSwitchNumber.frame.size.width/2
		lblSwitchNumber.clipsToBounds = true
        lblSwitchNumber.isHidden = false
		lblSwitchNumber.font = Font_SanFranciscoText_Regular_H10
		lblSwitchNumber.textColor = UICOLOR_WHITE
		constantProgressViewHight.constant = 0
		
		progressView.trackTintColor =  UICOLOR_SWITCH_BORDER_COLOR_UNSELECTED
		progressView.progressTintColor = UICOLOR_WHITE
		
		self.lblSwitchNumber.backgroundColor = UICOLOR_PINK
		
		//Added tap gesture and long gesture
		let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tappedView(_:)))
		self.vwContainer.addGestureRecognizer(tapGestureRecognizer)
	
		
		let longPressRecognizerForStepper = UILongPressGestureRecognizer.init(target: self, action: #selector(longTappedOnSteapperView(_:)))
		self.vwSteapper.addGestureRecognizer(longPressRecognizerForStepper)
	}
	
	func configureSwitchForMoodSettingCollectionViewCell(obj:Mood, isAllowEditing: Bool,indexPath: IndexPath)
	{
		self.objMood = obj
		self.isAllowEditing = isAllowEditing
		self.currentIndexPath = indexPath
		
		self.hideBothProgressViewAndLabel()
		if isAllowEditing
		{
			self.showElementsOnCell()
			self.setProgress()
			//TO Set Image Name
			self.imagUsedFor.image = UIImage.init(named: self.objMood.getImageNameToSetForMood())
			//To set Border Color
			self.vwContainer.layer.borderColor = self.getBorderColorForVwContainer().cgColor
			//Set Switch Number
            self.lblSwitchNumber.isHidden = false
			self.lblSwitchNumber.text = "\(self.objMood.switch_id!)"
			//Set Background Color to LblSwitchNumber
			//			self.lblSwitchNumber.backgroundColor = self.getBackgroundColorForSwitchNumber()
		}
		else
		{
			lblSwitchNumber.isHidden = true
			vwContainer.layer.borderColor = UICOLOR_SWITCH_BORDER_COLOR_UNSELECTED.cgColor
			self.imagUsedFor.image = #imageLiteral(resourceName: "type_0_1")
		}
		
	}

	//MARK :- ALL TAP ACTIONS
	@objc func tappedView(_ sender : UIView)
	{
		if isAllowEditing!
		{
			//Need Help Sapanesh Sir
			var changeStatus = "1"
			if objMood.status == 1
			{
				changeStatus = "0"
			}
            if self.objMood.type == SWITCH_TYPE_FAN || self.objMood.type == SWITCH_TYPE_DIMMER
            {
                if self.objMood.position == 0 && changeStatus == "1"
                {
                    self.objMood.position = 1
                }
            }
			//TO CHANGE DATA MVC
			self.objMood.status = Int(changeStatus)!
			self.delegate?.tappedOnSwitch(obj: self.objMood, status: changeStatus, indexPath: currentIndexPath as IndexPath)
		}
	}
	
	
	@objc func longTappedOnSteapperView(_ sender : UILongPressGestureRecognizer)
	{
		if self.objMood.type == SWITCH_TYPE_FAN || self.objMood.type == SWITCH_TYPE_DIMMER
		{
			self.vwSteapper.isUserInteractionEnabled = true
			//OPEN SLIDER
			SSLog(message: "steapper click")
			self.delegate?.longPressOnSteapperView(obj: self.objMood)
		}
		else{
			self.vwSteapper.isUserInteractionEnabled = false
		}
	}
	
	func getBorderColorForVwContainer() -> UIColor
	{
		var borderColor = UICOLOR_SWITCH_BORDER_COLOR_UNSELECTED
		if self.objMood.status == 1
		{
			if self.objMood.type == SWITCH_TYPE_LIGHT || self.objMood.type == SWITCH_TYPE_DIMMER
			{
				borderColor = UICOLOR_SWITCH_BORDER_COLOR_YELLOW
			}
			else if self.objMood.type == SWITCH_TYPE_FAN
			{
				borderColor = UICOLOR_SWITCH_BORDER_COLOR_BLUE
			}
		}
		return borderColor
	}
	
	
	
	
	func showElementsOnCell()
	{
		if (!Utility.isEmpty(val: self.objMood.switch_name) && (self.objMood.type == SWITCH_TYPE_FAN || self.objMood.type == SWITCH_TYPE_DIMMER))
		{
			self.showBothProgressViewAndLabel()
		}
		else{
			if !Utility.isEmpty(val: self.objMood.switch_name)
			{
				self.showLabelOnly()
			}
			else if self.objMood.type == SWITCH_TYPE_FAN || self.objMood.type == SWITCH_TYPE_DIMMER
			{
				self.showProgressViewOnly()
			}
		}
	}
	func showProgressViewOnly() {
		lblUsedFor.text = " "
		labelBottomSpace.constant = 0
		spaceBetweenProgressBarAndLabel.constant = 8
		constantProgressViewHight.constant = 3
		// TODO: Set progress
	}
	
	func showLabelOnly() {
		labelBottomSpace.constant = 8
		spaceBetweenProgressBarAndLabel.constant = 0
		constantProgressViewHight.constant = 0
		// TODO: Set label text
		self.lblUsedFor.text = self.objMood.switch_name?.uppercased()
	}
	
	func showBothProgressViewAndLabel() {
		labelBottomSpace.constant = 8
		spaceBetweenProgressBarAndLabel.constant = 4
		constantProgressViewHight.constant = 3
		
		// TODO: Set label text
		self.lblUsedFor.text = self.objMood.switch_name?.uppercased()
	}
	
	func hideBothProgressViewAndLabel() {
		lblUsedFor.text = nil
		labelBottomSpace.constant = 0
		spaceBetweenProgressBarAndLabel.constant = 0
		constantProgressViewHight.constant = 0
	}
	
	func setProgress()
	{
		let position = Float(self.objMood.position)
		var divideBy = Float(4)
		if self.objMood.type == SWITCH_TYPE_DIMMER
		{
			divideBy = 6
		}
		progressView.setProgress(position/divideBy, animated: false)
	}
}
