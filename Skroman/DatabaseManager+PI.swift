//
//  DatabaseManager+Activity.swift
//  CalenderApp
//
//  Created by Pradip Parkhe on 2/26/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import FMDB



extension DatabaseManager {
    
    //MARK:- Directory Database Methods
    func addPIDAndSSID (pid : String, ssid : String , password : String){
        
        var is_present = false
        dbQueue?.inTransaction { db, rollback in
            do {
                
                let rs = try db.executeQuery("SELECT * from pi where ppid=?", values: [pid])
                
                if rs.next() {
                    is_present = true
                }
                
                if(!is_present)
                {
                    try db.executeUpdate("INSERT INTO pi(ppid,ssid,password) VALUES (?,?,?)", values: [pid,ssid,password])
                }
                else{
                    try db.executeUpdate("update pi set ssid=?,password=? where ppid=?", values: [ssid,password,pid])
                    
                }
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
    }
    
    func deletePIWIthSSID(ssid: String){
        dbQueue?.inTransaction { db, rollback in
            do {
                try db.executeUpdate("delete from pi where ssid=?", values: [ssid])
            } catch {
                rollback.pointee = true
            }
        }
    }
    
    func getPI(piid:String) -> PI
    {
        let objPI =  PI()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT * from pi where ppid=?", values: [piid])
                
                if rs.next() {
                    
                    objPI.lid = rs.long(forColumn: "lid")
                    objPI.pi_id = rs.string(forColumn: "ppid")
                    objPI.ssid = rs.string(forColumn: "ssid")!
                    objPI.password = rs.string(forColumn: "password")!
                    
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return objPI
    }
    
    
    func getAllPIs() -> NSMutableArray
    {
        let arrPIs =  NSMutableArray()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT * from pi", values:nil)
                
                while rs.next() {
                    let objPI = PI()
                    objPI.lid = rs.long(forColumn: "ppid")
                    objPI.pi_id = rs.string(forColumn: "ppid")
                    objPI.ssid = rs.string(forColumn: "ssid")!
                    objPI.password = rs.string(forColumn: "password")!
                    arrPIs.add(objPI)
                    
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return arrPIs
    }
    
    func deleteAndSyncData(objSyncData : SyncData)
    {
        if((objSyncData.syncData?.count)!>0)
        {
            for objHome in objSyncData.syncData!
            {
                // so if and only if we have valid response
                
                //1. get all room if for that home and keep it in array it will usefull for to clear switch box table
                
                //2. delete all switchs for room which gets in step 1
                
                //3. delete all switchbox for room which gets in step 1
                
                //4. delete all table data where home_id(s) = home_id
                
                let room_ids = DatabaseManager.sharedInstance().getAllRoomIDsWithHomeID(home_id: objHome.home_id!)
                
                let switchbox_ids  =  DatabaseManager.sharedInstance().getAllSwitchBoxesIdsWithRoomID(room_ids: room_ids.componentsJoined(by: ","))
                
                
                DatabaseManager.sharedInstance().deleteAllMoodWithHomeId(home_id: objHome.home_id!)
                
                DatabaseManager.sharedInstance().deleteSwitchWithSwitchsBoxSwitchID(switchbox_ids: switchbox_ids.componentsJoined(by: ","))
                
                DatabaseManager.sharedInstance().deleteSwithBoxDeviceWithSwitchBoxIDs(switchbox_ids: switchbox_ids.componentsJoined(by: ","))
                DatabaseManager.sharedInstance().deleteRoomWithRoomIDs(room_ids: room_ids.componentsJoined(by: ","))
                
                DatabaseManager.sharedInstance().deleteHomeWithHomeId(home_id: objHome.home_id!)
                
                
                
                let isAlreadyHaveDefaultHome = DatabaseManager.sharedInstance().isAlreadyHaveDefaultHome()
                //insert all data in database
                dbQueue?.inTransaction { db, rollback in
                    
                    do {
                        // insert home
                        try db.executeUpdate("INSERT INTO home(home_name,home_id,pi_id,is_default)  VALUES (?,?,?,?)", values: [objHome.home_name ?? "",objHome.home_id ?? "" ,objHome.pi_id ?? "",!isAlreadyHaveDefaultHome])
                        
                        
                        //insert rooms
                        try objHome.rooms?.forEach({ (objRoom) in
                            try  db.executeUpdate("INSERT INTO room(room_id,room_name,home_id,image) VALUES (?,?,?,?)", values: [objRoom.room_id ?? "",objRoom.room_name ?? "",objRoom.home_id ?? "",objRoom.image ?? "room_1"])
                            print("Error \(db.lastError())")
                            //insert switchboxes
                            try objRoom.switchboxes?.forEach({ (objSwitchBox) in
                                try db.executeUpdate("INSERT INTO switchbox(room_id,name,switchbox_id,mac_address,child_lock) VALUES (?,?,?,?,?)", values: [objSwitchBox.room_id ?? "",objSwitchBox.name ??  "",objSwitchBox.switchbox_id ?? "",objSwitchBox.mac_address ?? "",objSwitchBox.child_lock! ])
                                
                                //insert switches
                                try objSwitchBox.switches?.forEach({ (objSwitch) in
                                    
                                    //                               try db.executeUpdate("INSERT INTO switch(switchbox_id,switch_id,type,status,position,master_mode_status) VALUES (?,?,?,?,?,?)", values:[objSwitch.switchbox_id ?? "",objSwitch.switch_id! ,objSwitch.type ?? 0,objSwitch.status ?? 0,objSwitch.position ?? 0,objSwitch.master_mode_status ?? 0])
                                    let switchIcon = objSwitch.switch_icon ?? "\(String(format: "type_%@_1","\(objSwitch.type ?? 0 )"))"
                                    
                                    
                                    try db.executeUpdate("INSERT INTO switch(switchbox_id,switch_id,type,status,position,master_mode_status,switch_name,switch_icon,wattage) VALUES (?,?,?,?,?,?,?,?,?)", values:[objSwitch.switchbox_id ?? "",objSwitch.switch_id! ,objSwitch.type ?? 0,objSwitch.status ?? 0,                                                                                                                                                                                                      objSwitch.position ?? 0,objSwitch.master_mode_status ?? 0,                                                                                                                                                                                                      objSwitch.switch_name ?? "",switchIcon,objSwitch.wattage ?? 0])
                                })
                                
                                //insert moods
                                try objSwitchBox.moods?.forEach({ (objMood) in
                                    try db.executeUpdate("INSERT INTO mood(mood_id,mood_name,switchbox_id,home_id,switch_id,mood_type,status,position,mood_repeat,mood_time,mood_status) VALUES (?,?,?,?,?,?,?,?,?,?,?)", values: [objMood.mood_id ?? "",objMood.mood_name ?? "",objMood.switchbox_id ?? "",objMood.home_id ?? "",objMood.switch_id!,objMood.mood_type,objMood.status,objMood.position,objMood.mood_repeat ,objMood.mood_time ?? "",objMood.mood_status])
                                })
                            })
                        })
                    } catch {
                        rollback.pointee = true
                    }
                }
            }
        }
    }
    
    
    func deleteBeforeSync(objSyncData : SyncData)
    {
        if((objSyncData.syncData?.count)!>0)
        {
            for objHome in objSyncData.syncData!
            {
                let room_ids = DatabaseManager.sharedInstance().getAllRoomIDsWithHomeID(home_id: objHome.home_id!)
                
                let switchbox_ids  =  DatabaseManager.sharedInstance().getAllSwitchBoxesIdsWithRoomID(room_ids: room_ids.componentsJoined(by: ","))
                
                
                //            Delete Mood
                //            Delete SwitchBoxes
                //            Delete SwitchBox
                //            Delete Home
                
                
                DatabaseManager.sharedInstance().deleteAllMoodWithHomeId(home_id: objHome.home_id!)
                
                DatabaseManager.sharedInstance().deleteSwitchWithSwitchsBoxSwitchID(switchbox_ids: switchbox_ids.componentsJoined(by: ","))
                
                DatabaseManager.sharedInstance().deleteSwithBoxDeviceWithSwitchBoxIDs(switchbox_ids: switchbox_ids.componentsJoined(by: ","))
                
                DatabaseManager.sharedInstance().deleteRoomWithRoomIDs(room_ids: room_ids.componentsJoined(by: ","))
                
                DatabaseManager.sharedInstance().deleteHomeWithHomeId(home_id: objHome.home_id!)
            }
        }
    }
    
    
    func syncDataFormleftMenu(objSyncData : SyncData)
    { 
        if((objSyncData.syncData?.count)!>0)
        {
            self.deleteBeforeSync(objSyncData: objSyncData)
            
            for objHome in objSyncData.syncData!
            {
                let isAlreadyHaveDefaultHome = DatabaseManager.sharedInstance().isAlreadyHaveDefaultHome()
                //insert all data in database
                dbQueue?.inTransaction { db, rollback in
                    
                    do {
                        // insert home
                        try db.executeUpdate("INSERT INTO home(home_name,home_id,pi_id,is_default)  VALUES (?,?,?,?)", values: [objHome.home_name ?? "",objHome.home_id ?? "" ,VVBaseUserDefaults.getCurrentPIID(),!isAlreadyHaveDefaultHome])
                        
                        
                        //insert rooms
                        try objHome.rooms?.forEach({ (objRoom) in
                            //checkRoomIDExistsInHome
                            var count = 0
                            let rs = try db.executeQuery("SELECT count(*) as h_count from room where room_id=?", values:[objRoom.room_id!])
                            
                            if rs.next() {
                                count = rs.long(forColumn: "h_count")
                            }
                            
                            if(count>0)
                            {
                                //Update room name only
                                try db.executeUpdate("update room set room_name=? where room_id=? and home_id=?", values: [objRoom.room_name!,objRoom.room_id!,objRoom.home_id!])
                                //                            DatabaseManager.sharedInstance().updateRoomName(obj: objRoom)
                            }
                            else
                            {
                                //Insert
                                try db.executeUpdate("INSERT INTO room(room_id,room_name,home_id,image) VALUES (?,?,?,?)", values: [objRoom.room_id ?? "",objRoom.room_name ?? "",objRoom.home_id ?? "",objRoom.image ?? "room_1"])
                            }
                            
                            //insert switchboxes
                            try objRoom.switchboxes?.forEach({ (objSwitchBox) in
                                try db.executeUpdate("INSERT INTO switchbox(room_id,name,switchbox_id,mac_address,child_lock) VALUES (?,?,?,?,?)", values: [objSwitchBox.room_id ?? "",objSwitchBox.name ??  "",objSwitchBox.switchbox_id ?? "",objSwitchBox.mac_address ?? "",objSwitchBox.child_lock! ])
                                
                                //insert switches
                                try objSwitchBox.switches?.forEach({ (objSwitch) in
                                    
                                    //check
                                    var count = 0
                                    let rs = try db.executeQuery("SELECT count(*) as h_count from switch where switch_id=? and switchbox_id=?", values:[objSwitch.switch_id!,objSwitch.switchbox_id!])
                                    
                                    if rs.next() {
                                        
                                        count = rs.long(forColumn: "h_count")
                                        
                                    }
                                    
                                    if(count>0)
                                    {
                                        try db.executeUpdate("update switch set type=?, status=?, position=?,master_mode_status=? where switch_id=? and switchbox_id=?", values: [objSwitch.type!, objSwitch.status ?? 0, objSwitch.position ?? 0, objSwitch.master_mode_status ?? 0, objSwitch.switch_id!, objSwitch.switchbox_id!])
                                    }
                                    else
                                    {
                                        let switchIcon = objSwitch.switch_icon ?? "\(String(format: "type_%@_1","\(objSwitch.type ?? 0 )"))"
                                        
                                        //                                    //Insert
                                        try db.executeUpdate("INSERT INTO switch(switchbox_id,switch_id,type,status,position,master_mode_status,switch_name,switch_icon,wattage) VALUES (?,?,?,?,?,?,?,?,?)", values:[objSwitch.switchbox_id ?? "",objSwitch.switch_id! ,objSwitch.type ?? 0,objSwitch.status ?? 0,objSwitch.position ?? 0,objSwitch.master_mode_status ?? 0,objSwitch.switch_name ?? "",switchIcon,objSwitch.wattage ?? 0])
                                        
                                    }
                                    
                                })
                                
                                //insert moods
                                try objSwitchBox.moods?.forEach({ (objMood) in
                                    try db.executeUpdate("INSERT INTO mood(mood_id,mood_name,switchbox_id,home_id,switch_id,mood_type,status,position,mood_repeat,mood_time,mood_status) VALUES (?,?,?,?,?,?,?,?,?,?,?)", values: [objMood.mood_id ?? "",objMood.mood_name ?? "",objMood.switchbox_id ?? "",objMood.home_id ?? "",objMood.switch_id!,objMood.mood_type,objMood.status,objMood.position,objMood.mood_repeat ,objMood.mood_time ?? "",objMood.mood_status])
                                })
                            })
                        })
                    } catch {
                        rollback.pointee = true
                    }
                }
            }
        }
    }
    
    
    func deleteAllTableData()
    {
        dbQueue?.inTransaction { db, rollback in
            do {
                try db.executeUpdate("DELETE FROM pi", values: nil)
                try db.executeUpdate("DELETE FROM home", values: nil)
                try db.executeUpdate("DELETE FROM mood", values: nil)
                try db.executeUpdate("DELETE FROM room", values: nil)
                try db.executeUpdate("DELETE FROM switch", values: nil)
                try db.executeUpdate("DELETE FROM switchbox", values: nil)
                try db.executeUpdate("DELETE FROM energydata", values: nil)
                try db.executeUpdate("DELETE FROM user", values: nil)
            } catch {
                rollback.pointee = true
            }
        }
    }
}

