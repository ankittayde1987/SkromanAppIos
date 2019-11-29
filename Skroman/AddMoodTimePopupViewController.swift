//
//  AddMoodTimePopupViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/21/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import STPopup
import ActionSheetPicker_3_0

protocol AddMoodTimePopupViewControllerDelegate {
	func didSelectedTime(objMoodWrapper : MoodWrapper)
}

class AddMoodTimePopupViewController: BaseViewController {

    @IBOutlet weak var btnSkip: UIButton!
    var delegate : AddMoodTimePopupViewControllerDelegate?
	@IBOutlet weak var vwTitleSeprator: UIView!
	@IBOutlet weak var btnSave: UIButton!
	@IBOutlet weak var btnTime: UIButton!
	@IBOutlet weak var lblTime: UILabel!
	@IBOutlet weak var imagClock: UIImageView!
	@IBOutlet weak var vwTimeContainer: UIView!
	@IBOutlet weak var lblStartTimeTitle: UILabel!
	@IBOutlet weak var btnClose: UIButton!
	@IBOutlet weak var lblTitleText: UILabel!
	//New For JSON
	var objMoodWrapper = MoodWrapper()
	
    @IBOutlet weak var btnResetTime: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		initViewController()
    }
	func initViewController()
	{
        if Utility.isIpad()
        {
            self.contentSizeInPopup = CGSize.init(width: CONSTANT_IPAD_VIEW_WIDTH - 60, height: 180)
        }
        else
        {
            self.contentSizeInPopup = CGSize.init(width: SCREEN_SIZE.width - 60, height: 180)
        }
		self.view.backgroundColor = UICOLOR_MAIN_BG
		self.view.layer.cornerRadius = 3.0
		self.view.layer.borderWidth = 1.0
		self.view.layer.borderColor = UICOLOR_POPUP_BORDER.cgColor
		self.popupController?.containerView.layer.cornerRadius = 3.0
		self.popupController?.containerView.layer.borderWidth = 1.0
		self.popupController?.containerView.layer.borderColor = UICOLOR_POPUP_BORDER.cgColor
		
		self.vwTitleSeprator.backgroundColor = UICOLOR_POPUP_BORDER
		self.popupController?.navigationBarHidden = true
		self.lblTitleText.font = Font_Titillium_Semibold_H16
		self.lblStartTimeTitle.font = Font_Titillium_Regular_H14
		self.lblTime.font = Font_Titillium_Regular_H15
		self.btnSave.titleLabel?.font = Font_Titillium_Regular_H16
		self.btnSave.backgroundColor = UICOLOR_BLUE
        self.btnSkip.titleLabel?.font = Font_Titillium_Regular_H16
        
        
		self.vwTimeContainer.backgroundColor = UICOLOR_WHITE
		self.vwTimeContainer.layer.borderWidth = 1.0
		self.vwTimeContainer.layer.borderColor = UICOLOR_TXTFIELD_BORDER_COLOR.cgColor
		self.lblTime.textColor = UICOLOR_MAIN_BG
		if Utility.isEmpty(val: self.objMoodWrapper.mood_time)
		{
			self.lblTime.text = SSLocalizedString(key: "select_time")
		}
		else
		{
			self.lblTime.text = skromanDateFormatter.getStartTimeToShow(dateToConvert: self.objMoodWrapper.mood_time!)
		}
		
		self.lblStartTimeTitle.text = SSLocalizedString(key: "start_time")
		btnSave.setTitle(SSLocalizedString(key: "save").uppercased(), for: .normal)
        btnSkip.setTitle(SSLocalizedString(key: "skip").uppercased(), for: .normal)
        
        
        if(Utility.isEmpty(val: self.objMoodWrapper.mood_time)){
            self.btnSkip.isUserInteractionEnabled = true
            self.btnSkip.backgroundColor = UICOLOR_BLUE
        }
        else
        {
            self.btnSkip.isUserInteractionEnabled = false
            self.btnSkip.backgroundColor = UICOLOR_SEPRATOR
        }
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//MARK:- IBAction
    
    @IBAction func tappedOnResetTime(_ sender: Any) {
        self.objMoodWrapper.mood_time = ""
        self.lblTime.text = SSLocalizedString(key: "select_time")
        self.btnSkip.isUserInteractionEnabled = true
        self.btnSkip.backgroundColor = UICOLOR_BLUE
        
    }
    @IBAction func tappedOnBtnSkip(_ sender: Any) {
        self.popupController?.dismiss(completion: {
            self.delegate?.didSelectedTime(objMoodWrapper: self.objMoodWrapper)
        })
    }
    @IBAction func tappedOnClose(_ sender: Any) {
		self.popupController?.dismiss()
	}
	
	@IBAction func tappedOnTime(_ sender: Any) {
		let  selectedDate: Date? = Date()
		let datePicker = ActionSheetDatePicker(title: SSLocalizedString(key: "select_time"), datePickerMode: UIDatePickerMode.time, selectedDate: selectedDate, doneBlock: {
			picker, value, index in
			print(value ?? "")
			
			let dateFormatter = DateFormatter()
//			dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
//			dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
			dateFormatter.dateFormat = kTimeFormatFor24Hours
			let myString = dateFormatter.string(from:value! as! Date)
			self.btnSkip.backgroundColor = UICOLOR_SEPRATOR
            self.btnSkip.isUserInteractionEnabled = false
			self.objMoodWrapper.mood_time = myString
			self.lblTime.text = skromanDateFormatter.getStartTimeToShow(dateToConvert: self.objMoodWrapper.mood_time!)
			return
		}, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
//		datePicker?.minimumDate = minDate
		//datePicker?.maximumDate = maxDate
		
		datePicker?.setDoneButton(UIBarButtonItem(title: SSLocalizedString(key: "done"), style: .plain, target: nil, action: nil))
		datePicker?.setCancelButton(UIBarButtonItem(title: SSLocalizedString(key: "cancel"), style: .plain, target: nil, action: nil))
		datePicker?.locale = NSLocale(localeIdentifier: "en_US") as Locale
		datePicker?.minuteInterval = 1
		datePicker?.show()
	}
	
	@IBAction func tappedOnSave(_ sender: Any) {
//		let isValidData: Bool = validateUserEnteredData()
//		if isValidData {
			self.popupController?.dismiss(completion: {
				self.delegate?.didSelectedTime(objMoodWrapper: self.objMoodWrapper)
			})
//		}
	}
	// MARK:- validateUserEnteredData method
	func validateUserEnteredData() -> Bool {
			if(Utility.isEmpty(val: self.objMoodWrapper.mood_time)){
				showAlertMessage(strMessage: SSLocalizedString(key: "please_select_start_time"))
				return false
			}
		return true
	}
	
}
