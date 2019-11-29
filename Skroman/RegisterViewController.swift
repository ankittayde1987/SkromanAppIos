//
//  RegisterViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SVProgressHUD
class RegisterViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,RegisterFooterTableViewCellDelegate,QRCodeScannerViewControllerDelegate, addIPAddressDelegate {
	
    @IBOutlet weak var vwConstant_iPadWidth: NSLayoutConstraint!
    var objUser = User()
	var isComeFromSocialLogin : Bool? = false
	@IBOutlet weak var btnAlreadyAMemberLogin: UIButton!
	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var vwFixBottom: UIView!
	@IBOutlet weak var tableView: TPKeyboardAvoidingTableView!
    
    var tempPIObj : PI?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		setupTableView()
		view.backgroundColor = UICOLOR_MAIN_BG
		tableView.backgroundColor = UICOLOR_MAIN_BG
		vwFixBottom.backgroundColor = UICOLOR_CONTAINER_BG
		vwSeprator.backgroundColor = UICOLOR_SEPRATOR
		setAttributedTextForButtonAlreasyAMember()
        customiseUIForIPad()
         NotificationCenter.default.addObserver(self, selector: #selector(handleLinkUserIdAndPIIDAPISuccess(_:)), name: .handleLinkUserIdAndPIIDAPISuccess, object: nil)
        
	}
    func customiseUIForIPad()
    {
        if Utility.isIpad()
        {
            self.vwConstant_iPadWidth.constant = CONSTANT_IPAD_VIEW_WIDTH
            vwSeprator.backgroundColor = UICOLOR_MAIN_BG
            vwFixBottom.backgroundColor = UICOLOR_MAIN_BG
        }
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Hiding default navigation bar
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	fileprivate func setAttributedTextForButtonAlreasyAMember() {
		let attributedString = NSMutableAttributedString()
		attributedString.append(NSAttributedString(string: SSLocalizedString(key: "already_a_member_questionmark"),
												   attributes: [.font: Font_SanFranciscoText_Regular_H14 ?? "",
																.foregroundColor:UICOLOR_WHITE]))
		
		attributedString.append(NSAttributedString(string: SSLocalizedString(key: "login"),
												   attributes: [.font: Font_SanFranciscoText_Regular_H14 ?? "",
																.foregroundColor: UICOLOR_BLUE]))
		
		
		let style = NSMutableParagraphStyle()
		style.alignment = .center
		attributedString.addAttributes([.paragraphStyle: style], range: NSMakeRange(0, attributedString.length))
		
		btnAlreadyAMemberLogin.setAttributedTitle(attributedString, for: .normal)
		btnAlreadyAMemberLogin.setAttributedTitle(attributedString, for: .selected)
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func setupTableView() {
		// Registering nibs
		tableView.register(UINib.init(nibName: "RegisterHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "RegisterHeaderTableViewCell")
		tableView.register(UINib.init(nibName: "RegisterFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "RegisterFooterTableViewCell")
		tableView.register(UINib.init(nibName: "TextFieldContainerTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldContainerTableViewCell")
		
		// Stop auto adjustment of content inset
		if #available(iOS 11.0, *) {
			tableView.contentInsetAdjustmentBehavior = .never
		} else {
			self.automaticallyAdjustsScrollViewInsets = false
		}
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 400
	}
	
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (section == 1) {
			if isComeFromSocialLogin!
			{
				return 3
			}
			else
			{
				return 5
			}
		}
		
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterHeaderTableViewCell", for: indexPath) as! RegisterHeaderTableViewCell
			return cell
		} else if indexPath.section == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldContainerTableViewCell", for: indexPath) as! TextFieldContainerTableViewCell
			cell.configureCellWithIndexPath(indexPath: indexPath, obj: self.objUser)
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterFooterTableViewCell", for: indexPath) as! RegisterFooterTableViewCell
			cell.delegate = self
			return cell
		}
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}
	
	// MARK: - IBAction
	
	@IBAction func tappedAlreadyAMember(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
	}
	// MARK: -RegisterFooterTableViewCellDelegate
	func tappedSubmit() {
		
//        self.navigateToQRCodeScannerViewController()
//        return
        
		self.view.endEditing(true)
		// Befor register validate if user has entered correct data or not
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
                self.view.isUserInteractionEnabled = false;
				SkromanAppAPI().registerNewUser(body: self.objUser, success: { (obj) in
					// Done calling API
					
					// Hide the spinner
					SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true;
					self.view.endEditing(true)
					// Save user in NSUserDefaults and make logged in user as current user
					VVBaseUserDefaults.setUserObject(value: obj.result)
					//Set User Id
					VVBaseUserDefaults.setString((obj.result?.user_id)!, forKey: KEY_USER_ID)
					
					// Navigate to QRCodeScanner screen
					self.navigateToQRCodeScannerViewController()
					
				}, failure: { (error) in
					self.view.endEditing(true)
                     self.view.isUserInteractionEnabled = true;
					SVProgressHUD.dismiss()
					Utility.showErrorNativeMessage(error: error)
				})
			}
		}
	}
	func navigateToQRCodeScannerViewController()
	{
//        let vc = QRCodeScannerViewController.init(nibName: "QRCodeScannerViewController", bundle: nil)
//        vc.comefrom = QRCodeScannType.home
//        vc.delegate = self as QRCodeScannerViewControllerDelegate
//        let nav = UINavigationController.init(rootViewController: vc)
//        self.present(nav, animated: true, completion: nil)

        let vc = AddIPAddressViewController.init(nibName: "AddIPAddressViewController", bundle: nil)
        vc.ipDelegate = self
        vc.jumpedFrom = "registration"
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)

        
	}
    
    
//

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
                                        self.linkUserAndPiIdAPICall(page: "registration")
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
        
//        let myhome = MyHomesViewController()
//        myhome.didReceivedIP(ipValue: ipValue, from: from)
//
//        self.navigationController?.dismiss(animated: true, completion: nil)
        
        
//        let vc = AddIPAddressViewController.init(nibName: "AddIPAddressViewController", bundle: nil)
//        vc.ipDelegate = self
//        vc.jumpedFrom = "registration"
//        let nav = UINavigationController.init(rootViewController: vc)
//        self.present(nav, animated: true, completion: nil)


