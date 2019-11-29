//
//  ForgotPasswordViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 10/25/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import RNLoadingButton_Swift
import SVProgressHUD

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var vwConstant_iPadWidth: NSLayoutConstraint!
    @IBOutlet weak var btnSubmit: RNLoadingButton!
	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var txtEmail: UITextField!
	@IBOutlet weak var vwTxtFieldContainer: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.initViewController()
		self.backButtonSetup()
		self.title = SSLocalizedString(key: "forgot_password")
		self.txtEmail.becomeFirstResponder()
        self.customiseUIForIPad()
    }
    func customiseUIForIPad()
    {
        if Utility.isIpad()
        {
            self.vwConstant_iPadWidth.constant = CONSTANT_IPAD_VIEW_WIDTH
        }
    }
	override func backButtonTapped() {
		self.view.endEditing(true)
		self.dismiss(animated: true, completion: nil)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.isNavigationBarHidden = false
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.isNavigationBarHidden = true
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func initViewController()
	{
		setFont()
		setColor()
		localizeText()
	}
	func setFont()
	{
		txtEmail.font = Font_SanFranciscoText_Regular_H16
		btnSubmit.titleLabel?.font = Font_SanFranciscoText_Regular_H16
		self.btnSubmit.isLoading = false
	}
	func setColor()
	{
		view.backgroundColor = UICOLOR_MAIN_BG
		vwTxtFieldContainer.backgroundColor = UICOLOR_TEXTFIELD_CONTAINER_BG
		btnSubmit.backgroundColor = UICOLOR_BLUE
		vwSeprator.backgroundColor = UICOLOR_SEPRATOR
		
		vwTxtFieldContainer.layer.borderWidth = 1.0
		vwTxtFieldContainer.layer.borderColor = UICOLOR_TEXTFIELD_CONTAINER_BORDER.cgColor
		txtEmail.tintColor = .white
		
	}
	func localizeText()
	{
		txtEmail.attributedPlaceholder = NSAttributedString(string: SSLocalizedString(key: "email"),
															attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
		btnSubmit.setTitle(SSLocalizedString(key: "submit"), for: .normal)
		btnSubmit.setTitle(SSLocalizedString(key: "submit"), for: .selected)
	}
	@IBAction func tappedOnSubmit(_ sender: Any) {
//		self.dismiss(animated: true, completion: nil)
		
		
		hideKeyboard({
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
					SkromanAppAPI().forgotPasswordAPICall(email: self.txtEmail.text!, success: { (message) in
						// Done calling API
						self.view.endEditing(true)
						// Hide the spinner
						SVProgressHUD.dismiss()
						ToastMessage.showSuccessMessage(message)
						self.dismiss(animated: true, completion: nil)
						
					}, failure: { (error) in
						SVProgressHUD.dismiss()
						Utility.showErrorNativeMessage(error: error)
					})
				}
			}
		})
		
		
	}
	
	// MARK:- validateUserEnteredData method
	func validateUserEnteredData() -> Bool {
		if(Utility.isEmpty(val: txtEmail.text!.removingWhitespaces())){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_email_address"))
			return false
		}
		else if !(Utility.isEmailValid(txtEmail.text!)){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_valid_email_address"))
			return false
		}
		return true
	}

}
