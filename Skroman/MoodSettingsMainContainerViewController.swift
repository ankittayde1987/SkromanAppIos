//
//  MoodSettingViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/21/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import PageMenu
import Masonry
import STPopup

protocol MoodSettingsMainContainerViewControllerDelegate {
	func didAddedOrEditedMoodSuccessfully()
}
class MoodSettingsMainContainerViewController: UIViewController,AddMoodTimePopupViewControllerDelegate,SelectDaysPopUpViewControllerDelegate,CAPSPageMenuDelegate {
	var delegate : MoodSettingsMainContainerViewControllerDelegate?
	var comeFrom:MoodSettingsMainContainerViewControllerComeFrom? = .addNewHomeMood
	var pageMenu: CAPSPageMenu!
	var controllerArray = [RoomDetailForMoodSettingViewController]() // Array to keep track of controllers in page menu
	var selected_room_id : String!
	var objMoodToEdit = Mood()
	var strMoodName : String!
    var strMoodIdToAdd : String!
	var arrRooms = [Room]()
	var moodTypeForHomeOrDevice : Int? = MOOD_TYPE_HOME
	
	var controllerRoomDetailForMoodSetting : RoomDetailForMoodSettingViewController!
	
	//New For JSON
	var objMoodWrapper = MoodWrapper()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
        //For iPad it can't reload view so set hardcoded
        
        if Utility.isIpad()
        {
            self.view.frame.size = (UIAppDelegate.window?.frame.size)!
        }
        
        
		getRoomsFromDatabase()
		self.setupPageMenu()
		self.setNavigationBarRightButton()
		self.view.backgroundColor = UICOLOR_MAIN_BG
		self.title = SSLocalizedString(key: "mood_setting")
		
		//assign moodName and time to MoodWrapper object
		self.objMoodWrapper.mood_name = strMoodName
        
