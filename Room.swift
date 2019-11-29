//
//  PI.swift
//  Skroman
//
//  Created by Sphinx Solutions on 9/8/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class Room: Codable {
    var rid : Int = 0
    var room_id : String?
    var room_name : String?
    var home_id : String?
    var image : String?
	var unique_room_id : String? //come for edit room
    var switchboxes : [SwitchBox]?
//	var roomImage =  UIImage()
	
    enum CodingKeys: String, CodingKey {
        case room_name
        case room_id
        case home_id
        case image
		case unique_room_id
        case switchboxes
   }
    
    init() {
        rid = 0
        room_name = ""
        room_id = ""
        home_id = ""
        image = ""
		unique_room_id = ""
        switchboxes = []
    }
	func getDefaultImageName() -> String
	{
		return "room_1_active"
	}
	func getDefaultImagesArray() -> Array<String>
	{
		return [
			"room_1",
			"room_2",
			"room_3",
			"room_4",
			"room_5",
			"room_6",
			"camera"
		]
	}
}
