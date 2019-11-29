//
//  DataUsageViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import SVProgressHUD

class DataUsageViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,SelectOptionViewControllerDelegate {
	var comeFrom : DataUsageViewControllerComeFrom? = .home
	var parentNavigation : UINavigationController?
	
	var arrRoomData = [Room]()
    var arrRoomDataWithAllRooms = [Room]()
    var arrDataUsageData = [DataUsage]()
    
    var objEnerygyDataWrapperForLineGraph = EnergyDataWrapper()
    
	var arrSwitchBoxes = [SwitchBox]()
	var arrSwitch = [Switch]()
    var totalDataUsagaeValue : String? = ""
	var objSwitchBox : SwitchBox?
	var objCurrentRoom : Room?
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var vwTableHeader: UIView!
	@IBOutlet weak var vwTotalUsage: UIView!
	@IBOutlet weak var vwRoomNameContainer: UIView!
	@IBOutlet weak var lblTotalUsageTitle: UILabel!
	@IBOutlet weak var lblTotalUsgaeValue: UILabel!
	@IBOutlet weak var btnTotalUsgae: UIButton!
	@IBOutlet weak var lblRoomTitle: UILabel!
	@IBOutlet weak var imagDownArrow: UIImageView!
	@IBOutlet weak var btnRoomName: UIButton!
	
    @IBOutlet weak var constantHightForVwIPadTop: NSLayoutConstraint!
    @IBOutlet weak var vwInternalSeprator: UIView!
    @IBOutlet weak var btnAddDevice: UIButton!
    @IBOutlet weak var vwTopAddDevicesForIPad: UIView!
    
    @IBOutlet weak var lblConnectToLocalMessage: UILabel!
    @IBOutlet weak var vwConnectToLocal: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
		