    //
//        // Take a dictonary and associate home-name:{ homeid:ip-value}
//        VVBaseUserDefaults.setCurrentHomeIP(home_ip: ipValue)
//
//        SMQTTClient.sharedInstance().connectToServer(success: { (error) in
//            if((error) != nil)
//            {
//                SVProgressHUD.dismiss()
//                ToastMessage.showErrorMessageAppTitle(withMessage: SSLocalizedString(key: "unable_to_connect"))
//
//            }else{
//
//                SVProgressHUD.dismiss()
//                SMQTTClient.sharedInstance().subscribe(topic: SM_GET_PI_ID_ACK) { (data, topic) in
//                    print("here---- topic \(topic)")
//                    SMQTTClient.sharedInstance().unsubscribe(topic: topic)
//                    if data == nil{
//                        Utility.showErrorAccordingToLocalAndGlobal()
//                    }
//                    else{
//
//                        if let objPI : PI? = PI.decode(data!){
//                            self.tempPIObj = PI()
//                            self.tempPIObj = objPI
//
//                            VVBaseUserDefaults.setCurrentPIID(pi_id: (objPI?.pi_id)!)
//                            if objPI?.home_id != nil{
//                                VVBaseUserDefaults.setCurrentHomeID(home_id: (objPI?.home_id)!)
//                            }
//
//                            if objPI?.ssid != nil{
//                                SSLog(message: "Add SSID in UserDefaults")
//                                VVBaseUserDefaults.setCurrentSSID(ssid: (objPI?.ssid)!)
//                            }
//
//                            if objPI?.password != nil{
//                                VVBaseUserDefaults.setCurrentPASSWORD(password: (objPI?.password)!)
//                            }
//
//
//                            DatabaseManager.sharedInstance().addPIDAndSSID(pid:(objPI?.pi_id)!, ssid: (objPI?.ssid)!, password: (objPI?.password)!)
//
//                            SVProgressHUD.show(withStatus: SSLocalizedString(key: "linking_account"))
//
//                            //API Call For link_user_and_pi
//                            SVProgressHUD.show(withStatus: SSLocalizedString(key: "connecting"))
//                            Utility.delay(2, closure: {
//                                DispatchQueue.main.async {
//                                    SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: true, success: { (str) in
//                                        SVProgressHUD.dismiss()
//                                        VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: true)
//                                        SMQTTClient.sharedInstance().subscribeAllTopic()
//                                        self.linkUserAndPiIdAPICallFirst()
//                                    }, failure: { (error) in
//                                        SVProgressHUD.dismiss()
//                                        let objUser = User()
//                                        VVBaseUserDefaults.setUserObject(value: objUser)
//                                        VVBaseUserDefaults.setString("", forKey: KEY_USER_ID)
//                                        self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_global_server"))
//                                    })
//                                }
//                            })
//                        }
//                        else
//                        {
//                            SVProgressHUD.dismiss()
//                        }
//                    }
//
//                }
//
//            }
//            let dict =  NSMutableDictionary()
//            dict.setValue("send:me:pi:id", forKey: "user_unique_id");
//            SSLog(message: "SM_GET_PI_ID: \(dict)")
//
//            let deadlineTime = DispatchTime.now() + 5.0
//            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
//
//
//                SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_GET_PI_ID) { (error) in
//                    print("error :\(String(describing: error))")
//                    if((error) != nil)
//                    {
//                        Utility.showErrorAccordingToLocalAndGlobal()
//                    }
//                }
//            })
//
//        })
//    }
//
//
//
//    func linkUserAndPiIdAPICallFirst()
//    {
//        SSLog(message: "************** linkUserAndPiIdAPICall **************")
//
//        SSLog(message: "linkUserAndPiIdAPICall")
//        if !Utility.isAnyConnectionIssue()
//        {
//
//            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK) { (data, topic) in
//                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK)
//                SSLog(message: "******************** SUCCESSSSSSSSSSSSSSSS ***********************")
//
//
//                SVProgressHUD.show(withStatus: SSLocalizedString(key: "connecting"))
//                Utility.delay(2, closure: {
//                    DispatchQueue.main.async {
//                        SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: false, success: { (str) in
//                            SVProgressHUD.dismiss()
//                            VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: false)
//                            SMQTTClient.sharedInstance().subscribeAllTopic()
//
//                            if self.tempPIObj?.home_id != nil
//                            {
//                                //Gaurav need to change
//                                SVProgressHUD.dismiss()
//                                // go to add new home screen as user don't have setup home yet
//                                DispatchQueue.main.async {
//                                    let nibName = Utility.getNibNameForClass(class_name: String.init(describing: AddNewHomeViewController.self))
//                                    let vc = AddNewHomeViewController(nibName: nibName , bundle: nil)
//                                    vc.comeFrom = .addNewHome
//                                    vc.isComeFromRegisterVC = true
//                                    self.navigationController?.pushViewController(vc, animated: true)
//                                }
//
//                            }
//                            else
//                            {
//                                //Add Energy Data into table
//                                SVProgressHUD.dismiss()
//                                SSLog(message: "<<<<<<<<<<<<<<<<<<< startSyncWithDelay >>>>>>>>>>>>>>>>>>>>>>")
//                                DispatchQueue.main.async {
//                                    self.perform(#selector(self.startSyncWithDelay), with: self, afterDelay: 0.5)
//                                }
//
//
//                            }
//
//                        }, failure: { (error) in
//                            SVProgressHUD.dismiss()
//                            let objUser = User()
//                            VVBaseUserDefaults.setUserObject(value: objUser)
//                            VVBaseUserDefaults.setString("", forKey: KEY_USER_ID)
//                            self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_global_server"))
//                        })
//                    }
//                })
//
//                print("here---- SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK \(topic)")
//                SVProgressHUD.dismiss()
//            }
//
//            let dict =  NSMutableDictionary()
//
//            //{"user_id":"pradip12345678","pi_id":"PI-VI3MI5"}
//            dict.setValue(Utility.getCurrentUserId(), forKey: "user_id");
//            dict.setValue(VVBaseUserDefaults.getCurrentPIID(), forKey: "pi_id");
//            SSLog(message: "DICT FOR LINKING : \(dict)")
//            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_LINK_USER_ID_AND_PI_ID) { (error) in
//                if error != nil{
//                    Utility.showErrorAccordingToLocalAndGlobal()
//                }
//            }
//        }
//    }
    
