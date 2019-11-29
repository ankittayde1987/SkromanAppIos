//
//  MyProfileViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SVProgressHUD

class MyProfileViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var vwConstant_iPadWidth: NSLayoutConstraint!
    var objUser = User()
	@IBOutlet weak var btnChnagePassword: UIButton!
	@IBOutlet var vwTableFooter: UIView!
	@IBOutlet weak var btnUserImage: UIButton!
	@IBOutlet var vwTableHeader: UIView!
	@IBOutlet weak var btnSave: UIButton!
	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var vwBottomContainer: UIView!
	@IBOutlet weak var tableView: TPKeyboardAvoidingTableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		self.initViewController()
	}
	func initViewController()
	{
		self.title = SSLocalizedString(key: "my_profile")
		self.view.backgroundColor = UICOLOR_MAIN_BG
		self.tableView.backgroundColor = UICOLOR_MAIN_BG
		self.vwTableHeader.backgroundColor = UICOLOR_MAIN_BG
		self.vwTableFooter.backgroundColor = UICOLOR_MAIN_BG
		self.vwBottomContainer.backgroundColor = UICOLOR_BLUE
		self.btnSave.backgroundColor = UICOLOR_BLUE
		self.vwSeprator.backgroundColor = UICOLOR_SEPRATOR
		self.btnSave.titleLabel?.font = Font_SanFranciscoText_Regular_H16
		self.btnChnagePassword.titleLabel?.font = Font_SanFranciscoText_Medium_H16
		self.btnChnagePassword.titleLabel?.textColor = UICOLOR_CHANGE_PW_TEXT
		self.btnChnagePassword.setTitle(SSLocalizedString(key: "change_password"), for: .normal)
		self.btnChnagePassword.setTitle(SSLocalizedString(key: "change_password"), for: .selected)
		self.setupTableView()
		self.tableView.tableHeaderView = self.vwTableHeader
		self.tableView.tableFooterView = self.vwTableFooter
        self.customiseUIForIPad()
	}
    func customiseUIForIPad()
    {
        if Utility.isIpad()
        {
            self.vwConstant_iPadWidth.constant = CONSTANT_IPAD_VIEW_WIDTH
        }
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
		cell.configureCellForMyProfileVC(obj: self.objUser, indexPath: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}
	//MARK:- IBAction
	@IBAction func tappedOnSave(_ sender: Any) {
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
				SkromanAppAPI().updateUserAPI(body: self.objUser, success: { (obj) in
					// Done calling API
					
					// Hide the spinner
					SVProgressHUD.dismiss()
					self.view.endEditing(true)
					// Save user in NSUserDefaults and make logged in user as current user
					VVBaseUserDefaults.setUserObject(value: obj.result)
					//Set User Id
					
					// Navigate to QRCodeScanner screen
					self.navigationController?.popViewController(animated: true)
					
				}, failure: { (error) in
					self.view.endEditing(true)
					SVProgressHUD.dismiss()
					Utility.showErrorNativeMessage(error: error)
				})
			}
		}
	}
	
	@IBAction func tappedOnUserImage(_ sender: Any) {
	}
	
	@IBAction func tappedOnChangePassword(_ sender: Any) {
        let nibName = Utility.getNibNameForClass(class_name: String.init(describing: ChnagePasswordViewController.self))
        let vc = ChnagePasswordViewController(nibName: nibName , bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
	}
	
	
	// MARK:- validateUserEnteredData method
	func validateUserEnteredData() -> Bool {
		if(Utility.isEmpty(val: objUser.name?.removingWhitespaces())){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_name"))
			return false
		}
//		else if(Utility.isEmpty(val: objUser.email?.removingWhitespaces())){
//			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_email_address"))
//			return false
//		}
//		else if !(Utility.isEmailValid(objUser.email!)){
//			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_valid_email_address"))
//			return false
//		}
		else if(Utility.isEmpty(val: objUser.phoneNumber?.removingWhitespaces())){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_mobile_number"))
			return false
		}
		return true
	}
}
