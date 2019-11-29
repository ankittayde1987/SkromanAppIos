//
//  PI.swift
//  Skroman
//
//  Created by Sphinx Solutions on 9/8/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class Home: Codable {
    var hid : Int?
    var home_name : String?
    var home_id : String?
    var pi_id : String?
    var is_default : Int = 0
    var rooms: [Room]?
    var success : Int?
	
	var roomToAdd : Room?
	var switchBoxToAdd : SwitchBox?
	var deviceName : String?
	
    
    enum CodingKeys: String, CodingKey {
        case hid
        case home_name
        case home_id
        case pi_id
        case rooms
		case roomToAdd
		case switchBoxToAdd
		case deviceName
        case success
    }
    
    init() {
        hid = 0
        home_name = ""
        home_id = ""
        pi_id = ""
        is_default = 0
        rooms = []
		roomToAdd = Room()
		switchBoxToAdd = SwitchBox()
		deviceName = ""
        success = 0
    }
}
