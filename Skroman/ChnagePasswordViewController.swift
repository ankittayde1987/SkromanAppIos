//
//  ChnagePasswordViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/24/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SVProgressHUD

class ChnagePasswordViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
	var objUser = User()
    
    
    @IBOutlet weak var vwConstant_iPadWidth: NSLayoutConstraint!
    @IBOutlet var vwTableFooter: UIView!
    @IBOutlet weak var btnConstImage: UIButton!
	@IBOutlet var vwTableHeader: UIView!
	@IBOutlet weak var btnSave: UIButton!
	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var vwBottomContainer: UIView!
	@IBOutlet weak var tableView: TPKeyboardAvoidingTableView!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.initViewController()
        self.customiseUIForIPad()
    }
    func customiseUIForIPad()
    {
        if Utility.isIpad()
        {
            self.vwConstant_iPadWidth.constant = CONSTANT_IPAD_VIEW_WIDTH
            self.vwTableFooter.backgroundColor = UICOLOR_MAIN_BG
            self.tableView.tableFooterView = self.vwTableFooter
        }
    }
	func initViewController()
	{
		self.title = SSLocalizedString(key: "change_password")
		self.view.backgroundColor = UICOLOR_MAIN_BG
		self.tableView.backgroundColor = UICOLOR_MAIN_BG
		self.vwTableHeader.backgroundColor = UICOLOR_MAIN_BG
		self.vwBottomContainer.backgroundColor = UICOLOR_BLUE
		self.btnSave.backgroundColor = UICOLOR_BLUE
		self.vwSeprator.backgroundColor = UICOLOR_SEPRATOR
		self.btnSave.titleLabel?.font = Font_SanFranciscoText_Regular_H16
		self.setupTableView()
		self.tableView.tableHeaderView = self.vwTableHeader
	}
	func setupTableView() {
		// Registering nibs
		tableView.register(UINib.init(nibName: "LabelAndTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelAndTextFieldTableViewCell")
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
		return 3
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 104
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "LabelAndTextFieldTableViewCell", for: indexPath) as! LabelAndTextFieldTableViewCell
		cell.configureCellWithIndexPathForChangePassword(indexPath: indexPath, obj: self.objUser)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}
	//MARK:- IBAction
	@IBAction func tappedOnSave(_ sender: Any) {
//		UIAppDelegate.navigateToHomeScreen()
		
		
		// Befor login validate if user has entered correct data or not
		let isValidData: Bool = self.validateUserEnteredData()
		if isValidData {
			
			if !Utility.isInternetAvailable(){
				//no internet message
				self.showAlertViewWithMessage(SSLocalizedString(key: "no_internet_connection"))
				return
			}
			else{
				//handle valid data action
				// User has entered correct kind of data
				
				// Now show spinner while login API is in progress
				SVProgressHUD.show()
				self.view.endEditing(true)
				
				SkromanAppAPI().changePasswordOfUser(body: self.objUser, success: { (obj) in
					// Done calling API
					
					// Hide the spinner
					SVProgressHUD.dismiss()
					ToastMessage.showSuccessMessage(SSLocalizedString(key: "password_change_successfully"))
					// Navigate to home screen
					UIAppDelegate.navigateToHomeScreen()
				}, failure: { (error) in
					self.view.endEditing(true)
					SVProgressHUD.dismiss()
					Utility.showErrorNativeMessage(error: error)
				})
			}
		}
	}
	
	// MARK:- validateUserEnteredData method
	func validateUserEnteredData() -> Bool {
		if(Utility.isEmpty(val: objUser.old_password?.removingWhitespaces())){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_old_password"))
			return false
		}
		else if(Utility.isEmpty(val: objUser.password?.removingWhitespaces())){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_new_password"))
			return false
		}
		else if(Utility.isEmpty(val: objUser.confirm_password?.removingWhitespaces())){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_confirm_password"))
			return false
		}
		else if(objUser.password != objUser.confirm_password){
			self.showAlertMessage(strMessage: SSLocalizedString(key: "new_password_not_match"))
			return false
		}
		return true
	}
}
