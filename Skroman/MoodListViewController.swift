//
//  MoodListViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

let spacing: CGFloat = 8

import UIKit
import STPopup

protocol MoodListViewControllerDelegate {
	func gotoConfigureMoodForDevice(strSwitchBox_id : String,objMood : Mood, objRoom: Room)
}

class MoodListViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,MoodNameContainerCollectionViewCellDelegate,MenuViewDelegate,SkormanPopupViewControllerDelegate,MoodSettingsMainContainerViewControllerDelegate {
	var delegate : MoodListViewControllerDelegate?
	@IBOutlet weak var lblConfigureMoods: UILabel!
	@IBOutlet weak var vwInfoContainer: UIView!
	@IBOutlet weak var vwBackground: UIView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
	@IBOutlet weak var containerViewTop: NSLayoutConstraint!
	
	var arrDeviceMoods = [Mood]()
	var strSwitchBox_id = String()
	var objRoom = Room()
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.getDeviceMoodsFromDB()
		self.modalPresentationStyle = .overCurrentContext
		self.setupCollectionView()
		self.collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
	
	func getDeviceMoodsFromDB()
	{
		arrDeviceMoods = DatabaseManager.sharedInstance().getAllMoodsForDeviceMoodSettings(switchBox_id: self.strSwitchBox_id) as! [Mood]
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setToolbarHidden(true, animated: true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.setToolbarHidden(false, animated: true)
	}
	
	deinit {
		self.collectionView.removeObserver(self, forKeyPath: "contentSize", context: nil)
	}
	
	fileprivate func setupCollectionView() {
		//Basic SetUp
		self.lblConfigureMoods.font = Font_Titillium_Semibold_H16
		self.lblConfigureMoods.textColor = UICOLOR_MAIN_BG
		self.lblConfigureMoods.text = SSLocalizedString(key: "configure_moods").uppercased()
		//Added tap gesture and long gesture
		let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tappedView(_:)))
		self.vwBackground.addGestureRecognizer(tapGestureRecognizer)
		
		let layout = GauravCollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		collectionView.collectionViewLayout = layout

