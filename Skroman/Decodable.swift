//
//  DecoderModified.swift
//  SoftSpot
//
//  Created by Pradip Parkhe on 09/05/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

extension Decodable{
    static func decode<T : Decodable>(_ data : Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let err {
            SSLog(message: "DecoderModifiedError>>\(err)")
        }
        return nil
    }
}
