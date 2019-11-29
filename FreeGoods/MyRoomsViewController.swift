//
//  MyRoomsViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import STPopup

class MyRoomsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,SkormanPopupViewControllerDelegate,RoomsHeaderCollectionViewCellDelegate,MoodSettingsMainContainerViewControllerDelegate,MenuViewDelegate,DeleteOptionsPopupViewControllerDelegate {
	let spacing: CGFloat = 12
    var arrRoomData = NSMutableArray()
	var arrMoodsForHome = NSMutableArray()
	var parentNavigation : UINavigationController?
	@IBOutlet weak var collectionView: TPKeyboardAvoidingCollectionView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
        setupCollectionView()
		NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: .switchValueChange, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: .handleUpdateMoodStatusAck, object: nil)

	}

	@objc func reloadData(_ notification: Notification)
	{
		loadRoomData()
		let indexPath : IndexPath = [0,0]
		self.collectionView.reloadItems(at: [indexPath])
	}
    
	fileprivate func setupCollectionView() {
		// Registering nibs
		collectionView.register(UINib.init(nibName: "RoomContainerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RoomContainerCollectionViewCell")
		
		collectionView.register(UINib.init(nibName: "RoomsHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RoomsHeaderCollectionViewCell")

		// Disabling automatic content inset behaviour
		if #available(iOS 11.0, *) {
			collectionView.contentInsetAdjustmentBehavior = .never
		}
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	// MARK: - UICollectionViewDataSource
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if section == 0
		{
            if arrRoomData.count > 0
            {
               return 1
            }
            else
            {
                return 0
            }
		}
             return arrRoomData.count
     }
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if indexPath.section == 0
		{
			let cell: RoomsHeaderCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomsHeaderCollectionViewCell", for: indexPath) as! RoomsHeaderCollectionViewCell
			cell.delegate = self
			cell.configureCellWith(arr: arrMoodsForHome)
			return cell
		}
		else
		{
			let objRoom = arrRoomData[indexPath.row]
			
			let cell: RoomContainerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomContainerCollectionViewCell", for: indexPath) as! RoomContainerCollectionViewCell
			cell.btnDeleteRoom.isHidden = true
			cell.configureCellWithRoom(objRoom: objRoom as! Room)
			return cell
		}
		

	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.section == 1
		{
			let objRoom = arrRoomData[indexPath.row] as! Room
            VVBaseUserDefaults.setCurrentRoomID(room_id: objRoom.room_id!)
			let vc = RoomDetailsMainContainerViewController.init(nibName: "RoomDetailsMainContainerViewController", bundle: nil)
			vc.selected_room_id = objRoom.room_id
			self.parentNavigation?.pushViewController(vc, animated: true)
            
		}
	}
	
	// MARK: - UICollectionViewDelegateFlowLayout
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if indexPath.section == 0
		{
			//IF WANT VERTICALLY MOODS
//			return CGSize(width: collectionView.frame.size.width, height: RoomsHeaderCollectionViewCell.cellHeight())
			//IF WANT HORIZONTALLY MOODS
			return CGSize(width: collectionView.frame.size.width, height: 81)
		}
		else
		{
			let width = (collectionView.frame.size.width - (spacing * 4)) / 3.0 // (collection view width - left side space - right side space - (2 * space between cells)) divide by no. of cells i.e. 3
			return CGSize(width: width, height: 87.0)
		}

	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		if section == 0
		{
			return UIEdgeInsetsMake(0, 0, 0, 0)
		}
		else
		{
			return UIEdgeInsetsMake(0, spacing, spacing, spacing);
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		// vertical space between cells
		return spacing
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		// horizontal space between cells
		return spacing
	}
    
    
    func loadRoomData()
    {
        arrRoomData.removeAllObjects()
        arrRoomData = NSMutableArray()

        arrMoodsForHome.removeAllObjects()
        arrMoodsForHome = NSMutableArray()

        arrRoomData = DatabaseManager.sharedInstance().getAllRoomWithHomeID(home_id: VVBaseUserDefaults.getCurrentHomeID())
        
        var arrayForMoodsForHome = NSMutableArray()

		arrayForMoodsForHome = DatabaseManager.sharedInstance().getAllMoodsForHomeWithHomeId(home_id: VVBaseUserDefaults.getCurrentHomeID())
        
        for moodItem in arrayForMoodsForHome {
            
            let objMood = moodItem as! Mood
            
            let homeMoodId = objMood.mood_id!.components(separatedBy: ["_"])
            
            if homeMoodId.count == 3 {
                arrMoodsForHome.add(moodItem)
            }
        }
		
		if self.arrMoodsForHome.count == 0
		{
			self.arrMoodsForHome.insert(self.addAddMoodInArrayMoods(), at: 0)
		}
        self.collectionView.reloadData()
    }
	
	func reloadControllerOnDefaultHomeChange()
	{
		self.loadRoomData()
	}
	
	//MARK:- addAddMoodInArrayMoods
    func addAddMoodInArrayMoods() -> Mood
    {
        let obj = Mood()
        obj.mood_id = DUMMY_MOOD_ID
        obj.mood_name = SSLocalizedString(key: "add_mood")
        obj.mood_status = 1
        return obj
    }
	//MARK:- SkormanPopupViewControllerDelegate
	func reloadControllerData()
	{
		self.didAddedOrEditedMoodSuccessfully()
	}
	 func dissmissPopupAndLoadMoodSeetings(strMoodName: String, mood_id : String, comeFrom: SkormanPopupViewControllerComeFrom)
	{
		let vc = MoodSettingsMainContainerViewController.init(nibName: "MoodSettingsMainContainerViewController", bundle: nil)
		vc.strMoodName = strMoodName
        vc.strMoodIdToAdd = mood_id
		vc.comeFrom = .addNewHomeMood
		vc.moodTypeForHomeOrDevice = MOOD_TYPE_HOME
		vc.delegate = self
		self.parentNavigation?.pushViewController(vc, animated: true)
	}
	
	//MARK:- RoomsHeaderCollectionViewCellDelegate
	func tappedOnMore(_ sender: UIButton,moodsCount:String)
    {
        SSLog(message: "tappedOnMore")
        if Utility.isRestrictOperation(){
            Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
        }
        else
        {
            let controller = SkormanPopupViewController.init(nibName: "SkormanPopupViewController", bundle: nil)
            controller.comeFrom = .addNewMood
            controller.moodCountToCreateId = moodsCount
            controller.delegate = self;
            let cntPopup = STPopupController.init(rootViewController: controller)
            cntPopup.present(in: self.parentNavigation!)
        }
    }
	
	func tappedOnMoodBtn(obj : Mood,moodsCount:String)
	{
		if obj.mood_id == DUMMY_MOOD_ID
        {
            if Utility.isRestrictOperation(){
                Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
            }
            else
            {
                let controller = SkormanPopupViewController.init(nibName: "SkormanPopupViewController", bundle: nil)
                controller.comeFrom = .addNewMood
                controller.moodCountToCreateId = moodsCount
                controller.delegate = self;
                let cntPopup = STPopupController.init(rootViewController: controller)
                cntPopup.present(in: self.parentNavigation!)
            }
        }
		else
		{
			//Need Help Sapanesh Sir
			//Need To add a logic to activite deactivate mood_status
			DatabaseManager.sharedInstance().updateMood(objMood: obj)
		}
		
	}
	func longPressOnButtonMood(_ sender: UIButton, obj : Mood)
	{
		let viewFrameInRespectToView = sender.convert(sender.frame, to: UIAppDelegate.window)
		let svc = MenuViewController.init(nibName: "MenuViewController", bundle: nil)
		svc.menuDelegate = self
		svc.comeFrom = .homeMoods
		svc.objMood = obj
		svc.tappedViewFrame = viewFrameInRespectToView
		svc.modalTransitionStyle = .crossDissolve
		svc.modalPresentationStyle = .custom
		present(svc, animated: true, completion: nil)
	}
	//MARK: - MoodSettingsMainContainerViewControllerDelegate
	func didAddedOrEditedMoodSuccessfully()
	{
		arrMoodsForHome.removeAllObjects()
		arrMoodsForHome = DatabaseManager.sharedInstance().getAllMoodsForHomeWithHomeId(home_id: VVBaseUserDefaults.getCurrentHomeID())
		let indexPath = IndexPath(row: 0, section: 0)
		collectionView.reloadItems(at: [indexPath])
	}
	
	//MARK:- MenuViewDelegate
	func didSelectOption(indexPath: IndexPath, comeFrom: MenuViewControllerComeFrom, obj: Any)
	{
		SSLog(message: "tapped")
		let objMood = obj as! Mood
		if comeFrom == .homeMoods
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
                    let vc = MoodSettingsMainContainerViewController.init(nibName: "MoodSettingsMainContainerViewController", bundle: nil)
                    vc.strMoodName = objMood.mood_name
                    vc.objMoodToEdit = objMood
                    vc.comeFrom = .editHomeMood
                    vc.moodTypeForHomeOrDevice = MOOD_TYPE_HOME
                    vc.delegate = self
                    self.parentNavigation?.pushViewController(vc, animated: true)
                }
                else if indexPath.row == 1
                {
                    //Rename Mood
                    SSLog(message: "Rename Mood")
                    let controller = SkormanPopupViewController.init(nibName: "SkormanPopupViewController", bundle: nil)
                    controller.comeFrom = .renameMoodName
                    controller.objMood = objMood
                    controller.delegate = self
                    let cntPopup = STPopupController.init(rootViewController: controller)
                    cntPopup.present(in: self)
                }
                else
                {
                    //delete Mood
                    SSLog(message: "Delete Mood")
                    let alert = UIAlertController(title: APP_NAME_TITLE, message: String(format: SSLocalizedString(key: "are_you_sure_to_delete_xxx"), objMood.mood_name!), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: SSLocalizedString(key: "no"), style: .default) { action in
                    })
                    alert.addAction(UIAlertAction(title: SSLocalizedString(key: "yes"), style: .default) { action in
                        self.deleteHomeMood(objMood: objMood)
                    })
                    self.present(alert, animated: true)
                    
                    //On 25/4/2019 remove Locally and Permanantly popup
                    /*let controller = DeleteOptionsPopupViewController.init(nibName: "DeleteOptionsPopupViewController", bundle: nil)
                     controller.objMood = objMood
                     controller.comeFrom = .deleteHomeMood
                     controller.delegate = self
                     let cntPopup = STPopupController.init(rootViewController: controller)
                     cntPopup.present(in: self.parentNavigation!)*/
                }
            }
		}
	}
	
	//MARK:- DeleteOptionsPopupViewControllerDelegate
	func deleteSuccessfully() {
		self.didAddedOrEditedMoodSuccessfully()
	}

    //API CALL BY GAURAV ISSUE
    func deleteHomeMood(objMood : Mood)
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API deleteHomeMood")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_DELETE_HOME_MOOD_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_DELETE_HOME_MOOD_ACK)
                //We got data from Server
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_DELETE_HOME_MOOD_ACK)
                {
                    DatabaseManager.sharedInstance().deleteMoodWithMoodId(mood_id: objMood.mood_id!)
                    self.loadRoomData()
                }
                print("here---- SM_TOPIC_DELETE_HOME_MOOD_ACK \(topic)")
            }
            let dict =  NSMutableDictionary()
            dict.setValue(objMood.mood_id, forKey: "mood_id");
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