        //To add HomeMood set mood_id
        if self.comeFrom == .addNewHomeMood
        {
            self.objMoodWrapper.mood_id = strMoodIdToAdd
        }
        if self.comeFrom == .addNewRoomMood
        {
            self.objMoodWrapper.mood_id = strMoodIdToAdd
        }
		if self.comeFrom == .editHomeMood
		{
            if !Utility.isEmpty(val: self.objMoodToEdit.mood_id)
            {
                self.objMoodWrapper.mood_id = self.objMoodToEdit.mood_id
            }
			if !Utility.isEmpty(val: self.objMoodToEdit.mood_time)
			{
				self.objMoodWrapper.mood_time = self.objMoodToEdit.mood_time
			}
			if !Utility.isEmpty(val: "\(self.objMoodToEdit.mood_status)")
			{
				self.objMoodWrapper.mood_status = self.objMoodToEdit.mood_status
			}
			if objMoodToEdit.mood_repeat.count != 0
			{
				self.objMoodWrapper.arraySelectedDaysForMoodRepeat = self.objMoodToEdit.mood_repeat
			}
		}
        if self.comeFrom == .editRoomMood
        {
//            if !Utility.isEmpty(val: self.objMoodToEdit.mood_id)
//            {
//                self.objMoodWrapper.mood_id = self.objMoodToEdit.mood_id
//            }
//            if !Utility.isEmpty(val: self.objMoodToEdit.mood_time)
//            {
//                self.objMoodWrapper.mood_time = self.objMoodToEdit.mood_time
//            }
//            if !Utility.isEmpty(val: "\(self.objMoodToEdit.mood_status)")
//            {
//                self.objMoodWrapper.mood_status = self.objMoodToEdit.mood_status
//            }
//            if objMoodToEdit.mood_repeat.count != 0
//            {
//                self.objMoodWrapper.arraySelectedDaysForMoodRepeat = self.objMoodToEdit.mood_repeat
//            }
        }
	}
	// MARK:- setNavigationBarRightButton
	func setNavigationBarRightButton(){
		let saveButton = UIButton(type: .custom)
		saveButton.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(44), height: CGFloat(44))
		saveButton.backgroundColor = UIColor.clear
		saveButton.setTitle(SSLocalizedString(key: "save").uppercased(), for: .normal)
		saveButton.titleLabel?.font = Font_Titillium_Regular_H15
		saveButton.setTitleColor(UICOLOR_WHITE, for: .normal)
		saveButton.setTitleColor(UICOLOR_WHITE, for: .selected)
		saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
		let btnSave = UIBarButtonItem(customView: saveButton)
		navigationItem.rightBarButtonItem = btnSave
	}
    
	func getRoomsFromDatabase()
	{
        if self.comeFrom == .addNewRoomMood ||  self.comeFrom == .editRoomMood{
            
            var arrayOfRooms = [Room]()
            
            arrayOfRooms = DatabaseManager.sharedInstance().getAllRoomWithHomeID(home_id: VVBaseUserDefaults.getCurrentHomeID()) as! [Room]
            
            for roomItem in arrayOfRooms {
                if roomItem.room_id == VVBaseUserDefaults.getCurrentRoomID() {
                    arrRooms = [roomItem]
                    break
                }
            }
        }
        else{
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
		
		arrRooms.forEach { (room) in
            
            let nibName = Utility.getNibNameForClass(class_name: String.init(describing: RoomDetailForMoodSettingViewController.self))
            let controllerRoomDetailForMoodSetting = RoomDetailForMoodSettingViewController(nibName: nibName , bundle: nil)
			controllerRoomDetailForMoodSetting.parentNavigation = self.navigationController
			controllerRoomDetailForMoodSetting.title = room.room_name
			controllerRoomDetailForMoodSetting.objRoom = room
			controllerRoomDetailForMoodSetting.comeFrom = self.comeFrom
			controllerRoomDetailForMoodSetting.objMoodToEdit = self.objMoodToEdit
			controllerRoomDetailForMoodSetting.moodTypeForHomeOrDevice = self.moodTypeForHomeOrDevice
			controllerArray.append(controllerRoomDetailForMoodSetting)
		}
		
		
		
		// Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
		// Example:
		
		let parameters: [CAPSPageMenuOption] = [
			.scrollMenuBackgroundColor(UICOLOR_MAIN_BG),
			.viewBackgroundColor(UIColor.clear),
			.selectionIndicatorColor(UICOLOR_CAPSMENU_SELECTED_LINE),
			.unselectedMenuItemLabelColor(UIColor.lightGray),
			.menuItemFont(Font_SanFranciscoText_Regular_H18!),
			.menuHeight(55.0),
			.menuMargin(12.0),
			.selectionIndicatorHeight(3.0),
			.bottomMenuHairlineColor(UICOLOR_SEPRATOR),
			.selectedMenuItemLabelColor(UIColor.white),
			.menuItemWidthBasedOnTitleTextWidth(true),
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
        
        SSLog(message: self.view.frame.size.width)
//        self.reloadRoomDetailViewController(currentPageIndex: pageMenu.currentPageIndex)
	}
    func validateData()-> Bool
    {
        var allowToMakeAPICall : Bool? = false
        controllerArray.forEach { (cnt) in
            let switchBoxesInCnt = cnt.getCurrentStatusOfRoom()
            for switchBox in switchBoxesInCnt
            {
                let addSwitchBox = Utility.addCurrentSwitchBoxOrNot(objSwitchBox: switchBox)
                if addSwitchBox
                {
                    allowToMakeAPICall = true
                    break
                }
            }
        }
        return allowToMakeAPICall!
    }
	
	// MARK:- saveButtonTapped method
	@objc func saveButtonTapped() {
        
        if validateData(){
            let controller = AddMoodTimePopupViewController.init(nibName: "AddMoodTimePopupViewController", bundle: nil)
            controller.delegate = self
            controller.objMoodWrapper = self.objMoodWrapper
            let cntPopup = STPopupController.init(rootViewController: controller)
            cntPopup.present(in: self)
        }
        else
        {
          Utility.showAlertMessage(strMessage: SSLocalizedString(key: "please_on_atleast_one_switch"))
        }
	}
	//MARK:- AddMoodTimePopupViewControllerDelegate
	func didSelectedTime(objMoodWrapper : MoodWrapper) {
		let controller = SelectDaysPopUpViewController.init(nibName: "SelectDaysPopUpViewController", bundle: nil)
		controller.delegate = self
		controller.objMoodWrapper = objMoodWrapper
		let cntPopup = STPopupController.init(rootViewController: controller)
		cntPopup.present(in: self)
	}
	
	//MARK:- SelectDaysPopUpViewControllerDelegate
	func didSelectedDays(objMoodWrapper : MoodWrapper)
	{
		//Need Help Sapanesh Sir
		//		{"mood":[{"switchbox_id":"SB-5D69","switch_id":[0,1,2,3,5,4,6,7,8,9],"status":[1,1,0,0,0,1,0,0,0,0],"position":[1,1,1,1,1,1,1,1,1,1]}],"mood_time":"13:27","mood_type":3,"mood_repeat":[4,5],"mood_status":0,"mood_name":"hello"},"success":1}
		
		
		//Main Dict
		var moodDict = NSMutableDictionary()
		//Need Help Sapanesh Sir
		moodDict = Utility.createAJsonForDeviceOrHomeMoodSeeting(controllerArray: self.controllerArray, objMoodToEdit: self.objMoodToEdit, objMoodWrapper: self.objMoodWrapper, moodTypeForHomeOrDevice: self.moodTypeForHomeOrDevice!)
        
        var moodDictToStore = NSMutableDictionary()
        //Need Help Sapanesh Sir
        moodDictToStore = Utility.createAJsonForDeviceOrHomeMoodSeetingToStoreInDatabase(controllerArray: self.controllerArray, objMoodToEdit: self.objMoodToEdit, objMoodWrapper: self.objMoodWrapper, moodTypeForHomeOrDevice: self.moodTypeForHomeOrDevice!)
        
        self.addHomeMoodAPICall(moodDict: moodDict, moodDictToStore: moodDictToStore)
	}
	
	
	//API CALL BY GAURAV ISSUE
    func addHomeMoodAPICall(moodDict: NSMutableDictionary, moodDictToStore : NSMutableDictionary)
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API SM_TOPIC_CREATE_HOME_MOOD")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_CREATE_HOME_MOOD_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_CREATE_HOME_MOOD_ACK)
//                SSLog(message: "SUCCESSSSS  :: \(data!)")
                SSLog(message: "TOPIC  :: \(topic)")
                SSLog(message: "MYYY  :: \(SM_TOPIC_CREATE_HOME_MOOD_ACK)")
                
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_CREATE_HOME_MOOD_ACK)
                {
                    //We got data from Server
                    //Handle Success
                    //                Utility.delay(1.0
                    //                    , closure: {
                    var responseDict : NSDictionary?
                    do {
                        let obj = try JSONSerialization.jsonObject(with: data!, options: [])
                        //                    print(obj)
                        responseDict = obj as? NSDictionary
                    } catch let error {
                        print(error)
                    }
                    SSLog(message: "*************######## SUCCESSSSS CALLEDDDD *************########")
                    let moodId = responseDict?.value(forKey: "mood_id") as! String
                    moodDictToStore.setValue(moodId, forKey: "mood_id")
                    DatabaseManager.sharedInstance().addOrEditHomeMoodWithDictionary(moodDict: moodDictToStore)
                    self.delegate?.didAddedOrEditedMoodSuccessfully()
                    SMQTTClient.sharedInstance().subscribeAllTopic()
                    self.navigationController?.popViewController(animated: true)
                    
                    Utility.delay(3){
                        NotificationCenter.default.post(name: .handleMoodButtonAdded, object: nil)
                    }

                    print("here---- SM_TOPIC_CREATE_HOME_MOOD_ACK \(topic)")
                    //                })
                }

            }
            var dict =  NSMutableDictionary()
            dict = moodDict
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: dict,
                options: []) {
                let theJSONText = String(data: theJSONData,
                                         encoding: .ascii)
                print("JSON string = \(theJSONText!)")
            }
            
            
            SSLog(message: dict)
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_CREATE_HOME_MOOD) { (error) in
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
                print("error :\(String(describing: error))")
            }
        }
        //24/4/2019 make same topic for add and edit home mood
       /* if self.comeFrom == .addNewHomeMood
        {
            if !Utility.isAnyConnectionIssue()
            {
                SSLog(message: "API SM_TOPIC_CREATE_HOME_MOOD")
                SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_CREATE_HOME_MOOD_ACK) { (data, topic) in
                    SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_CREATE_HOME_MOOD_ACK)
                    SSLog(message: "SUCCESSSSS  :: \(data!)")
                    //We got data from Server
                    //Handle Success
                    var responseDict : NSDictionary?
                    do {
                        let obj = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(obj)
                        responseDict = obj as? NSDictionary
                    } catch let error {
                        print(error)
                    }
                    
                    let moodId = responseDict?.value(forKey: "mood_id") as! String
                    moodDict.setValue(moodId, forKey: "mood_id")
                    DatabaseManager.sharedInstance().addOrEditHomeMoodWithDictionary(moodDict: moodDict)
                    self.delegate?.didAddedOrEditedMoodSuccessfully()
                    self.navigationController?.popViewController(animated: true)
                    print("here---- SM_TOPIC_CREATE_HOME_MOOD_ACK \(topic)")
                }
                var dict =  NSMutableDictionary()
                dict = moodDict
                SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_CREATE_HOME_MOOD) { (error) in
                    if((error) != nil)
                    {
                        Utility.showErrorAccordingToLocalAndGlobal()
                    }
                    print("error :\(String(describing: error))")
                }
            }
        }
        else
        {
            if !Utility.isAnyConnectionIssue()
            {
                SSLog(message: "API SM_TOPIC_EDIT_HOME_MOOD")
                SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_CREATE_HOME_MOOD_ACK) { (data, topic) in
                    SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_CREATE_HOME_MOOD_ACK)
                    SSLog(message: "SUCCESSSSS  :: \(data!)")
                    //We got data from Server
                    //Handle Success
                    var responseDict : NSDictionary?
                    do {
                        let obj = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(obj)
                        responseDict = obj as? NSDictionary
                    } catch let error {
                        print(error)
                    }
                    
                    let moodId = responseDict?.value(forKey: "mood_id") as! String
                    moodDict.setValue(moodId, forKey: "mood_id")
                    DatabaseManager.sharedInstance().addOrEditHomeMoodWithDictionary(moodDict: moodDict)
                    self.delegate?.didAddedOrEditedMoodSuccessfully()
                    self.navigationController?.popViewController(animated: true)
                    print("here---- SM_TOPIC_CREATE_HOME_MOOD_ACK \(topic)")
                }
                var dict =  NSMutableDictionary()
                dict = moodDict
                SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_CREATE_HOME_MOOD) { (error) in
                    print("error :\(String(describing: error))")
                    if((error) != nil)
                    {
                        Utility.showErrorAccordingToLocalAndGlobal()
                    }
                }
            }
        }*/
    }
    
    func reloadRoomDetailViewController(currentPageIndex : Int)
    {
        let roomCnt = controllerArray[pageMenu.currentPageIndex]
        roomCnt.updateOnOrientationChange()
    }
    //MARK:- DEVICE ORIENTATION
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.reloadRoomDetailViewController(currentPageIndex: pageMenu.currentPageIndex)
    }
    
    //MARK:- CAPSPageMenuDelegate didMoveToPage willMoveToPage
    func didMoveToPage(_ controller: UIViewController, index: Int)
     {
        self.reloadRoomDetailViewController(currentPageIndex: index)
    }
   
    
}
