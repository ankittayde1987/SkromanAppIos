//
//  Rooms.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 11/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import WatchKit

class Rooms: NSObject {

    var home_id : String?
    var room_id : String?
    var room_name : String?

    var arrayOfCount : Any?
    var arrayOfSwitchboxes : Any?
    var switchboxes : SwitchBoxes?
    
    
    func initwithJson(json: [String: Any]) -> Rooms{
        
                   self.home_id = json["home_id"] as? String ?? ""
                   self.room_id = json["room_id"] as? String ?? ""
                 self.room_name = json["room_name"] as? String ?? ""
        self.arrayOfSwitchboxes = NSMutableArray()
              self.arrayOfCount = NSMutableArray()
              self.arrayOfCount = json["switchboxes"]
        
        if self.arrayOfCount != nil {
        for i in 0 ..< (self.arrayOfCount! as AnyObject).count {
            
            switchboxes = SwitchBoxes().initwithJson(json: (self.arrayOfCount as AnyObject).object(at: i) as! [String : Any])
            (arrayOfSwitchboxes as AnyObject).add(switchboxes as Any)
        }
    }
        return self
    }
}
