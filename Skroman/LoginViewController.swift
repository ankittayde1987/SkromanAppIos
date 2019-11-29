//
//  LoginViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import GoogleSignIn
import RNLoadingButton_Swift
import SVProgressHUD

class LoginViewController: BaseViewController, UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate,QRCodeScannerViewControllerDelegate, addIPAddressDelegate {
    
    var tempPIObj : PI?
    @IBOutlet weak var vwConstant_iPadWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
	@IBOutlet weak var vwLogoAndAppNameContainer: UIView!
	@IBOutlet weak var vwMainBottomContainer: UIView!
	@IBOutlet weak var imagSmallAppLogo: UIImageView!
	@IBOutlet weak var lblAppName: UILabel!
	@IBOutlet weak var lblPleaseContinueLogin: UILabel!
	@IBOutlet weak var vwTextFieldContainer: UIView!
	@IBOutlet weak var txtEmail: UITextField!
	@IBOutlet weak var vwEmailAndPasswordSeprator: UIView!
	@IBOutlet weak var txtPassword: UITextField!
	@IBOutlet weak var btnForgotPassword: UIButton!
	@IBOutlet weak var btnLogin: RNLoadingButton!
	@IBOutlet weak var vwGoogleButtonContainer: UIView!
	@IBOutlet weak var imagGoogle: UIImageView!
	@IBOutlet weak var lblLoginWithGoogle: UILabel!
	@IBOutlet weak var btnGoogleLogin: RNLoadingButton!
	@IBOutlet weak var vwRegisterNowContainer: UIView!
	@IBOutlet weak var vwTopSeprator: UIView!
	@IBOutlet weak var btnNotAMember: UIButton!
	
    @IBOutlet weak var btnSecureText: UIButton!
    override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		initViewController()
		
