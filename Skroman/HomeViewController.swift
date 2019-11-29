//
//  HomeViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

let SendUpdatedJson = "sendUpdatedJson"
let GetUserInformation = "getUserInformation"
let switchesCount   =    "switchesCount"
let PublishTopic   =    "publishTopic"
let SubscribeTopic   =   "subscribeTopic"
let child_lock_active   =   "child_lock_active"
let master_mode_active   =   "master_mode_active"
let master_mode_switch_id   =   "master_mode_switch_id"
let home_id   =   "home_id"
let master_mode_status   =   "master_mode_status"
let position   =   "position"
let room_id   =   "room_id"
let switchbox_id   =   "switchbox_id"
let statusT   =   "status"
let switch_id   =   "switch_id"
let typeOfSwitch   =   "type"
let wattage   =   "wattage"


import UIKit
import SideMenu
import PageMenu
import Masonry
import SVProgressHUD
import WatchConnectivity
import MQTTClient

class HomeViewController: BaseViewController,CAPSPageMenuDelegate,WCSessionDelegate,MQTTSessionDelegate,addIPAddressDelegateForExistingHome {
    
    
	var pageMenu: CAPSPageMenu!
    var sessionMQTT :  MQTTSession?

	var controllerArray = [UIViewController]() // Array to keep track of controllers in page menu
	var controllerMyRooms : MyRoomsViewController!
	var controllerDataUsage : DataUsageViewController!
    var mainHomeSwitch : UIButton?
    var mqttConnectionSignal : UIButton?
    var callFor : String?
    var switchesCounter : Int?

    //===============================
    var responseJson : NSMutableDictionary = [:]
    var dictonaryIds : NSMutableDictionary = [:]

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if VVBaseUserDefaults.getHomeIPAccess() == false {
           
                 self.setUpHomePopUp()
         }
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
        switchesCounter = 0

