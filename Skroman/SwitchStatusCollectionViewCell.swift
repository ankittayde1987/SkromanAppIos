//
//  SwitchStatusCollectionViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/17/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
protocol SwitchStatusCollectionViewCellDelegate {
	func longPressOnContainerView(_ sender: UIView, obj: Switch)
	func tappedOnSwitch(obj: Switch, status: Int, indexPath : IndexPath)
	func longPressOnSteapperView(obj: Switch)
}

class SwitchStatusCollectionViewCell: UICollectionViewCell {

	var delegate : SwitchStatusCollectionViewCellDelegate?
	
	
	
	@IBOutlet weak var vwSteapper: UIView!
	@IBOutlet weak var labelBottomSpace: NSLayoutConstraint! // 8 or 0
	@IBOutlet weak var spaceBetweenProgressBarAndLabel: NSLayoutConstraint! // 4 or 0
	@IBOutlet weak var progressView: UIProgressView!
	@IBOutlet weak var lblSwitchNumber: UILabel!
	
	@IBOutlet weak var constantProgressViewHight: NSLayoutConstraint!
	@IBOutlet weak var lblUsedFor: UILabel!
	@IBOutlet weak var imagUsedFor: UIImageView!
	@IBOutlet weak var vwContainer: UIView!
	var objSwitch = Switch()
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
		lblSwitchNumber.font = Font_SanFranciscoText_Regular_H10
		lblSwitchNumber.textColor = UICOLOR_WHITE
		constantProgressViewHight.constant = 0
		
		progressView.trackTintColor =  UICOLOR_SWITCH_BORDER_COLOR_UNSELECTED
		progressView.progressTintColor = UICOLOR_WHITE
		
		self.lblSwitchNumber.backgroundColor = UICOLOR_PINK
		
		//Added tap gesture and long gesture
		let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tappedView(_:)))
		self.vwContainer.addGestureRecognizer(tapGestureRecognizer)
		let longPressRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(longTappedOnView(_:)))
		self.vwContainer.addGestureRecognizer(longPressRecognizer)
		
		let longPressRecognizerForStepper = UILongPressGestureRecognizer.init(target: self, action: #selector(longTappedOnSteapperView(_:)))
		self.vwSteapper.addGestureRecognizer(longPressRecognizerForStepper)
	}
	@objc func longTappedOnSteapperView(_ sender : UILongPressGestureRecognizer)
	{
		if self.objSwitch.type == SWITCH_TYPE_FAN || self.objSwitch.type == SWITCH_TYPE_DIMMER
		{
			self.vwSteapper.isUserInteractionEnabled = true
			//OPEN SLIDER
			SSLog(message: "steapper click")
			self.delegate?.longPressOnSteapperView(obj: self.objSwitch)
		}
		else{
			self.vwSteapper.isUserInteractionEnabled = false
		}
	}
	func configureCellForSwitchStatusCollectionViewCell(obj:Switch, isAllowEditing: Bool,indexPath: IndexPath)
	{
		self.objSwitch = obj
		self.isAllowEditing = isAllowEditing
		self.currentIndexPath = indexPath
		
		self.hideBothProgressViewAndLabel()
		if isAllowEditing
		{
			self.showElementsOnCell()
            
            if (self.objSwitch.type == SWITCH_TYPE_FAN || self.objSwitch.type == SWITCH_TYPE_DIMMER)
            {
                SSLog(message: objSwitch.type)
                SSLog(message: objSwitch.position)
                self.setProgress()
            }
			//TO Set Image Name
			self.imagUsedFor.image = UIImage.init(named: self.objSwitch.getImageNameToSet())
			//To set Border Color
			self.vwContainer.layer.borderColor = self.getBorderColorForVwContainer().cgColor
			//Set Switch Number
            
            print("SWITCH_BOX_Name: \(self.objSwitch.switch_name!)")
            print("SWITCH_BOX_NO TO SHOW: \(self.objSwitch.switch_id!)")
            lblSwitchNumber.isHidden = false
			self.lblSwitchNumber.text = "\(self.objSwitch.switch_id!)"
            lblUsedFor.text = "\(self.objSwitch.switch_name!)"
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
	
	@objc func tappedView(_ sender : UIView)
	{
		
		if isAllowEditing!
		{
			//Need Help Sapanesh Sir
			var changeStatus = 1
			if objSwitch.status == 1
			{
				changeStatus = 0
			}
			objSwitch.status = changeStatus
            
            if self.objSwitch.type == SWITCH_TYPE_FAN || self.objSwitch.type == SWITCH_TYPE_DIMMER
            {
                if self.objSwitch.position == 0 && changeStatus == 1
                {
                    self.objSwitch.position = 1
                }
            }
            
            
			self.delegate?.tappedOnSwitch(obj: self.objSwitch, status: changeStatus, indexPath: currentIndexPath as IndexPath)
		}
	}
	@objc func longTappedOnView(_ sender : UILongPressGestureRecognizer)
	{
		
		if isAllowEditing!
		{
			if sender.state == .ended {
				self.delegate?.longPressOnContainerView(self.vwContainer, obj: self.objSwitch)
			} else if sender.state == .began {
				print("Long press detected")
			}
		}
	}
	
	func getBorderColorForVwContainer() -> UIColor
	{
		var borderColor = UICOLOR_SWITCH_BORDER_COLOR_UNSELECTED
		if self.objSwitch.status == 1
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
	
	
	func getBackgroundColorForSwitchNumber() -> UIColor
	{
		var borderColor = UICOLOR_SWITCH_BORDER_COLOR_UNSELECTED
		if self.objSwitch.status == 1
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
	func showElementsOnCell()
	{
		if (!Utility.isEmpty(val: self.objSwitch.switch_name) && (self.objSwitch.type == SWITCH_TYPE_FAN || self.objSwitch.type == SWITCH_TYPE_DIMMER))
		{
			self.showBothProgressViewAndLabel()
		}
		else{
			if !Utility.isEmpty(val: self.objSwitch.switch_name)
			{
				self.showLabelOnly()
			}
			else if self.objSwitch.type == SWITCH_TYPE_FAN || self.objSwitch.type == SWITCH_TYPE_DIMMER
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
		self.lblUsedFor.text = self.objSwitch.switch_name?.uppercased()
	}
	
	func showBothProgressViewAndLabel() {
		labelBottomSpace.constant = 8
		spaceBetweenProgressBarAndLabel.constant = 4
		constantProgressViewHight.constant = 3
		
		// TODO: Set label text
		self.lblUsedFor.text = self.objSwitch.switch_name?.uppercased()
	}
	
	func hideBothProgressViewAndLabel() {
		lblUsedFor.text = nil
		labelBottomSpace.constant = 0
		spaceBetweenProgressBarAndLabel.constant = 0
		constantProgressViewHight.constant = 0
	}
	
	func setProgress()
	{
		let position = Float(self.objSwitch.position!)
		var divideBy = Float(4)
		if self.objSwitch.type == SWITCH_TYPE_DIMMER
		{
			divideBy = 6
		}
		progressView.setProgress(position/divideBy, animated: false)
	}
}