		if #available(iOS 11.0, *) {
			scrollView.contentInsetAdjustmentBehavior = .never
		} else {
			self.automaticallyAdjustsScrollViewInsets = false
		}
		
        txtEmail.text = "sana10@test.com"
        txtPassword.text = "123456"
		
		
		self.btnGoogleLogin.isLoading = false
		self.showGoogleBtnTextAndImage()
        self.customiseUIForIPad()
     
        NotificationCenter.default.addObserver(self, selector: #selector(handleLinkUserIdAndPIIDAPISuccess(_:)), name: .handleLinkUserIdAndPIIDAPISuccess, object: nil)
       
        
	}
    
	func customiseUIForIPad()
    {
        if Utility.isIpad()
        {
            self.vwConstant_iPadWidth.constant = CONSTANT_IPAD_VIEW_WIDTH
            vwTopSeprator.backgroundColor = UICOLOR_MAIN_BG
        }
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// Hiding default navigation bar
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	func initViewController()
	{
		setFont()
		setColor()
		localizeText()
		setAttributedTextForButtonNotAMember()
	}
	func setFont()
	{
		lblAppName.font = Font_Titillium_Semibold_H25
		lblPleaseContinueLogin.font = Font_SanFranciscoText_Regular_H20
		txtEmail.font = Font_SanFranciscoText_Regular_H16
		txtPassword.font = Font_SanFranciscoText_Regular_H16
		btnForgotPassword.titleLabel?.font = Font_SanFranciscoText_Regular_H14
		btnLogin.titleLabel?.font = Font_SanFranciscoText_Regular_H16
		lblLoginWithGoogle.font = Font_SanFranciscoText_Regular_H16
		
		
		self.btnLogin.isLoading = false
		self.btnGoogleLogin.isLoading = false
	}
	func setColor()
	{
		view.backgroundColor = UICOLOR_MAIN_BG
		scrollView.backgroundColor = UICOLOR_MAIN_BG
		vwTextFieldContainer.backgroundColor = UICOLOR_TEXTFIELD_CONTAINER_BG
		vwEmailAndPasswordSeprator.backgroundColor = UICOLOR_SEPRATOR
		btnLogin.backgroundColor = UICOLOR_BLUE
		vwGoogleButtonContainer.backgroundColor = UICOLOR_RED
		vwMainBottomContainer.backgroundColor = UICOLOR_MAIN_BG
        vwTopSeprator.backgroundColor = UICOLOR_SEPRATOR
        
		
	
		vwTextFieldContainer.layer.borderWidth = 1.0
		vwTextFieldContainer.layer.borderColor = UICOLOR_TEXTFIELD_CONTAINER_BORDER.cgColor
		txtEmail.tintColor = .white
		txtPassword.tintColor = .white

	}
	func localizeText()
	{
		lblAppName.text = SSLocalizedString(key: "skroman")
		lblPleaseContinueLogin.text = SSLocalizedString(key: "please_login_to_continue")
		txtEmail.attributedPlaceholder = NSAttributedString(string: SSLocalizedString(key: "email"),
															attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
		txtPassword.attributedPlaceholder = NSAttributedString(string: SSLocalizedString(key: "password"),
															   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
		btnForgotPassword.setTitle(SSLocalizedString(key: "forgot_password"), for: .normal)
		btnForgotPassword.setTitle(SSLocalizedString(key: "forgot_password"), for: .selected)
		btnLogin.setTitle(SSLocalizedString(key: "login").uppercased(), for: .normal)
		btnLogin.setTitle(SSLocalizedString(key: "login").uppercased(), for: .selected)
		lblLoginWithGoogle.text = SSLocalizedString(key: "login_using_google")
	}
	
	fileprivate func setAttributedTextForButtonNotAMember() {
		let attributedString = NSMutableAttributedString()
		attributedString.append(NSAttributedString(string: SSLocalizedString(key: "not_a_member_questionmark"),
												   attributes: [.font: Font_SanFranciscoText_Regular_H14 ?? "",
																.foregroundColor:UICOLOR_WHITE]))
		
		attributedString.append(NSAttributedString(string: SSLocalizedString(key: "register_here"),
												   attributes: [.font: Font_SanFranciscoText_Regular_H14 ?? "",
																.foregroundColor: UICOLOR_BLUE]))
		
		
		let style = NSMutableParagraphStyle()
		style.alignment = .center
		attributedString.addAttributes([.paragraphStyle: style], range: NSMakeRange(0, attributedString.length))
		
		btnNotAMember.setAttributedTitle(attributedString, for: .normal)
		btnNotAMember.setAttributedTitle(attributedString, for: .selected)
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
		else if(Utility.isEmpty(val: txtPassword.text!)){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_password"))
			return false
		}
		return true
	}
	
	// MARK:- IBAction
	@IBAction func tappedForgotPassword(_ sender: Any) {
		hideKeyboard ({
            let nibName = Utility.getNibNameForClass(class_name: String.init(describing: ForgotPasswordViewController.self))
            let vc = ForgotPasswordViewController(nibName: nibName , bundle: nil)
            let navigationVC = UINavigationController(rootViewController: vc)
            self.present(navigationVC, animated: true, completion: nil)
		})
	}
	
	@IBAction func tappedLogin(_ sender: Any) {
        
//        UIAppDelegate.navigateToHomeScreen()
//        return
		
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
					// Create body for API
					let userBody: User = User()
					userBody.email = self.txtEmail.text
					userBody.password = self.txtPassword.text
					SkromanAppAPI().loginUserAPICall(body: userBody, success: { (obj) in
						// Done calling API
						
						// Hide the spinner
						SVProgressHUD.dismiss()
						// Login successful
						// Save user in NSUserDefaults and make logged in user as current user
						VVBaseUserDefaults.setUserObject(value: obj.result)
						//Set User Id
						VVBaseUserDefaults.setString((obj.result?.user_id)!, forKey: KEY_USER_ID)
                        
                        if obj.result?.piids == nil || obj.result?.piids?.count == 0
                        {
                            //Navigate to ScanQrCodeVC
                            self.navigateToQRCodeScannerViewController()
                        }
                        else
                        {

                            VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: true)

//                            self.getPreviousDataForAllHomesToAddInDB()
                            

                            
                                let piid = (obj.result?.piids![0])!
                                VVBaseUserDefaults.setCurrentPIID(pi_id: piid)
                            
                                Utility.delay(2, closure: {
                                    DispatchQueue.main.async {
                                        SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: true, success: { (str) in
                                            SVProgressHUD.dismiss()
                                            VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: true)
                                            SMQTTClient.sharedInstance().subscribeAllTopic()
                                            self.getPreviousData(piid:piid)
                                        }, failure: { (error) in
                                            SVProgressHUD.dismiss()
                                            let objUser = User()
                                            VVBaseUserDefaults.setUserObject(value: objUser)
                                            VVBaseUserDefaults.setString("", forKey: KEY_USER_ID)
                                            self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_global_server"))
                                        })
                                    }
                                })
                        }
                        
                        
						
					}, failure: { (error) in
						self.view.endEditing(true)
						SVProgressHUD.dismiss()
						Utility.showErrorNativeMessage(error: error)
					})
				}
			}
	}
    
    
