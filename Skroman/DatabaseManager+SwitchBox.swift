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
    /*  var sbid : Int
     var room_id : String?
     var name : String?
     var switchbox_id : String?
     var mac_address : String?
     var child_lock : Int
     var switches : [Switch]?
     var moods : [Mood]?
     
     */
    
    //MARK:- Directory Database Methods
    func addSwitchBoxDevice(objDevice:SwitchBox){
       dbQueue?.inTransaction { db, rollback in
            do {
               
                try db.executeUpdate("INSERT INTO switchbox(room_id,name,switchbox_id,mac_address,child_lock) VALUES (?,?,?,?,?)", values: [objDevice.room_id ?? "",objDevice.name ??  "",objDevice.switchbox_id ?? "",objDevice.mac_address ?? "",objDevice.child_lock! ])
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
    }
    
    func deleteSwithBoxDeviceWithSwitchBoxID(switchbox_id: String){
        dbQueue?.inTransaction { db, rollback in
            do {
                try db.executeUpdate("delete from switchbox where switchbox_id=?", values: [switchbox_id])
            } catch {
                rollback.pointee = true
            }
        }
    }
    func deleteSwithBoxDeviceWithSwitchBoxIDs(switchbox_ids: String){
        dbQueue?.inTransaction { db, rollback in
            do {
                try db.executeUpdate("delete from switchbox where switchbox_id in (\(switchbox_ids))", values: nil)
            } catch {
                rollback.pointee = true
            }
        }
    }
    func getSwithBoxDeviceWithSwitchBoxID(switchbox_id: String) -> SwitchBox
    {
        let objSwitchbox =  SwitchBox()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT * from switchbox where switchbox_id=?", values: [switchbox_id])
                
                if rs.next() {
                    objSwitchbox.sbid = rs.long(forColumn: "sbid")
                    
                    objSwitchbox.name = rs.string(forColumn: "name")
                    
                    objSwitchbox.room_id = rs.string(forColumn: "room_id")
                   
                    objSwitchbox.switchbox_id = rs.string(forColumn: "switchbox_id")
                    
                    objSwitchbox.mac_address = rs.string(forColumn: "mac_address")
                    
                    objSwitchbox.child_lock = rs.long(forColumn: "child_lock")
                    
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return objSwitchbox
    }
    
    
    func getAllSwitchBoxesWithRoomID(room_id : String) -> NSMutableArray
    {
        let arrSwitchDevices =  NSMutableArray()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT *  from switchbox where room_id=?", values:[room_id])
                
                while rs.next() {
                    let objSwitchbox = SwitchBox()
                    objSwitchbox.sbid = rs.long(forColumn: "sbid")
                    
                    objSwitchbox.name = rs.string(forColumn: "name")
                    
                    objSwitchbox.room_id = rs.string(forColumn: "room_id")
                    
                    objSwitchbox.switchbox_id = rs.string(forColumn: "switchbox_id")
                    
                    objSwitchbox.mac_address = rs.string(forColumn: "mac_address")
                    
                    objSwitchbox.child_lock = rs.long(forColumn: "child_lock")
					//Remove Order by Position
//					let rs1 = try db.executeQuery("SELECT * from switch  where switchbox_id =? order by position asc", values:[objSwitchbox.switchbox_id ?? ""])
					let rs1 = try db.executeQuery("SELECT * from switch  where switchbox_id =?", values:[objSwitchbox.switchbox_id ?? ""])
					
					while rs1.next() {
						let objSwitch = Switch()
						objSwitch.swid = rs1.long(forColumn: "swid")
						objSwitch.switch_id = rs1.long(forColumn: "switch_id")
						objSwitch.switchbox_id = rs1.string(forColumn: "switchbox_id")
						objSwitch.type = rs1.long(forColumn: "type")
						objSwitch.status = rs1.long(forColumn: "status")
						objSwitch.position = rs1.long(forColumn: "position")
						objSwitch.master_mode_status = rs1.long(forColumn: "master_mode_status")
						objSwitch.switch_name = rs1.string(forColumn: "switch_name")
						objSwitch.switch_icon = rs1.string(forColumn: "switch_icon")
                        objSwitch.wattage = rs1.double(forColumn: "wattage")
						objSwitchbox.switches?.append(objSwitch)
						
					}
				
					arrSwitchDevices.add(objSwitchbox)
                    
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return arrSwitchDevices
    }
	
	
	//Added For SwitchBoxes For Mood Settings
	func getAllSwitchBoxesWithRoomIDForMoodSettings(room_id : String, mood_id: String, switchbox_id: String, comeFrom: MoodSettingsMainContainerViewControllerComeFrom,moodTypeForHomeOrDevice : Int) -> NSMutableArray
	{
		let arrSwitchDevices =  NSMutableArray()
		dbQueue?.inTransaction { db, rollback in
			do {
                var rs = try db.executeQuery("SELECT *  from switchbox where room_id=?", values:[room_id])
                if moodTypeForHomeOrDevice == MOOD_TYPE_DEVICE
                {
                    rs = try db.executeQuery("SELECT *  from switchbox where room_id=? and switchbox_id=?", values:[room_id,switchbox_id])
                }
				
				
				while rs.next() {
					let objSwitchbox = SwitchBox()
					objSwitchbox.sbid = rs.long(forColumn: "sbid")
					
					objSwitchbox.name = rs.string(forColumn: "name")
					
					objSwitchbox.room_id = rs.string(forColumn: "room_id")
					
					objSwitchbox.switchbox_id = rs.string(forColumn: "switchbox_id")
					
					objSwitchbox.mac_address = rs.string(forColumn: "mac_address")
					
					objSwitchbox.child_lock = rs.long(forColumn: "child_lock")
					

					
					var rs1 = try db.executeQuery("SELECT *, s.switch_id as s_switch_id, s.position as s_position  from switch s where s.switchbox_id =?", values:[objSwitchbox.switchbox_id ?? ""])
					if comeFrom == .editHomeMood
					{
                        //OLD QUERY
//                        rs1 = try db.executeQuery("SELECT *, s.switch_id as s_switch_id, m.position as s_position  from switch s left join mood m on(s.switchbox_id=m.switchbox_id and s.switch_id=m.switch_id and m.mood_type=?)where s.switchbox_id =? and m.mood_id=?", values:[moodTypeForHomeOrDevice,objSwitchbox.switchbox_id ?? "",mood_id])
                        
                        
                        //SELECT *, s.switch_id as s_switch_id, m.position as s_position  from switch s left join mood m on(s.switchbox_id=m.switchbox_id and s.switch_id=m.switch_id and m.mood_type= 1 and m.mood_id= 'HM-90540_MOOD_1')  where s.switchbox_id ='SB-AA7B'  and s.type!=2
                        
                        //UPDATED QUERY
                        rs1 = try db.executeQuery("SELECT *, s.switch_id as s_switch_id, m.position as s_position  from switch s left join mood m on(s.switchbox_id=m.switchbox_id and s.switch_id=m.switch_id and m.mood_type= ? and m.mood_id= ?)  where s.switchbox_id = ?  and s.type!= 2", values:[moodTypeForHomeOrDevice,mood_id,objSwitchbox.switchbox_id ?? ""])
					}
					while rs1.next() {
						let objMood = Mood()
						objMood.switch_id = rs1.long(forColumn: "s_switch_id")
						objMood.switchbox_id = rs1.string(forColumn: "switchbox_id")
						objMood.type = rs1.long(forColumn: "type")
						objMood.switch_name = rs1.string(forColumn: "switch_name")
						objMood.switch_icon = rs1.string(forColumn: "switch_icon")
						objMood.mood_time = rs1.string(forColumn: "mood_time")
						if comeFrom == .addNewHomeMood
						{
							objMood.status = 0
							objMood.position = 0
						}
						else
						{
							objMood.status = rs1.long(forColumn: "status")
							objMood.position = rs1.long(forColumn: "s_position")
						}

						objSwitchbox.moods?.append(objMood)
					}
					
					arrSwitchDevices.add(objSwitchbox)
					
				}
				
			} catch _ as NSError  {
				rollback.pointee = true
			}
		}
		return arrSwitchDevices
	}
    func getAllSwitchBoxesIdsWithRoomID(room_ids : String) -> NSMutableArray
    {
        let arrSwitchDevices =  NSMutableArray()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT * from  switchbox where room_id IN (\(room_ids))", values:nil)
                
                while rs.next() {
                    
                    if(rs.string(forColumn: "switchbox_id") != nil)
                    {
                        arrSwitchDevices.add(String(format : "'%@'",rs.string(forColumn: "switchbox_id") ?? ""))
                    }
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return arrSwitchDevices
    }
	
	func updateSwitchBoxName(switchboxNew_name: String,switchbox_id:String) {
		dbQueue?.inTransaction { db, rollback in
			do {
				try db.executeUpdate("update switchbox set name=? where switchbox_id=?", values: [switchboxNew_name,switchbox_id])
			} catch let error as NSError  {
				SSLog(message:error)
				rollback.pointee = true
			}
		}
	}
	
	func updateSwitchBoxChildLockStatus(child_lock: String,switchbox_id:String) {
		dbQueue?.inTransaction { db, rollback in
			do {
				try db.executeUpdate("update switchbox set child_lock=? where switchbox_id=?", values: [child_lock,switchbox_id])
			} catch let error as NSError  {
				SSLog(message:error)
				rollback.pointee = true
			}
		}
	}
    
    
    
    
    func getSwitBoxForIPad(switchBox_id : String) -> SwitchBox
    {
        let objSwitchbox = SwitchBox()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT * from switchbox where switchbox_id=?", values: [switchBox_id])
                
                while rs.next() {
                    objSwitchbox.sbid = rs.long(forColumn: "sbid")
                    
                    objSwitchbox.name = rs.string(forColumn: "name")
                    
                    objSwitchbox.room_id = rs.string(forColumn: "room_id")
                    
                    objSwitchbox.switchbox_id = rs.string(forColumn: "switchbox_id")
                    
                    objSwitchbox.mac_address = rs.string(forColumn: "mac_address")
                    
                    objSwitchbox.child_lock = rs.long(forColumn: "child_lock")
                    //Remove Order by Position
                    //                    let rs1 = try db.executeQuery("SELECT * from switch  where switchbox_id =? order by position asc", values:[objSwitchbox.switchbox_id ?? ""])
                    let rs1 = try db.executeQuery("SELECT * from switch  where switchbox_id =?", values:[objSwitchbox.switchbox_id ?? ""])
                    
                    while rs1.next() {
                        let objSwitch = Switch()
                        objSwitch.swid = rs1.long(forColumn: "swid")
                        objSwitch.switch_id = rs1.long(forColumn: "switch_id")
                        objSwitch.switchbox_id = rs1.string(forColumn: "switchbox_id")
                        objSwitch.type = rs1.long(forColumn: "type")
                        objSwitch.status = rs1.long(forColumn: "status")
                        objSwitch.position = rs1.long(forColumn: "position")
                        objSwitch.master_mode_status = rs1.long(forColumn: "master_mode_status")
                        objSwitch.switch_name = rs1.string(forColumn: "switch_name")
                        objSwitch.switch_icon = rs1.string(forColumn: "switch_icon")
                        objSwitchbox.switches?.append(objSwitch)
                        
                    }
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return objSwitchbox
    }
    
    
    
    
    
    
    
    
    
    
    func insertSwitchBoxAfterAdded(obj : SwitchBox)
    {
      
        dbQueue?.inTransaction { db, rollback in
            do {
                try db.executeUpdate("INSERT INTO switchbox(room_id,name,switchbox_id,mac_address,child_lock) VALUES (?,?,?,?,?)", values: [obj.room_id ?? "",obj.name ??  "",obj.switchbox_id ?? "",obj.mac_address ?? "",obj.child_lock ?? 0])
                
                //insert switches
                try obj.switches?.forEach({ (objSwitch) in
                    
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
                try obj.moods?.forEach({ (objMood) in
                    try db.executeUpdate("INSERT INTO mood(mood_id,mood_name,switchbox_id,home_id,switch_id,mood_type,status,position,mood_repeat,mood_time,mood_status) VALUES (?,?,?,?,?,?,?,?,?,?,?)", values: [objMood.mood_id ?? "",objMood.mood_name ?? "",objMood.switchbox_id ?? "",objMood.home_id ?? "",objMood.switch_id!,objMood.mood_type,objMood.status,objMood.position,objMood.mood_repeat ,objMood.mood_time ?? "",objMood.mood_status])
                })
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
    }
    
    
    
    
    
    func isSwitchBoxPresentInRoom(strRoomId : String)->Bool
    {
        var count = 0
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT count(*) as h_count from switchbox where room_id=?", values:[strRoomId])
                
                if rs.next() {
                    
                    count = rs.long(forColumn: "h_count")
                    
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        if(count>0)
        {
            return true
            
        }
        else
        {
            return false
        }
    }
}

