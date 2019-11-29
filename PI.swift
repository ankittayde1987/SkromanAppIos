//
//  PI.swift
//  Skroman
//
//  Created by Sphinx Solutions on 9/8/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class PI: Encodable,Decodable {
    var lid : Int = 0
    var pi_id : String?
    var ssid : String?
    var password : String?
    var home_id : String?
    
    enum CodingKeys: String, CodingKey {
        case pi_id
        case ssid
        case password
        case home_id
    }
    
    init() {
        pi_id = ""
        ssid = ""
        password = ""
        home_id = ""
    }
}
