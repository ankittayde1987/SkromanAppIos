//
//  String+MD5.swift
//  WedOud
//
//  Created by anand mahajan on 2/5/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

extension String {
    func MD5() -> String {
        let messageData = self.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
