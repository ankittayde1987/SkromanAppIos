//
//  EVModified.swift
//  getAMe
//
//  Created by admin on 6/16/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import EVReflection

class EVModified: EVObject {
    
    //https://github.com/evermeer/EVReflection/issues/43
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        
    }
   
}