    func tappedTermsAndConditions() {
		SSLog(message: "tappedTermsAndConditions")
	}
    
    func navigateToLoginOnError()
    {
        let alert = UIAlertController(title: APP_NAME_TITLE, message: SSLocalizedString(key: "unable_to_connect_login_and_continue"), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: SSLocalizedString(key: "ok"), style: UIAlertActionStyle.cancel, handler:{ action in
            let objUser = User()
            VVBaseUserDefaults.setUserObject(value: objUser)
            VVBaseUserDefaults.setString("", forKey: KEY_USER_ID)
            UIAppDelegate.navigateToLoginScreen()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
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
//        self.showAlertMessage(strMessage: SSLocalizedString(key: "unable_to_connect_login_and_continue"))
        self.navigateToLoginOnError()
        //TO Make User obj empty
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
                
//                self.showAlertMessage(strMessage: SSLocalizedString(key: "unable_to_connect_login_and_continue"))
                self.navigateToLoginOnError()
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
                            
                            Utility.delay(2
                                , closure: {
                                      DispatchQueue.main.async {
                                    self.linkUserAndPIID();
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
    
    func linkUserAndPIID()
    {
        SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: true, success: { (str) in
            SVProgressHUD.dismiss()
            VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: true)
            SMQTTClient.sharedInstance().subscribeAllTopic()
            SVProgressHUD.show(withStatus: SSLocalizedString(key: "linking_account"))
            self.linkUserAndPiIdAPICall()
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            let objUser = User()
            VVBaseUserDefaults.setUserObject(value: objUser)
            VVBaseUserDefaults.setString("", forKey: KEY_USER_ID)
            self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_global_server"))
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
	
	
	

    
	// MARK:- validateUserEnteredData method
	func validateUserEnteredData() -> Bool {
		if(Utility.isEmpty(val: objUser.name?.removingWhitespaces())){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_name"))
			return false
		}
		else if(Utility.isEmpty(val: objUser.email?.removingWhitespaces())){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_email_address"))
			return false
		}
		else if !(Utility.isEmailValid(objUser.email!)){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_valid_email_address"))
			return false
		}
		else if(Utility.isEmpty(val: objUser.phoneNumber?.removingWhitespaces())){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_mobile_number"))
			return false
		}
		if !isComeFromSocialLogin!
		{
			if(Utility.isEmpty(val: objUser.password?.removingWhitespaces())){
				showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_password"))
				return false
			}
			else if(Utility.isEmpty(val: objUser.confirm_password?.removingWhitespaces())){
				showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_confirm_password"))
				return false
			}
			else if(objUser.password != objUser.confirm_password){
				self.showAlertMessage(strMessage: SSLocalizedString(key: "password_not_match"))
				return false
			}
		}
		
		return true
	}
    
   
    func linkUserAndPiIdAPICall()
    {
        SSLog(message: "************** linkUserAndPiIdAPICall **************")
//        SVProgressHUD.show()
        SSLog(message: "linkUserAndPiIdAPICall")
        if !Utility.isAnyConnectionIssue()
        {
            
            
           /* SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK) { (data, topic) in
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
                
//                if let objSync : User? = User.decode(data!){
//
//                    if let message = objSync?.message
//                    {
//                        SSLog(message: message)
//
//                    }
//
//                    }
                //redirect to home page
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
            if topVC is RegisterViewController
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
                                SSLog(message: "here *****************************************")
                                DispatchQueue.main.async {
                                    let nibName = Utility.getNibNameForClass(class_name: String.init(describing: AddNewHomeViewController.self))
                                    let vc = AddNewHomeViewController(nibName: nibName , bundle: nil)
                                    vc.comeFrom = .addNewHome
                                    vc.isComeFromRegisterVC = true
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                // go to add new home screen as user don't have setup home yet
                                
                                
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
                    SVProgressHUD.dismiss()
                    self.perform(#selector(self.startSyncWithDelay), with: self, afterDelay: 0.5)
                    
                }
            }
            else
            {
               SSLog(message: "Not RegisterViewController");
            }
        }
    }
    
    
    
    func syncLocalData()
    {
        if !Utility.isAnyConnectionIssue()
        {
            SVProgressHUD.show(withStatus: SSLocalizedString(key: SSLocalizedString(key: "sync")))
            
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_SYNC_EVERYTHING_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_SYNC_EVERYTHING_ACK)
                
                SSLog(message: "topic From RPi :: \(topic)")
                let checkURL = Utility.getTopicNameToCheck(topic: SM_TOPIC_SYNC_EVERYTHING_ACK);
                SSLog(message: "Utility.getTopicNameToCheck :: \(checkURL)")
                
                
                
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_SYNC_EVERYTHING_ACK)
                {
                    if let objSync : SyncData? = SyncData.decode(data!){
                        if((objSync?.syncData?.count)!>0)
                        {
                            //delete old data and insert new data
                            DatabaseManager.sharedInstance().deleteAndSyncData(objSyncData: objSync!)
                            //redirect to Home vc
                            //SUBSCRIBE_ALL_TOPICS
                            SMQTTClient.sharedInstance().subscribeAllTopic();
                            UIAppDelegate.navigateToHomeScreen()
                        }
                        
                        print("here---- SM_TOPIC_SYNC_EVERYTHING_ACK \(topic)")}
                    //redirect to home page
                    SVProgressHUD.dismiss()
                }
                else
                {
                    //Utility.showAlertMessage(strMessage: topic);
                     //SVProgressHUD.dismiss()
                }
            }
            
            let dict =  NSMutableDictionary()
            dict.setValue("1", forKey: "sync");
            //            let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_SYNC_EVERYTHING) { (error) in
                if error != nil{
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
    func syncGlobalData()
    {
        if !Utility.isAnyConnectionIssueToMakeGlobalAPI()
        {
            SVProgressHUD.show(withStatus: SSLocalizedString(key: "sync"))
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU)
                SSLog(message: "topic From RPi :: \(topic)")
                let checkURL = Utility.getTopicNameToCheck(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU);
                SSLog(message: "Utility.getTopicNameToCheck :: \(checkURL)")
                
                
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
                }else
                {
                    //Utility.showAlertMessage(strMessage: topic + " 2");
                    //SVProgressHUD.dismiss()
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
extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}
