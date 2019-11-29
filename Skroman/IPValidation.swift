//
//  IPValidation.swift
//  Skroman
//
//  Created by Skroman on 27/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


func validateIpAddress(ipToValidate: String) -> Bool {
    
    var sin = sockaddr_in()
    var sin6 = sockaddr_in6()
    
    if ipToValidate.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
        // IPv6 peer.
        return true
    }
    if ipToValidate.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
        // IPv4 peer.
        return true
    }
    
    return true;
}
