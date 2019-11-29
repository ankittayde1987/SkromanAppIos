//
//  SkormanPopupViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import STPopup

protocol SkormanPopupViewControllerDelegate {
	func reloadControllerData()
    func dissmissPopupAndLoadMoodSeetings(strMoodName: String, mood_id : String, comeFrom: SkormanPopupViewControllerComeFrom)
}

class SkormanPopupViewController: BaseViewController,UITextFieldDelegate {
    
    var delegate : SkormanPopupViewControllerDelegate?
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtUsedFor: UITextField!
    @IBOutlet weak var vwTxtFieldContainer: UIView!
    @IBOutlet weak var lblUsedFor: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblPopUpTitle: UILabel!
    @IBOutlet weak var vwTitleSeprator: UIView!
    
    
    var moodCountToCreateId : String?
    var comeFrom:SkormanPopupViewControllerComeFrom? = .renameSwitchBox
    var objSwitchBox = SwitchBox()
    var objMood = Mood()
    var objSwitch = Switch()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initController()
    }
    func initController()
    {
        if Utility.isIpad()
        {
            self.contentSizeInPopup = CGSize.init(width: CONSTANT_IPAD_VIEW_WIDTH - 60, height: 180)
        }
        else
        {
            self.contentSizeInPopup = CGSize.init(width: SCREEN_SIZE.width - 60, height: 180)
        }
        
        
        self.view.backgroundColor = UICOLOR_MAIN_BG
        self.view.layer.cornerRadius = 3.0
        self.view.layer.borderWidth = 1.0
        self.view.layer.borderColor = UICOLOR_POPUP_BORDER.cgColor
        self.popupController?.containerView.layer.cornerRadius = 3.0
        self.popupController?.containerView.layer.borderWidth = 1.0
        self.popupController?.containerView.layer.borderColor = UICOLOR_POPUP_BORDER.cgColor
        
        self.vwTitleSeprator.backgroundColor = UICOLOR_POPUP_BORDER
        self.popupController?.navigationBarHidden = true
        self.lblPopUpTitle.font = Font_Titillium_Semibold_H16
        self.lblUsedFor.font = Font_Titillium_Regular_H14
        self.txtUsedFor.font = Font_Titillium_Regular_H15
        self.btnSave.titleLabel?.font = Font_Titillium_Regular_H16
        self.btnSave.backgroundColor = UICOLOR_BLUE
        
        self.vwTxtFieldContainer.backgroundColor = UICOLOR_WHITE
        self.vwTxtFieldContainer.layer.borderWidth = 1.0
        self.vwTxtFieldContainer.layer.borderColor = UICOLOR_TXTFIELD_BORDER_COLOR.cgColor
        
        self.txtUsedFor.becomeFirstResponder()
        if self.comeFrom == .renameSwitchBox
        {
            self.txtUsedFor.text = self.objSwitchBox.name
            self.lblPopUpTitle.text = SSLocalizedString(key: "rename_device").uppercased()
            self.lblUsedFor.text = SSLocalizedString(key: "set_new_name")
            btnSave.setTitle(SSLocalizedString(key: "save").uppercased(), for: .normal)
            
        }
        else if self.comeFrom == .addNewMood
        {
            self.lblPopUpTitle.text = SSLocalizedString(key: "add_new_mood").uppercased()
            self.lblUsedFor.text = SSLocalizedString(key: "add_mood_name")
            btnSave.setTitle(SSLocalizedString(key: "add").uppercased(), for: .normal)
        }
        else if self.comeFrom == .addRoomMood
        {
            self.lblPopUpTitle.text = SSLocalizedString(key: "add_new_mood").uppercased()
            self.lblUsedFor.text = SSLocalizedString(key: "add_mood_name")
            btnSave.setTitle(SSLocalizedString(key: "add").uppercased(), for: .normal)
        }
        else if self.comeFrom == .renameMoodName
        {
            if !Utility.isEmpty(val: self.objMood.mood_name)
            {
                self.txtUsedFor.text = self.objMood.mood_name
            }
            self.lblPopUpTitle.text = SSLocalizedString(key: "rename_mood").uppercased()
            self.lblUsedFor.text = SSLocalizedString(key: "set_new_name")
            btnSave.setTitle(SSLocalizedString(key: "save").uppercased(), for: .normal)
        }
        else if self.comeFrom == .switchPowerConsumption
        {
            self.txtUsedFor.keyboardType = .numberPad
            self.lblPopUpTitle.text = SSLocalizedString(key: "set_power_consumption").uppercased()
            self.lblUsedFor.text = SSLocalizedString(key: "power_consumption_in_kw")
            btnSave.setTitle(SSLocalizedString(key: "save").uppercased(), for: .normal)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedClose(_ sender: Any) {
        self.popupController?.dismiss()
    }
    
    @IBAction func tappedSave(_ sender: Any) {
        let isValidData: Bool = validateUserEnteredData()
        if isValidData {
            //handle valid data action
            if self.comeFrom == .renameSwitchBox
            {
                self.renameSwitchBoxName(switchBoxName: self.txtUsedFor.text!, switchBoxID: self.objSwitchBox.switchbox_id!)
            }
            else if self.comeFrom == .addNewMood
            {
                //"mood_id":"HM-02A0F_MOOD_1"
                self.popupController?.dismiss(completion: {
                    let mood_id = VVBaseUserDefaults.getCurrentHomeID() + "_MOOD_" + (self.moodCountToCreateId ?? "1")
                    self.delegate?.dissmissPopupAndLoadMoodSeetings(strMoodName: self.txtUsedFor.text!, mood_id: mood_id, comeFrom: self.comeFrom!)
                })
            }
            else if self.comeFrom == .addRoomMood
            {
                //"mood_id":"HM-02A0F_RM-0A55_MOOD_1"
                self.popupController?.dismiss(completion: {
                    let mood_id = VVBaseUserDefaults.getCurrentHomeID() + "_" + VVBaseUserDefaults.getCurrentRoomID() + "_MOOD_" + (self.moodCountToCreateId ?? "1")
                    self.delegate?.dissmissPopupAndLoadMoodSeetings(strMoodName: self.txtUsedFor.text!, mood_id: mood_id, comeFrom: self.comeFrom!)
                })
            }
            else if self.comeFrom == .renameMoodName
            {
                //Need Help Sapanesh Sir
                self.renameHomeMoodName(homeMoodName: self.txtUsedFor.text!)
            }
            else if self.comeFrom == .switchPowerConsumption
            {
                self.popupController?.dismiss(completion: {
                    self.powerConsumptionAPICall(obj: self.objSwitch)
                })
            }
        }
    }
    // MARK:- validateUserEnteredData method
    func validateUserEnteredData() -> Bool {
        self.txtUsedFor.resignFirstResponder()
        if self.comeFrom == .renameSwitchBox
        {
            if(Utility.isEmpty(val: txtUsedFor.text!.removingWhitespaces())){
                showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_new_name"))
                return false
            }
        }
        else if self.comeFrom == .addNewMood
        {
            if(Utility.isEmpty(val: txtUsedFor.text!.removingWhitespaces())){
                showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_mood_name"))
                return false
            }
        }
        else if self.comeFrom == .renameMoodName
        {
            if(Utility.isEmpty(val: txtUsedFor.text!.removingWhitespaces())){
                showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_new_name"))
                return false
            }
        }
        else if self.comeFrom == .switchPowerConsumption
        {
            if(Utility.isEmpty(val: txtUsedFor.text!.removingWhitespaces())){
                showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_power_consumption"))
                return false
            }
        }
        return true
    }
    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //API CALL BY GAURAV
    func renameHomeMoodName(homeMoodName : String)
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API renameHomeMoodName")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_RENAME_HOME_MOOD_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_RENAME_HOME_MOOD_ACK)
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_RENAME_HOME_MOOD_ACK)
                {
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
                    self.objMood.mood_name = responseDict?.value(forKey: "mood_name") as? String
                    DatabaseManager.sharedInstance().updateMood(objMood: self.objMood)
                    self.delegate?.reloadControllerData()
                    self.popupController?.dismiss()
                    print("here---- SM_TOPIC_RENAME_HOME_MOOD_ACK \(topic)")
                }
            }
            let dict =  NSMutableDictionary()
            dict.setValue(self.objMood.mood_id, forKey: "mood_id");
            dict.setValue(homeMoodName, forKey: "mood_name");
            
            print("dict \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_RENAME_HOME_MOOD) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
    
    //MARK:- powerConsumptionAPICall
    func powerConsumptionAPICall(obj : Switch)
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API powerConsumptionAPICall")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_SET_WATTAGE_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_SET_WATTAGE_ACK)
                SSLog(message: "TOPICCCCC:: \(topic)")
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_SET_WATTAGE_ACK)
                {
                    SSLog(message: "SUCCESSSSSSSSSSSS")
                    //We got data from Server
                    if let objSwitch : Switch? = Switch.decode(data!){
                        //Handle Success
                        SSLog(message: objSwitch)
                        print("here---- SM_TOPIC_SET_WATTAGE_ACK \(topic)")
                    }
                }
            }
            let dict =  NSMutableDictionary()
            dict.setValue(obj.switchbox_id, forKey: "switchbox_id");
//            dict.setValue("\(obj.switch_id!)", forKey: "switch_id");
            dict.setValue(obj.switch_id, forKey: "switch_id")
            dict.setValue(self.txtUsedFor.text, forKey: "wattage")
            print("switchdata \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_SET_WATTAGE) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
    
    //API CALL BY GAURAV
    func renameSwitchBoxName(switchBoxName : String, switchBoxID : String)
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API renameHomeMoodName")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_RENAME_SWITCHBOX_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_RENAME_SWITCHBOX_ACK)
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_RENAME_SWITCHBOX_ACK)
                {
                    //We got data from Server
                    //Handle Success
                    DatabaseManager.sharedInstance().updateSwitchBoxName(switchboxNew_name: switchBoxName, switchbox_id: switchBoxID)
                    self.delegate?.reloadControllerData()
                    self.popupController?.dismiss()
                    print("here---- SM_TOPIC_RENAME_SWITCHBOX_ACK \(topic)")
                }
            }
            let dict =  NSMutableDictionary()
            dict.setValue(switchBoxID, forKey: "unique_switchbox_id");
            dict.setValue(switchBoxName, forKey: "switchbox_name");
            
            print("dict \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_RENAME_SWITCHBOX) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
}
