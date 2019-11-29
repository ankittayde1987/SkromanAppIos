//
//  EnergyDataWrapper.swift
//  Skroman
//
//  Created by Admin on 06/03/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EnergyDataWrapper: Codable {
    var energy_data : [EnergyData]?
    
    enum CodingKeys: String, CodingKey {
        case energy_data
    }
    init() {
        energy_data = []
    }
}
