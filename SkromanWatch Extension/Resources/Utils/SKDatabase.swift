//
//  SKDatabase.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 10/09/19.
//  Copyright © 2019 admin. All rights reserved.
//


let SERVERID     = "serverid"
let USERID     = "userid"
let HOMEID       = "homeid"
let ROOMID       = "roomid"
let REMOTEACCESS = "remoteaccess"
let SWITCHBOXID  = "switchboxid"
let JSON         = "json"
let USER         = "user"
let CHILDLOCK    = "childlock"

let SWITCHBOXE  = "switchboxes"
let SWITCHE     = "switches"
let SELECTEDSWITCH     = "selectedswitch"




import WatchKit

class SKDatabase: NSObject {
    
    
    /* User Information */
    
    
    class func saveUserInformation(user: NSDictionary) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(user, forKey: USER)
        defaults.synchronize()
    }

    
    class func getUserInformation() ->NSMutableDictionary {
        let defaults: UserDefaults = UserDefaults.standard
        let loadedValue = defaults.dictionary(forKey: USER)

        if loadedValue == nil {
            let emptyJson = NSMutableDictionary()
            return emptyJson
        }
        else{
            let json = NSMutableDictionary(dictionary: loadedValue!)
            return json
        }
    }

    
    /* Home Id */

    
   class func saveHomeId(homeId: String) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(homeId, forKey: HOMEID)
        defaults.synchronize()
    }
    
    
   class func getHomeId() ->String {
        let defaults: UserDefaults = UserDefaults.standard
        let homeId = defaults.object(forKey: HOMEID)
    
        if homeId == nil {
            return ""
        }
        else{
            return homeId as! String
        }
    }
    
    
    /* Remote Access */
    
    
   class func saveRemoteAccess(flag: Bool) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(flag, forKey: REMOTEACCESS)
        defaults.synchronize()
    }

    
   class func getRemoteAccess() ->Bool {
        let defaults: UserDefaults = UserDefaults.standard
        var flag = defaults.object(forKey: REMOTEACCESS)
    
        if flag == nil{
            flag = false
        }
        return flag as! Bool
    }

    
    /* Server Id */


   class func saveServerId(serverId: String) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(serverId, forKey: SERVERID)
        defaults.synchronize()
    }
    
    
   class func getServerId() ->String {
        let defaults: UserDefaults = UserDefaults.standard
        let serverId = defaults.object(forKey: SERVERID)
        return serverId as! String
    }
    
    
    /* User Id */
    
    
    class func saveUserId(userId: String) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(userId, forKey: USERID)
        defaults.synchronize()
    }
    
    
    class func getUserId() ->String {
        let defaults: UserDefaults = UserDefaults.standard
        let userId = defaults.object(forKey: USERID)
        return userId as! String
    }
    

    /* Room Id */
    
    
    class func saveRoomId(roomId: String) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(roomId, forKey: ROOMID)
        defaults.synchronize()
    }
    
    
    class func getRoomId() ->String {
        let defaults: UserDefaults = UserDefaults.standard
        let roomId = defaults.object(forKey: ROOMID)
        return roomId as! String
    }
    
    
    /* SwitchBox Id */
    
    
    class func saveSwitchBoxId(switchBoxId: String) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(switchBoxId, forKey: SWITCHBOXID)
        defaults.synchronize()
    }
    
    
    class func getSwitchBoxId() ->String {
        let defaults: UserDefaults = UserDefaults.standard
        let switchBoxId = defaults.object(forKey: SWITCHBOXID)
        return switchBoxId as! String
    }

    
    /* JSON */

    
    class func saveJson(json: NSDictionary) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(json, forKey: JSON)
        defaults.synchronize()
    }
    
    
    class func getJson() ->NSMutableDictionary {
        let defaults: UserDefaults = UserDefaults.standard
        let loadedValue = defaults.dictionary(forKey: JSON)

        if loadedValue == nil {
            let emptyJson = NSMutableDictionary()
            return emptyJson
        }
        else{
            let json = NSMutableDictionary(dictionary: loadedValue!)
            return json
        }
    }

    
    /* Child Lock */

    
    class func saveChildLock(lock: NSInteger) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(lock, forKey: CHILDLOCK)
        defaults.synchronize()
    }
    
    
    class func getChildLock() ->NSInteger {
        let defaults: UserDefaults = UserDefaults.standard
        var lock = defaults.object(forKey: CHILDLOCK)
        
        if lock == nil{
            lock = 0
        }

        return lock as! NSInteger
    }

    
    /* Get Room*/
    
    
    class func getRoom() ->Rooms {
        
        var rooms = Rooms()
        var newRooom = Rooms()
        var syncData = SyncData()
        var newHome = Home()

        
        var arrROOMS : NSArray?
        var arrHOME : NSArray?
        arrHOME = NSArray()
        
        syncData = SyncData().initwithJson(json: SKDatabase.getJson() as! [String : Any])


        arrHOME = syncData.arrayOfHomes!


        
        for x in 0 ..< arrHOME!.count {
            
            
            newHome = arrHOME![x] as! Home
            

            let homeIdVal = newHome.home_id
            let valHomeId = SKDatabase.getHomeId()
            
            if homeIdVal == valHomeId {

                
                arrROOMS = newHome.arrayOfRooms as? NSArray
                
                
                for z in 0 ..< arrROOMS!.count {
                    
                    newRooom = arrROOMS?[z] as! Rooms
                    
                    let roomIdVal = newRooom.room_id
                    let valRoomId = SKDatabase.getRoomId()
                    
                    if roomIdVal == valRoomId {

                        rooms = arrROOMS?.object(at: z) as! Rooms
                        break;
                    }
                }
            }
            break;
        }
         return rooms
    }



    
    /* Get SwitchBoxes */
    
    
    class func getSwitchBoxes() ->SwitchBoxes {

        var switchboxes = SwitchBoxes()
        
        var syncData = SyncData()
        var newHome = Home()
        var newRooom = Rooms()
        var newSwitchoxes = SwitchBoxes()
        
        var arrSWITCHBOXES : NSArray?
        var arrROOMS : NSArray?
        var arrHOME : NSArray?

        
        syncData = SyncData().initwithJson(json: SKDatabase.getJson() as! [String : Any])
        
        arrHOME = NSArray()
        arrHOME = syncData.arrayOfHomes!

        
        
        for x in 0 ..< arrHOME!.count {
            
            
            newHome = arrHOME![x] as! Home

            
            let homeIdVal = newHome.home_id
            let valHomeId = SKDatabase.getHomeId()
            
            if homeIdVal == valHomeId {
                
                arrROOMS = newHome.arrayOfRooms as? NSArray

                
                for y in 0 ..< arrROOMS!.count {
                    
                    newRooom = arrROOMS?[y] as! Rooms

                    
                    let roomIdVal = newRooom.room_id
                    let valRoomId = SKDatabase.getRoomId()
                    
                    if roomIdVal == valRoomId {
                        
                        arrSWITCHBOXES = newRooom.arrayOfSwitchboxes as? NSArray
                        
                        for z in 0 ..< arrSWITCHBOXES!.count {
                            
                            newSwitchoxes = arrSWITCHBOXES?[z] as! SwitchBoxes
                            
                            let switchboxIdVal = newSwitchoxes.switchbox_id
                            let valSwitchBoxId = SKDatabase.getSwitchBoxId()
                            
                            if switchboxIdVal == valSwitchBoxId {


                                switchboxes = arrSWITCHBOXES?.object(at: z) as! SwitchBoxes
                                break;
                        }
                    }
                }
                }
            }
        }
        return switchboxes
    }
    
}