        // Do any additional setup after loading the view.
		initViewController()
//        Utility.createAJsonToShare()
		NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: .defaultHomeChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocalGlobalSwitch(_:)), name: .changeHomeMode, object: nil)
        
        setUpWCSession()
        setUpMQTTSession()
        
 	}
    
    
    //MARK:- Below execution block is only for users who have logged in and haven't set up ip for their respective homes

    /******************************************************************************************************************************************/

    
    func setUpHomePopUp() {
        
        let  arrHome : NSMutableArray = DatabaseManager.sharedInstance().getAllHomes()
        
        let objeHome : Home = arrHome.object(at: 0) as! Home

        let alert = UIAlertController(title: APP_NAME_TITLE as String?, message: String(format: "%@ has been setup as your default home, please set IP for it...", objeHome.home_name!) , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: SSLocalizedString(key: "OK"), style: .default) { action in
                
                self.setUpIpView(homeObject: objeHome)
            })
         self.present(alert, animated: true, completion: nil)

    }

    func setUpIpView(homeObject: Home) {
        
        
        let vc = AddIPAddressViewController.init(nibName: "AddIPAddressViewController", bundle: nil)
        vc.objHome = homeObject
        vc.ipDelegateForExisting = self
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    func didReceivedIPForExistingHome(ipValue: String, homeObj: Home) {
        
        
            VVBaseUserDefaults.setCurrentHomeSettingIP(home_ip: ipValue)
            
            SMQTTClient.sharedInstance().connectToServerForHomeChange(success: { (error) in
                if((error) != nil){
                    let msgToShow = String(format: "Not able to connect to MQTT server , so close the app and try once again")
                    Utility.showAlertMessage(strMessage: msgToShow)
                }else{
                    
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
                                
                                homeObj.is_default = 1
                                NotificationCenter.default.post(name: .defaultHomeChange, object: nil)
                                NotificationCenter.default.post(name: .defaultHomeChangeLeftMenu, object: nil)
                                self.startSyncDatas()
                                VVBaseUserDefaults.setHomeIPAccess(status: true)

                        }
                });
    }

    func startSyncDatas()
    {
        if Utility.isRestrictOperation()
        {
            self.syncGlobalDatas()
        }
        else
        {
            self.syncLocalDatas()
        }
    }
    
    
    func syncLocalDatas()
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
    
    func syncGlobalDatas()
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

 /******************************************************************************************************************************************/
    @objc func reloadData(_ notification: Notification)
    {
		self.controllerMyRooms.reloadControllerOnDefaultHomeChange()
		self.controllerDataUsage.reloadControllerOnDefaultHomeChange()
	}
    @objc func updateLocalGlobalSwitch(_ notification: Notification)
    {
        self.setUpRightNavigationBarButton(connectionMqtt: "")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDefaultHomeNameFromDb()
        self.controllerMyRooms.reloadControllerOnDefaultHomeChange()

    }
	func initViewController()
	{
        self.setUpNotificationCentre()
		setUpNavigationBar()
        setUpRightNavigationBarButton(connectionMqtt: "")
		setupPageMenu()
	}
    
    func setUpNotificationCentre(){
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.checkMQTTSignalConnectivity),
            name: .checkMQTTSignalConnectivity,
            object: nil)
    }

    @objc func checkMQTTSignalConnectivity(notification:NSNotification){
        
        var userInfo = NSDictionary()
        userInfo = notification.userInfo! as NSDictionary
        
        let connectionMqtt : String = userInfo.value(forKey: "connection") as! String
        
        self.setUpRightNavigationBarButton(connectionMqtt: connectionMqtt)
    }

    func getDefaultHomeNameFromDb()
    {

        let defaultHomeName = DatabaseManager.sharedInstance().getDefaultHome().home_name
        
        if(defaultHomeName != nil)
        {
            self.title = defaultHomeName

        }
        else
        {
            self.title = SSLocalizedString(key: "HOME")
        }
    }
	func setUpNavigationBar()  {
		let left = UIButton(type: .custom)
		left.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
		left.addTarget(self, action: #selector(tappedMenu(_:)), for: UIControlEvents.touchUpInside)
		left.setImage(UIImage(named: "menu"), for: .normal)
		let leftButton = UIBarButtonItem(customView: left)
		self.navigationItem.leftBarButtonItem = leftButton
	}
	
    func setUpRightNavigationBarButton(connectionMqtt:String)  {
		mainHomeSwitch = UIButton(type: .custom)
		mainHomeSwitch?.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
		mainHomeSwitch?.addTarget(self, action: #selector(tappedMainHomeSwitch(_:)), for: UIControlEvents.touchUpInside)
        mainHomeSwitch?.setImage(UIImage(named: "switch_off"), for: .selected)
        mainHomeSwitch?.setImage(UIImage(named: "switch_on"), for: .normal)
        if VVBaseUserDefaults.getIsGlobalConnect()
        {
            mainHomeSwitch?.isSelected = false
        }
        else
        {
            mainHomeSwitch?.isSelected = true
        }
		let button1 = UIBarButtonItem(customView: mainHomeSwitch!)
        
        //-------------------
        mqttConnectionSignal = UIButton(type: .custom)
        mqttConnectionSignal?.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        
        if (connectionMqtt == "connected") {
            mqttConnectionSignal?.setImage(UIImage(named: "mqttOn"), for: .normal)
        }
        else{
            mqttConnectionSignal?.setImage(UIImage(named: "mqttOff"), for: .normal)
        }
        let button2 = UIBarButtonItem(customView: mqttConnectionSignal!)
        
        
        let barButton_array: [UIBarButtonItem] = [button1, button2]
        navigationItem.setRightBarButtonItems(barButton_array, animated: false)

	}
    
    
	@objc func tappedMainHomeSwitch(_ sender : UIButton)
	{
		SSLog(message: "tappedMainHomeSwitch")
//        self.mainHomeSwitch?.isSelected = !(self.mainHomeSwitch?.isSelected)!
        
        if (self.mainHomeSwitch?.isSelected)!
        {
            SVProgressHUD.show()
            Utility.delay(2, closure: {
                DispatchQueue.main.async {
                    SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: true, success: { (str) in
                        self.mainHomeSwitch?.isSelected = false
                        
                        VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: true)
                        if self.pageMenu.currentPageIndex == 1
                        {
                            self.controllerDataUsage.updateDataUsageViewControllerUI()
                        }
                        SMQTTClient.sharedInstance().subscribeAllTopic()
                        
                        SVProgressHUD.dismiss()
                        
                    }, failure: { (error) in
                        SVProgressHUD.dismiss()
                        self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_global_server"))
                    })
                }
            })
        }
        else
        {
            
            SMQTTClient.sharedInstance().connectToServer(success: { (error) in
                if((error) != nil){
                    let msgToShow = String(format: SSLocalizedString(key: "before_switch_to_local_please_connect_to_xxx_wifi"), VVBaseUserDefaults.getCurrentSSID())
                    Utility.showAlertMessage(strMessage: msgToShow)
                }else{
                    SVProgressHUD.show()
                    Utility.delay(2, closure: {
                        DispatchQueue.main.async {
                            SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: false, success: { (str) in
                                SVProgressHUD.dismiss()
                                self.updateMainSwitch()
                                VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: false)
                                if self.pageMenu.currentPageIndex == 1
                                {
                                    self.controllerDataUsage.updateDataUsageViewControllerUI()
                                    self.controllerDataUsage.canMakeGetEnergyDataAPICall()
                                }
                                else
                                {
                                    SMQTTClient.sharedInstance().subscribeAllTopic()
                                }
                                
                            }, failure: { (error) in
                                SVProgressHUD.dismiss()
                                self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_local_server"))
                            })
                        }
                    })
                }});
            }
	}
    
    func updateMainSwitch()  {
        self.mainHomeSwitch?.isSelected = true
    }
    
	@objc func tappedMenu(_ sender : UIButton)
	{
		var sideMenu: UISideMenuNavigationController?
		sideMenu = SideMenuManager.default.menuLeftNavigationController
		if (sideMenu != nil) {
			sender.isUserInteractionEnabled = false
			self.present(sideMenu!, animated: true, completion: {
				sender.isUserInteractionEnabled = true
			})
		}
	}
	
	
	fileprivate func setupPageMenu() {
		// Create variables for all view controllers you want to put in the
		// page menu, initialize them, and add each to the controller array.
		// (Can be any UIViewController subclass)
		// Make sure the title property of all view controllers is set
		controllerMyRooms = MyRoomsViewController(nibName: "MyRoomsViewController", bundle: nil)
		controllerMyRooms.title = SSLocalizedString(key: "my_rooms").uppercased()
		controllerMyRooms.parentNavigation = self.navigationController
		controllerArray.append(controllerMyRooms)
		
		controllerDataUsage = DataUsageViewController(nibName: "DataUsageViewController", bundle: nil)
		controllerDataUsage.title = SSLocalizedString(key: SSLocalizedString(key: "data_usage")).uppercased()
		controllerDataUsage.comeFrom = .home
		controllerDataUsage.parentNavigation = self.navigationController
		controllerArray.append(controllerDataUsage)
		
		// Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
		// Example:
		
		let parameters: [CAPSPageMenuOption] = [
			.scrollMenuBackgroundColor(UICOLOR_MAIN_BG),
			.viewBackgroundColor(UIColor.clear),
			.selectionIndicatorColor(UICOLOR_CAPSMENU_SELECTED_LINE),
			.unselectedMenuItemLabelColor(UIColor.lightGray),
			.menuItemFont(Font_SanFranciscoText_Regular_H18!),
			.menuHeight(55.0),
			.menuMargin(0.0),
			.selectionIndicatorHeight(3.0),
			.bottomMenuHairlineColor(UICOLOR_SEPRATOR),
			.selectedMenuItemLabelColor(UIColor.white),
			.menuItemWidth((SCREEN_SIZE.width-2)/2)
		]
		// Initialize page menu with controller array, frame, and optional parameters
		pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: self.view.bounds, pageMenuOptions: parameters)
        self.pageMenu.delegate = self;
		// Lastly add page menu as subview of base view controller view
		// or use pageMenu controller in you view hierachy as desired
		self.view.addSubview(self.pageMenu!.view)
		
		_ =  self.pageMenu.view.mas_makeConstraints { (make:MASConstraintMaker?) in
			_ = make?.top.equalTo()(0)
			_ = make?.bottom.equalTo()(0)
			_ = make?.left.equalTo()(0)
			_ = make?.right.equalTo()(0)
		}
		pageMenu.view.subviews
			.map { $0 as? UIScrollView }
			.forEach { $0?.isScrollEnabled = false }
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
    func willMoveToPage(_ controller: UIViewController, index: Int)
    {
        SSLog(message: "willMoveToPage")
//        if index == 1
//        {
//           mainHomeSwitch?.isHidden = true
//        }
//        else
//        {
//             mainHomeSwitch?.isHidden = false
//        }
       
    }
    func didMoveToPage(_ controller: UIViewController, index: Int)
    {
         SSLog(message: "didMoveToPage")
        
//        if index == 1
//        {
//            if Utility.isRestrictOperation()
//            {
//                self.pageMenu.moveToPage(0)
//                Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
//                return
//            }
//        }
    }