        // Do any additional setup after loading the view.
		if self.comeFrom == .roomDetails
		{
			self.title = SSLocalizedString(key: "data_usage")
            loadSwitchBoxeData()
            self.imagDownArrow.isHidden = true;
            self.btnRoomName.isUserInteractionEnabled = false
		}
        else
        {
            loadRoomData()
            self.imagDownArrow.isHidden = false;
            self.btnRoomName.isUserInteractionEnabled = true
        }
		self.initViewController()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vwTopAddDevicesForIPad.isHidden = true
        self.updateDataUsageViewControllerUI()
        if !Utility.isRestrictOperation()
        {
            
            self.canMakeGetEnergyDataAPICall();
        }
    }
    
    func canMakeGetEnergyDataAPICall()
    {
        
        if DatabaseManager.sharedInstance().checkEnergyDataExist()
        {
           self.perFormAfterEnergeyDataAPISuccess();
            Utility.insertEnergyDataForDefaultHomeWithCallbackNew(success: { (success) in
//                self.perFormAfterEnergeyDataAPISuccess();
            }) { (error) in
                SSLog(message: "error");
            }
        }
        else
        {
            SVProgressHUD.show(withStatus: SSLocalizedString(key: "loading"))
            self.objEnerygyDataWrapperForLineGraph.energy_data?.removeAll()
            
            DatabaseManager.sharedInstance().deleteEnergyData()
            
            Utility.insertEnergyDataForDefaultHomeWithCallbackNew(success: { (success) in
                self.perFormAfterEnergeyDataAPISuccess();
            }) { (error) in
                SSLog(message: "error");
            }
        }
    }
   
    func updateDataUsageViewControllerUI()
    {
        if Utility.isIpad()
        {
            self.vwTopAddDevicesForIPad.isHidden = false
        }
        else
        {
          self.vwTopAddDevicesForIPad.isHidden = true
        }
        
        if Utility.isRestrictOperation()
        {
            self.tableView.isHidden = true;
            self.vwConnectToLocal.isHidden = false;
        }
        else
        {
            self.tableView.isHidden = true
             self.vwConnectToLocal.isHidden = true;
        }
    }
    func perFormAfterEnergeyDataAPISuccess()
    {
        //SVProgressHUD.show(withStatus: SSLocalizedString(key: "loading"))
        Utility.delay(1) {
            self.tableView.isHidden = false
            SVProgressHUD.dismiss()
            
            if self.comeFrom == .home
            {
                self.loadRoomData()
            }
            else
            {
                self.getDataUsageArrayForSpecificRoom()
                self.lblRoomTitle.text = self.objCurrentRoom?.room_name
            }
            
            self.objEnerygyDataWrapperForLineGraph = DatabaseManager.sharedInstance().getWeeklyEnergyDataConsumption()
            self.totalDataUsagaeValue = DatabaseManager.sharedInstance().getTotalUsgaeForCurrentHome()
            self.lblTotalUsgaeValue.text = self.totalDataUsagaeValue! + " " + SSLocalizedString(key: "kw")
            
            //if it returns 0.0 then hide everything
            if Double(self.totalDataUsagaeValue ?? "0") == 0.0
            {
                SSLog(message: "totalUsgaeValue")
                if !Utility.isIpad()
                {
                    self.tableView.tableHeaderView = nil
                }
                else
                {
                    if self.comeFrom == .home{
                        
                        self.constantHightForVwIPadTop.constant = 56
                    }
                    else if self.comeFrom == .roomDetails{
                        
                        self.constantHightForVwIPadTop.constant = 0
                    }
                }
            }
            else
            {
                //get rooms and other things
                self.vwTopAddDevicesForIPad.isHidden = false
                
            }
            
            //            self.tableView.dataSource = self
            //            self.tableView.delegate = self
            self.tableView.reloadData()
            
        }
    }
	func loadSwitchBoxeData()
	{
		arrSwitch = DatabaseManager.sharedInstance().getAllSwitchWithSwitchBoxID(switchbox_id: (self.objSwitchBox?.switchbox_id)!) as! [Switch]
		self.lblRoomTitle.text = self.objSwitchBox?.name
	}
    //MARK:- addAddMoodInArrayMoods
    func addAllRoomsInArrayRoom() -> Room
    {
        let obj = Room()
        obj.room_id = ALL_ROOM_ID
        obj.room_name = SSLocalizedString(key: "all_rooms")
        return obj
    }
    
	func loadRoomData()
	{
		arrRoomData = DatabaseManager.sharedInstance().getAllRoomWithHomeID(home_id: VVBaseUserDefaults.getCurrentHomeID()) as! [Room]
        
        arrRoomDataWithAllRooms = arrRoomData
        arrRoomDataWithAllRooms.insert(self.addAllRoomsInArrayRoom(), at: 0)
       
        self.getDataUsageArrayForAllRooms()
        
		if self.comeFrom == .home
		{
			if self.arrRoomDataWithAllRooms.count != 0
			{
				self.objCurrentRoom = arrRoomDataWithAllRooms[0]
				if self.lblRoomTitle != nil
				{
					self.lblRoomTitle.text = self.objCurrentRoom?.room_name
				}
                
                
                if self.objCurrentRoom?.room_id == ALL_ROOM_ID
                {
                    
                }
                else
                {
                    
                }
			}
		}
	}
	
    func createDataUsageObj(data_id : String, name : String, color: String, kw: String) -> DataUsage
    {
        let objDU = DataUsage()
        objDU.data_id = data_id
        objDU.name = name
        objDU.color = color
        objDU.kw = kw
        return objDU
    }
	func reloadControllerOnDefaultHomeChange()
	{
		//Clear all old data
		self.arrSwitch.removeAll()
		self.arrSwitchBoxes.removeAll()
		self.arrRoomData.removeAll()
		self.objCurrentRoom = Room()
		
		self.loadRoomData()
		if self.tableView != nil
		{
			DispatchQueue.main.async{
				self.tableView.reloadData()
			}
			SSLog(message: "inside")
		}
		
	}
	func getDataUsageArrayForAllRooms()
    {
        self.arrDataUsageData.removeAll()
        for objRm in arrRoomData
        {
            
            let dataUsageinKwForRoom = DatabaseManager.sharedInstance().getTotalUsgaeForRoom(room_id: objRm.room_id!)
            
            let objDUtoAppnd = self.createDataUsageObj(data_id: objRm.room_id!, name: objRm.room_name!, color: "", kw: dataUsageinKwForRoom)
            arrDataUsageData.append(objDUtoAppnd)
        }
    }
    
    func getDataUsageArrayForSpecificRoom()
    {
        self.arrDataUsageData.removeAll()
        //Get All SwitchBoxes in Room
        arrSwitchBoxes = DatabaseManager.sharedInstance().getAllSwitchBoxesWithRoomID(room_id: (self.objCurrentRoom?.room_id)!) as! [SwitchBox]
        //Append All Switches To SwitchArray
        for switchBox in arrSwitchBoxes
        {
            let dataUsageinKwForSwitchBox = DatabaseManager.sharedInstance().getTotalUsgaeForSwitchBox(switchbox_id: switchBox.switchbox_id!)
            
            let objDUtoAppnd = self.createDataUsageObj(data_id: switchBox.switchbox_id!, name: switchBox.name!, color: "", kw: dataUsageinKwForSwitchBox)
            arrDataUsageData.append(objDUtoAppnd)
        }
    }
	
	func getDataUsageArrayAndReload()
	{
		if self.comeFrom == .home
		{
			self.lblRoomTitle.text = self.objCurrentRoom?.room_name
            if self.objCurrentRoom?.room_id == ALL_ROOM_ID
            {
                self.getDataUsageArrayForAllRooms()
            }
            else
            {
                self.getDataUsageArrayForSpecificRoom()
            }
		}
		else
		{
			self.lblRoomTitle.text = self.objSwitchBox?.name
			arrSwitch = DatabaseManager.sharedInstance().getAllSwitchWithSwitchBoxID(switchbox_id: (self.objSwitchBox?.switchbox_id)!) as! [Switch]
		}
		self.tableView.reloadData()
	}
	func initViewController()
	{
		//Setting Background Color
		self.view.backgroundColor = UICOLOR_MAIN_BG
		self.tableView.backgroundColor = UICOLOR_MAIN_BG
		self.vwTableHeader.backgroundColor = UICOLOR_MAIN_BG
		self.vwTotalUsage.backgroundColor = UICOLOR_CONTAINER_BG
		self.vwRoomNameContainer.backgroundColor = UICOLOR_CONTAINER_BG
		
		//Setting Border
		self.vwTotalUsage.layer.cornerRadius = 3.0
		self.vwTotalUsage.clipsToBounds = true
		self.vwTotalUsage.layer.borderWidth = 1.0
		self.vwTotalUsage.layer.borderColor = UICOLOR_SWITCH_BORDER_COLOR_YELLOW.cgColor
		
		self.vwRoomNameContainer.layer.cornerRadius = 3.0
		self.vwRoomNameContainer.clipsToBounds = true
		self.vwRoomNameContainer.layer.borderWidth = 1.0
		self.vwRoomNameContainer.layer.borderColor = UICOLOR_TEXTFIELD_CONTAINER_BORDER.cgColor
		
		//Setting Font
		self.lblTotalUsageTitle.font = Font_SanFranciscoText_Medium_H18
		self.lblTotalUsgaeValue.font = Font_SanFranciscoText_Medium_H18
		self.lblRoomTitle.font = Font_SanFranciscoText_Medium_H18
		
		//Setting TextColor
		self.lblTotalUsageTitle.textColor = UICOLOR_WHITE
		self.lblTotalUsgaeValue.textColor = UICOLOR_SWITCH_BORDER_COLOR_YELLOW
		self.lblRoomTitle.textColor = UICOLOR_WHITE
		
		//Setting Default Text
		self.lblTotalUsageTitle.text = SSLocalizedString(key: "total_usage").uppercased()
		
        //
        self.constantHightForVwIPadTop.constant = 0
        
        if !Utility.isIpad()
        {
            //Add HeaderView To TableView
            self.tableView.tableHeaderView = self.vwTableHeader
        }
        else
        {
            if self.comeFrom == .home
            {
                self.constantHightForVwIPadTop.constant = 56.0
            }
        }
		
		
        //
        self.vwTopAddDevicesForIPad.backgroundColor = UICOLOR_ROOM_CELL_BG
        self.vwInternalSeprator.backgroundColor = UICOLOR_SEPRATOR
        
        self.btnAddDevice.layer.cornerRadius = 3.0
        self.btnAddDevice.titleLabel?.font = Font_SanFranciscoText_Regular_H14
        self.btnAddDevice.backgroundColor = UICOLOR_ADD_MOOD_BG
        self.btnAddDevice.setTitleColor(UICOLOR_WHITE, for: .normal)
        self.btnAddDevice.setTitle(SSLocalizedString(key: "add_device"), for: .normal)
        
        
		self.setupTableView()
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func setupTableView() {
		// Registering nibs
		tableView.register(UINib.init(nibName: "PieChartTableViewCell", bundle: nil), forCellReuseIdentifier: "PieChartTableViewCell")
		
		
		tableView.register(UINib.init(nibName: "LineChartViewTableViewCell", bundle: nil), forCellReuseIdentifier: "LineChartViewTableViewCell")
        
        tableView.register(UINib.init(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyTableViewCell")
	}
	
	// MARK: - UITableView
	
	func numberOfSections(in tableView: UITableView) -> Int {
		
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 1
        if Double(self.totalDataUsagaeValue ?? "0") != 0.0
        {
            rows = 2
        }
		return rows
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var tblRowHeight = self.tableView.frame.size.height
        if Double(self.totalDataUsagaeValue ?? "0") != 0.0
        {
            tblRowHeight = self.tableView.frame.size.height / 2
        }
		return tblRowHeight
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Double(self.totalDataUsagaeValue ?? "0") != 0.0
        {
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTableViewCell", for: indexPath) as! PieChartTableViewCell
                cell.configureCellWithDataUsageArray(arr: arrDataUsageData)
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LineChartViewTableViewCell", for: indexPath) as! LineChartViewTableViewCell
                cell.configureCellWithEnergyDataWrapperForWeeklyLineGraph(obj: objEnerygyDataWrapperForLineGraph)
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell
            cell.configureCellWithEmptyMsg(emptyMsg: SSLocalizedString(key: "no_data_usage"))
            return cell
        }
		

	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}
	
	// MARK: - IBAction
	
	@IBAction func tappedOnTotalUsgae(_ sender: Any) {
	}
    
	@IBAction func tappedOnRoomName(_ sender: Any) {
		if self.comeFrom == .home
		{
			let vc = SelectOptionViewController.init(nibName: "SelectOptionViewController", bundle: nil)
			vc.comeFrom = .selectRoomForDataUsage
			vc.delegate = self
			let homeObj = Home()
			homeObj.home_id = VVBaseUserDefaults.getCurrentHomeID()
			homeObj.roomToAdd = self.objCurrentRoom
			vc.objHome = homeObj
            vc.arrRooms = self.arrRoomDataWithAllRooms
			self.parentNavigation?.pushViewController(vc, animated: true)
		}
		else
		{
			let vc = SelectOptionViewController.init(nibName: "SelectOptionViewController", bundle: nil)
			vc.comeFrom = .selectDeviceForDataUsage
			vc.delegate = self
			let homeObj = Home()
			homeObj.home_id = VVBaseUserDefaults.getCurrentHomeID()
			homeObj.roomToAdd = self.objCurrentRoom
			homeObj.switchBoxToAdd = self.objSwitchBox
			vc.objHome = homeObj
			let navigationVC = UINavigationController(rootViewController: vc)
			self.present(navigationVC, animated: true, completion: nil)
		}

	}
	//MARK:- SelectOptionViewControllerDelegate
	func didSelectHomeOrRoom(obj : Home , comeFrom : SelectOptionViewControllerComeFrom)
	{
		if self.comeFrom == .home
		{
			self.objCurrentRoom = obj.roomToAdd
		}
		else
		{
			self.objSwitchBox = obj.switchBoxToAdd
		}
		self.getDataUsageArrayAndReload()
	}
    //MARK:- IBAction
    @IBAction func tappedOnAddDevice(_ sender: Any) {
        let nibName = Utility.getNibNameForClass(class_name: String.init(describing: AddDeviceViewController.self))
        let vc = AddDeviceViewController(nibName: nibName , bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
