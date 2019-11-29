//
//  PI.swift
//  Skroman
//
//  Created by Sphinx Solutions on 9/8/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class Switch: Codable {
    var swid : Int = 0
    var switch_id : Int?
    var switchbox_id : String?
    var type : Int?
    var status : Int?
    var position : Int?
    var master_mode_status : Int?
	var switch_name : String?
	var switch_icon : String?
    var wattage : Double?
    
    //For EnergyData
    //watt,timestamp,_id
    var timestamp : String?
    

 
    
    enum CodingKeys: String, CodingKey {
        case switch_id
        case switchbox_id
        case type
        case status
        case position
        case master_mode_status
		case switch_name
		case switch_icon
        case wattage = "kw"
        case timestamp
//        case _id
    }
    

    
    init() {
        swid = 0
        switch_id = 0
        switchbox_id = ""
        type = 0
        status = 0
        position = 0
        master_mode_status =  0
		switch_name = ""
		switch_icon = ""
        wattage = 0
        timestamp = ""
//        _id = ""
        
        
    }
	func getImageNameToSet() -> String
	{
		var imageName = self.getDefaultImageName()
			if (!Utility.isEmpty(val: self.switch_icon) && self.status == 1)
			{
				imageName = getActiveImageName()
			}
		return imageName
	}
	
	func getDefaultImageName() -> String
	{
		var defaultImageName = String(format: "type_%@_1","\(self.type!)")
		if !Utility.isEmpty(val: self.switch_icon)
		{
			defaultImageName = self.switch_icon!
		}
		
		return defaultImageName
	}
	
	func getActiveImageName() -> String
	{
		return String(format: "%@_active",self.switch_icon!)
	}
	func getDefaultImageNameByType() -> String
	{
		let defaultImageName = String(format: "type_%@_1","\(self.type!)")
		return defaultImageName
	}
	func getType0ImagesArray() -> Array<String>
	{
		return [
			"type_0_1"
		]
	}
	func getType1ImagesArray() -> Array<String>
	{
		return [
			"type_1_1",
			"type_1_2",
			"type_1_3",
			"type_1_4",
			"type_1_5",
			"type_1_6",
			"type_1_7",
			"type_1_8"
		]
	}
	func getType2ImagesArray() -> Array<String>
	{
		return [
			"type_2_1"
		]
	}
	func getType3ImagesArray() -> Array<String>
	{
		return [
			"type_3_1"
		]
	}
	
	
	
	func getDefaultImagesArrayAccordingToType() -> Array<String>
	{
		var imagesArray = self.getType0ImagesArray()
		if self.type == SWITCH_TYPE_FAN //1
		{
			imagesArray = self.getType1ImagesArray()
		}
		else if self.type == SWITCH_TYPE_MOOD //2
		{
			imagesArray = self.getType2ImagesArray()
		}
		else if self.type == SWITCH_TYPE_DIMMER //3
		{
			imagesArray = self.getType3ImagesArray()
		}
		return imagesArray
	}
	
	
	func getSteeperValueArrayForFan() -> Array<Int>
	{
		return [
			0,
			1,
			2,
			3,
			4
		]
	}
	func getSteeperValueArrayForDimmer() -> Array<Int>
	{
		return [
			0,
			1,
			2,
			3,
			4,
			5,
			6,
			7
		]
	}
	func getSteeperValueArray() -> Array<Int>
	{
		var steeperValueArray = self.getSteeperValueArrayForFan()
		if self.type == SWITCH_TYPE_DIMMER
		{
			steeperValueArray = self.getSteeperValueArrayForDimmer()
		}
		return steeperValueArray
	}
            }


