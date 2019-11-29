//
//  MenuCell.swift
//  CalenderApp
//
//  Created by Pradip Parkhe on 1/15/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var btnSwitch: UIButton!
	
	@IBOutlet weak var btnSwitchWidth: NSLayoutConstraint!
	var objSwitch = Switch()
	var objSwitchBox = SwitchBox()
	 var comeFrom:MenuViewControllerComeFrom?
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblTitle.font = Font_Titillium_Regular_H16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
	func configureCellWith(obj : Any, comeFrom : MenuViewControllerComeFrom)
	{
		self.comeFrom = comeFrom
		if self.comeFrom == .room
		{
			self.objSwitchBox = obj as! SwitchBox
			self.btnSwitch.setImage(#imageLiteral(resourceName: "on"), for: .selected) // if child_lock == 1 then On
			self.btnSwitch.setImage(#imageLiteral(resourceName: "off"), for: .normal)  // if child_lock == 0 then off
			self.btnSwitch.isSelected = true
			if self.objSwitchBox.child_lock == 0
			{
				self.btnSwitch.isSelected = false
			}
		}
		else
		{
			self.objSwitch = obj as! Switch
//			master_mode_status == 0 OUT
//			master_mode_status == 1 IN
			self.btnSwitch.setImage(#imageLiteral(resourceName: "out"), for: .normal) //if master_mode_status == 0 OUT
			self.btnSwitch.setImage(#imageLiteral(resourceName: "in"), for: .selected) //if master_mode_status == 1 IN
			self.btnSwitch.isSelected = true
			if self.objSwitch.master_mode_status == 0
			{
				self.btnSwitch.isSelected = false
			}
		}
	}
	@IBAction func tappedSwitch(_ sender: Any) {
        
        if Utility.isRestrictOperation(){
            Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
        }
        else
        {
            if self.comeFrom == .room
            {
                self.btnSwitch.isSelected = !self.btnSwitch.isSelected
                
                var str = "1"
                if self.btnSwitch.isSelected == false {
                    // off
                    str = "0"
                }
                
                self.childLockAPICall(obj: self.objSwitchBox, str: str)
            }
            else
            {
                SSLog(message: "handle objSwitch ")
                self.btnSwitch.isSelected = !self.btnSwitch.isSelected
                
                var str = "1"
                if self.btnSwitch.isSelected == false {
                    // off
                    str = "0"
                }
                self.masterSwitchInOutAPICall(obj: self.objSwitch, str: str)
            }
        }
	}
	
	//MARK:- MASTERSWITCH IN-OUT API CALL
	func masterSwitchInOutAPICall(obj : Switch,str: String)
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API masterSwitchInOutAPICall")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_MASTER_MOOD_APP_TO_RPI_FEEDBACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_MASTER_MOOD_APP_TO_RPI_FEEDBACK)
                SSLog(message: "TOPIC : \(topic)")
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_MASTER_MOOD_APP_TO_RPI_FEEDBACK)
                {
                    SSLog(message: "SUCCESSSSSSSSSSSS")
                    //We got data from Server
                    if let objSwitch : Switch? = Switch.decode(data!){
                        //Handle Success
                        DatabaseManager.sharedInstance().updateSwitchMasterModeInOutStatus(self.objSwitch, master_mode_status: str)
                        self.objSwitch.master_mode_status = Int(str)
                        //MVC Data Will Be Updated
                        
                        SMQTTClient.sharedInstance().subscribeAllTopic()
                        NotificationCenter.default.post(name: .dismissPopup, object: nil)
                        print("here---- SM_TOPIC_MASTER_MOOD_APP_TO_RPI_FEEDBACK \(topic)")
                    }
                }
            }
            
            let dict =  NSMutableDictionary()
            dict.setValue(obj.switchbox_id, forKey: "switchbox_id");
//            dict.setValue("\(obj.switch_id!)", forKey: "master_mode_switch_id");
//            dict.setValue(obj.switch_id), forKey: "master_mode_switch_id");
            dict.setValue(obj.switch_id, forKey: "master_mode_switch_id")
            dict.setValue("\(str)", forKey: "master_mode_active");//IN ==1 OUT == 0
            
            print("switchdata \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_MASTER_MOOD_APP_TO_RPI) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
	
	
	//MARK:- CHILDLOCK API CALL
	func childLockAPICall(obj : SwitchBox,str: String)
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API childLockAPICall")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_CHILD_MOOD_APP_TO_RPI_FEEDBACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_CHILD_MOOD_APP_TO_RPI_FEEDBACK)
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_CHILD_MOOD_APP_TO_RPI_FEEDBACK)
                {
                    SSLog(message: "SUCCESSSSSSSSSSSS")
                    //We got data from Server
                    //            if let objSwitch : Switch? = Switch.decode(data!){
                    //Handle Success
                    DatabaseManager.sharedInstance().updateSwitchBoxChildLockStatus(child_lock: str, switchbox_id: self.objSwitchBox.switchbox_id!)
                    //MVC Data Will Be Updated
                    self.objSwitchBox.child_lock = Int(str)
                    //MVC Data Will Be Updated
                    SMQTTClient.sharedInstance().subscribeAllTopic()
                    NotificationCenter.default.post(name: .dismissPopup, object: nil)
                    print("here---- SM_TOPIC_CHILD_MOOD_APP_TO_RPI_FEEDBACK \(topic)")
                    //            }
                }
            }
            
            let dict =  NSMutableDictionary()
            dict.setValue(obj.switchbox_id, forKey: "switchbox_id");
            dict.setValue("\(str)", forKey: "child_lock_active");//IN ==1 OUT == 0
            
            print("Data \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_CHILD_MOOD_APP_TO_RPI) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
}

