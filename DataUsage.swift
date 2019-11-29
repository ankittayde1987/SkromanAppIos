//
//  DataUsage.swift
//  Skroman
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class DataUsage: Codable {
    var name : String? = ""
    var color : String? = ""
    var data_id : String? = ""
    var kw : String? = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case color
        case data_id
        case kw
    }
    
    init() {
        name = ""
        color = ""
        data_id = ""
        kw = ""
    }
}
