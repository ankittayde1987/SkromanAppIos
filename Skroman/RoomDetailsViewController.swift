//
//  RoomDetailsViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/17/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import STPopup
import SVProgressHUD
import TPKeyboardAvoiding



class RoomDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RoomDetailsCellTableViewCellDelegate, MenuViewDelegate, SkormanPopupViewControllerDelegate,EditSwitchViewControllerDelegate,MoodListViewControllerDelegate,SetStepperValuePopupViewControllerDelegate,RoomsHeaderCollectionViewCellDelegate,UICollectionViewDelegate, UICollectionViewDataSource, MoodSettingsMainContainerViewControllerDelegate, UICollectionViewDelegateFlowLayout  {
    
        

    @IBOutlet weak var tableView: UITableView!
    var parentNavigation : UINavigationController?
    var objRoom : Room!
    var arrSwitchBoxes = [SwitchBox]()
//    let spacing: CGFloat = 12
    var arrRoomData = NSMutableArray()
    var arrMoodsForRooms = NSMutableArray()


    @IBOutlet weak var collectionView: TPKeyboardAvoidingCollectionView!

    
    var objCurrentSwitchBox = SwitchBox()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dictO = NSMutableDictionary()
         SMQTTClient.sharedInstance().publishJson(json: dictO, topic: SM_TOPIC_UPDATE_SWITCH) { (error) in
             print("error :\(String(describing: error))")
             if((error) != nil)
             {
                 SVProgressHUD.dismiss()
                 Utility.showErrorAccordingToLocalAndGlobal()
             }
        }

        
        setupCollectionView()
        loadRoomData()

