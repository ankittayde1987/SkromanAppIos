//
//  PI.swift
//  Skroman
//
//  Created by Sphinx Solutions on 9/8/18.
//  Copyright © 2018 admin. All rights reserved.
//
/*
 switchbox_id : "SB-5D69"
 home_id : "HM-28CD3"
 mood_id : "SB-5D69_MOOD_7"
 switch_id : 8
 mood_type : 3
 status : 0
 position : 0
 mood_repeat : "null"
 mood_time : "null"
 mood_status : 1
 mood_name : "MOOD 0"
 */
import Foundation

class Mood: Codable {
    var mid : Int = 0
    var mood_id : String?
    var mood_name : String?
    var switchbox_id : String?
    var home_id : String?
    var switch_id : Int? = 0
    var mood_type : Int = 0
    var status : Int = 0
    var position : Int = 0
    var mood_repeat : [Int] = []
    var mood_time : String?
    var mood_status : Int = 0
	
	

	
	
	//NEED TO ADD BELOW FOR ADD/EDIT MOOD
	//"type" is equal to mood_type
	//"switch_name"
	//"switch_icon"
	var switch_name : String? = ""
	var switch_icon : String? = ""
	var type : Int?
	

   /*  var home_id : String?
    var switchbox_id : String?
    var switch_id : Int?
    var status : Int?
    var position : Int?
    var mood_status : Int?
    var mood_repeat : String?
    var mood_type : Int?
    var mood_time : String?
    var mood_name : String?*/
    
    enum CodingKeys: String, CodingKey {
        case mood_id
        case mood_name
        case switchbox_id
        case home_id
        case switch_id
        case mood_type
        case status
        case position
        case mood_repeat
        case mood_time
        case mood_status
		case switch_name
		case switch_icon
		case type
     
    }
    
    init() {
       mid = 0
       mood_id = ""
       mood_name = ""
       switchbox_id = ""
       home_id = ""
       switch_id = 0
       mood_type = 0
       status = 0
       position = 0
       mood_repeat = []
       mood_time = ""
       mood_status = 0
		type = 0
    }
	
	func getImageNameToSetForMood() -> String
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
		var defaultImageName = String(format: "type_%@_1","\(self.mood_type)")
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
		let defaultImageName = String(format: "type_%@_1","\(self.mood_type)")
		return defaultImageName
	}
	
	func getCommaSepratedMoodRepeatArray() -> String
	{
		var stringRepresentation : String? = ""
		stringRepresentation = (self.mood_repeat.map{String(describing: $0)}).joined(separator: ",")
		SSLog(message: stringRepresentation)
		return stringRepresentation!
	}
	func getArrayFormString(str : String) -> [Int]
	{
		let items = str.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "\n", with: "").removingWhitespaces().split(separator: ",")
		
		var arrNew = [Int]()
		if items.count != 0
		{
			for element in items {
				arrNew.append(Int(element)!)
			}
		}
		return arrNew
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
