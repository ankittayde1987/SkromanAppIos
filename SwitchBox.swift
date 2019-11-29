//
//  PI.swift
//  Skroman
//
//  Created by Sphinx Solutions on 9/8/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class SwitchBox: Codable {
    var sbid : Int = 0
    var room_id : String?
    var name : String?
    var switchbox_id : String?
    var mac_address : String?
    var child_lock : Int?
    var switches : [Switch]?
    var moods : [Mood]?
	
	
	//Added a Master Switch object for mood Add/Edit
	var masterSwitch : Mood?
	
	
	
	var masterSwitchObjFromMoods: Mood? {
		guard let masterTemp = moods else {
			return nil
		}
		
		
		let filteredOptions = masterTemp.filter { (obj: Mood) -> Bool in
			return ((obj.switch_id == 0))
		}
		
		if filteredOptions.count > 0 {
			return filteredOptions[0]
		} else {
			return nil
		}
	}
  
    enum CodingKeys: String, CodingKey {
        case room_id
        case name
        case switchbox_id
        case mac_address
        case child_lock
        case switches
        case moods
		case masterSwitch
    }
    
    init() {
        sbid = 0
        room_id = ""
        name = ""
        switchbox_id = ""
        mac_address = ""
        child_lock = 0
        switches = []
        moods = []
		masterSwitch = Mood()
    }
	
	func getTotalSwitchesCount() -> String
	{
		return "\(self.switches?.count ?? 0)"
	}
	func getActiveSwitchesCount() -> String
	{
		let obj = switches?.filter{ objSwtch in
			return objSwtch.status == 1
		}
		return "\(obj?.count ?? 1)"
	}
	
	func getMasterSwitchDataFromSwitchBox() -> Switch
	{
		var isFound : Bool = false
		var foundIndex : Int = 0
		for currentIndex in 0..<(switches?.count)! {
			let obj = switches![currentIndex]
			if obj.switch_id == 0
			{
				isFound = true
				foundIndex = currentIndex
			}
		}
		var objMasterSwitch = Switch()
		if(isFound){
			objMasterSwitch = switches![foundIndex]
		}
		return objMasterSwitch
	}
	
	func removeMasterSwitchDataFromMainSwitchBoxes()
	{
		var isFound : Bool = false
		var foundIndex : Int = 0
		for currentIndex in 0..<(switches?.count)! {
			let obj = switches![currentIndex]
			if obj.switch_id == 0
			{
				isFound = true
				foundIndex = currentIndex
			}
		}
		if(isFound){
			switches?.remove(at: foundIndex)
		}
	}
	
	func removeMoodSwitchDataFromMainSwitchBoxes()
	{
		var isFound : Bool = false
		var foundIndex : Int = 0
		for currentIndex in 0..<(switches?.count)! {
			let obj = switches![currentIndex]
			if obj.type == 2
			{
				isFound = true
				foundIndex = currentIndex
			}
		}
		if(isFound){
			switches?.remove(at: foundIndex)
		}
	}
	
	
	//ADDED BELOW FOR MOOD ADD/EDIT
	func getMasterSwitchFromMoods() -> Mood
	{
		var isFound : Bool = false
		var foundIndex : Int = 0
		for currentIndex in 0..<(moods?.count)! {
			let obj = moods![currentIndex]
			if obj.switch_id == 0
			{
				isFound = true
				foundIndex = currentIndex
			}
		}
		var objMasterSwitch = Mood()
		let objS = Mood()
		if(isFound){
			objMasterSwitch = moods![foundIndex]
			//IF FOUND THEN COPY PROPERTIES
			objS.mid = objMasterSwitch.mid
			objS.mood_id = objMasterSwitch.mood_id
			objS.mood_name = objMasterSwitch.mood_name
			objS.switchbox_id = objMasterSwitch.switchbox_id
			objS.home_id = objMasterSwitch.home_id
			objS.switch_id = objMasterSwitch.switch_id
			objS.mood_type = objMasterSwitch.mood_type
			objS.status = objMasterSwitch.status
			objS.position = objMasterSwitch.position
			objS.mood_repeat = objMasterSwitch.mood_repeat
			objS.mood_time = objMasterSwitch.mood_time
			objS.mood_status = objMasterSwitch.mood_status
			objS.switch_name = objMasterSwitch.switch_name
			objS.switch_icon = objMasterSwitch.switch_icon
		}
		return objS
	}
	
	func removeMasterSwitchFromMoods()
	{
		var isFound : Bool = false
		var foundIndex : Int = 0
		for currentIndex in 0..<(moods?.count)! {
			let obj = moods![currentIndex]
			if obj.switch_id == 0
			{
				isFound = true
				foundIndex = currentIndex
			}
		}
		if(isFound){
			moods?.remove(at: foundIndex)
		}
	}
	
	func removeMoodSwitchFromMoods()
	{
		var isFound : Bool = false
		var foundIndex : Int = 0
		for currentIndex in 0..<(moods?.count)! {
			let obj = moods![currentIndex]
			if obj.type == SWITCH_TYPE_MOOD
			{
				isFound = true
				foundIndex = currentIndex
			}
		}
		if(isFound){
			moods?.remove(at: foundIndex)
		}
	}
	
	func getSelectedMoodsName() -> String
	{
		var str : String?
		for obj in moods!
		{
			if Utility .isEmpty(val: str)
			{
				str = obj.mood_name
			}
			else
			{
				str = str! + "," + obj.mood_name!
			}
			
		}
		if str == nil
		{
			str = ""
		}
		return str!
	}
}