//
//    func getPreviousDataForAllHomesToAddInDB(){
//
//
//            if !Utility.isAnyConnectionIssueToMakeGlobalAPI()
//            {
//                SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_GET_PREVIOUS_DATA_ACK) { (data, topic) in
//                    SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_GET_PREVIOUS_DATA_ACK)
//                    SSLog(message: "******************** SUCCESSSSSSSSSSSSSSSS ***********************")
//
//
//                    var responseDict : NSDictionary?
//                    do {
//                        let obj = try JSONSerialization.jsonObject(with: data!, options: [])
//                        responseDict = obj as? NSDictionary
//                        let objJson = Utility.JSONValue(object: responseDict)
//                        SSLog(message: objJson)
//                    } catch let error {
//                        print(error)
//                    }
//                    //
//
//
//                    if let objSync : SyncData? = SyncData.decode(data!){
//
//                        if objSync?.syncData == nil {
//
//                            Utility.delay(2){
//                                self.getPreviousDataForAllHomesToAddInDB()
//                            }
//                        }
//                        else{
//
//                            let syncCount : Int = (objSync?.syncData!.count)!
//
//                            if syncCount > 0 {
//
//
//                                //To set default HOME (Consider 0th index Home as Default)
//                                let obj = objSync?.syncData![i]
//
//                                DatabaseManager.sharedInstance().addHome(home_name: (obj?.home_name)!, home_id: (obj?.home_id)!, pi_id: arr[i] as! String)
//
//
//                                /* Call when all homes has been added */
//                                    self.makePreviousDataCall(piid: arr[0] as! String)
//                            }
//                        }
//
//                        SVProgressHUD.dismiss()
//                        print("here---- SM_TOPIC_GET_PREVIOUS_DATA_ACK \(topic)")
//                    }
//                }
//                let dict =  NSMutableDictionary()
//                dict.setValue(Utility.getCurrentUserId(), forKey: "user_id");
//                SSLog(message: "DICT FOR Previous data : \(dict)")
//                SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_GET_PREVIOUS_DATA) { (error) in
//                    if error != nil{
//                        Utility.showErrorAccordingToLocalAndGlobal()
//                    }
//                }
//            }
//    }
    
//    func makePreviousDataCall(piid:String) {
//
//        VVBaseUserDefaults.setCurrentPIID(pi_id: piid)
//
//        Utility.delay(2, closure: {
//            DispatchQueue.main.async {
//                SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: true, success: { (str) in
//                    SVProgressHUD.dismiss()
//                    VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: true)
//                    SMQTTClient.sharedInstance().subscribeAllTopic()
//                    self.getPreviousData(piid:piid)
//                }, failure: { (error) in
//                    SVProgressHUD.dismiss()
//                    let objUser = User()
//                    VVBaseUserDefaults.setUserObject(value: objUser)
//                    VVBaseUserDefaults.setString("", forKey: KEY_USER_ID)
//                    self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_global_server"))
//                })
//            }
//        })
//    }

    
    func navigateToQRCodeScannerViewController()
    {
        let vc = AddIPAddressViewController.init(nibName: "AddIPAddressViewController", bundle: nil)
        vc.ipDelegate = self
        vc.jumpedFrom = "signin"
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)


