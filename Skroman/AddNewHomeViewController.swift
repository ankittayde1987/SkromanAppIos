//
//  AddNewHomeViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import Foundation
import STPopup
import SVProgressHUD

class AddNewHomeViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,HeaderCollectionReusableViewDelegate,AddNewRoomViewControllerDelegate,RoomContainerCollectionViewCellDelegate,DeleteOptionsPopupViewControllerDelegate {
    @IBOutlet weak var vwConstant_iPadWidth: NSLayoutConstraint!
    let spacing: CGFloat = 15
	var comeFrom : AddNewHomeViewControllerComeFrom? = .addNewHome
	@IBOutlet weak var btnSave: UIButton!
	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var vwBottomContainer: UIView!
    @IBOutlet weak var vwAddRoom : UIView!
    @IBOutlet weak var lblAddHome: UILabel!
    @IBOutlet weak var btnAddHome: UIButton!
    var arrHome : NSMutableArray!
	
	var arrRoomData = NSMutableArray()
	var objHome : Home?
    var isComeFromRegisterVC : Bool = false
	@IBOutlet weak var collectionView: TPKeyboardAvoidingCollectionView!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		if self.comeFrom == .addNewHome
		{
			self.objHome = Home()
		}
		else
		{
			loadRoomData()
		}
		
