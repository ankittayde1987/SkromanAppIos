//
//  SyncData.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 11/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import WatchKit

class SyncData: NSObject {

    var pi_id : String?
    var user_id : String?
    var arrayOfCount : NSArray?
    var arrayOfHomes : NSMutableArray?
    var home : Home?

    
    func initwithJson(json: [String: Any]) -> SyncData{
        
               self.pi_id = json["pi_id"] as? String ?? ""
             self.user_id = json["user_id"] as? String ?? ""
        self.arrayOfHomes = NSMutableArray()
        self.arrayOfCount = NSArray()
        self.arrayOfCount = json["syncData"] as? NSArray ?? []
        
        for i in 0 ..< self.arrayOfCount!.count {

            home = Home().initwithJson(json: self.arrayOfCount?.object(at: i) as! [String : Any])
            arrayOfHomes?.add(home as Any)
        }
        return self
    }

    
    func initwithHomeJson(json: [String: Any]) -> SyncData{
        
        self.pi_id = json["pi_id"] as? String ?? ""
        self.user_id = json["user_id"] as? String ?? ""
        self.arrayOfHomes = NSMutableArray()
        self.arrayOfCount = NSArray()
        self.arrayOfCount = json["syncData"] as? NSArray ?? []
        
        for i in 0 ..< self.arrayOfCount!.count {
            
            arrayOfHomes?.add(self.arrayOfCount?.object(at: i) as! [String : Any])
        }
        return self
    }

}
