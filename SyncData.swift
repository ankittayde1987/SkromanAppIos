//
//  SyncData.swift
//  Skroman
//
//  Created by Sphinx Solutions on 9/14/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class SyncData: Codable {
    var syncData : [Home]?
    
    enum CodingKeys: String, CodingKey {
        case syncData
    }
    init() {
        syncData = []
    }
}