		initViewController()
		setupCollectionView()
        customiseUIForIPad()
    }
    func customiseUIForIPad()
    {
        if Utility.isIpad()
        {
            self.vwConstant_iPadWidth.constant = CONSTANT_IPAD_VIEW_WIDTH
        }
        else
        {
            btnSave.titleLabel?.font = Font_SanFranciscoText_Regular_H16
            setColor()
            localizeText()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isComeFromRegisterVC
        {
            self.navigationController?.isNavigationBarHidden = false
            //TO Hide navigation back button on particular controller
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: self, action: nil)

        }
        getHomeFromDatabase()
    }
	func loadRoomData()
	{
        if Utility.isEmpty(val: self.objHome?.home_id)
        {
            self.objHome?.home_id = VVBaseUserDefaults.getCurrentHomeID()
        }
		arrRoomData = DatabaseManager.sharedInstance().getAllRoomWithHomeID(home_id: (self.objHome?.home_id)!)
	}
    func getHomeFromDatabase()
    {
        self.arrHome = DatabaseManager.sharedInstance().getAllHomes()
        
        if(self.arrHome.count==0)
        {
            vwAddRoom.isHidden = false
        }
        else
        {
            vwAddRoom.isHidden = true
        }
        
    }
    @IBAction func clickAddNewHome()
    {
       
        self.vwAddRoom.isHidden = true
        
    }
	fileprivate func setupCollectionView() {
		// Registering nibs
		collectionView.register(UINib.init(nibName: "RoomContainerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RoomContainerCollectionViewCell")
		
		
		collectionView.register(UINib.init(nibName: "HeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView")
        
        collectionView.register(UINib.init(nibName: "FooterButtonCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterButtonCollectionReusableView")
        
		// Disabling automatic content inset behaviour
		if #available(iOS 11.0, *) {
			collectionView.contentInsetAdjustmentBehavior = .never
		}
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func initViewController()
	{
		if self.comeFrom == .addNewHome
		{
			self.title = SSLocalizedString(key: "add_new_home")
		}
		else
		{
			self.title = SSLocalizedString(key: "edit_home")
		}
		
        //self.title = SSLocalizedString(key: "add_home")
        
		setFont()
		view.backgroundColor = UICOLOR_MAIN_BG
		collectionView.backgroundColor = UICOLOR_MAIN_BG
	}
	func setFont()
	{
        lblAddHome.font = Font_SanFranciscoText_Regular_H18
	}
	func setColor()
	{
		vwBottomContainer.backgroundColor = UICOLOR_BLUE
		btnSave.backgroundColor = UICOLOR_BLUE
		vwSeprator.backgroundColor = UICOLOR_SEPRATOR
	}
	func localizeText()
	{
		btnSave.setTitle(SSLocalizedString(key: "save").uppercased(), for: .normal)
		btnSave.setTitle(SSLocalizedString(key: "save").uppercased(), for: .selected)
	}
	// MARK: - UICollectionViewDataSource
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if self.comeFrom == .addNewHome
		{
			return 0
		}
		else
		{
			return arrRoomData.count
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let objRoom = arrRoomData[indexPath.row]
		let cell: RoomContainerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomContainerCollectionViewCell", for: indexPath) as! RoomContainerCollectionViewCell
        //ON 24/4/2019 Hide delete room functionality
        //On 26/6/2019  Before delete need to check whether Room don’t have any SwitchBox associate with it else show error.
		cell.btnDeleteRoom.isHidden = false
		cell.delegate = self
		cell.configureCellWithRoom(objRoom: objRoom as! Room)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch kind {
			
		case UICollectionElementKindSectionHeader:
			let collectionHeaderView: HeaderCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
			collectionHeaderView.delegate = self;
			if self.comeFrom == .addNewHome
			{
				collectionHeaderView.vwRoomsLabelContainer.isHidden = true
			}
			else
			{
				collectionHeaderView.vwRoomsLabelContainer.isHidden = false
			}
			if self.objHome == nil
			{
				self.objHome = Home()
			}
			collectionHeaderView.configureCell(home: self.objHome!)
			return collectionHeaderView
            
        case UICollectionElementKindSectionFooter:
            let collectionHeaderView: FooterButtonCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterButtonCollectionReusableView", for: indexPath) as! FooterButtonCollectionReusableView
            collectionHeaderView.btnSave.addTarget(self, action: #selector(tappedSave(_:)), for: .touchUpInside)
            return collectionHeaderView
			
		default:
			assert(false, "Unexpected element kind")
			return UICollectionReusableView.init()
			
		}
		
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if self.comeFrom == .editHome
		{
			if arrRoomData.count != 0
            {
                if Utility.isRestrictOperation(){
                    Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
                }
                else
                {
                    DispatchQueue.main.async {
                        let obj = self.arrRoomData[indexPath.row] as? Room
                        let nibName = Utility.getNibNameForClass(class_name: String.init(describing: AddNewRoomViewController.self))
                        let vc = AddNewRoomViewController(nibName: nibName , bundle: nil)
                        vc.comeFrom = .editRoom
                        obj?.home_id = self.objHome?.home_id
                        vc.objRoom = obj
                        vc.delegate = self
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
            }
		}
	}
	
	// MARK: - UICollectionViewDelegateFlowLayout
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.frame.size.width - (spacing * 4)) / 3.0 // (collection view width - left side space - right side space - (2 * space between cells)) divide by no. of cells i.e. 3
		return CGSize(width: width, height: 87.0)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsMake(0, spacing, spacing, spacing);
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		// vertical space between cells
		return spacing
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		// horizontal space between cells
		return spacing
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
			return CGSize(width: collectionView.frame.size.width, height: 201)
	}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if Utility.isIpad()
        {
            return CGSize(width: collectionView.frame.size.width, height: 110)
        }
        else
        {
            return CGSize(width: 0, height: 0)
        }
        
    }
	
	//MARK: - HeaderCollectionReusableViewDelegate
    func tappedAddRoom() {
        if Utility.isRestrictOperation(){
            Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
        }
        else
        {
            DispatchQueue.main.async {
                let nibName = Utility.getNibNameForClass(class_name: String.init(describing: AddNewRoomViewController.self))
                let vc = AddNewRoomViewController(nibName: nibName , bundle: nil)
                //        vc.comeFrom = .editRoom
                vc.comeFrom = .addNewRoom
                let obj = Room()
                obj.image = "room_1"
                
                if Utility.isEmpty(val: self.objHome?.home_id)
                {
                    obj.home_id = VVBaseUserDefaults.getCurrentHomeID()
                    }
                    else
                    {
                    obj.home_id = self.objHome?.home_id
                    }
                
                vc.objRoom = obj
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
	//MARK: - IBAction
	@IBAction func tappedSave(_ sender: Any) {
        SSLog(message: objHome?.home_name)
        if self.comeFrom == .addNewHome
        {
            //API Call for Add Home and Handle Success And redirect to back page and refresh list
            let isValidData: Bool = validateUserEnteredData()
            if isValidData {
                self.addNewHome()
            }
        }
        else
        {
            //to add room and handle navigation on click 
            if isComeFromRegisterVC
            {
                //If 0 rooms show alert
                if arrRoomData.count == 0
                {
                    showAlertMessage(strMessage: SSLocalizedString(key: "please_add_room"))
                }
                else
                {
                    //Navigate to home view
                    //SUBSCRIBE_ALL_TOPICS
                     DispatchQueue.main.async {
                        UIAppDelegate.navigateToHomeScreen()
                    }
//                    SMQTTClient.sharedInstance().subscribeAllTopic();
                    
                }
            }
            else
            {
                //Handle edit flow from myHomesVC
                 DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                
                
            }
        }
	}
    
    //API CALL BY GAURAV
    func addNewHome()
    {
        //Resign Keyboard
        self.view.endEditing(true)
            if !Utility.isAnyConnectionIssue()
            {
                self.addHomeAPIAndHandling()
            }
        
    }
    
    func addHomeAPIAndHandling()
    {
        
         let topicTosend = "\(VVBaseUserDefaults.getCurrentPIID())/create_home"
         let topicToAck = "\(VVBaseUserDefaults.getCurrentPIID())/create_home_ack"
        
        
        SVProgressHUD.show()
        SSLog(message: "API addNewHome")
        SMQTTClient.sharedInstance().subscribe(topic: topicToAck) { (data, topic) in
            SMQTTClient.sharedInstance().unsubscribe(topic: topicToAck)
            SVProgressHUD.dismiss()
            //We got data from Server
            SSLog(message: data)
            if let objHome : Home? = Home.decode(data!){
                
                if objHome?.success != nil && objHome?.success != 0
                {
                    //Dismiss SVProgressView
                    SVProgressHUD.dismiss()
                    //Handle Success
                    SSLog(message: objHome)
                    //First Check Whether Home Id is present in DB if present don't insert else Insert
                                        
                    
                    if !DatabaseManager.sharedInstance().isAlreadyHomeExistsInDB(home_id: (objHome?.home_id)!)
                    {
                        //Insert Home in home table
                        DatabaseManager.sharedInstance().addHome(home_name: (objHome?.home_name)!, home_id: (objHome?.home_id)!, pi_id: VVBaseUserDefaults.getCurrentPIID())
                        
                        // Take shared dictonary and then add dictonary to existing one and associate it like :  home-name:{ homeid:ip-value}
                        
                        var ipDict = NSMutableDictionary ()
                        ipDict = VVBaseUserDefaults.getHomeIpDictonary()
                        
                        let dictonary = NSMutableDictionary()
                        dictonary.setValue(VVBaseUserDefaults.getCurrentHomeIP(), forKey:objHome!.home_id!)
                        
                        ipDict.setValue(dictonary, forKey:objHome!.home_name!)
                        
                        VVBaseUserDefaults.setHomeIpDictonary(home_dict: ipDict)
                    }
                    else
                    {
                        SSLog(message: "Home Already exists")
                        //Show error message Home already exists!!!
                        self.showAlertMessage(strMessage: SSLocalizedString(key: "home_already_exists"))
                        return
                    }
                    
                    if self.isComeFromRegisterVC
                    {
                         VVBaseUserDefaults.setCurrentHomeID(home_id: (objHome?.home_id)!)
                        DatabaseManager.sharedInstance().updateDefaultHome(obj: objHome!)
                        
                        //Need to give add room option so added below value
                        self.comeFrom = .editHome
                        //need to reload controller for add room
                        self.collectionView.reloadData()
                    }
                    else
                    {
                        //GO to my homes list
                        self.navigationController?.popToViewController(self, animated: true)
                    }
                }
                else
                {
              //      Show error message Home already exists!!!
                    self.showAlertMessage(strMessage: SSLocalizedString(key: "home_already_exists"))
                }
                
                
            }
        }
        let dict =  NSMutableDictionary()
        dict.setValue(self.objHome?.home_name, forKey: "home_name");
        
        print("SM_TOPIC_CREATE_HOME \(dict)")
        print("PIIIDDDDDDDDD \(VVBaseUserDefaults.getCurrentPIID())")
        
       
        
        SMQTTClient.sharedInstance().publishJson(json: dict, topic: topicTosend) { (error) in
            print("error :\(String(describing: error))")
            if((error) != nil)
            {
                Utility.showErrorAccordingToLocalAndGlobal()
            }
        }
    }
	//MARK:- AddNewRoomViewControllerDelegate
    func reloadAddRoomControllerOnSuccessOfAddOrEditRoom()
	{
		loadRoomData()
		self.collectionView.reloadData()
	}
	//MARK:- RoomContainerCollectionViewCellDelegate
	func tappedOnDeleteRoom(obj : Room)
	{
        SSLog(message: "Delete Room")
        if DatabaseManager.sharedInstance().isSwitchBoxPresentInRoom(strRoomId: obj.room_id!)
        {
            Utility.showAlertMessage(strMessage: SSLocalizedString(key: "make_sure_before_delete_message"))
        }
        else
        {
            //Delete
            let alert = UIAlertController(title: APP_NAME_TITLE, message: String(format: SSLocalizedString(key: "are_you_sure_to_delete_xxx"),obj.room_name ?? ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: SSLocalizedString(key: "no"), style: .default) { action in
            })
            alert.addAction(UIAlertAction(title: SSLocalizedString(key: "yes"), style: .default) { action in
               self.deleteRoom(objRoom: obj)
            })
            self.present(alert, animated: true, completion: nil)

            /*let controller = DeleteOptionsPopupViewController.init(nibName: "DeleteOptionsPopupViewController", bundle: nil)
            controller.comeFrom = .deleteRoom
            controller.objRoom = obj
            controller.delegate = self
            let cntPopup = STPopupController.init(rootViewController: controller)
            cntPopup.present(in: self)*/
        }
	}
	//MARK:- DeleteOptionsPopupViewControllerDelegate
	func deleteSuccessfully()
	{
		self.reloadAddRoomControllerOnSuccessOfAddOrEditRoom()
	}
    
    
    // MARK:- validateUserEnteredData method
    func validateUserEnteredData() -> Bool {
        if(Utility.isEmpty(val: self.objHome?.home_name)){
            showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_home_name"))
            return false
        }
        return true
    }
    
    
    //API CALL BY GAURAV ISSUE
    func deleteRoom(objRoom : Room)
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API deleteHomeMood")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_DELETE_ROOM_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_DELETE_ROOM_ACK)
                //We got data from Server
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_DELETE_ROOM_ACK)
                {
                    DatabaseManager.sharedInstance().deleteRoomWithRoomID(room_id: objRoom.room_id!)
                    NotificationCenter.default.post(name: .defaultHomeChange, object: nil)
                    self.reloadAddRoomControllerOnSuccessOfAddOrEditRoom()
                }
            }
            let dict =  NSMutableDictionary()
            dict.setValue(objRoom.room_id!, forKey: "room_id");
            
            print("dict \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_DELETE_ROOM) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }

}
