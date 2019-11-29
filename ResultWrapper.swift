//
//  ResultWrapper.swift
//  PalacesNQuneees
//
//  Created by admin on 26/06/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
struct  ResultWrapper <T : Decodable>: Decodable  {
    var result:T?
    
    private enum CodingKeys: String, CodingKey {
        case result
    }
}