		// Registering nibs
		collectionView.register(UINib.init(nibName: "MoodNameContainerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MoodNameContainerCollectionViewCell")
	}
	@objc func tappedView(_ sender : UIView)
	{
		dismiss(animated: true, completion: nil)
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "contentSize" {
			collectionViewHeight.constant = self.collectionView.contentSize.height
			containerViewTop.constant = -(collectionViewHeight.constant + collectionView.frame.origin.y + UIAppDelegate.windowSafeAreaInsets.bottom)
			self.view.layoutIfNeeded()
		}
	}
	
	
	// MARK: - UICollectionViewDataSource
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return arrDeviceMoods.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: MoodNameContainerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoodNameContainerCollectionViewCell", for: indexPath) as! MoodNameContainerCollectionViewCell
		cell.delegate = self
		cell.configureCellWith(obj: self.arrDeviceMoods[indexPath.row], indexPath: indexPath)
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

	}
	
	// MARK: - UICollectionViewDelegateFlowLayout
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		//Need to calculate Width for Button according to text here
		let obj = self.arrDeviceMoods[indexPath.row]
		let str =  obj.mood_name
		var rect: CGRect = str!.boundingRect(with: CGSize(width: 500, height: 500), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: Font_Titillium_Regular_H16!], context: nil)
		rect.size.width += 30;
		rect.size.width = ceil(rect.size.width);

		return CGSize(width: rect.size.width, height: 34)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsMake(9, 14, 9, 14)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		// vertical space between cells
		return spacing
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		// horizontal space between cells
		return spacing
	}
	
	//MARK:- MoodNameContainerCollectionViewCellDelegate
	func tappedOnMoodBtnFromDeviceMood(obj : Mood,indexPath : IndexPath)
	{

        self.triggerMood(objMood: obj, indePath: indexPath)
//        DatabaseManager.sharedInstance().updateMood(objMood: obj)
//        self.collectionView.reloadItems(at: [indexPath])
	}
	func longPressOnButtonMoodFromDeviceMood(_ sender: UIButton, obj : Mood,indexPath : IndexPath) {
		let viewFrameInRespectToView = sender.convert(sender.frame, to: UIAppDelegate.window)
		let svc = MenuViewController.init(nibName: "MenuViewController", bundle: nil)
		svc.menuDelegate = self
		svc.comeFrom = .deviceMoods
		svc.objMood = obj
		svc.tappedViewFrame = viewFrameInRespectToView
		svc.modalTransitionStyle = .crossDissolve
		svc.modalPresentationStyle = .custom
		present(svc, animated: true, completion: nil)
	}
	//MARK:- MenuViewDelegate
	func didSelectOption(indexPath: IndexPath, comeFrom: MenuViewControllerComeFrom, obj: Any)
	{
		SSLog(message: "tapped")
		let objM = obj as! Mood
		if comeFrom == .deviceMoods
		{
            if Utility.isRestrictOperation(){
                Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
            }
            else
            {
                if indexPath.row == 0
                {
                    //Configure Moods
                    SSLog(message: "Configure Mood")
                    self.dismiss(animated: true, completion: {
                        self.delegate?.gotoConfigureMoodForDevice(strSwitchBox_id: self.strSwitchBox_id, objMood: objM, objRoom: self.objRoom)
                    })
                }
                else
                {
                    //Rename Mood
                    SSLog(message: "Rename Mood")
                    let controller = SkormanPopupViewController.init(nibName: "SkormanPopupViewController", bundle: nil)
                    controller.comeFrom = .renameMoodName
                    controller.objMood = objM
                    controller.delegate = self
                    let cntPopup = STPopupController.init(rootViewController: controller)
                    cntPopup.present(in: self)
                }
            }
		}
	}
	
	
	//MARK:- SkormanPopupViewControllerDelegate
	func reloadControllerData()
	{
		getDeviceMoodsFromDB()
		self.collectionView.reloadData()
	}
	 func dissmissPopupAndLoadMoodSeetings(strMoodName: String, mood_id : String, comeFrom: SkormanPopupViewControllerComeFrom)
	{
		return
	}
	//MARK:- MoodSettingsMainContainerViewControllerDelegate
	func didAddedOrEditedMoodSuccessfully()
	{
		getDeviceMoodsFromDB()
		
	}
    
    //API CALL BY GAURAV
    func triggerMood(objMood : Mood, indePath : IndexPath)
    {
        if !Utility.isAnyConnectionIssue()
        {
            /* Ankit : for reflection of switches icon on mood selection */
//            SSLog(message: "API triggerMood")
//            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_HARDWARD_MOOD_TRIGGERED_ACK) { (data, topic) in
//                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_HARDWARD_MOOD_TRIGGERED_ACK)
//                //We got data from Server
//                //Handle Success
//                var responseDict : NSDictionary?
//                do {
//                    let obj = try JSONSerialization.jsonObject(with: data!, options: [])
////                    print(obj)
//                    responseDict = obj as? NSDictionary
//                } catch let error {
//                    print(error)
//                }
//                var mood_status = 0
//                //Need to handle it here
//                if let str = responseDict?.value(forKey: "mood_status") as? Int {
//                    mood_status = str
//                }
//                var mood_id = ""
//                if let str1 = responseDict?.value(forKey: "mood_id") as? String {
//                    mood_id = str1
//                }
//
//                print("responseDict %@" , responseDict as Any)
//                DatabaseManager.sharedInstance().updateMoodStatus(moodStatus: mood_status, moodId: mood_id)
//
//                NotificationCenter.default.post(name: .handleMoodButtonAdded, object: nil)
//            }
            print(objMood.mood_status)
            
            /*     By Ankit : To switch ON/OFF mood on same button    */
            if (objMood.mood_status == 0){
                
                let moodForSwitches : Mood =    DatabaseManager.sharedInstance().getMood(mood_id: objMood.mood_id!)
                let arrayOfAllSwitchesInMood : NSMutableArray =    DatabaseManager.sharedInstance().getAllSwitchWithSwitchBoxID(switchbox_id: moodForSwitches.switchbox_id!)
                
                for switchObj in arrayOfAllSwitchesInMood{
                                                            
                    var newSwitch = Switch()
                    newSwitch = switchObj as! Switch
                    
                    let dict =  NSMutableDictionary()

                    if newSwitch.switch_id != nil {
                        dict.setValue("\(newSwitch.switch_id!)", forKey: "switch_id")
                    }
                    if newSwitch.switchbox_id != nil {
                        dict.setValue("\(newSwitch.switchbox_id!)", forKey: "switchbox_id")
                    }
                    if newSwitch.status != nil {
                        
                        if newSwitch.status == 1{
                            dict.setValue("0", forKey: "status")
                        }
                        else{
                            dict.setValue("0", forKey: "status")
                        }
                    }
                    if newSwitch.position != nil {
                        dict.setValue("\(newSwitch.position!)", forKey: "position")
                    }
                    dict.setValue("1", forKey: "slide_end");
                    
                    
                    if !Utility.isAnyConnectionIssue() {
                        
                                SSLog(message: "API updateSwitchAPICall")
//                                SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_UPDATE_SWITCH_ACK_APP) { (data, topic) in
//                                    SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_UPDATE_SWITCH_ACK_APP)
//                                    SSLog(message: "Successsssss")
//                                    //We got data from Server
//
//
//                                    if let objSwitch : Switch? = Switch.decode(data!){
//                                         if objSwitch != nil{
//                                                if objSwitch == nil{
//                                                    SSLog(message: " Check by ankit for mumbai acetech 2019 , remove once fixed from server end")
//                                                }
//                                                else{
//                                                    DatabaseManager.sharedInstance().updateSwitchStatus(objSwitch!, status: objSwitch?.status ?? 0)
//                                                    NotificationCenter.default.post(name: .updateSwitchBoardWhenExistingSelectedMoodClicked, object: nil)
//                                                }
//                                        }}
//                                    NotificationCenter.default.post(name: .switchValueChange, object: nil)
//                                    print("here---- SSM_TOPIC_UPDATE_SWITCH_ACK_APP \(topic)")
//                                    //                }
//                                }
 
                                 SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_UPDATE_SWITCH) { (error) in
                                    print("error :\(String(describing: error))")
                                    if((error) != nil)
                                    {
                                        Utility.showErrorAccordingToLocalAndGlobal()
                                    }
                                }
                            }
                    sleep(1)
                    }
             }
            else{
                            
                let dict =  NSMutableDictionary()
                dict.setValue(objMood.mood_id, forKey: "mood_id");
                dict.setValue(objMood.mood_type, forKey: "mood_type");
            
                print("dict \(dict)")
            
                SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_HARDWARD_MOOD_TRIGGERED) { (error) in
                    print("error :\(String(describing: error))")
                    if((error) != nil) {
                    Utility.showErrorAccordingToLocalAndGlobal()
                    }
                }
            }
        }
    }

}



class GauravCollectionViewFlowLayout: UICollectionViewFlowLayout {
	open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let answer = super.layoutAttributesForElements(in: rect) else {
			return nil
		}
		let count = answer.count
		
		for i in 1..<count {
			let currentLayoutAttributes = answer[i]
			let prevLayoutAttributes = answer[i-1]
			let origin = prevLayoutAttributes.frame.maxX
			if (origin + spacing + currentLayoutAttributes.frame.size.width) < self.collectionViewContentSize.width && currentLayoutAttributes.frame.origin.x > prevLayoutAttributes.frame.origin.x {
				var frame = currentLayoutAttributes.frame
				frame.origin.x = origin + spacing
				currentLayoutAttributes.frame = frame
			}
		}
		return answer
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
}

