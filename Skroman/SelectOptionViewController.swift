//
//  SelectOptionViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/24/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

protocol SelectOptionViewControllerDelegate {
	func didSelectHomeOrRoom(obj : Home , comeFrom : SelectOptionViewControllerComeFrom)
}

class SelectOptionViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

	var delegate : SelectOptionViewControllerDelegate?
	var comeFrom : SelectOptionViewControllerComeFrom? = .selectHome
	var objHome = Home()
	var arrRooms = [Room]()
	var arrHomes = [Home]()
	
	var arrSwitchBoxes = [SwitchBox]()
	
	@IBOutlet weak var tableView: TPKeyboardAvoidingTableView!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		backButtonSetup()
		self.initViewController()
		if self.comeFrom == .selectRoom
		{
			getRoomsFromDatabase()
		}
		else if self.comeFrom == .selectDeviceForDataUsage
		{
			self.getSwitchBoxesFromDB()
		}
		else if self.comeFrom == .selectHome
		{
			self.getAllHomesFormDB()
		}
    }
    
	func getAllHomesFormDB()
	{
		arrHomes = DatabaseManager.sharedInstance().getAllHomes() as! [Home]
	}
	func getSwitchBoxesFromDB()
	{
		arrSwitchBoxes = DatabaseManager.sharedInstance().getAllSwitchBoxesWithRoomID(room_id: (self.objHome.roomToAdd?.room_id)!) as! [SwitchBox]
	}
	func getRoomsFromDatabase()
	{
		arrRooms = DatabaseManager.sharedInstance().getAllRoomWithHomeID(home_id: self.objHome.home_id!) as! [Room]
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(false, animated: true)
	}
	func initViewController()
	{
		self.view.backgroundColor = UICOLOR_MAIN_BG
		self.tableView.backgroundColor = UICOLOR_MAIN_BG
		self.title = SSLocalizedString(key: "select_home")
        if self.comeFrom == .selectRoom || self.comeFrom == .selectRoomForDataUsage
		{
			self.title = SSLocalizedString(key: "select_room")
		}
		
		self.setupTableView()
	}
	func setupTableView() {
		// Registering nibs
		tableView.register(UINib.init(nibName: "OptionContainerTableViewCell", bundle: nil), forCellReuseIdentifier: "OptionContainerTableViewCell")
	}
	override func backButtonTapped() {
		if self.comeFrom == .selectRoomForDataUsage
		{
			self.navigationController?.popViewController(animated: true)
		}
		else
		{
			self.dismiss(animated: true, completion: nil)
		}
		
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
		if self.comeFrom == .selectRoom || self.comeFrom == .selectRoomForDataUsage
		{
			return self.arrRooms.count
		}
		else if self.comeFrom == .selectDeviceForDataUsage
		{
			return self.arrSwitchBoxes.count
		}
		else if self.comeFrom == .selectHome
		{
			return self.arrHomes.count
		}
		else
		{
			return 1
		}
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
		let cell = tableView.dequeueReusableCell(withIdentifier: "OptionContainerTableViewCell", for: indexPath) as! OptionContainerTableViewCell
		if self.comeFrom == .selectRoom || self.comeFrom == .selectRoomForDataUsage
		{
			let currRoom = arrRooms[indexPath.row]
			if self.objHome.roomToAdd != nil && !Utility.isEmpty(val: self.objHome.roomToAdd?.room_id)
			{
				if currRoom.room_id == self.objHome.roomToAdd?.room_id
				{
					cell.btnOptionSelectDeselect.isSelected = true
				}
				else
				{
					cell.btnOptionSelectDeselect.isSelected = false
				}
			}
			cell.configureCellWithRoom(obj: currRoom)
		}
		else if self.comeFrom == .selectDeviceForDataUsage
		{
			let currentSwitchBox = arrSwitchBoxes[indexPath.row]
			if self.objHome.switchBoxToAdd != nil && !Utility.isEmpty(val: self.objHome.switchBoxToAdd?.switchbox_id)
			{
				if currentSwitchBox.switchbox_id == self.objHome.switchBoxToAdd?.switchbox_id
				{
					cell.btnOptionSelectDeselect.isSelected = true
				}
				else
				{
					cell.btnOptionSelectDeselect.isSelected = false
				}
			}
			cell.configureCellWithSwitchBox(obj: currentSwitchBox)
		}
		else if self.comeFrom == .selectHome
		{
			let currentHome = arrHomes[indexPath.row]
			if self.objHome.home_id != nil
			{
				if currentHome.home_id == self.objHome.home_id
				{
					cell.btnOptionSelectDeselect.isSelected = true
				}
				else
				{
					cell.btnOptionSelectDeselect.isSelected = false
				}
			}
			else
			{
				cell.btnOptionSelectDeselect.isSelected = false
			}
			cell.configureCellWithHome(obj: currentHome)
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if self.comeFrom == .selectRoom || self.comeFrom == .selectRoomForDataUsage
		{
			let roomObjSelected = arrRooms[indexPath.row]
			self.objHome.roomToAdd = roomObjSelected
		}
		else if self.comeFrom == .selectDeviceForDataUsage
		{
			let switchBoxSelected = arrSwitchBoxes[indexPath.row]
			self.objHome.switchBoxToAdd = switchBoxSelected
		}
		
		
		if self.comeFrom == .selectRoomForDataUsage
		{
			self.navigationController?.popViewController(animated: true)
			self.delegate?.didSelectHomeOrRoom(obj: self.objHome, comeFrom: self.comeFrom!)
		}
		else if self.comeFrom == .selectHome
		{
			let homeSelected = arrHomes[indexPath.row]
			self.objHome = homeSelected
			self.dismiss(animated: true) {
				self.delegate?.didSelectHomeOrRoom(obj: self.objHome, comeFrom: self.comeFrom!)
			}
		}
		else if self.comeFrom == .selectRoom
		{
			let selectedRoom = arrRooms[indexPath.row]
			self.objHome.roomToAdd = selectedRoom
			self.dismiss(animated: true) {
				self.delegate?.didSelectHomeOrRoom(obj: self.objHome, comeFrom: self.comeFrom!)
			}
		}

		
	}
}
