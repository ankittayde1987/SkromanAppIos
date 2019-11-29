//
//  HomeForIpadViewController.swift
//  Skroman
//
//  Created by Admin on 27/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import SideMenu
import STPopup
import SVProgressHUD

class HomeForIpadViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MoodButtonCollectionViewCellDelegate,SkormanPopupViewControllerDelegate,MoodSettingsMainContainerViewControllerDelegate,MenuViewDelegate,DeleteOptionsPopupViewControllerDelegate,addIPAddressDelegateForExistingHome {

    @IBOutlet weak var btnAddMood: UIButton!
    @IBOutlet weak var lblTotalUsage: UILabel!
    @IBOutlet weak var collectionViewForMoods: UICollectionView!
    @IBOutlet weak var vwConstantHeader: UIView!
    @IBOutlet weak var vwRoomContainer: UIView!
    @IBOutlet weak var lblMyRooms: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var vwRoomDetails: UIView!
    @IBOutlet weak var vwDataUsage: UIView!
    var totalDataUsagaeValue : String? = ""
    var objSelectedRoom : Room?
    
    var controllerRoomDetailsMainContainer : RoomDetailsMainContainerViewController!
    var controllerDataUsage : DataUsageViewController!
    let spacing: CGFloat = 0
    let spacingForHomeMood: CGFloat = 8
    var arrRoomData = NSMutableArray()
    var arrMoodsForHome = NSMutableArray()
    var mainHomeSwitch : UIButton?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       loadController()
    }
    
    
    //MARK:- Below execution block is only for users who have logged in and haven't set up ip for their respective homes
    
    /******************************************************************************************************************************************/
    
    
    func setUpHomePopUp() {
        
        let  arrHome : NSMutableArray = DatabaseManager.sharedInstance().getAllHomes()
        
        let objeHome : Home = arrHome.object(at: 0) as! Home
        
        let alert = UIAlertController(title: APP_NAME_TITLE as String?, message: String(format: "%@ has been setup as your default home, please set IP for it...", objeHome.home_name!) , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: SSLocalizedString(key: "OK"), style: .default) { action in
            
            self.setUpIpView(homeObject: objeHome)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUpIpView(homeObject: Home) {
        
        
        let vc = AddIPAddressViewController.init(nibName: "AddIPAddressViewController", bundle: nil)
        vc.objHome = homeObject
        vc.ipDelegateForExisting = self
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    func didReceivedIPForExistingHome(ipValue: String, homeObj: Home) {
        
        
        VVBaseUserDefaults.setCurrentHomeSettingIP(home_ip: ipValue)
        
        SMQTTClient.sharedInstance().connectToServerForHomeChange(success: { (error) in
            if((error) != nil){
                let msgToShow = String(format: "Not able to connect to MQTT server , so close the app and try once again")
                Utility.showAlertMessage(strMessage: msgToShow)
            }else{
                
                DatabaseManager.sharedInstance().updateDefaultHome(obj: homeObj)
                VVBaseUserDefaults.setCurrentHomeID(home_id: homeObj.home_id!)
                VVBaseUserDefaults.setCurrentHomeName(home_name: homeObj.home_name!)
                VVBaseUserDefaults.setCurrentPIID(pi_id: homeObj.pi_id!)
                VVBaseUserDefaults.setCurrentHomeIP(home_ip: ipValue)
                
                /*---------------------*/
                /*  save in nsuserdefaults */
                var ipDict = NSMutableDictionary ()
                ipDict = VVBaseUserDefaults.getHomeIpDictonary()
                
                let dictonary = NSMutableDictionary()
                dictonary.setValue(ipValue, forKey:homeObj.home_id!)
                
                ipDict.setObject(dictonary, forKey: homeObj.home_name! as NSCopying)
                VVBaseUserDefaults.setHomeIpDictonary(home_dict: ipDict)
                /*---------------------*/
                
                let objPI = DatabaseManager.sharedInstance().getPI(piid: homeObj.pi_id!)
                VVBaseUserDefaults.setCurrentSSID(ssid: objPI.ssid ?? VVBaseUserDefaults.getCurrentSSID())
                VVBaseUserDefaults.setCurrentPASSWORD(password: objPI.password ?? VVBaseUserDefaults.getCurrentPASSWORD())
                
                homeObj.is_default = 1
                NotificationCenter.default.post(name: .defaultHomeChange, object: nil)
                NotificationCenter.default.post(name: .defaultHomeChangeLeftMenu, object: nil)
                self.startSyncDatas()
                VVBaseUserDefaults.setHomeIPAccess(status: true)
                
            }
        });
    }
    
    func startSyncDatas()
    {
        if Utility.isRestrictOperation()
        {
            self.syncGlobalDatas()
        }
        else
        {
            self.syncLocalDatas()
        }
    }
    
    
    func syncLocalDatas()
    {
        if !Utility.isAnyConnectionIssue()
        {
            SVProgressHUD.show(withStatus: SSLocalizedString(key: "sync..."))
            Utility.delay(2.0) {
                SVProgressHUD.dismiss()
            }
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_SYNC_EVERYTHING_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_SYNC_EVERYTHING_ACK)
                
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_SYNC_EVERYTHING_ACK)
                {
                    if let objSync : SyncData? = SyncData.decode(data!){
                        
                        if((objSync?.syncData?.count)!>0)
                        {
                            //delete old data and insert new data
                            SMQTTClient.sharedInstance().subscribeAllTopic()
                            DatabaseManager.sharedInstance().syncDataFormleftMenu(objSyncData: objSync!)
                        }
                        //Default Home
                        self.dismiss(animated: true, completion: {
                            
                        })
                        print("here---- SM_TOPIC_SYNC_EVERYTHING_ACK \(topic)")}
                    //redirect to home page
                    SVProgressHUD.dismiss()
                }
                
            }
            
            let dict =  NSMutableDictionary()
            dict.setValue("1", forKey: "sync");
            //            let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_SYNC_EVERYTHING) { (error) in
                if error != nil
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
    func syncGlobalDatas()
    {
        if !Utility.isAnyConnectionIssue()
        {
            SVProgressHUD.show(withStatus: SSLocalizedString(key: "sync..."))
            
            //Hide loader after 2 sec irrespective of result
            Utility.delay(2.0) {
                SVProgressHUD.dismiss()
            }
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU)
                
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU)
                {
                    if let objSync : SyncData? = SyncData.decode(data!){
                        
                        if((objSync?.syncData?.count)!>0)
                        {
                            //delete old data and insert new data
                            SMQTTClient.sharedInstance().subscribeAllTopic()
                            DatabaseManager.sharedInstance().syncDataFormleftMenu(objSyncData: objSync!)
                        }
                        //Default Home
                        self.dismiss(animated: true, completion: {
                            
                        })
                        print("here---- SM_TOPIC_SYNC_EVERYTHING_ACK \(topic)")}
                    //redirect to home page
                    SVProgressHUD.dismiss()
                }
                
            }
            
            let dict =  NSMutableDictionary()
            dict.setValue(VVBaseUserDefaults.getCurrentPIID(), forKey: "pi_id");
            dict.setValue(Utility.getCurrentUserId(), forKey: "user_id");
            //            let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_LEFT_MENU) { (error) in
                if error != nil
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
    /******************************************************************************************************************************************/

    
    
    
    
    
    func loadController()
    {
        
        if VVBaseUserDefaults.getHomeIPAccess() == false {
            setUpHomePopUp()
        }

        setupCollectionView()
        setUpRightNavigationBarButton()
        loadRoomData()
        setUpNavigationBar()
        //For Active Devices in Navigation bar
//        addAttributedLabelNavigationTitle()
        initController()
        addSubView()
        
        //Temporary
//         DatabaseManager.sharedInstance().deleteEnergyData()
//        Utility.insertEnergyDataForDefaultHome()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDefaultHomeNameFromDb()
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
    func addSubView()
    {
        self.addDataUsageViewControllerAsSubView()
        if self.objSelectedRoom == nil
        {
            self.objSelectedRoom = arrRoomData[0] as? Room
        }
        self.addRoomDetailsMainControllerAsSubView(obj: self.objSelectedRoom!)
    }
    func addDataUsageViewControllerAsSubView()
    {
        //if already present then remove
        if controllerDataUsage != nil {
            controllerDataUsage.view.removeFromSuperview()
        }
        
        controllerDataUsage = DataUsageViewController(nibName: "DataUsageViewController", bundle: nil)
        controllerDataUsage.comeFrom = .home
        addChildViewController(controllerDataUsage)
        vwDataUsage.addSubview(controllerDataUsage.view)
        controllerDataUsage.view.frame = vwDataUsage.bounds
        controllerDataUsage.didMove(toParentViewController: self)
    }
    func addRoomDetailsMainControllerAsSubView(obj : Room)
    {
        //if already present then remove
        if controllerRoomDetailsMainContainer != nil {
            controllerRoomDetailsMainContainer.view.removeFromSuperview()
        }
        
        controllerRoomDetailsMainContainer = RoomDetailsMainContainerViewController(nibName: "RoomDetailsMainContainerViewController", bundle: nil)
        let objRoom = obj
        controllerRoomDetailsMainContainer.selected_room_id = objRoom.room_id
        addChildViewController(controllerRoomDetailsMainContainer)
        vwRoomDetails.addSubview(controllerRoomDetailsMainContainer.view)
        controllerRoomDetailsMainContainer.view.frame = vwRoomDetails.bounds
        controllerRoomDetailsMainContainer.didMove(toParentViewController: self)
    }
    func initController()
    {
        self.view.backgroundColor = UICOLOR_IPAD_HOME_BG
        self.vwRoomContainer.backgroundColor = UICOLOR_CONTAINER_BG
        self.vwConstantHeader.backgroundColor = UICOLOR_IPAD_HOME_BG
        self.collectionView.backgroundColor = UICOLOR_CONTAINER_BG
        self.collectionViewForMoods.backgroundColor = UICOLOR_IPAD_HOME_BG
        
        self.lblMyRooms.font = Font_SanFranciscoText_Medium_H16
        self.lblMyRooms.textColor = UICOLOR_SWITCH_BORDER_COLOR_YELLOW
        self.lblMyRooms.text = SSLocalizedString(key: "my_rooms")
        
    }
    fileprivate func setupCollectionView() {
        // Registering nibs
        collectionView.register(UINib.init(nibName: "RoomContainerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RoomContainerCollectionViewCell")
        
        collectionViewForMoods.register(UINib.init(nibName: "MoodButtonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MoodButtonCollectionViewCell")
        
        // Disabling automatic content inset behaviour
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
    }
    func loadRoomData()
    {
        arrRoomData = DatabaseManager.sharedInstance().getAllRoomWithHomeID(home_id: VVBaseUserDefaults.getCurrentHomeID())
        
     
        arrMoodsForHome = DatabaseManager.sharedInstance().getAllMoodsForHomeWithHomeId(home_id: VVBaseUserDefaults.getCurrentHomeID())
         arrMoodsForHome.insert(self.addAddMoodInArrayMoods(), at: 0)
//         self.arrMoodsForHome.add(self.addAddMoodInArrayMoods())
//        SSLog(message: arrMoodsForHome)
        
        self.totalDataUsagaeValue = DatabaseManager.sharedInstance().getTotalUsgaeForCurrentHome()
        self.attributedStringForTotalUsage()

    }
    //MARK:- attributedStringForTotalUsage
    fileprivate func attributedStringForTotalUsage() {
        var stringToShow = ""
        if Double(self.totalDataUsagaeValue ?? "0") == 0.0
        {
            stringToShow = "-"
        }
        else
        {
            stringToShow = self.totalDataUsagaeValue! + " " + SSLocalizedString(key: "kw")
        }
        
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: SSLocalizedString(key: "total_usage_spaces"),
                                                   attributes: [.font: Font_Titillium_Regular_H15 ?? "",
                                                                .foregroundColor: UICOLOR_WHITE]))
        attributedString.append(NSAttributedString(string: stringToShow,
                                                   attributes: [.font: Font_Titillium_Regular_H15 ?? "",
                                                                .foregroundColor: UICOLOR_SELECTEDORON_BG]))
        
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        attributedString.addAttributes([.paragraphStyle: style], range: NSMakeRange(0, attributedString.length))
        
        self.lblTotalUsage.attributedText = attributedString
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
    //MARK:- setUpNavigationBar
    func setUpNavigationBar()  {
        let left = UIButton(type: .custom)
        left.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        left.addTarget(self, action: #selector(tappedMenu(_:)), for: UIControlEvents.touchUpInside)
        left.setImage(UIImage(named: "menu"), for: .normal)
        let leftButton = UIBarButtonItem(customView: left)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    //MARK:- tappedMenu
    @objc func tappedMenu(_ sender : UIButton)
    {
        var sideMenu: UISideMenuNavigationController?
        sideMenu = SideMenuManager.default.menuLeftNavigationController
        if (sideMenu != nil) {
            sender.isUserInteractionEnabled = false
            self.present(sideMenu!, animated: true, completion: {
                sender.isUserInteractionEnabled = true
            })
        }
    }
 //MARK:- setUpRightNavigationBarButton
    func setUpRightNavigationBarButton()  {
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
       
        let rightButton = UIBarButtonItem(customView: mainHomeSwitch!)
        self.navigationItem.rightBarButtonItem = rightButton
    }
    //MARK:- tappedMainHomeSwitch
    @objc func tappedMainHomeSwitch(_ sender : UIButton)
    {
        SSLog(message: "tappedMainHomeSwitch")
//        self.mainHomeSwitch?.isSelected = !(self.mainHomeSwitch?.isSelected)!
        
        
//        if (self.mainHomeSwitch?.isSelected)!
//        {
//            self.mainHomeSwitch?.isSelected = false
//            VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: true)
//            SMQTTClient.sharedInstance().changeLocalToGlobalServer(globalServer: true)
//        }
//        else
//        {
//            self.mainHomeSwitch?.isSelected = true
//            VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: false)
//            SMQTTClient.sharedInstance().changeLocalToGlobalServer(globalServer: false)
//        }
        if (self.mainHomeSwitch?.isSelected)!
        {
           
            SVProgressHUD.show()
            
            Utility.delay(2, closure: {
                DispatchQueue.main.async {
                    SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: true, success: { (str) in
                        self.mainHomeSwitch?.isSelected = false
                        VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: true)
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
            
            SVProgressHUD.show()
            Utility.delay(2, closure: {
                DispatchQueue.main.async {
                    SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: false, success: { (str) in
                        self.mainHomeSwitch?.isSelected = true
                        VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: false)
                        SMQTTClient.sharedInstance().subscribeAllTopic()
                        SVProgressHUD.dismiss()
                    }, failure: { (error) in
                        SVProgressHUD.dismiss()
                        self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_local_server"))
                    })
                }
            })
        }
        
    }
    //MARK:- AddAttributedLabelNavigationTitle
    func addAttributedLabelNavigationTitle()
    {
        let labelWidth = self.labelSize(for: self.attributedStringForActiveDevices().string, maxWidth: 40.0)
        //35 width + 35 x position + 20 space  TEMPORARY PATCH NEED TO REFACTOR
//         var firstFrame = CGRect(x: 550, y: 0, width:labelWidth.width , height: (self.navigationController?.navigationBar.frame.height)!)
        
           let  firstFrame = CGRect(x: ((self.navigationController?.navigationBar.frame.width)! - labelWidth.width - 90), y: 0, width:labelWidth.width , height: (self.navigationController?.navigationBar.frame.height)!)
        
        
       
        
        
        let firstLabel = UILabel(frame: firstFrame)
        firstLabel.attributedText = self.attributedStringForActiveDevices()
        firstLabel.textAlignment = .right
        self.navigationController?.navigationBar.addSubview(firstLabel)
       
    }
    fileprivate func attributedStringForActiveDevices() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: SSLocalizedString(key: "active_devices"),
                                                   attributes: [.font: Font_Titillium_Regular_H14 ?? "",
                                                                .foregroundColor: UICOLOR_WHITE]))
        attributedString.append(NSAttributedString(string: DatabaseManager.sharedInstance().getHomeOnSwitchesCount(),
                                                   attributes: [.font: Font_Titillium_Regular_H14 ?? "",
                                                                .foregroundColor: UICOLOR_SELECTEDORON_BG]))
        attributedString.append(NSAttributedString(string: "/" + DatabaseManager.sharedInstance().getHomeSwitchesCount(),
                                                   attributes: [.font: Font_Titillium_Regular_H14 ?? "",
                                                                .foregroundColor: UICOLOR_WHITE]))
        
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        attributedString.addAttributes([.paragraphStyle: style], range: NSMakeRange(0, attributedString.length))
        
        return attributedString
//        lblActiveDevicesCount.attributedText = attributedString
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView
        {
            return arrRoomData.count
        }
        else
        {
            return self.arrMoodsForHome.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView
        {
            let objRoom = arrRoomData[indexPath.row] as! Room
            let cell: RoomContainerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomContainerCollectionViewCell", for: indexPath) as! RoomContainerCollectionViewCell
            
            
            if self.objSelectedRoom == nil
            {
                cell.contentView.alpha = 0.4
            }
            else
            {
                if self.objSelectedRoom?.room_id == objRoom.room_id
                {
                    cell.contentView.alpha = 1.0
                }
                else
                {
                    cell.contentView.alpha = 0.4
                }
            }
            
            cell.btnDeleteRoom.isHidden = true
            cell.configureCellWithRoom(objRoom: objRoom)
            return cell
        }
        else
        {
            let objMood = arrMoodsForHome[indexPath.row]
            let cell: MoodButtonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoodButtonCollectionViewCell", for: indexPath) as! MoodButtonCollectionViewCell
            cell.delegate = self
            cell.configureCellWith(obj: objMood as! Mood, indexPath: indexPath)
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView
        {
            let objRoom = arrRoomData[indexPath.row] as! Room
            self.objSelectedRoom = objRoom
            self.collectionView.reloadData()
            self.addRoomDetailsMainControllerAsSubView(obj: self.objSelectedRoom!)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView
        {
            let width = (collectionView.frame.size.width)
            return CGSize(width: width, height: 87.0)
        }
        else
        {
            let obj = arrMoodsForHome[indexPath.row] as! Mood
            let str =  obj.mood_name
            var rect: CGRect = str!.boundingRect(with: CGSize(width: 500, height: 500), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: Font_SanFranciscoText_Regular_H14!], context: nil)
            rect.size.width += 20;
            rect.size.width = ceil(rect.size.width);
            
            return CGSize(width: rect.size.width, height: 34)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.collectionView
        {
            return UIEdgeInsetsMake(0, spacing, spacing, spacing);
        }
        else
        {
            return UIEdgeInsetsMake(15, 0, 15, 14)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // vertical space between cells
        if collectionView == self.collectionView
        {
            return spacing
        }
        else
        {
            return spacingForHomeMood
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // horizontal space between cells
        if collectionView == self.collectionView
        {
            return spacing
        }
        else
        {
            return spacingForHomeMood
        }
    }

    @IBAction func tappedOnAddMood(_ sender: Any) {
    }
    
    //MARK:  MoodButtonCollectionViewCellDelegate
    func tappedOnMoodBtn(obj : Mood,indexPath : IndexPath)
    {
        SSLog(message: obj.mood_name)
        if obj.mood_id == DUMMY_MOOD_ID
        {
            let controller = SkormanPopupViewController.init(nibName: "SkormanPopupViewController", bundle: nil)
            controller.comeFrom = .addNewMood
            controller.delegate = self;
            let cntPopup = STPopupController.init(rootViewController: controller)
            cntPopup.present(in: self)
        }
        else
        {
            //Need Help Sapanesh Sir
            //Need To add a logic to activite deactivate mood_status
            DatabaseManager.sharedInstance().updateMood(objMood: obj)
        }
        self.collectionViewForMoods.reloadItems(at: [indexPath])
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - MoodSettingsMainContainerViewControllerDelegate
    func didAddedOrEditedMoodSuccessfully()
    {
        arrMoodsForHome.removeAllObjects()
        arrMoodsForHome = DatabaseManager.sharedInstance().getAllMoodsForHomeWithHomeId(home_id: VVBaseUserDefaults.getCurrentHomeID())
        collectionViewForMoods.reloadData()
    }
    //MARK:- MenuViewDelegate
    func didSelectOption(indexPath: IndexPath, comeFrom: MenuViewControllerComeFrom, obj: Any)
    {
        SSLog(message: "tapped")
        let objMood = obj as! Mood
        if comeFrom == .homeMoods
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
                self.navigationController?.pushViewController(vc, animated: true)
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
                let controller = DeleteOptionsPopupViewController.init(nibName: "DeleteOptionsPopupViewController", bundle: nil)
                controller.objMood = objMood
                controller.comeFrom = .deleteHomeMood
                controller.delegate = self
                let cntPopup = STPopupController.init(rootViewController: controller)
                cntPopup.present(in: self)
            }
        }
    }
    //MARK:- DeleteOptionsPopupViewControllerDelegate
    func deleteSuccessfully() {
        self.didAddedOrEditedMoodSuccessfully()
    }
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        if UIDevice.current.orientation.isLandscape {
////            self.view = self.vwControllerForHozizontal
//
//        } else {
////            self.view = self.vwControllerForPortrait
//        }
//        self.view.layoutIfNeeded()
//    }
    func labelSize(for text: String, maxWidth : CGFloat) -> CGRect{
        
        let font = Font_Titillium_Regular_H15
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: maxWidth, height: CGFloat.leastNonzeroMagnitude))
        label.numberOfLines = 1
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame
    }
    
    
//    override func viewWillLayoutSubviews() {
//        let orientation = UIApplication.shared.statusBarOrientation
//        if orientation == .landscapeLeft || orientation == .landscapeRight
//        {
//             SSLog(message: "HomeForIpadViewController")
//        }
//        else
//        {
//            SSLog(message: "HomeForIpadViewController_portrait")
//        }
//    }
    
//    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
//        if toInterfaceOrientation.isLandscape {
//            Bundle.main.loadNibNamed("\(NSStringFromClass(type(of: self).self))", owner: self, options: nil)
//            viewDidLoad()
//        } else {
//            Bundle.main.loadNibNamed("\(NSStringFromClass(type(of: self).self))_portrait", owner: self, options: nil)
//            viewDidLoad()
//        }
//    }
}
