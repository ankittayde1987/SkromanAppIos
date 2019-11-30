//
//  Moods.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 11/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import WatchKit

class Moods: NSObject {
    
    var switchbox_id : String?
    var home_id : String?
    var mood_id : String?
    var switch_id : Int?
    var mood_type : Int?
    var status : Int?
    var position : Int?
    var mood_time : String?
    var mood_status : Int?
    var mood_name : String?

    var arrayOfCount : NSArray?
    var arrayOfMoodRepeat : NSMutableArray?
    
    
    func initwithJson(json: [String: Any]) -> Moods{
        
        self.switchbox_id = json["switchbox_id"] as? String ?? ""
        self.home_id = json["home_id"] as? String ?? ""
        self.mood_id = json["mood_id"] as? String ?? ""
        self.switch_id = (json["switch_id"] as! Int)
        self.mood_type = (json["mood_type"] as! Int)
        self.status = (json["status"] as! Int)
        self.position = (json["position"] as! Int)
        self.mood_time = json["mood_time"] as? String ?? ""
        self.mood_status = (json["mood_status"] as! Int)
        self.mood_name = json["mood_name"] as? String ?? ""
        self.arrayOfMoodRepeat = NSMutableArray()
        self.arrayOfCount = NSArray()
        self.arrayOfCount = json["mood_repeat"] as? NSArray ?? []
        
//        for i in 0 ..< self.arrayOfCount!.count {
            
//            arrayOfMoodRepeat?.add(self.arrayOfCount?.object(at: i) as! [String : Any] as Any)
//        }
        return self
    }
}

    
    
    
