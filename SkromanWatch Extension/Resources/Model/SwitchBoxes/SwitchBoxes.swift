//
//  SwitchBoxes.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 11/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import WatchKit

class SwitchBoxes: NSObject {
    
    var room_id : String?
    var switchbox_id : String?
    var mac_address : String?
    var child_lock : String?
    var name : String?

    var arrayOfCount1 : Any?
    var arrayOfCount2 : Any?
    var arrayOfSwitches : Any?
    var arrayOfMoods : Any?
    var switches : Switches?
    var moods : Moods?

    
    func initwithJson(json: [String: Any]) -> SwitchBoxes{
        
        self.room_id = json["room_id"] as? String ?? ""
        self.switchbox_id = json["switchbox_id"] as? String ?? ""
        self.mac_address = json["mac_address"] as? String ?? ""
        self.child_lock = json["child_lock"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.arrayOfSwitches = NSMutableArray()
        self.arrayOfMoods = NSMutableArray()
        self.arrayOfCount1 = NSMutableArray()
        self.arrayOfCount1 = json["switches"]
        self.arrayOfCount2 = NSMutableArray()
        self.arrayOfCount2 = json["moods"]

        for i in 0 ..< (self.arrayOfCount1! as AnyObject).count {
            
            switches = Switches().initwithJson(json: (self.arrayOfCount1 as AnyObject).object(at: i) as! [String : Any])
            (arrayOfSwitches as AnyObject).add(switches as Any)
        }


        for j in 0 ..< (self.arrayOfCount2! as AnyObject).count {
            
            moods = Moods().initwithJson(json: (self.arrayOfCount2 as AnyObject).object(at: j) as! [String : Any])
            (arrayOfMoods as AnyObject).add(moods as Any)
        }
        return self
    }

}
