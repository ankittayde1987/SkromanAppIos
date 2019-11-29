//
//  RoomDetailsMainContainerViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/17/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import PageMenu
import Masonry
import SVProgressHUD

class RoomDetailsMainContainerViewController: BaseViewController,CAPSPageMenuDelegate {
    var mainHomeSwitch : UIButton?
    var mqttConnectionSignal : UIButton?
	var pageMenu: CAPSPageMenu!
	var controllerArray = [UIViewController]() // Array to keep track of controllers in page menu
	var selected_room_id : String!
	var arrRooms = [Room]()
    
    var arrSwitchBoxes = [SwitchBox]()
    
    
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
		
        self.setUpNotificationCentre()        // Do any additional setup after loading the view.
        getRoomsFromDatabase()
		setUpRightNavigationBarButton(connectionMqtt: "")
		self.setupPageMenu()
		self.view.backgroundColor = UICOLOR_MAIN_BG
    }
    
    func setUpNotificationCentre(){
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.checkMQTTConnectivity),
            name: .checkMQTTConnectivity,
            object: nil)
    }

    @objc func checkMQTTConnectivity(notification:NSNotification){
        
        var userInfo = NSDictionary()
        userInfo = notification.userInfo! as NSDictionary
        
        let connectionMqtt : String = userInfo.value(forKey: "connection") as! String
        
        self.setUpRightNavigationBarButton(connectionMqtt: connectionMqtt)
    }

    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        if !Utility.isIpad()
        {
            SMQTTClient.sharedInstance().subscribeAllTopic()
        }
		getDefaultHomeNameFromDb()
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
//        SSLog(message: "tappedMainHomeSwitch")
//        self.mainHomeSwitch?.isSelected = !(self.mainHomeSwitch?.isSelected)!
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
                        NotificationCenter.default.post(name: .changeHomeMode, object: nil)
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
                                self.mainHomeSwitch?.isSelected = true
                                VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: false)
                                NotificationCenter.default.post(name: .changeHomeMode, object: nil)
                                SMQTTClient.sharedInstance().subscribeAllTopic()
                            }, failure: { (error) in
                                SVProgressHUD.dismiss()
                                self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_local_server"))
                            })
                        }
                    })
                    
                }});
          }
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
	func getRoomsFromDatabase()
	{
        if Utility.isIpad()
        {
          arrSwitchBoxes = DatabaseManager.sharedInstance().getAllSwitchBoxesWithRoomID(room_id: self.selected_room_id) as! [SwitchBox]
        }
        else
        {
            arrRooms = DatabaseManager.sharedInstance().getAllRoomWithHomeID(home_id: VVBaseUserDefaults.getCurrentHomeID()) as! [Room]

        }
	}
	
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	fileprivate func setupPageMenu() {
		// Create variables for all view controllers you want to put in the
		// page menu, initialize them, and add each to the controller array.
		// (Can be any UIViewController subclass)
		// Make sure the title property of all view controllers is set
        
        //For HairLine Color Below Page Menu
        var bottomHairLineColor = UICOLOR_SEPRATOR
		
        if Utility.isIpad()
        {
            if arrSwitchBoxes.count == 0
            {
                bottomHairLineColor = UIColor.clear
                let controllerRoomDetail = RoomDetailsViewController(nibName: "RoomDetailsViewController", bundle: nil)
                controllerRoomDetail.parentNavigation = self.navigationController
                controllerRoomDetail.title = ""
                controllerRoomDetail.objCurrentSwitchBox = self.dummySwitchBoxObj()
                let objRoom = Room()
                objRoom.room_id = self.selected_room_id
                controllerRoomDetail.objRoom = objRoom
                controllerArray.append(controllerRoomDetail)
            }
            else
            {
                arrSwitchBoxes.forEach { (switchBox) in
                    let controllerRoomDetail = RoomDetailsViewController(nibName: "RoomDetailsViewController", bundle: nil)
                    controllerRoomDetail.parentNavigation = self.navigationController
                    controllerRoomDetail.title = switchBox.name
                    controllerRoomDetail.objCurrentSwitchBox = switchBox
                    let objRoom = DatabaseManager.sharedInstance().getRoomWithRoomID(room_id: self.selected_room_id)
                    controllerRoomDetail.objRoom = objRoom
                    controllerArray.append(controllerRoomDetail)
                }
            }

        }
        else
        {
            arrRooms.forEach { (room) in
                let controllerRoomDetail = RoomDetailsViewController(nibName: "RoomDetailsViewController", bundle: nil)
                controllerRoomDetail.parentNavigation = self.navigationController
                controllerRoomDetail.title = room.room_name
                controllerRoomDetail.objRoom = room
                controllerArray.append(controllerRoomDetail)
            }
        }

		
		
	
		// Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
		// Example:
		
        
        
        var scrollBgColor = UICOLOR_MAIN_BG
        var selectedLineColor = UICOLOR_CAPSMENU_SELECTED_LINE
        if Utility.isIpad()
        {
            scrollBgColor = UICOLOR_ROOM_CELL_BG
            selectedLineColor = UICOLOR_SWITCH_BORDER_COLOR_YELLOW
        }
		let parameters: [CAPSPageMenuOption] = [
			.scrollMenuBackgroundColor(scrollBgColor),
			.viewBackgroundColor(UIColor.clear),
			.selectionIndicatorColor(selectedLineColor),
			.unselectedMenuItemLabelColor(UIColor.lightGray),
			.menuItemFont(Font_SanFranciscoText_Regular_H18!),
			.menuHeight(55.0),
			.menuMargin(12.0),
			.selectionIndicatorHeight(3.0),
			.bottomMenuHairlineColor(bottomHairLineColor),
			.selectedMenuItemLabelColor(UIColor.white),
			.menuItemWidthBasedOnTitleTextWidth(true)
//			.menuItemWidth((SCREEN_SIZE.width - CGFloat(controllerArray.count)) / CGFloat(controllerArray.count))
		]
		// Initialize page menu with controller array, frame, and optional parameters
		pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: self.view.bounds, pageMenuOptions: parameters)
        pageMenu.delegate = self
		
		// Lastly add page menu as subview of base view controller view
		// or use pageMenu controller in you view hierachy as desired
		self.view.addSubview(self.pageMenu!.view)
		
		
		_ =  self.pageMenu.view.mas_makeConstraints { (make:MASConstraintMaker?) in
			_ = make?.top.equalTo()(0)
			_ = make?.bottom.equalTo()(0)
			_ = make?.left.equalTo()(0)
			_ = make?.right.equalTo()(0)
		}
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.pageMenu.moveToPage(self.getSelectedPageIndex())
        })
		
	}
	
	func getSelectedPageIndex() -> Int
	{
		var isFound : Bool = false
		var foundIndex : Int = 0
		for currentIndex in 0..<(arrRooms.count) {
			let obj = arrRooms[currentIndex] as Room
			if obj.room_id == self.selected_room_id
			{
				isFound = true
				foundIndex = currentIndex
			}
		}
		var index : Int = 0
		if(isFound){
			index = foundIndex
		}
		return index
	}
    
    func dummySwitchBoxObj() -> SwitchBox
    {
        let obj = SwitchBox()
        obj.switchbox_id = "-1"
        return obj
        
    }
    
    @objc func willMoveToPage(_ controller: UIViewController, index: Int){
        
        var arrRoomData = NSMutableArray()
        var objRoom : Room!
        
        arrRoomData = DatabaseManager.sharedInstance().getAllRoomWithHomeID(home_id: VVBaseUserDefaults.getCurrentHomeID())
        objRoom = arrRoomData.object(at: index) as? Room
        VVBaseUserDefaults.setCurrentRoomID(room_id: objRoom.room_id!)
    }
}
