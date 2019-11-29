 //
//  RoomDetailForMoodSettingViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/21/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import STPopup

class RoomDetailForMoodSettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,AddMoodTimePopupViewControllerDelegate,SelectDaysPopUpViewControllerDelegate,RoomForMoodSettingTableViewCellDelegate,SetStepperValuePopupViewControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
	var parentNavigation : UINavigationController?
	var comeFrom:MoodSettingsMainContainerViewControllerComeFrom? = .addNewHomeMood
    var isComeToEditHardwareMood : Bool = false;
	var objRoom : Room!
	var arrSwitchBoxes = [SwitchBox]()
	var objMoodToEdit = Mood()
	var moodTypeForHomeOrDevice : Int? = MOOD_TYPE_HOME
    
    var isDeviceOrientationLandscape : Bool? = false
	
	//New For JSON
	var objMoodWrapper = MoodWrapper()
    
    var strSwitchBoxId : String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.arrSwitchBoxes.removeAll()
		setupTableView()
		if self.moodTypeForHomeOrDevice == MOOD_TYPE_DEVICE
		{
			//Add Save navigation Button
			self.setNavigationBarRightButton()
			if self.comeFrom == .editHomeMood
			{
                if !Utility.isEmpty(val: self.objMoodToEdit.mood_id)
                {
                    self.objMoodWrapper.mood_id = self.objMoodToEdit.mood_id
                }
				if !Utility.isEmpty(val: self.objMoodToEdit.mood_name)
				{
					self.objMoodWrapper.mood_name = self.objMoodToEdit.mood_name
				}
				if !Utility.isEmpty(val: self.objMoodToEdit.mood_time)
				{
					self.objMoodWrapper.mood_time = self.objMoodToEdit.mood_time
				}
				if !Utility.isEmpty(val: "\(self.objMoodToEdit.mood_status)")
				{
					self.objMoodWrapper.mood_status = self.objMoodToEdit.mood_status
				}
			}
		}
        getSwitchboxesFromDB()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .landscapeLeft || orientation == .landscapeRight
        {
            self.isDeviceOrientationLandscape = true
        }
        else
        {
            self.isDeviceOrientationLandscape = false
        }
    }
	func getSwitchboxesFromDB()
	{
		if Utility.isEmpty(val: objMoodToEdit.mood_id)
		{
			objMoodToEdit.mood_id = ""
		}
        if Utility.isEmpty(val: self.strSwitchBoxId)
        {
            self.strSwitchBoxId = ""
        }
        
        arrSwitchBoxes = DatabaseManager.sharedInstance().getAllSwitchBoxesWithRoomIDForMoodSettings(room_id: objRoom.room_id!, mood_id: objMoodToEdit.mood_id!, switchbox_id: self.strSwitchBoxId!, comeFrom: self.comeFrom!, moodTypeForHomeOrDevice: moodTypeForHomeOrDevice!) as! [SwitchBox]


	}
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
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func setupTableView() {
		view.backgroundColor = UICOLOR_MAIN_BG
		tableView.backgroundColor = UICOLOR_MAIN_BG
		// Registering nibs
		tableView.register(UINib.init(nibName: "RoomForMoodSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "RoomForMoodSettingTableViewCell")
        
        tableView.register(UINib.init(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyTableViewCell")
	}
	// MARK: - UITableView
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrSwitchBoxes.count
        
        if self.arrSwitchBoxes.count != 0
        {
            return arrSwitchBoxes.count
        }
        else
        {
            return 1
        }
	}
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return RoomForMoodSettingTableViewCell.hightForRoomCellMoodSettingTableViewCell(switchbox: arrSwitchBoxes[indexPath.row])
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
        if self.arrSwitchBoxes.count != 0
        {
            return UITableViewAutomaticDimension
        }
        else
        {
            return self.tableView.frame.size.height
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.arrSwitchBoxes.count != 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoomForMoodSettingTableViewCell", for: indexPath) as! RoomForMoodSettingTableViewCell
            cell.delegate = self
            cell.configureCellWithSwitchBox(switchbox: arrSwitchBoxes[indexPath.row], isDeviceOrientationLandscape: self.isDeviceOrientationLandscape!)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell
            cell.configureCellWithEmptyMsg(emptyMsg: SSLocalizedString(key: "no_devices_added_yet"))
            return cell
        }
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
	func getCurrentStatusOfRoom() -> [SwitchBox]
	{
		return self.arrSwitchBoxes
	}
    
    func validateData()-> Bool
    {
        var     controllerArray = [RoomDetailForMoodSettingViewController]()
        controllerArray.append(self)
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
    
    
	//MARK:- saveButtonTapped
	@objc func saveButtonTapped() {
        if validateData()
        {
            if self.moodTypeForHomeOrDevice == MOOD_TYPE_DEVICE
            {
                if self.comeFrom == .editHomeMood
                {
                    self.didSelectedDays(objMoodWrapper: self.objMoodWrapper)
                }
            }
            else
            {
                let controller = AddMoodTimePopupViewController.init(nibName: "AddMoodTimePopupViewController", bundle: nil)
                controller.delegate = self
                controller.objMoodWrapper = self.objMoodWrapper
                let cntPopup = STPopupController.init(rootViewController: controller)
                cntPopup.present(in: self)
            }
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
		SSLog(message: "CreateFinalJSONHear For Configure Device Mood")
		var	 controllerArray = [RoomDetailForMoodSettingViewController]()
		controllerArray.append(self)
		
		//Main Dict
		var moodDict = NSMutableDictionary()
		moodDict = Utility.createAJsonForDeviceOrHomeMoodSeeting(controllerArray: controllerArray, objMoodToEdit: self.objMoodToEdit, objMoodWrapper: self.objMoodWrapper, moodTypeForHomeOrDevice: self.moodTypeForHomeOrDevice!)
        
        
        var moodDictToStore = NSMutableDictionary()
        moodDictToStore = Utility.createAJsonForDeviceOrHomeMoodSeetingToStoreInDatabase(controllerArray: controllerArray, objMoodToEdit: self.objMoodToEdit, objMoodWrapper: self.objMoodWrapper, moodTypeForHomeOrDevice: self.moodTypeForHomeOrDevice!)
        self.editDeviceMoodAPICall(moodDict: moodDict, moodDictToStore: moodDictToStore)
	}
	//MARK:- RoomForMoodSettingTableViewCellDelegate
	func longPressOnSteapperView(obj: Mood)
	{
		let controller = SetStepperValuePopupViewController.init(nibName: "SetStepperValuePopupViewController", bundle: nil)
		controller.objMood = obj
		controller.delegate = self
		controller.comeFrom = .moodSeetings
		let cntPopup = STPopupController.init(rootViewController: controller)
		cntPopup.transitionStyle = .fade;
		if self.moodTypeForHomeOrDevice == MOOD_TYPE_HOME
		{
			cntPopup.present(in: self.parentNavigation!)
		}
		else
		{
			cntPopup.present(in: self)
		}
		
	}
	//MARK:- SetStepperValuePopupViewControllerDelegate
	func didChangeTheSteeperValue(obj : Switch)
	{
		return
	}
	func didChangeTheSteeperValueForMoodSettings(obj : Mood)
	{
		SSLog(message: obj.position)
		//MVC Automatically reflect change in UI
		self.tableView.reloadData()
	}
	
	
	//API CALL BY GAURAV ISSUE
    func editDeviceMoodAPICall(moodDict: NSMutableDictionary, moodDictToStore : NSMutableDictionary)
	{
        if !Utility.isAnyConnectionIssue()
        {
			SSLog(message: "API SM_TOPIC_EDIT_HOME_MOOD")
			SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_CREATE_HOME_MOOD_ACK) { (data, topic) in
				SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_CREATE_HOME_MOOD_ACK)
				SSLog(message: "SUCCESSSSS  :: \(data!)")
				//We got data from Server
				//Handle Success
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_CREATE_HOME_MOOD_ACK)
                {
                    var responseDict : NSDictionary?
                    do {
                        let obj = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(obj)
                        responseDict = obj as? NSDictionary
                    } catch let error {
                        print(error)
                    }
                    
                    let moodId = responseDict?.value(forKey: "mood_id") as! String
                    moodDictToStore.setValue(moodId, forKey: "mood_id")
                    DatabaseManager.sharedInstance().addOrEditHomeMoodWithDictionary(moodDict: moodDictToStore)
                    //                self.delegate?.didAddedOrEditedMoodSuccessfully()
                    self.navigationController?.popViewController(animated: true)
                    print("here---- SM_TOPIC_CREATE_HOME_MOOD_ACK \(topic)")
                }
			}
			var dict =  NSMutableDictionary()
			dict = moodDict
            //4. Edit hardware mood: Sends request on incorrect topic (PI-VI3MI5/HM-02A0F/edit_home_mood). Correct topic is PIID/HOMEID/create_hardware_mood_from_app
            if self.isComeToEditHardwareMood
            {
                SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_EDIT_HARDWARD_MOOD_FROM_APP) { (error) in
                    print("error :\(String(describing: error))")
                    if((error) != nil)
                    {
                        Utility.showErrorAccordingToLocalAndGlobal()
                    }
                }
            }
            else
            {
                //UPDATEHERE
                SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_CREATE_HOME_MOOD) { (error) in
                    print("error :\(String(describing: error))")
                    if((error) != nil)
                    {
                        Utility.showErrorAccordingToLocalAndGlobal()
                    }
                }
            }

        }
	}
    
    //MARK:- DEVICE ORIENTATION
    func updateOnOrientationChange() {
        if UIDevice.current.orientation.isLandscape {
            self.isDeviceOrientationLandscape = true
        } else {
            self.isDeviceOrientationLandscape = false
        }
        self.tableView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateOnOrientationChange()
    }
}
