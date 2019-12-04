//
//  MyHomesViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import SwipeCellKit
import SVProgressHUD

class MyHomesViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,SwipeTableViewCellDelegate,QRCodeScannerViewControllerDelegate,addIPAddressDelegate, addIPAddressDelegateForExistingHome {
    
    
    var tempPIObj : PI?
	@IBOutlet weak var tableView: UITableView!
    var arrHome =  NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupTableView()
		setUpNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllHome()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func getAllHome() {
         arrHome = DatabaseManager.sharedInstance().getAllHomes()
        self.tableView.reloadData()
    }

	func setupTableView() {
		self.title = SSLocalizedString(key: "my_homes")
		view.backgroundColor = UICOLOR_MAIN_BG
		tableView.backgroundColor = UICOLOR_MAIN_BG
		// Registering nibs
		tableView.register(UINib.init(nibName: "MyHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "MyHomeTableViewCell")
	}
	func setUpNavigationBar()  {
		let right = UIButton(type: .custom)
		right.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
		right.addTarget(self, action: #selector(tappedAdd(_:)), for: UIControlEvents.touchUpInside)
		right.setImage(UIImage(named: "add_room"), for: .normal)
		let rightButton = UIBarButtonItem(customView: right)
		self.navigationItem.rightBarButtonItem = rightButton
	}
	@objc func tappedAdd(_ sender : UIButton)
    {
        if Utility.isRestrictOperation(){
            Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
        }
        else{
            //  Push on AddIPAddressVC //


        let vc = AddIPAddressViewController.init(nibName: "AddIPAddressViewController", bundle: nil)
            vc.ipDelegate = self
            let nav = UINavigationController.init(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)

            //Push on QRCodeScannerVC
/*
            let vc = QRCodeScannerViewController.init(nibName: "QRCodeScannerViewController", bundle: nil)
            vc.comefrom = QRCodeScannType.newHomeFromMyHomes
            vc.delegate = self
            let nav = UINavigationController.init(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
    */
        }
    }
    //MARK:-QRCodeScannerViewControllerDelegate methods
    func didSuccess(ssid : String, password : String) -> Void
    {
        
        Utility.delay(4) {
            self.didSuccessWithDelay(strSSID: ssid)
        }
        
        
//        let nibName = Utility.getNibNameForClass(class_name: String.init(describing: AddNewHomeViewController.self))
        let vc = AddNewHomeViewController(nibName: nibName , bundle: nil)
//        vc.comeFrom = .addNewHomeFromMyHomes
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didFailure() -> Void
    {
        
        SSLog(message: "QRCode Scan failure")
        self.showAlertMessage(strMessage: SSLocalizedString(key: "unable_to_connect_device_please_try_again"))
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
		return arrHome.count
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MyHomeTableViewCell", for: indexPath) as! MyHomeTableViewCell
        cell.configureCell(objHome: arrHome[indexPath.row] as! Home)
		cell.delegate = self
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let obj = arrHome[indexPath.row] as! Home
        self.processHomeChange(ipValue: "", homeObj: obj)
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let homeObj = arrHome[indexPath.row] as! Home
        if homeObj.is_default == 1
        {
            if orientation == .right {
                let editList = SwipeAction (style: .default, title: nil)  { action, indexPath in
                    if Utility.isRestrictOperation(){
                        Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
                    }
                    else
                    {
                        let nibName = Utility.getNibNameForClass(class_name: String.init(describing: AddNewHomeViewController.self))
                        let vc = AddNewHomeViewController(nibName: nibName , bundle: nil)
                        vc.comeFrom = .editHome
                        vc.objHome = homeObj
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                editList.title = SSLocalizedString(key: "edit").uppercased()
                editList.font = Font_SanFranciscoText_Regular_H12
                editList.image = #imageLiteral(resourceName: "edit")
                editList.backgroundColor = UICOLOR_SWIPECELL_EDIT
                return [editList]
            }
            else{
                return nil
            }
        }
        else{
            if orientation == .right {
                let deleteList = SwipeAction (style: .default, title: nil)  { action, indexPath in
                    SSLog(message: "DELETE HOME API CALL")
                }
                
                deleteList.title = SSLocalizedString(key: "delete").uppercased()
                deleteList.font = Font_SanFranciscoText_Regular_H12
                deleteList.image = #imageLiteral(resourceName: "delete")
                deleteList.backgroundColor = UICOLOR_SWIPECELL_DELETE
                return [deleteList]
            }
            else{
                return nil
            }
        }
    }
	
	
	func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
		var options = SwipeTableOptions()
		options.expansionStyle = .selection
		options.transitionStyle = .border
		return options
	}
	
	
	
	func findOldDefaultHome() -> Home
	{
		var isFound : Bool = false
		var foundIndex : Int = 0
		for currentIndex in 0..<(arrHome.count) {
			let obj = arrHome[currentIndex] as! Home
			if obj.is_default == 1
			{
				isFound = true
				foundIndex = currentIndex
			}
		}
		var objMasterSwitch = Home()
		if(isFound){
			objMasterSwitch = arrHome[foundIndex] as! Home
		}
		return objMasterSwitch
	}
    
    
    
    func didReceivedIPForExistingHome(ipValue: String, homeObj: Home) {

        self.processHomeChange(ipValue: ipValue, homeObj: homeObj)
    }
    
    func processHomeChange(ipValue:String , homeObj:Home){
        
        var ipAddress : String = ""
        if ipValue.isEmpty {
            
                    let homeName : String = homeObj.home_name!
            
                     var homeDictonary = NSMutableDictionary()
                     homeDictonary = VVBaseUserDefaults.getHomeIpDictonary()
            
                    var ipDictonary = NSMutableDictionary()
            
                    if homeDictonary.allValues.count == 0 {

                        self .setIPForHome(homeObject: homeObj)
                    }
                    else{
                        
                        if homeDictonary[homeName] != nil {
                            let dictVal : Any =  homeDictonary.value(forKey: homeName)
                            let somedict =   dictVal as! Dictionary<String, String>
                            ipDictonary = NSMutableDictionary(dictionary: somedict)

//                            ipDictonary = homeDictonary.value(forKey: homeName) as! NSMutableDictionary
                        }
                        else{

                            self .setIPForHome(homeObject: homeObj)
                        }
                    }
            
                    if ipDictonary.allValues.count == 0 {
                        
                        self .setIPForHome(homeObject: homeObj)
                    }
                    else{
                        
                        ipAddress = ipDictonary.value(forKey: homeObj.home_id!) as! String
                        VVBaseUserDefaults.setCurrentHomeSettingIP(home_ip: ipAddress)
                        
                        SMQTTClient.sharedInstance().connectToServerForHomeChange(success: { (error) in
                            if((error) != nil){
                                let msgToShow = String(format: "Not able to connect to MQTT server , so close the app and try once again")
                                Utility.showAlertMessage(strMessage: msgToShow)
                            }else{
                                

                                if homeObj.is_default == 1         {
                                    SSLog(message: "Already default home")
                                }
                                else {
                                    SSLog(message: "Set Default")
                                    if Utility.isRestrictOperation(){
                                        Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
                                    }
                                    else
                                    {
                                        let alert = UIAlertController(title: APP_NAME_TITLE, message: String(format: SSLocalizedString(key: "are_you_sure_to_set_xxx_as_default_home"),homeObj.home_name!), preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: SSLocalizedString(key: "no"), style: .default) { action in
                                        })
                                        alert.addAction(UIAlertAction(title: SSLocalizedString(key: "yes"), style: .default) { action in
                                            DatabaseManager.sharedInstance().updateDefaultHome(obj: homeObj)
                                            VVBaseUserDefaults.setCurrentHomeID(home_id: homeObj.home_id!)
                                            VVBaseUserDefaults.setCurrentHomeName(home_name: homeObj.home_name!)
                                            VVBaseUserDefaults.setCurrentPIID(pi_id: homeObj.pi_id!)
                                            VVBaseUserDefaults.setCurrentHomeIP(home_ip: ipAddress)

                                            
                                            let objPI = DatabaseManager.sharedInstance().getPI(piid: homeObj.pi_id!)
                                            VVBaseUserDefaults.setCurrentSSID(ssid: objPI.ssid ?? VVBaseUserDefaults.getCurrentSSID())
                                            VVBaseUserDefaults.setCurrentPASSWORD(password: objPI.password ?? VVBaseUserDefaults.getCurrentPASSWORD())
                                            
                                            
                                            let defaultOldHome = self.findOldDefaultHome()
                                            defaultOldHome.is_default = 0
                                            homeObj.is_default = 1
                                            self.tableView.reloadData()
                                            NotificationCenter.default.post(name: .defaultHomeChange, object: nil)
                                            NotificationCenter.default.post(name: .defaultHomeChangeLeftMenu, object: nil)
                                            self.startSyncData()

                                        })
                                        
                                        self.present(alert, animated: true)
                                    }
                                }
                            }});
                    }
                }
        else{
            
            VVBaseUserDefaults.setCurrentHomeSettingIP(home_ip: ipValue)

            SMQTTClient.sharedInstance().connectToServerForHomeChange(success: { (error) in
                if((error) != nil){
                    let msgToShow = String(format: "Not able to connect to MQTT server , so close the app and try once again")
                    Utility.showAlertMessage(strMessage: msgToShow)
                }else{
                    

                    if homeObj.is_default == 1 {
                        SSLog(message: "Already default home")
                    }
                    else {
                        SSLog(message: "Set Default")
                        if Utility.isRestrictOperation(){
                            Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
                        }
                        else {
                            let alert = UIAlertController(title: APP_NAME_TITLE, message: String(format: SSLocalizedString(key: "are_you_sure_to_set_xxx_as_default_home"),homeObj.home_name!), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: SSLocalizedString(key: "no"), style: .default) { action in
                            })
                            alert.addAction(UIAlertAction(title: SSLocalizedString(key: "yes"), style: .default) { action in
                                DatabaseManager.sharedInstance().updateDefaultHome(obj: homeObj)
                                VVBaseUserDefaults.setCurrentHomeID(home_id: homeObj.home_id!)
                                VVBaseUserDefaults.setCurrentHomeName(home_name: homeObj.home_name!)
                                VVBaseUserDefaults.setCurrentPIID(pi_id: homeObj.pi_id!)
                                VVBaseUserDefaults.setCurrentHomeIP(home_ip: ipValue)
                                
                                /*---------------------*/
                                /*  save in nsuserdefaults */
                                var ipDict = NSMutableDictionary ()
                                ipDict = VVBaseUserDefaults.getHomeIpDictonary()
                                
                                let dictonary = NSMutableDictionary()
                                dictonary.setValue(ipValue, forKey:homeObj.home_id!)
                                
                                ipDict.setObject(dictonary, forKey: homeObj.home_name! as NSCopying)
                                VVBaseUserDefaults.setHomeIpDictonary(home_dict: ipDict)
                                /*---------------------*/
                                
                                let objPI = DatabaseManager.sharedInstance().getPI(piid: homeObj.pi_id!)
                                VVBaseUserDefaults.setCurrentSSID(ssid: objPI.ssid ?? VVBaseUserDefaults.getCurrentSSID())
                                VVBaseUserDefaults.setCurrentPASSWORD(password: objPI.password ?? VVBaseUserDefaults.getCurrentPASSWORD())
                                
                                
                                let defaultOldHome = self.findOldDefaultHome()
                                defaultOldHome.is_default = 0
                                homeObj.is_default = 1
                                self.tableView.reloadData()
                                NotificationCenter.default.post(name: .defaultHomeChange, object: nil)
                                NotificationCenter.default.post(name: .defaultHomeChangeLeftMenu, object: nil)
                                self.startSyncData()
                            })
                            self.present(alert, animated: true)
                        }
                    }
                }});
        }
    }

    
    func setIPForHome(homeObject: Home){
        
        let vc = AddIPAddressViewController.init(nibName: "AddIPAddressViewController", bundle: nil)
        vc.objHome = homeObject
        vc.ipDelegateForExisting = self
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func startSyncData()
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
    
    
    func syncLocalData()
    {
        if !Utility.isAnyConnectionIssue()
        {
            SVProgressHUD.show(withStatus: SSLocalizedString(key: "sync..."))
            Utility.delay(2.0) {
                SVProgressHUD.dismiss()
            }
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_SYNC_EVERYTHING_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_SYNC_EVERYTHING_ACK)
                
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_SYNC_EVERYTHING_ACK)
                {
                    if let objSync : SyncData? = SyncData.decode(data!){
                        
                        if((objSync?.syncData?.count)!>0)
                        {
                            //delete old data and insert new data
                            SMQTTClient.sharedInstance().subscribeAllTopic()
                            DatabaseManager.sharedInstance().syncDataFormleftMenu(objSyncData: objSync!)
                        }
                        //Default Home
                        self.dismiss(animated: true, completion: {
                            
                        })
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
        if !Utility.isAnyConnectionIssue()
        {
            SVProgressHUD.show(withStatus: SSLocalizedString(key: "sync..."))
            
            //Hide loader after 2 sec irrespective of result
            Utility.delay(2.0) {
                SVProgressHUD.dismiss()
            }
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU)
                
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU)
                {
                    if let objSync : SyncData? = SyncData.decode(data!){
                        
                        if((objSync?.syncData?.count)!>0)
                        {
                            //delete old data and insert new data
                            SMQTTClient.sharedInstance().subscribeAllTopic()
                            DatabaseManager.sharedInstance().syncDataFormleftMenu(objSyncData: objSync!)
                        }
                        //Default Home
                        self.dismiss(animated: true, completion: {
                            
                        })
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
    
    func didReceivedIP(ipValue : String , from :String) {
        
        // Take a dictonary and associate home-name:{ homeid:ip-value}
        VVBaseUserDefaults.setCurrentHomeIP(home_ip: ipValue)

        SMQTTClient.sharedInstance().connectToServerForAddingHome(success: { (error) in
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

    
    
    
    
    
    @objc func didSuccessWithDelay(strSSID : String)
    {
        //mke provision to send ip address in below method
        
        SMQTTClient.sharedInstance().connectToServer(success: { (error) in
            if((error) != nil)
            {
                SVProgressHUD.dismiss()
                
                //TO REMOVE WIFI
                let manager = UIAppDelegate.manager
                manager?.remove(ssid: strSSID, completion: { (err) in
                })
                ToastMessage.showErrorMessageAppTitle(withMessage: SSLocalizedString(key: "unable_to_connect"))
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
                            
                            SVProgressHUD.show(withStatus: SSLocalizedString(key: "linking_account"))
                            
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
    
    
    func linkUserAndPiIdAPICall()
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
                                                            
                                if self.tempPIObj?.home_id != nil     {
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
    
    @objc func startSyncWithDelay()
    {
        
        
        if !Utility.isAnyConnectionIssue()
        {
            SVProgressHUD.show(withStatus: SSLocalizedString(key: SSLocalizedString(key: "sync")))
            let topicTosend = "\(VVBaseUserDefaults.getCurrentPIID())/sync_everything"
            let topicToAck = "\(VVBaseUserDefaults.getCurrentPIID())/sync_everything_ack"
            SMQTTClient.sharedInstance().subscribe(topic: topicToAck) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: topicToAck)
                
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
                        
                        print("here---- SM_TOPIC_SYNC_EVERYTHING_ACK \(topic)")
                    }
                    //redirect to home page
                    SVProgressHUD.dismiss()
                }
            }
            
            let dict =  NSMutableDictionary()
            dict.setValue("1", forKey: "sync");
//            let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: topicTosend) { (error) in
                if error != nil{
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
}