        // Do any additional setup after loading the view.
        setupTableView()
        getSwitchboxesFromDB()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSuccessOfUpdateSwitchAPICall(_:)), name: .handleUpdateSwitchAPISuccess, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleMoodButtonAdded(_:)), name: .handleMoodButtonAdded, object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPopup(_:)), name: .dismissPopup, object: nil)
        
    }
 
    
    fileprivate func setupCollectionView() {
        // Registering nibs
        
        self.collectionView.register(UINib.init(nibName: "RoomsHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RoomsHeaderCollectionViewCell")
        
        // Disabling automatic content inset behaviour
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    
    func loadRoomData(){
        
        /*  for getting mood for rooms  */
        var arrayForMoodsForRoom = NSMutableArray()
        
        arrayForMoodsForRoom = DatabaseManager.sharedInstance().getAllMoodsForHomeWithHomeId(home_id: VVBaseUserDefaults.getCurrentHomeID())

        arrRoomData.removeAllObjects()
        arrRoomData = NSMutableArray()
        for moodItem in arrayForMoodsForRoom {

            let objMood = moodItem as! Mood
            let roomMoodId = objMood.mood_id!.components(separatedBy: ["_"])
            
            /* check for room mood and room_id */
            if (roomMoodId.count == 4) && (VVBaseUserDefaults.getCurrentRoomID() == roomMoodId[1]){
                arrRoomData.add(moodItem)
            }
        }


        if self.arrRoomData.count == 0
        {
            self.arrRoomData.insert(self.addAddMoodInArrayMoods(), at: 0)
        }
        self.collectionView.reloadData()
    }

    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return arrRoomData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell: RoomsHeaderCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomsHeaderCollectionViewCell", for: indexPath) as! RoomsHeaderCollectionViewCell
            cell.delegate = self
            cell.lblActiveDevicesCount.isHidden = true
            cell.configureCellWith(arr: arrRoomData)
            return cell
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.section == 1
//        {
//            let objRoom = arrRoomData[indexPath.row] as! Room
//            let vc = RoomDetailsMainContainerViewController.init(nibName: "RoomDetailsMainContainerViewController", bundle: nil)
//            vc.selected_room_id = objRoom.room_id
//            self.parentNavigation?.pushViewController(vc, animated: true)
//        }
//    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0
        {
            //IF WANT VERTICALLY MOODS
            //            return CGSize(width: collectionView.frame.size.width, height: RoomsHeaderCollectionViewCell.cellHeight())
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
            return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // vertical space between cells
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // horizontal space between cells
        return spacing
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

    
    
    
    
    
    
    
    @objc func dismissPopup(_ notification: Notification)
    {
        self.dismiss(animated: false, completion: nil);
    }
    @objc func handleSuccessOfUpdateSwitchAPICall(_ notification: Notification)
    {
        SVProgressHUD.dismiss()
        self.getSwitchboxesFromDB()
//        self.tableView.reloadRows(at: [indexPath], with: .none)
        self.tableView.reloadData()
        NotificationCenter.default.post(name: .switchValueChange, object: nil)
    }
    
    @objc func handleMoodButtonAdded(_ notification: Notification)
    {
        Utility.delay(2){
            
            self.loadRoomData()
            NotificationCenter.default.post(name: .handleMoodButtonAddition, object: nil)

//            self.collectionView.reloadData()
//            self.collectionView.reloadData()
        }
//        SVProgressHUD.dismiss()
//        self.getSwitchboxesFromDB()
//        //        self.tableView.reloadRows(at: [indexPath], with: .none)
//        self.tableView.reloadData()
//        NotificationCenter.default.post(name: .switchValueChange, object: nil)
    }

    
    
    func getSwitchboxesFromDB()
    {
        if Utility.isIpad()
        {
            
            let obj = DatabaseManager.sharedInstance().getSwitBoxForIPad(switchBox_id: self.objCurrentSwitchBox.switchbox_id!)
            arrSwitchBoxes.removeAll()
            if self.objCurrentSwitchBox.switchbox_id != "-1"
            {
                arrSwitchBoxes.append(obj)
            }
        }
        else
        {
            arrSwitchBoxes = DatabaseManager.sharedInstance().getAllSwitchBoxesWithRoomID(room_id: objRoom.room_id!) as! [SwitchBox]
            
        }
    }
    
    func setupTableView() {
        view.backgroundColor = UICOLOR_MAIN_BG
        tableView.backgroundColor = UICOLOR_MAIN_BG
        if Utility.isIpad()
        {
            view.backgroundColor = UICOLOR_ROOM_CELL_BG
            tableView.backgroundColor = UICOLOR_ROOM_CELL_BG
        }
        
        // Registering nibs
        tableView.register(UINib.init(nibName: "RoomDetailsCellTableViewCell", bundle: nil), forCellReuseIdentifier: "RoomDetailsCellTableViewCell")
        
        tableView.register(UINib.init(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyTableViewCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.arrSwitchBoxes.count != 0
        {
            return arrSwitchBoxes.count
        }
        else
        {
            return 1
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoomDetailsCellTableViewCell", for: indexPath) as! RoomDetailsCellTableViewCell
            cell.delegate = self
            cell.configureCellWithSwitchBox(switchbox: arrSwitchBoxes[indexPath.row], tableViewWidth: tableView.frame.size.width, tableIndexPath: indexPath)
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
    
    @objc func userInterActionEnable()
    {
        self.view.isUserInteractionEnabled = true
    }
    //MARK:- RoomDetailsCellTableViewCellDelegate
  func updateMasterSwitchAPI(obj : Switch,status : String,indexPath : IndexPath)
  {

    if !Utility.isAnyConnectionIssue()
    {
        SVProgressHUD.show()
        //After 2 sec irrespective of API success hide loader
        Utility.delay(2.0) {
            SVProgressHUD.dismiss()
        }
        //When turning switches ON/OFF, allow only one tap per second. This will help in getting proper response to the app
        self.view.isUserInteractionEnabled = false
        perform(#selector(userInterActionEnable), with: nil, afterDelay: 1)

        SSLog(message: "API updateSwitchAPICall")
//        SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_UPDATE_SWITCH_ACK_APP) { (data, topic) in
//         SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_UPDATE_SWITCH_ACK_APP)
//         SSLog(message: "Successsssss")
//         SVProgressHUD.dismiss()
//         //We got data from Server
//
//            //let datastring = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
//
//            let objSwitch:Switch = Switch.decode(data!)!
//
//            if objSwitch.status == nil || objSwitch.switch_id == nil || objSwitch.switchbox_id == nil || objSwitch.position == nil {
//                    SSLog(message: " Check by ankit for mumbai acetech 2019 , remove once fixed from server end basic control")
//                }
//                else{
//                    DatabaseManager.sharedInstance().updateSwitchStatus(objSwitch, status: objSwitch.status ?? 0)
//                }
//
//         self.getSwitchboxesFromDB()
//         self.tableView.reloadRows(at: [indexPath], with: .none)
//         NotificationCenter.default.post(name: .switchValueChange, object: nil)
//         print("here---- SSM_TOPIC_UPDATE_SWITCH_ACK_APP \(topic)")
//                         }
//         }
        let dict =  NSMutableDictionary()
        dict.setValue(obj.switchbox_id, forKey: "switchbox_id");
        dict.setValue("\(obj.switch_id!)", forKey: "switch_id");
        dict.setValue("\(status)", forKey: "status");
        dict.setValue("\(obj.position!)", forKey: "position");
        dict.setValue("1", forKey: "slide_end");
        print("switchdata \(dict)")
        

     SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_UPDATE_SWITCH) { (error) in
         print("error :\(String(describing: error))")
         if((error) != nil)
         {
             SVProgressHUD.dismiss()
             Utility.showErrorAccordingToLocalAndGlobal()
         }
    } 
    }
    }
    
    func tappedOnMenuButton(_ sender: UIButton,obj : SwitchBox) {
        func reloadTableData()
        {
            self.tableView.reloadData()
        }
        var buttonFrameInRespectToView = sender.convert(sender.frame, to: UIAppDelegate.window)
        if Utility.isIpad()
        {
            buttonFrameInRespectToView.origin.x = sender.frame.origin.x
        }
        let svc = MenuViewController.init(nibName: "MenuViewController", bundle: nil)
        svc.menuDelegate = self
        svc.comeFrom = .room
        svc.objSwitchBox = obj
        svc.tappedViewFrame = buttonFrameInRespectToView
        svc.modalTransitionStyle = .crossDissolve
        svc.modalPresentationStyle = .custom
        present(svc, animated: true, completion: nil)
    }
    
    func tappedOnDataUsage(obj : SwitchBox) {
        let vc = DataUsageViewController.init(nibName: "DataUsageViewController", bundle: nil)
        vc.comeFrom = .roomDetails
        vc.objSwitchBox = obj
        vc.objCurrentRoom = self.objRoom
        parentNavigation?.pushViewController(vc, animated: true)
    }
    func longPressOnContainerView(_ sender: UIView, obj: Switch){
        let viewFrameInRespectToView = sender.convert(sender.frame, to: UIAppDelegate.window)
        let svc = MenuViewController.init(nibName: "MenuViewController", bundle: nil)
        svc.menuDelegate = self
        svc.comeFrom = .switches
        svc.objSwitch = obj
        svc.tappedViewFrame = viewFrameInRespectToView
        svc.modalTransitionStyle = .crossDissolve
        svc.modalPresentationStyle = .custom
        present(svc, animated: true, completion: nil)
    }
    func tappedOnMoods(strSwitchBox_id : String)
    {
        //Redirect To Moods
        let controller = MoodListViewController(nibName: "MoodListViewController", bundle:nil)
        controller.modalPresentationStyle = .overCurrentContext
        controller.delegate = self
        controller.strSwitchBox_id = strSwitchBox_id
        controller.objRoom = self.objRoom
        parentNavigation?.present(controller, animated:true, completion: nil)
        
    }
    func longPressOnSteapperView(obj: Switch)
    {
        let controller = SetStepperValuePopupViewController.init(nibName: "SetStepperValuePopupViewController", bundle: nil)
        controller.objSwitch = obj
        controller.delegate = self
        controller.comeFrom = .roomDetails
        let cntPopup = STPopupController.init(rootViewController: controller)
        cntPopup.transitionStyle = .fade;
        cntPopup.present(in: self.parentNavigation!)
    }
    

    //MARK:- MenuViewDelegate
    func didSelectOption(indexPath: IndexPath, comeFrom: MenuViewControllerComeFrom, obj: Any)
    {

        if comeFrom == .room{
            
            if indexPath.row == 0
            {
                //Rename
                SSLog(message: "Rename")
                if Utility.isRestrictOperation(){
                    Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
                }
                else
                {
                    let controller = SkormanPopupViewController.init(nibName: "SkormanPopupViewController", bundle: nil)
                    controller.comeFrom = .renameSwitchBox
                    controller.objSwitchBox = obj as! SwitchBox
                    controller.delegate = self
                    let cntPopup = STPopupController.init(rootViewController: controller)
                    cntPopup.present(in: self.parentNavigation!)
                }
            }
            else if indexPath.row == 1
            {
                //ChildLock
                SSLog(message: "ChildLock")
                return
            }
            else if indexPath.row == 2
            {
                //Delete
                SSLog(message: "Delete")
                
                if Utility.isRestrictOperation(){
                    Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
                }
                else
                {
                    let alert = UIAlertController(title: APP_NAME_TITLE, message: String(format: SSLocalizedString(key: "you_wont_be_able_to_control_xxx_anymore_from_your_app_this_will_also_permanently_delete_all_the_moods_to_which_this_device_belongs_to_delete_device"),(obj as! SwitchBox).name!), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: SSLocalizedString(key: "no"), style: .default) { action in
                    })
                    alert.addAction(UIAlertAction(title: SSLocalizedString(key: "yes"), style: .default) { action in
                        //Yes logic
                        self.deleteSwitchBox(objSwitchBox: obj as! SwitchBox)
                    })
                    self.present(alert, animated: true)
                }
            }
        }
        else if comeFrom == .switches{
            if indexPath.row == 0
            {
                //MasterSwitch in out
                SSLog(message: "MasterSwitch in out")
                return
            }
            else if indexPath.row == 1
            {
                //Edit
                SSLog(message: "Edit")
                
                if Utility.isRestrictOperation(){
                    Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
                }
                else
                {
                    let nibName = Utility.getNibNameForClass(class_name: String.init(describing: EditSwitchViewController.self))
                    let vc = EditSwitchViewController(nibName: nibName , bundle: nil)
                    vc.delegate = self
                    vc.objSwitch = (obj as? Switch)!
                    self.parentNavigation?.pushViewController(vc, animated: true)
                }
            }
        }
            
        else if comeFrom == .roomMoods{
            
            let objMood = obj as! Mood

            if Utility.isRestrictOperation(){
                Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
            }
            else{
                
                if indexPath.row == 0{
                    
                    //Configure Moods
                    SSLog(message: "Configure Mood")
                    let vc = MoodSettingsMainContainerViewController.init(nibName: "MoodSettingsMainContainerViewController", bundle: nil)
                    vc.strMoodName = objMood.mood_name
                    vc.objMoodToEdit = objMood
                    vc.comeFrom = .editRoomMood
                    vc.moodTypeForHomeOrDevice = MOOD_TYPE_ROOM
                    vc.delegate = self
                    self.parentNavigation?.pushViewController(vc, animated: true)
                }
                else if indexPath.row == 1{
                    
                    //Rename Mood
                    SSLog(message: "Rename Mood")
                    let controller = SkormanPopupViewController.init(nibName: "SkormanPopupViewController", bundle: nil)
                    controller.comeFrom = .renameMoodName
                    controller.objMood = objMood
                    controller.delegate = self
                    let cntPopup = STPopupController.init(rootViewController: controller)
                    cntPopup.present(in: self)
                }
                else{
                    //delete Mood
                    SSLog(message: "Delete Mood")
                    let alert = UIAlertController(title: APP_NAME_TITLE, message: String(format: SSLocalizedString(key: "are_you_sure_to_delete_xxx"), objMood.mood_name!), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: SSLocalizedString(key: "no"), style: .default) { action in
                    })
                    alert.addAction(UIAlertAction(title: SSLocalizedString(key: "yes"), style: .default) { action in
                        self.deleteHomeMood(objMood: objMood)
                    })
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func deleteHomeMood(objMood : Mood){
        
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
            controller.comeFrom = .addRoomMood
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
                controller.comeFrom = .addRoomMood
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
        svc.comeFrom = .roomMoods
        svc.objMood = obj
        svc.tappedViewFrame = viewFrameInRespectToView
        svc.modalTransitionStyle = .crossDissolve
        svc.modalPresentationStyle = .custom
        present(svc, animated: true, completion: nil)
    }

    
    
    //MARK: - MoodSettingsMainContainerViewControllerDelegate
    func didAddedOrEditedMoodSuccessfully()
    {
        arrMoodsForRooms.removeAllObjects()
        arrMoodsForRooms = DatabaseManager.sharedInstance().getAllMoodsForRoomWithRoomId(room_id: VVBaseUserDefaults.getCurrentRoomID())
        let indexPath = IndexPath(row: 0, section: 0)
        self.collectionView.reloadItems(at: [indexPath])
        loadRoomData()
    }

    
    
    //MARK:- SkormanPopupViewControllerDelegate
    func reloadControllerData() {
        getSwitchboxesFromDB()
        tableView.reloadData()

        self.didAddedOrEditedMoodSuccessfully()
    }
    
     func dissmissPopupAndLoadMoodSeetings(strMoodName: String, mood_id : String, comeFrom: SkormanPopupViewControllerComeFrom)
    {
        if comeFrom == .addRoomMood{
            let vc = MoodSettingsMainContainerViewController.init(nibName: "MoodSettingsMainContainerViewController", bundle: nil)
            vc.strMoodName = strMoodName
            vc.strMoodIdToAdd = mood_id
            vc.comeFrom = .addNewRoomMood
            vc.moodTypeForHomeOrDevice = MOOD_TYPE_ROOM
            vc.delegate = self
            self.parentNavigation?.pushViewController(vc, animated: true)
        }
        else{
            return
        }
    }
    //MARK:- EditSwitchViewControllerDelegate
    func updateSwitchName(obj: Switch) {
        getSwitchboxesFromDB()
        tableView.reloadData()
    }
    
    //MARK:- MoodListViewControllerDelegate
    func gotoConfigureMoodForDevice(strSwitchBox_id: String, objMood: Mood, objRoom: Room) {
        
        let nibName = Utility.getNibNameForClass(class_name: String.init(describing: RoomDetailForMoodSettingViewController.self))
        let controllerRoomDetailForMoodSetting = RoomDetailForMoodSettingViewController(nibName: nibName , bundle: nil)
        controllerRoomDetailForMoodSetting.title = objRoom.room_name
        controllerRoomDetailForMoodSetting.objRoom = objRoom
        controllerRoomDetailForMoodSetting.objMoodToEdit = objMood
        controllerRoomDetailForMoodSetting.strSwitchBoxId = strSwitchBox_id
        controllerRoomDetailForMoodSetting.comeFrom = .editHomeMood
        controllerRoomDetailForMoodSetting.isComeToEditHardwareMood = true;
        controllerRoomDetailForMoodSetting.moodTypeForHomeOrDevice = MOOD_TYPE_DEVICE
        self.parentNavigation?.pushViewController(controllerRoomDetailForMoodSetting, animated: true)
    }
    //MARK:- SetStepperValuePopupViewControllerDelegate
    func didChangeTheSteeperValue(obj : Switch)
    {
        self.updateSwitchAPICall(obj: obj)
    }
    func didChangeTheSteeperValueForMoodSettings(obj : Mood)
    {
        return
    }
    //MARK:- updateSwitchAPICall
    
    
    func updateSwitchAPICallsssss(obj : NSMutableDictionary){
        
        
        SMQTTClient.sharedInstance().publishJson(json: obj, topic: SM_TOPIC_UPDATE_SWITCH) { (error) in
            print("error :\(String(describing: error))")
            if((error) != nil)
            {
                Utility.showErrorAccordingToLocalAndGlobal()
            }
        }
    }
    func updateSwitchAPICall(obj : Switch)
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API updateSwitchAPICall")
           /* SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_UPDATE_SWITCH_ACK_APP) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_UPDATE_SWITCH_ACK_APP)
                
                SSLog(message: "SUCCESSSSSSSSSSSS")
                //We got data from Server
                if let objSwitch : Switch? = Switch.decode(data!){
                    //set Position to save in DB
                    objSwitch?.position = obj.position
                    //As we getting incorrect switch_id assign from above
                    objSwitch?.switch_id = obj.switch_id
                    //Handle Success
                    DatabaseManager.sharedInstance().updateSwitchStatus(objSwitch!, status: obj.status!)
                    print("here---- SSM_TOPIC_UPDATE_SWITCH_ACK_APP \(topic)")
                    self.tableView.reloadData()
                }
            }*/
            
            if obj.position == 0
            {
                obj.status = 0
            }
            else
            {
                obj.status = 1
            }
            
            let dict =  NSMutableDictionary()
            dict.setValue(obj.switchbox_id, forKey: "switchbox_id");
            dict.setValue("\(obj.switch_id!)", forKey: "switch_id");
            dict.setValue("\(obj.status ?? 0)", forKey: "status");
            dict.setValue("\(obj.position!)", forKey: "position");
            dict.setValue("1", forKey: "slide_end");
            print("switchdata \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_UPDATE_SWITCH) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
    
    
    
    
    //API CALL BY GAURAV ISSUE
    func deleteSwitchBox(objSwitchBox : SwitchBox)
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API deleteHomeMood")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_DELETE_SWITCHBOX_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_DELETE_SWITCHBOX_ACK)
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_DELETE_SWITCHBOX_ACK)
                {
                    if self.arrSwitchBoxes.count == 1
                    {
                        self.arrSwitchBoxes.removeAll()
                    }
                    else
                    {
                        DatabaseManager.sharedInstance().deleteSwithBoxDeviceWithSwitchBoxID(switchbox_id: "\(objSwitchBox.switchbox_id!)")
                        //Find and delete
                        self.removeSwitchBoxOnDeleteSuccessAndReload(switchIdToRemve: objSwitchBox.switchbox_id!)
                    }
                     NotificationCenter.default.post(name: .defaultHomeChange, object: nil)
                    DatabaseManager.sharedInstance().deleteAllMoodWithSWitchBoxId(switchbox_id: "\(objSwitchBox.switchbox_id!)")
                    SMQTTClient.sharedInstance().subscribeAllTopic()
                    UIAppDelegate.navigateToHomeScreen()
                }
            }
            let dict =  NSMutableDictionary()
            dict.setValue(objSwitchBox.switchbox_id!, forKey: "switchbox_id");
            
            print("dict \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_DELETE_SWITCHBOX) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
    func removeSwitchBoxOnDeleteSuccessAndReload(switchIdToRemve : String)
    {
        var isFound : Bool = false
        var foundIndex : Int = 0
        for currentIndex in 0..<(self.arrSwitchBoxes.count) {
            let obj = self.arrSwitchBoxes[currentIndex]
            if obj.switchbox_id == switchIdToRemve
            {
                isFound = true
                foundIndex = currentIndex
            }
        }
        if(isFound){
            arrSwitchBoxes.remove(at: foundIndex)
            self.tableView.reloadData()
        }
    }
}
