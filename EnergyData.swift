//
//  EnergyData.swift
//  Skroman
//
//  Created by Admin on 03/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class EnergyData: Codable {
    var week_start_date : String? = ""
    var switchbox : [SwitchBox]?
    
    //For App Use
    var weekly_total_usage : String? = ""
    
    enum CodingKeys: String, CodingKey {
        case week_start_date
        case switchbox
        case weekly_total_usage
    }
    init() {
        week_start_date = ""
        switchbox = []
        weekly_total_usage = ""
    }
}
