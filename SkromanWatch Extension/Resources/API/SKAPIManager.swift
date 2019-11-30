//
//  SKAPIManager.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 10/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import WatchKit



class SKAPIManager: NSObject {
    
    
    
    class func sharedInstance() -> SKAPIManager {
        
        var sharedInstance: SKAPIManager {
            struct Static {
                static let instance = SKAPIManager()
            }
            return Static.instance
        }
        return sharedInstance
    }

    
    
     func sendRemoteAccess(flag: Bool) {
        
        let dictonary: NSMutableDictionary = NSMutableDictionary()
        dictonary.setValue(flag, forKey: "remote_access")
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SendToMqttViaiPhone), object: nil, userInfo: dictonary as? [AnyHashable : Any])

    }
    
    
    
     func sendChildLock(dictonary: NSMutableDictionary) {
        
        let publishTopic = NSString(format:"%@/%@/%@", SKDatabase.getServerId(),SKDatabase.getHomeId(),PUBLISH_Child_Mode_App_To_Rpi)
        let subscribeTopic = NSString(format:"%@/%@/%@", SKDatabase.getServerId(),SKDatabase.getHomeId(),SUBSCRIBE_Child_Mode_Feedback)
        
        dictonary.setValue(publishTopic, forKey: "publishTopic")
        dictonary.setValue(subscribeTopic, forKey: "subscribeTopic")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SendToMqttViaiPhone), object: nil, userInfo: dictonary as? [AnyHashable : Any])
    }
    
    
    
     func sendDeleteMode(dictonary: NSMutableDictionary) {
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SendToMqttViaiPhone), object: nil, userInfo: dictonary as? [AnyHashable : Any])
    }
    
    
    
     func sendSwitchStatus(dictonary: NSMutableDictionary) {

        let publishTopic = NSString(format:"%@/%@/%@", SKDatabase.getServerId(),SKDatabase.getHomeId(),PUBLISH_UPDATE_SWITCH)
        let subscribeTopic = NSString(format:"%@/%@/%@", SKDatabase.getServerId(),SKDatabase.getHomeId(),SUBSCRIBE_UPDATE_SWITCH)
        
        dictonary.setValue(publishTopic, forKey: "publishTopic")
        dictonary.setValue(subscribeTopic, forKey: "subscribeTopic")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SendToMqttViaiPhone), object: nil, userInfo: dictonary as? [AnyHashable : Any])
    }
    
    
    
     func sendMasterMode(dictonary: NSMutableDictionary) {
        
        let publishTopic = NSString(format:"%@/%@/%@", SKDatabase.getServerId(),SKDatabase.getHomeId(),PUBLISH_Master_Mode_App_To_Rpi)
        let subscribeTopic = NSString(format:"%@/%@/%@", SKDatabase.getServerId(),SKDatabase.getHomeId(),SUBSCRIBE_Master_Mode_Feedback)
        
        dictonary.setValue(publishTopic, forKey: "publishTopic")
        dictonary.setValue(subscribeTopic, forKey: "subscribeTopic")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SendToMqttViaiPhone), object: nil, userInfo: dictonary as? [AnyHashable : Any])
    }
    
    
    
     func sendMasterSwitch(dictonary: NSMutableDictionary) {
        
        let publishTopic = NSString(format:"%@/%@/%@", SKDatabase.getServerId(),SKDatabase.getHomeId(),PUBLISH_UPDATE_SWITCH)
        let subscribeTopic = NSString(format:"%@/%@/%@", SKDatabase.getServerId(),SKDatabase.getHomeId(),SUBSCRIBE_UPDATE_SWITCH)
        
        dictonary.setValue(publishTopic, forKey: "publishTopic")
        dictonary.setValue(subscribeTopic, forKey: "subscribeTopic")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SendToMqttViaiPhone), object: nil, userInfo: dictonary as? [AnyHashable : Any])
    }

    
    func getUserInfo(dictonary: NSDictionary) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SendToMqttViaiPhone), object: nil, userInfo: dictonary as? [AnyHashable : Any])
    }

    
     func sendHardwareMood(dictonary: NSMutableDictionary) {
        
        let publishTopic = NSString(format:"%@/%@/%@", SKDatabase.getServerId(),SKDatabase.getHomeId(),PUBLISH_Hardware_Mood_Trigger)
        let subscribeTopic = NSString(format:"%@/%@/%@", SKDatabase.getServerId(),SKDatabase.getHomeId(),SUBSCRIBE_Hardware_Mood_Feedback)
        
        dictonary.setValue(publishTopic, forKey: "publishTopic")
        dictonary.setValue(subscribeTopic, forKey: "subscribeTopic")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SendToMqttViaiPhone), object: nil, userInfo: dictonary as? [AnyHashable : Any])
    }
}