//================================ For   Communication   Between   WATCH   App   And   IOS   App  ==============================

    func setUpWCSession(){
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {    }
    func sessionDidBecomeInactive(_ session: WCSession) {    }
    func sessionDidDeactivate(_ session: WCSession) {  }
    
    
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void){
        
        DispatchQueue.main.async() {
            self.messageFromiWatch(message: message as NSDictionary)
            
        }
        
    }
    
    
    
    
    
    func messageFromiWatch(message: NSDictionary){
        
        var valueJ : String = ""
        if message.value(forKey: SendUpdatedJson) != nil {
            valueJ = message.value(forKey: SendUpdatedJson) as! String
        }
       
        
        if(valueJ == SendUpdatedJson){
            
            self.sendDataToWatch()
        }
        else if (valueJ == GetUserInformation){
            
            self.sendUserInformationToWatch()
        }
        else {
            
            let dictonarySubPub : NSMutableDictionary = NSMutableDictionary()
            dictonarySubPub.setValue(message.value(forKey: PublishTopic), forKey: PublishTopic)
            dictonarySubPub.setValue(message.value(forKey: SubscribeTopic), forKey: SubscribeTopic)
            dictonarySubPub.setValue(message.value(forKey: switchesCount), forKey: switchesCount)

            
            responseJson = NSMutableDictionary()
            responseJson = NSMutableDictionary(dictionary: message)
            
            
            responseJson.removeObject(forKey: PublishTopic)
            responseJson.removeObject(forKey: SubscribeTopic)
            responseJson.removeObject(forKey: switchesCount)

            
            var childLock : String = ""
            if message.value(forKey: child_lock_active) != nil {
                childLock = message.value(forKey: child_lock_active) as! String
            }

            var mastermodeactive : String = ""
            if message.value(forKey: master_mode_active) != nil {
                mastermodeactive = message.value(forKey: master_mode_active) as! String
            }

            var switchoboxid : String = ""
            if message.value(forKey: switchbox_id) != nil {
                switchoboxid = message.value(forKey: switchbox_id) as! String
            }

            var mastermodeswitchid : String = ""
            if message.value(forKey: master_mode_switch_id) != nil {
                mastermodeswitchid = message.value(forKey: master_mode_switch_id) as! String
            }

            
            
            if(childLock == child_lock_active){}
            else if((mastermodeactive == master_mode_active) && (switchoboxid == switchbox_id) && (mastermodeswitchid == master_mode_switch_id)){
                
                dictonaryIds.removeAllObjects()
                dictonaryIds = NSMutableDictionary()
                
                dictonaryIds.setValue(message.value(forKey: home_id), forKey: home_id)
                dictonaryIds.setValue(message.value(forKey: master_mode_status), forKey: SubscribeTopic)
                dictonaryIds.setValue(message.value(forKey: position), forKey: position)
                dictonaryIds.setValue(message.value(forKey: room_id), forKey: room_id)
                dictonaryIds.setValue(message.value(forKey: switchbox_id), forKey: switchbox_id)
                dictonaryIds.setValue(message.value(forKey: statusT), forKey: statusT)
                dictonaryIds.setValue(message.value(forKey: switch_id), forKey: switch_id)
                dictonaryIds.setValue(message.value(forKey: typeOfSwitch), forKey: typeOfSwitch)
                dictonaryIds.setValue(message.value(forKey: wattage), forKey: wattage)
                
                responseJson.removeObject(forKey: home_id)
                responseJson.removeObject(forKey: master_mode_status)
                responseJson.removeObject(forKey: position)
                responseJson.removeObject(forKey: room_id)
                responseJson.removeObject(forKey: statusT)
                responseJson.removeObject(forKey: switch_id)
                responseJson.removeObject(forKey: typeOfSwitch)
                responseJson.removeObject(forKey: wattage)
                
            }
            else{
                
                dictonaryIds.removeAllObjects()
                dictonaryIds = NSMutableDictionary()
                
                dictonaryIds.setValue(message.value(forKey: home_id), forKey: home_id)
                dictonaryIds.setValue(message.value(forKey: room_id), forKey: room_id)
                dictonaryIds.setValue(message.value(forKey: master_mode_status), forKey: master_mode_status)
                dictonaryIds.setValue(message.value(forKey: typeOfSwitch), forKey: typeOfSwitch)
                dictonaryIds.setValue(message.value(forKey: wattage), forKey: wattage)
                
                responseJson.removeObject(forKey: home_id)
                responseJson.removeObject(forKey: room_id)
                responseJson.removeObject(forKey: master_mode_status)
                responseJson.removeObject(forKey: typeOfSwitch)
                responseJson.removeObject(forKey: wattage)
                
            }
            
            self.publishTopic(_topic: dictonarySubPub, datas: responseJson)
        }
    }
    
    
    func sendDataToWatch(){
        
        let dictonary : NSMutableDictionary = Utility.getJsonToShare()
        
        setUpWCSession()
        
        if (WCSession.default.isReachable) {
            let session = WCSession.default
            session.sendMessage(dictonary as! [String : Any] , replyHandler: { (response) in
            }, errorHandler: { (error) in
                print("Error sending message: %@", error)
            })
        }
    }
 
    
    func sendUserInformationToWatch(){
        
        var objUser = User()
        objUser = VVBaseUserDefaults.getUserObject()!
        
        let dictonary = NSMutableDictionary()
        dictonary.setValue(objUser.name, forKey: "name")
        dictonary.setValue(objUser.email, forKey: "email")
        dictonary.setValue(objUser.phoneNumber, forKey: "phone")
        
        
        setUpWCSession()
        
        if (WCSession.default.isReachable) {
            let session = WCSession.default
            session.sendMessage(dictonary as! [String : Any] , replyHandler: { (response) in
            }, errorHandler: { (error) in
                print("Error sending message: %@", error)
            })
        }
    }

    
        func setUpMQTTSession(){
    
            let transport = MQTTCFSocketTransport()
            transport.host = VVBaseUserDefaults.getCurrentHomeIP()
            transport.port = 1883
    
            sessionMQTT = MQTTSession()
            sessionMQTT?.delegate = self
            sessionMQTT?.transport = transport
            sessionMQTT?.connect(connectHandler: { (error) in
                print("error::",error as Any)
            })
    
            sessionMQTT?.disconnect()
    
            sessionMQTT?.connect(connectHandler: { (error) in
                print("error: ", error as Any)
            })
    
        }

    func publishTopic(_topic: NSMutableDictionary, datas: NSMutableDictionary){
        
        callFor = _topic.value(forKey: PublishTopic) as? String
        
        var valSwiCount : Int = 0
        
        if _topic.value(forKey: switchesCount) == nil {
            valSwiCount = 1
        }
        else{
            valSwiCount = _topic.value(forKey: switchesCount) as! Int
        }

        
        let dictonaryFormat = NSMutableDictionary()

        let arrayValues : NSArray = datas.allValues as NSArray
        let arrayKeys : NSArray = datas.allKeys as NSArray
        
        for x in 0 ..< arrayKeys.count {
            
            let newStringKey = String(format: "%@", arrayKeys.object(at: x) as! String)
            let newStringValue = String(format: "%@", arrayValues.object(at: x) as! String)
            dictonaryFormat.setValue(newStringValue, forKey: newStringKey)
        }

    
        if !Utility.isAnyConnectionIssue()
        {
            SVProgressHUD.show()
            //After 2 sec irrespective of API success hide loader
            Utility.delay(2.0) {
                SVProgressHUD.dismiss()
            }

            SMQTTClient.sharedInstance().subscribe(topic: _topic.value(forKey: SubscribeTopic) as! String) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: _topic.value(forKey: SubscribeTopic) as! String)
                SSLog(message: "Successsssss")
                SVProgressHUD.dismiss()
                
                self.switchesCounter = self.switchesCounter! + 1
                print("self.switchesCounter",self.switchesCounter as Any)
                
                /* switch and master switch */
                if self.callFor == SM_TOPIC_UPDATE_SWITCH{
                    
                    if let objSwitch : Switch? = Switch.decode(data!){
                        if objSwitch == nil{
                            SSLog(message: " Check by ankit for mumbai acetech 2019 , remove once fixed from server end")
                        }
                        else{
                            DatabaseManager.sharedInstance().updateSwitchStatus(objSwitch!, status: objSwitch?.status ?? 0)
                        }                    }
                }
                
                /* child lock */
                else if self.callFor == SM_TOPIC_CHILD_MOOD_APP_TO_RPI{
                    
                    DatabaseManager.sharedInstance().updateSwitchBoxChildLockStatus(child_lock: dictonaryFormat.value(forKey: "child_lock_active") as! String, switchbox_id: dictonaryFormat.value(forKey: "switchbox_id") as! String )
                }

                else if self.callFor == SM_TOPIC_MASTER_MOOD_APP_TO_RPI{
                    
                    if let objSwitch : Switch? = Switch.decode(data!){

                        DatabaseManager.sharedInstance().updateSwitchMasterModeInOutStatus(objSwitch!, master_mode_status: dictonaryFormat.value(forKey: "master_mode_active") as! String)
                    }
                }
                
                if self.switchesCounter == valSwiCount {

                    Utility.delay(3){
                        self.sendDataToWatch()
                        self.switchesCounter  = 0
                    }
                }
            }
         }


        SMQTTClient.sharedInstance().publishJson(json: dictonaryFormat, topic: _topic.value(forKey: PublishTopic) as! String){
            (error) in
            print("error :\(String(describing: error))")
            if((error) != nil) {
                Utility.showErrorAccordingToLocalAndGlobal()
            }
        }
    }
}

