//
//  Home.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 11/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import WatchKit

class Home: NSObject {

    var home_name : String?
    var home_id : String?
    var arrayOfCount : Any?
    var arrayOfRooms : Any?
    var rooms : Rooms?


    func initwithJson(json: [String: Any]) -> Home{
        
           self.home_name = json["home_name"] as? String ?? ""
             self.home_id = json["home_id"] as? String ?? ""
        self.arrayOfRooms = NSMutableArray()
        self.arrayOfCount = NSMutableArray()
        self.arrayOfCount = json["rooms"]
        
        for i in 0 ..< (self.arrayOfCount! as AnyObject).count {
            
            rooms = Rooms().initwithJson(json: (self.arrayOfCount as AnyObject).object(at: i) as! [String : Any])
            (arrayOfRooms as AnyObject).add(rooms as Any)
        }
        return self
    }
    
}
