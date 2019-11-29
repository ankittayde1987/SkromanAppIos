//
//  SelectDaysPopUpViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/21/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import STPopup

protocol SelectDaysPopUpViewControllerDelegate {
	func didSelectedDays(objMoodWrapper : MoodWrapper)
}

class SelectDaysPopUpViewController: BaseViewController,UITableViewDataSource, UITableViewDelegate {
	var delegate : SelectDaysPopUpViewControllerDelegate?
	@IBOutlet weak var btnSave: UIButton!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var btnClose: UIButton!
	@IBOutlet weak var lblPopUpTitle: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    
	//New For JSON
	var objMoodWrapper = MoodWrapper()
	
	var arrayDays : [String] = []
	var arraySelectedDays : [Int] = []
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		arrayDays =
			[SSLocalizedString(key: "sunday"),
			 SSLocalizedString(key: "monday"),
			 SSLocalizedString(key: "tuesday"),
			 SSLocalizedString(key: "wednesday"),
			 SSLocalizedString(key: "thrusday"),
			 SSLocalizedString(key: "friday"),
			 SSLocalizedString(key: "saturday")]
			 
		initViewController()
		if self.objMoodWrapper.arraySelectedDaysForMoodRepeat.count != 0
		{
			self.arraySelectedDays = self.objMoodWrapper.arraySelectedDaysForMoodRepeat
            self.btnSkip.isUserInteractionEnabled = false
            self.btnSkip.backgroundColor = UICOLOR_SEPRATOR
		}
    }
	func initViewController()
	{
        
        if Utility.isIpad()
        {
            self.contentSizeInPopup = CGSize.init(width: CONSTANT_IPAD_VIEW_WIDTH - 60, height: (110 + (44 * 7)))
        }
        else
        {
            self.contentSizeInPopup = CGSize.init(width: SCREEN_SIZE.width - 60, height: (110 + (44 * 7)))
        }
        
		self.view.backgroundColor = UICOLOR_MAIN_BG
		self.view.layer.cornerRadius = 3.0
		self.view.layer.borderWidth = 1.0
		self.view.layer.borderColor = UICOLOR_POPUP_BORDER.cgColor
		self.popupController?.containerView.layer.cornerRadius = 3.0
		self.popupController?.containerView.layer.borderWidth = 1.0
		self.popupController?.containerView.layer.borderColor = UICOLOR_POPUP_BORDER.cgColor
		
		self.vwSeprator.backgroundColor = UICOLOR_POPUP_BORDER
		self.popupController?.navigationBarHidden = true
		self.lblPopUpTitle.font = Font_Titillium_Semibold_H16
		self.btnSave.titleLabel?.font = Font_Titillium_Regular_H16
        self.btnSkip.titleLabel?.font = Font_Titillium_Regular_H16
		self.btnSave.backgroundColor = UICOLOR_BLUE
		
		view.backgroundColor = UICOLOR_MAIN_BG
		self.tableView.backgroundColor = UICOLOR_MAIN_BG
		btnSave.setTitle(SSLocalizedString(key: "save").uppercased(), for: .normal)
		btnSkip.setTitle(SSLocalizedString(key: "skip").uppercased(), for: .normal)
        
        if arraySelectedDays.count == 0{
            self.btnSkip.isUserInteractionEnabled = true
            self.btnSkip.backgroundColor = UICOLOR_BLUE
        }
        else
        {
            self.btnSkip.isUserInteractionEnabled = false
            self.btnSkip.backgroundColor = UICOLOR_SEPRATOR
        }
		self.lblPopUpTitle.text = SSLocalizedString(key: "add_mood_days").uppercased()
		self.setupTableView()
	}
	func setupTableView() {
		// Registering nibs
		tableView.register(UINib.init(nibName: "DayOptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DayOptionTableViewCell")
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	// MARK: - UITableView
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arrayDays.count
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 44
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DayOptionTableViewCell", for: indexPath) as! DayOptionTableViewCell
		cell.lblDayName.text = self.arrayDays[indexPath.row]
		cell.imagSelectDeselect.image = #imageLiteral(resourceName: "chkbox1")
		let opt : Int = indexPath.row
		if arraySelectedDays.contains(opt) {
			cell.imagSelectDeselect.image = #imageLiteral(resourceName: "chkbox2")
		}
		else {
			cell.imagSelectDeselect.image = #imageLiteral(resourceName: "chkbox1")
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if arraySelectedDays.contains(indexPath.row) {
			self.arraySelectedDays.remove(at: self.arraySelectedDays.index(of: indexPath.row)!)
		}
		else {
			self.arraySelectedDays.append(indexPath.row)
		}
        
        if arraySelectedDays.count == 0{
            self.btnSkip.isUserInteractionEnabled = true
            self.btnSkip.backgroundColor = UICOLOR_BLUE
        }
        else
        {
            self.btnSkip.isUserInteractionEnabled = false
            self.btnSkip.backgroundColor = UICOLOR_SEPRATOR
        }
		self.tableView.reloadRows(at: [indexPath], with: .none)
	}
	//MARK:- IBAction
    
    @IBAction func tappedOnSkip(_ sender: Any) {
        self.popupController?.dismiss(completion: {
            self.objMoodWrapper.arraySelectedDaysForMoodRepeat = self.arraySelectedDays
            self.delegate?.didSelectedDays(objMoodWrapper: self.objMoodWrapper)
        })
    }
    @IBAction func tappedOnClose(_ sender: Any) {
		self.popupController?.dismiss()
	}
	
	@IBAction func tappedOnSave(_ sender: Any) {
//		if arraySelectedDays.count == 0
//		{
//			showAlertMessage(strMessage: SSLocalizedString(key: "please_select_repeat_days") as NSString)
//			return
//		}
		self.popupController?.dismiss(completion: {
			self.objMoodWrapper.arraySelectedDaysForMoodRepeat = self.arraySelectedDays
			self.delegate?.didSelectedDays(objMoodWrapper: self.objMoodWrapper)
		})
	}
}
