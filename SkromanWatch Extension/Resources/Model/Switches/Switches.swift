//
//  Switches.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 11/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import WatchKit

class Switches: NSObject {

    var switchbox_id : String?
    var switch_id : Int?
    var type : Int?
    var status : Int?
    var position : Float?
    var master_mode_status : Int?
    var wattage : Int?
    
    
    func initwithJson(json: [String: Any]) -> Switches{
        
              self.switchbox_id = json["switchbox_id"] as? String ?? ""
                 self.switch_id = json["switch_id"] as? Int ?? 0
                      self.type = json["type"] as? Int ?? 0
                    self.status = json["status"] as? Int ?? 0
                  self.position = json["position"] as? Float ?? 0
        self.master_mode_status = json["master_mode_status"] as? Int ?? 0
                   self.wattage = json["wattage"] as? Int ?? 0
        
        return self
    }
}
