//
//  DeleteOptionsPopupViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/28/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import STPopup

protocol DeleteOptionsPopupViewControllerDelegate {
	func deleteSuccessfully()
}

class DeleteOptionsPopupViewController: UIViewController {
	var delegate: DeleteOptionsPopupViewControllerDelegate?
	var comeFrom : DeleteOptionsPopupViewControllerComeFrom? = .deleteHomeMood
	@IBOutlet weak var btnPermanent: UIButton!
	@IBOutlet weak var btnLocally: UIButton!
	@IBOutlet weak var btnClose: UIButton!
	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var lblPopupTitle: UILabel!
	var objMood = Mood()
	var objRoom = Room()
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.initController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
		
		self.vwSeprator.backgroundColor = UICOLOR_POPUP_BORDER
		self.popupController?.navigationBarHidden = true
		self.lblPopupTitle.font = Font_Titillium_Semibold_H16
		self.btnLocally.titleLabel?.font = Font_Titillium_Regular_H16
		self.btnLocally.backgroundColor = UICOLOR_TEXTFIELD_CONTAINER_BG
		
		self.btnPermanent.titleLabel?.font = Font_Titillium_Regular_H16
		self.btnPermanent.backgroundColor = UICOLOR_TEXTFIELD_CONTAINER_BG
		
		self.btnLocally.setTitle(SSLocalizedString(key: "locally"), for: .normal)
		self.btnLocally.setTitle(SSLocalizedString(key: "locally"), for: .selected)
		
		self.btnPermanent.setTitle(SSLocalizedString(key: "permanantly"), for: .normal)
		self.btnPermanent.setTitle(SSLocalizedString(key: "permanantly"), for: .selected)
		
		self.lblPopupTitle.text = SSLocalizedString(key: "delete_mood").uppercased()
		
		self.btnLocally.layer.cornerRadius = 3.0
		self.btnLocally.layer.borderWidth = 1.0
		self.btnLocally.layer.borderColor = UICOLOR_TEXTFIELD_CONTAINER_BORDER.cgColor
		
		self.btnPermanent.layer.cornerRadius = 3.0
		self.btnPermanent.layer.borderWidth = 1.0
		self.btnPermanent.layer.borderColor = UICOLOR_TEXTFIELD_CONTAINER_BORDER.cgColor
		
	}

	//MARK :- IBAction
	@IBAction func tappedOnClose(_ sender: Any) {
		self.popupController?.dismiss()
	}
	
	@IBAction func tappedOnLocally(_ sender: Any) {
		//Need Help Sapanesh Sir
		if self.comeFrom == .deleteHomeMood
		{
			DatabaseManager.sharedInstance().deleteMoodWithMoodId(mood_id: self.objMood.mood_id!)
		}
		else if self.comeFrom == .deleteRoom
		{
			DatabaseManager.sharedInstance().deleteRoomWithRoomID(room_id: self.objRoom.room_id!)
            NotificationCenter.default.post(name: .defaultHomeChange, object: nil)
		}
		self.delegate?.deleteSuccessfully()
		self.popupController?.dismiss()
	}
	
	@IBAction func tappedOnPermanently(_ sender: Any) {
		//TEMPORARY FOR PERMANANTLY NEED API CALL
		if self.comeFrom == .deleteHomeMood
		{
			//Need Help Sapanesh Sir
			self.deleteHomeMood()

		}
		else if self.comeFrom == .deleteRoom
		{
			//Need Help Sapanesh Sir
			DatabaseManager.sharedInstance().deleteRoomWithRoomID(room_id: self.objRoom.room_id!)
		}
		self.delegate?.deleteSuccessfully()
		self.popupController?.dismiss()
	}
	
	
	//API CALL BY GAURAV ISSUE
	func deleteHomeMood()
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API deleteHomeMood")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_DELETE_HOME_MOOD_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_DELETE_HOME_MOOD_ACK)
                //We got data from Server
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_DELETE_HOME_MOOD_ACK)
                {
                       DatabaseManager.sharedInstance().deleteMoodWithMoodId(mood_id: self.objMood.mood_id!)
                }
                print("here---- SM_TOPIC_DELETE_HOME_MOOD_ACK \(topic)")
            }
            let dict =  NSMutableDictionary()
            dict.setValue(self.objMood.mood_id, forKey: "mood_id");
            
            print("dict \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_DELETE_HOME_MOOD) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
}