//        let vc = QRCodeScannerViewController.init(nibName: "QRCodeScannerViewController", bundle: nil)
//        vc.comefrom = QRCodeScannType.home
//        vc.delegate = self
//        let nav = UINavigationController.init(rootViewController: vc)
//        self.present(nav, animated: true, completion: nil)
    }

    
    
    func didReceivedIP(ipValue : String , from :String) {
        
        // Take a dictonary and associate home-name:{ homeid:ip-value}
        VVBaseUserDefaults.setCurrentHomeIP(home_ip: ipValue)
        
        SMQTTClient.sharedInstance().connectToServer(success: { (error) in
            if((error) != nil)
            {
                SVProgressHUD.dismiss()
                ToastMessage.showErrorMessageAppTitle(withMessage: SSLocalizedString(key: "unable_to_connect"))
                
            }else{
                
                SVProgressHUD.dismiss()
                SMQTTClient.sharedInstance().subscribe(topic: SM_GET_PI_ID_ACK) { (data, topic) in
                    print("here---- topic \(topic)")
                    SMQTTClient.sharedInstance().unsubscribe(topic: topic)
                    if data == nil{
                        Utility.showErrorAccordingToLocalAndGlobal()
                    }
                    else{
                        
                        if let objPI : PI? = PI.decode(data!){
                            self.tempPIObj = PI()
                            self.tempPIObj = objPI
                            
                            VVBaseUserDefaults.setCurrentPIID(pi_id: (objPI?.pi_id)!)
                            if objPI?.home_id != nil{
                                VVBaseUserDefaults.setCurrentHomeID(home_id: (objPI?.home_id)!)
                            }
                            
                            if objPI?.ssid != nil{
                                SSLog(message: "Add SSID in UserDefaults")
                                VVBaseUserDefaults.setCurrentSSID(ssid: (objPI?.ssid)!)
                            }
                            
                            if objPI?.password != nil{
                                VVBaseUserDefaults.setCurrentPASSWORD(password: (objPI?.password)!)
                            }
                            
                            
                            
                            DatabaseManager.sharedInstance().addPIDAndSSID(pid:(objPI?.pi_id)!, ssid: (objPI?.ssid)!, password: (objPI?.password)!)
                            
                            SVProgressHUD.show(withStatus: SSLocalizedString(key: "linking_account"))
                            
                            //API Call For link_user_and_pi
                            SVProgressHUD.show(withStatus: SSLocalizedString(key: "connecting"))
                            Utility.delay(2, closure: {
                                DispatchQueue.main.async {
                                    SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: true, success: { (str) in
                                        SVProgressHUD.dismiss()
                                        VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: true)
                                        SMQTTClient.sharedInstance().subscribeAllTopic()
                                        self.linkUserAndPiIdAPICall(page: from)
                                    }, failure: { (error) in
                                        SVProgressHUD.dismiss()
                                        let objUser = User()
                                        VVBaseUserDefaults.setUserObject(value: objUser)
                                        VVBaseUserDefaults.setString("", forKey: KEY_USER_ID)
                                        self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_global_server"))
                                    })
                                }
                            })
                        }
                        else
                        {
                            SVProgressHUD.dismiss()
                        }
                    }
                    
                }
                
            }
            let dict =  NSMutableDictionary()
            dict.setValue("send:me:pi:id", forKey: "user_unique_id");
            SSLog(message: "SM_GET_PI_ID: \(dict)")
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_GET_PI_ID) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        })
    }
    
    
    
    func linkUserAndPiIdAPICall(page:String)
    {
        SSLog(message: "************** linkUserAndPiIdAPICall **************")
        
        SSLog(message: "linkUserAndPiIdAPICall")
        if !Utility.isAnyConnectionIssue()
        {
            
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK)
                SSLog(message: "******************** SUCCESSSSSSSSSSSSSSSS ***********************")
                
                
                SVProgressHUD.show(withStatus: SSLocalizedString(key: "connecting"))
                Utility.delay(2, closure: {
                    DispatchQueue.main.async {
                        SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: false, success: { (str) in
                            SVProgressHUD.dismiss()
                            VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: false)
                            SMQTTClient.sharedInstance().subscribeAllTopic()
                            
                            
                            if self.tempPIObj?.home_id == nil     {
                                //Gaurav need to change
                                SVProgressHUD.dismiss()
                                // go to add new home screen as user don't have setup home yet
                                DispatchQueue.main.async {
                                    let nibName = Utility.getNibNameForClass(class_name: String.init(describing: AddNewHomeViewController.self))
                                    let vc = AddNewHomeViewController(nibName: nibName , bundle: nil)
                                    vc.comeFrom = .addNewHome
                                    vc.isComeFromRegisterVC = true
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            else {
                                
                                //Add Energy Data into table
                                SVProgressHUD.dismiss()
                                SSLog(message: "<<<<<<<<<<<<<<<<<<< startSyncWithDelay >>>>>>>>>>>>>>>>>>>>>>")
                                DispatchQueue.main.async {
                                    self.perform(#selector(self.startSyncWithDelay), with: self, afterDelay: 0.5)
                                }
                            }

                        }, failure: { (error) in
                            SVProgressHUD.dismiss()
                            let objUser = User()
                            VVBaseUserDefaults.setUserObject(value: objUser)
                            VVBaseUserDefaults.setString("", forKey: KEY_USER_ID)
                            self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_global_server"))
                        })
                    }
                })
                
                print("here---- SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK \(topic)")
                SVProgressHUD.dismiss()
            }
            
            let dict =  NSMutableDictionary()
            
            //{"user_id":"pradip12345678","pi_id":"PI-VI3MI5"}
            dict.setValue(Utility.getCurrentUserId(), forKey: "user_id");
            dict.setValue(VVBaseUserDefaults.getCurrentPIID(), forKey: "pi_id");
            SSLog(message: "DICT FOR LINKING : \(dict)")
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_LINK_USER_ID_AND_PI_ID) { (error) in
                if error != nil{
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
    
    
    

    
    @IBAction func tappedGoogleLogin(_ sender: Any) {
		signInWithGoogle()
		self.btnGoogleLogin.isLoading = true
		self.hideGoogleBtnTextAndImage()
	}
	
	func hideGoogleBtnTextAndImage()
	{
		self.imagGoogle.isHidden = true
		self.lblLoginWithGoogle.isHidden = true
	}
	func showGoogleBtnTextAndImage()
	{
		self.imagGoogle.isHidden = false
		self.lblLoginWithGoogle.isHidden = false
	}
	func signInWithGoogle()  {
		let signIn = GIDSignIn.sharedInstance()
		GIDSignIn.sharedInstance().serverClientID = GOOGLE_CLIENT_KEY
		let path: String? = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
		if let myDictionary = NSDictionary(contentsOfFile: path!) as? [String: Any] {
			signIn?.clientID = myDictionary["CLIENT_ID"] as! String!
			signIn?.shouldFetchBasicProfile = true
			signIn?.scopes = ["profile", "email","https://www.googleapis.com/auth/calendar"]
			signIn?.delegate = self
			signIn?.uiDelegate = self
			GIDSignIn.sharedInstance().signOut()
			GIDSignIn.sharedInstance().signIn()
		}
	}
	
	//MARK:- GIDSignInDelegate
	public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
	{
		if let error = error {
			btnGoogleLogin.isLoading = false
			self.showGoogleBtnTextAndImage()
			self.showAlertViewWithMessage(error.localizedDescription)
			print("\(error.localizedDescription)")
		} else {
			let objUser = User.initWithGoogle(user: user);
			SSLog(message: objUser)
			//API call
			self.callSocialLoginAPI(obj: objUser!)
		}
		
	}
	func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
		//        myActivityIndicator.stopAnimating()
	}
	
	// Present a view that prompts the user to sign in with Google
	func signIn(signIn: GIDSignIn!,
				presentViewController viewController: UIViewController!) {
		self.present(viewController, animated: true, completion: nil)
	}
	
	// Dismiss the "Sign in with Google" view
	func signIn(signIn: GIDSignIn!,
				dismissViewController viewController: UIViewController!) {
		self.dismiss(animated: true, completion: nil)
	}
	func callSocialLoginAPI(obj : User)
	{
		
		SkromanAppAPI().socialLoginAPI(body: obj, success: { (obj) in
			// Login successful
			self.btnGoogleLogin.isLoading = false
			self.showGoogleBtnTextAndImage()
			// Save user in NSUserDefaults and make logged in user as current user
			VVBaseUserDefaults.setUserObject(value: obj.result)
			//Set User Id
			VVBaseUserDefaults.setString((obj.result?.user_id)!, forKey: KEY_USER_ID)
            
            if obj.result?.piids == nil || obj.result?.piids?.count == 0
            {
                //Navigate to ScanQrCodeVC
                self.navigateToQRCodeScannerViewController()
            }
            else
            {
                //get data with piid and User id API call
//                self.getPreviousData(piid: (obj.result?.piids![0])!)
                
                let piid = (obj.result?.piids![0])!
                self.getSSIDAndPassword(piid)
            }
			
//            // Navigate to home screen
//            UIAppDelegate.navigateToHomeScreen()
		}) { (error) in
			self.btnGoogleLogin.isLoading = false
			self.showGoogleBtnTextAndImage()
			let vc = RegisterViewController.init(nibName: "RegisterViewController", bundle: nil)
			vc.objUser = obj
			vc.isComeFromSocialLogin = true
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	
	@IBAction func tappedRegisterHere(_ sender: Any) {
        let nibName = Utility.getNibNameForClass(class_name: String.init(describing: RegisterViewController.self))
        let vc = RegisterViewController(nibName: nibName , bundle: nil)
        vc.objUser = User.dummyRegisterUser()
        self.navigationController?.pushViewController(vc, animated: true)
	}
    
    
    
    func getPreviousData(piid : String)
    {
        SSLog(message: "PIID : \(piid)")
        SSLog(message: "************** getPreviousData **************")
        SVProgressHUD.show(withStatus: SSLocalizedString(key: "sync"))
        SSLog(message: "getPreviousData")
        if !Utility.isAnyConnectionIssueToMakeGlobalAPI()
        {
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_GET_PREVIOUS_DATA_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_GET_PREVIOUS_DATA_ACK)
                SSLog(message: "******************** SUCCESSSSSSSSSSSSSSSS ***********************")
                
                
                var responseDict : NSDictionary?
                do {
                    let obj = try JSONSerialization.jsonObject(with: data!, options: [])
                    responseDict = obj as? NSDictionary
                    let objJson = Utility.JSONValue(object: responseDict)
                    SSLog(message: objJson)
                } catch let error {
                    print(error)
                }
//

                
                if let objSync : SyncData? = SyncData.decode(data!){
                    
                    if objSync?.syncData == nil {
                        
                        Utility.delay(2){
                            self.getPreviousData(piid: piid)
                        }
                    }
                    else{
                        
                        let arrayOfHomes = NSMutableArray()
                        
                        let syncCount : Int = (objSync?.syncData!.count)!
                    
                            if syncCount > 0 {
                        
                                for i in 0 ..< syncCount {

                                    let obj = objSync?.syncData![i]
                                    arrayOfHomes.add(obj?.home_name as Any)
                                    DatabaseManager.sharedInstance().addHome(home_name: (obj?.home_name)!, home_id: (obj?.home_id)!, pi_id: (obj?.pi_id)!)
                                }
                                
                                //To set default HOME (Consider 0th index Home as Default)
                                let obj = objSync?.syncData![0]
                                VVBaseUserDefaults.setCurrentHomeID(home_id: (obj?.home_id)!)
                        
                        
                                //delete old data and insert new data
                                DatabaseManager.sharedInstance().deleteAndSyncData(objSyncData: objSync!)
                                //redirect to Home vc
                        
                                //SUBSCRIBE_ALL_TOPICS
                                SMQTTClient.sharedInstance().subscribeAllTopic();
                                UIAppDelegate.navigateToHomeScreen()
                                



                            }
                    }
                    
                    SVProgressHUD.dismiss()
                    print("here---- SM_TOPIC_GET_PREVIOUS_DATA_ACK \(topic)")
                }
            }
            let dict =  NSMutableDictionary()
            dict.setValue(Utility.getCurrentUserId(), forKey: "user_id");
            SSLog(message: "DICT FOR Previous data : \(dict)")
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_GET_PREVIOUS_DATA) { (error) in
                if error != nil{
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }

    //QRCodeScannerViewController delegate methods
    func didSuccess(ssid : String, password : String) -> Void
    {
        Utility.delay(4) {
            self.didSuccessWithDelay(strSSID: ssid)
        }
    }
    
    
    func didFailure() -> Void
    {
        self.showAlertMessage(strMessage: SSLocalizedString(key: "unable_to_connect_login_and_continue"))
//        ToastMessage.showErrorMessageAppTitle(withMessage: SSLocalizedString(key: "unable_to_connect_login_and_continue"))
        //TO Make User obj empty
        let objUser = User()
        VVBaseUserDefaults.setUserObject(value: objUser)
        VVBaseUserDefaults.setString("", forKey: KEY_USER_ID)
    }
    
    @objc func didSuccessWithDelay(strSSID : String)
    {
        SMQTTClient.sharedInstance().connectToServer(success: { (error) in
            if((error) != nil)
            {
                SVProgressHUD.dismiss()
                
                //TO REMOVE WIFI
                let manager = UIAppDelegate.manager
                manager?.remove(ssid: strSSID, completion: { (err) in
                })
                
                self.showAlertMessage(strMessage: SSLocalizedString(key: "unable_to_connect_login_and_continue"))
//                ToastMessage.showErrorMessageAppTitle(withMessage: SSLocalizedString(key: "unable_to_connect_login_and_continue"))
                let objUser = User()
                VVBaseUserDefaults.setUserObject(value: objUser)
                VVBaseUserDefaults.setString("", forKey: KEY_USER_ID)
                return
                    SSLog(message: "INSIDE ERROR : \(error ?? "rrrr" as! Error)")
                
            }else{
                SVProgressHUD.dismiss()
                SMQTTClient.sharedInstance().subscribe(topic: SM_GET_PI_ID_ACK) { (data, topic) in
                    print("here---- topic \(topic)")
                    
                    SMQTTClient.sharedInstance().unsubscribe(topic: topic)
                    if data == nil{
                        SSLog(message: "DATA NIL")
                        //TO REMOVE WIFI And Show connection issue
                        let manager = UIAppDelegate.manager
                        manager?.remove(ssid: strSSID, completion: { (err) in
                        })
                        Utility.showErrorAccordingToLocalAndGlobal()
                    }
                    else{
                        if let objPI : PI? = PI.decode(data!){
                            self.tempPIObj = PI()
                            self.tempPIObj = objPI
                            
                            VVBaseUserDefaults.setCurrentPIID(pi_id: (objPI?.pi_id)!)
                            if objPI?.home_id != nil{
                                VVBaseUserDefaults.setCurrentHomeID(home_id: (objPI?.home_id)!)
                            }
                            
                            if objPI?.ssid != nil{
                                SSLog(message: "Add SSID in UserDefaults")
                                VVBaseUserDefaults.setCurrentSSID(ssid: (objPI?.ssid)!)
                            }
                            
                            if objPI?.password != nil{
                                VVBaseUserDefaults.setCurrentPASSWORD(password: (objPI?.password)!)
                            }
                            
                            DatabaseManager.sharedInstance().addPIDAndSSID(pid:(objPI?.pi_id)!, ssid: (objPI?.ssid)!, password: (objPI?.password)!)
                            
                            //API Call For link_user_and_pi
                            SVProgressHUD.show(withStatus: SSLocalizedString(key: "connecting"))
                            Utility.delay(2, closure: {
                                DispatchQueue.main.async {
                                    SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: true, success: { (str) in
                                        SVProgressHUD.dismiss()
                                        VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: true)
                                        SMQTTClient.sharedInstance().subscribeAllTopic()
                                        self.linkUserAndPiIdAPICall()
                                    }, failure: { (error) in
                                        SVProgressHUD.dismiss()
                                        let objUser = User()
                                        VVBaseUserDefaults.setUserObject(value: objUser)
                                        VVBaseUserDefaults.setString("", forKey: KEY_USER_ID)
                                        self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_global_server"))
                                    })
                                }
                            })
                        }
                        else
                        {
                            SVProgressHUD.dismiss()
                        }
                    }
                    
                }
                
            }
            let dict =  NSMutableDictionary()
            dict.setValue("send:me:pi:id", forKey: "user_unique_id");
            //            let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            //            SMQTTClient.sharedInstance().publishData(data: data, topic: SM_GET_PI_ID) { (error) in
            //
            //            }
            SSLog(message: "SM_GET_PI_ID: \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_GET_PI_ID) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        })
    }
    @objc func startSyncWithDelay()
    {
        if Utility.isRestrictOperation()
        {
            self.syncGlobalData()
        }
        else
        {
            self.syncLocalData()
        }
    }
    
    func linkUserAndPiIdAPICall()
    {
        SSLog(message: "************** linkUserAndPiIdAPICall **************")
        SVProgressHUD.show()
        SSLog(message: "linkUserAndPiIdAPICall")
        if !Utility.isAnyConnectionIssue()
        {
            
            
            /*SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK)
                SSLog(message: "******************** SUCCESSSSSSSSSSSSSSSS ***********************")
                
                SVProgressHUD.dismiss()
                if self.tempPIObj?.home_id == nil
                {
                    SVProgressHUD.dismiss()
                    // go to add new home screen as user don't have setup home yet
                    let nibName = Utility.getNibNameForClass(class_name: String.init(describing: AddNewHomeViewController.self))
                    let vc = AddNewHomeViewController(nibName: nibName , bundle: nil)
                    vc.comeFrom = .addNewHome
                    vc.isComeFromRegisterVC = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    //Add Energy Data into table
                    self.perform(#selector(self.startSyncWithDelay), with: self, afterDelay: 0.5)
                    
                }
                print("here---- SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK \(topic)")

                SVProgressHUD.dismiss()
            }*/
            
            let dict =  NSMutableDictionary()
            
            //{"user_id":"pradip12345678","pi_id":"PI-VI3MI5"}
            dict.setValue(Utility.getCurrentUserId(), forKey: "user_id");
            dict.setValue(VVBaseUserDefaults.getCurrentPIID(), forKey: "pi_id");
            SSLog(message: "DICT FOR LINKING : \(dict)")
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_LINK_USER_ID_AND_PI_ID) { (error) in
                if error != nil{
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
    @objc func handleLinkUserIdAndPIIDAPISuccess(_ notification: Notification)
    {
        if let topVC = UIApplication.getTopMostViewController() {
            SSLog(message: topVC);
            if topVC is LoginViewController
            {
                if self.tempPIObj?.home_id == nil
                {
                    //SWITCH BACK TO LOCAL
                    Utility.delay(2, closure: {
                        DispatchQueue.main.async {
                            SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: false, success: { (str) in
                                SVProgressHUD.dismiss()
                                VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: false)
                                SMQTTClient.sharedInstance().subscribeAllTopic()
                                
                                Utility.delay(0, closure: {
                                    // go to add new home screen as user don't have setup home yet
                                    let nibName = Utility.getNibNameForClass(class_name: String.init(describing: AddNewHomeViewController.self))
                                    let vc = AddNewHomeViewController(nibName: nibName , bundle: nil)
                                    vc.comeFrom = .addNewHome
                                    vc.isComeFromRegisterVC = true
                                    self.navigationController?.pushViewController(vc, animated: true)
                                    
                                })
                                
                            }, failure: { (error) in
                                SVProgressHUD.dismiss()
                                let objUser = User()
                                VVBaseUserDefaults.setUserObject(value: objUser)
                                VVBaseUserDefaults.setString("", forKey: KEY_USER_ID)
                                self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_local_server"))
                            })
                        }
                    })
                }
                else
                {
                    //Add Energy Data into table
                    self.perform(#selector(self.startSyncWithDelay), with: self, afterDelay: 0.5)
                    
                }
            }
            else
            {
                 SSLog(message: "Not LoginViewController");
            }
        }
    }
    
    
    @IBAction func tappedOnSecureText(_ sender: Any) {
        self.btnSecureText.isSelected = !self.btnSecureText.isSelected
        self.txtPassword.isSecureTextEntry = !self.txtPassword.isSecureTextEntry
    }
    
    
    //API CALL BY GAURAV ISSUE
    func getSSIDAndPassword(_ piid : String)
    {
        if !Utility.isAnyConnectionIssueToMakeGlobalAPI()
        {
            SVProgressHUD.show()
            SSLog(message: "API SM_TOPIC_GLOBAL_GET_SSID_AND_PASSWORD_ACK")
            let TOPIC_ACK = "global_vps_app/\(Utility.getCurrentUserId())/get_ssid_password_ack"
            SMQTTClient.sharedInstance().subscribe(topic: TOPIC_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: TOPIC_ACK)
                SSLog(message: "SUCCESSSSS  :: \(topic)")
                if topic == TOPIC_ACK
                {
                    
                    var responseDict : NSDictionary?
                    do {
                        let obj = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(obj)
                        responseDict = obj as? NSDictionary
                    } catch let error {
                        print(error)
                    }
                    let ssid = responseDict?.value(forKey: "ssid") as! String
                    let password = responseDict?.value(forKey: "password") as! String
                    // set Default PIID
                    VVBaseUserDefaults.setCurrentPIID(pi_id: piid)
                    //To set Default SSID (In future SSID and PIID will be Same)
                    VVBaseUserDefaults.setCurrentSSID(ssid: ssid)
                    //To set Default Password (In future Password and PIID will be Same)
                    VVBaseUserDefaults.setCurrentPASSWORD(password: password)
                    DatabaseManager.sharedInstance().addPIDAndSSID(pid: piid, ssid: ssid, password: password)
                    
                    
                    //get data with piid and User id API call
                    SVProgressHUD.dismiss()
                    SVProgressHUD.show(withStatus: SSLocalizedString(key: "please_wait_only"))
                    Utility.delay(4) {
                        SVProgressHUD.dismiss()
                        self.getPreviousData(piid: piid)
                    }
                }
            }
            let dict =  NSMutableDictionary()
            dict.setValue(piid, forKey: "pi_id");
            dict.setValue(Utility.getCurrentUserId(), forKey: "user_id");
            SSLog(message: dict)
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: "global_in/\(piid)/get_ssid_password") { (error) in
                if((error) != nil)
                {
                    SVProgressHUD.dismiss()
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
                print("error :\(String(describing: error))")
            }
        }
    }
    
    
    
    
    
    
    func syncLocalData()
    {
        if !Utility.isAnyConnectionIssue()
        {
            SVProgressHUD.show(withStatus: SSLocalizedString(key: "sync..."))
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_SYNC_EVERYTHING_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_SYNC_EVERYTHING_ACK)
                
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_SYNC_EVERYTHING_ACK)
                {
                    if let objSync : SyncData? = SyncData.decode(data!){
                        
                        for objHome in objSync!.syncData! {
                            
                            print(objHome.home_name)
                            break
                        }

                        if((objSync?.syncData?.count)!>0)
                        {
                            //delete old data and insert new data
                            DatabaseManager.sharedInstance().deleteAndSyncData(objSyncData: objSync!)
                            //redirect to Home vc
                            UIAppDelegate.navigateToHomeScreen()
                        }
                        print("here---- SM_TOPIC_SYNC_EVERYTHING_ACK \(topic)")}
                    //redirect to home page
                    SVProgressHUD.dismiss()
                }
                
            }
            
            let dict =  NSMutableDictionary()
            dict.setValue("1", forKey: "sync");
            //            let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_SYNC_EVERYTHING) { (error) in
                if error != nil
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
    func syncGlobalData()
    {
        if !Utility.isAnyConnectionIssueToMakeGlobalAPI()
        {
            SVProgressHUD.show(withStatus: SSLocalizedString(key: "sync..."))
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU)
                
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU)
                {
                    if let objSync : SyncData? = SyncData.decode(data!){
                        
                        if((objSync?.syncData?.count)!>0)
                        {
                            //delete old data and insert new data
                            DatabaseManager.sharedInstance().deleteAndSyncData(objSyncData: objSync!)
                            //redirect to Home vc
                            SMQTTClient.sharedInstance().subscribeAllTopic();
                            UIAppDelegate.navigateToHomeScreen()
                        }
                        print("here---- SM_TOPIC_SYNC_EVERYTHING_ACK \(topic)")}
                    //redirect to home page
                    SVProgressHUD.dismiss()
                }
                
            }
            
            let dict =  NSMutableDictionary()
            dict.setValue(VVBaseUserDefaults.getCurrentPIID(), forKey: "pi_id");
            dict.setValue(Utility.getCurrentUserId(), forKey: "user_id");
            //            let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_LEFT_MENU) { (error) in
                if error != nil
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
}
