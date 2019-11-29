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
	/*var swid : Int?
	var switchbox_id : String?
	var type : Int?
	var status : Int?
	var position : Int?
	var marter_mode_status : Int?
	
	*/
	//MARK:- Directory Database Methods
	func addSwitchInSwitchBox (objSwitch : Switch){
		let switchIcon = objSwitch.switch_icon ?? "\(String(format: "type_%@_1","\(objSwitch.type ?? 0 )"))"
        //To Avoid crash on sync
        objSwitch.wattage = 0
		dbQueue?.inTransaction { db, rollback in
			do {
                try db.executeUpdate("INSERT INTO switch(switchbox_id,switch_id,type,status,position,master_mode_status,switch_name,switch_icon,wattage) VALUES (?,?,?,?,?,?,?,?,?)", values:[objSwitch.switchbox_id ?? "",objSwitch.switch_id! ,objSwitch.type ?? 0,objSwitch.status ?? 0,objSwitch.position ?? 0,objSwitch.master_mode_status ?? 0,objSwitch.switch_name ?? "",switchIcon,objSwitch.wattage ?? 0])
			} catch _ as NSError  {
				rollback.pointee = true
			}
		}
	}
	
	func deleteSwitchWithSwitchBoxSwitchID(switch_id: String){
		dbQueue?.inTransaction { db, rollback in
			do {
				try db.executeUpdate("delete from switch where switch_id=?", values: [switch_id])
			} catch {
				rollback.pointee = true
			}
		}
	}
	func deleteSwitchWithSwitchsBoxSwitchID(switchbox_ids: String){
		dbQueue?.inTransaction { db, rollback in
			do {
				try db.executeUpdate("delete from switch where switch_id in (\(switchbox_ids))", values: nil)
			} catch {
				rollback.pointee = true
			}
		}
	}
	func getSwitch(switch_id:String) -> Switch
	{
		
		let objSwitch =  Switch()
		dbQueue?.inTransaction { db, rollback in
			do {
				let rs = try db.executeQuery("SELECT * from switch where switch_id  n=?", values: [switch_id])
				
				if rs.next() {
					
					objSwitch.swid = rs.long(forColumn: "swid")
					objSwitch.switch_id = rs.long(forColumn: "switch_id")
					objSwitch.switchbox_id = rs.string(forColumn: "switchbox_id")
					objSwitch.type = rs.long(forColumn: "type")
					objSwitch.status = rs.long(forColumn: "status")
					objSwitch.position = rs.long(forColumn: "position")
					objSwitch.master_mode_status = rs.long(forColumn: "master_mode_status")
					objSwitch.switch_name = rs.string(forColumn: "switch_name")
					objSwitch.switch_icon = rs.string(forColumn: "switch_icon")
                    objSwitch.wattage = rs.double(forColumn: "wattage")
					
				}
				
			} catch _ as NSError  {
				rollback.pointee = true
			}
		}
		return objSwitch
	}
	
	
	func getAllSwitchWithSwitchBoxID(switchbox_id:String) -> NSMutableArray
	{
		let arrSwitch =  NSMutableArray()
		dbQueue?.inTransaction { db, rollback in
			do {
				let rs = try db.executeQuery("SELECT * from switch where switchbox_id=?", values:[switchbox_id])
				
				while rs.next() {
					let objSwitch = Switch()
					
					objSwitch.swid = rs.long(forColumn: "swid")
					objSwitch.switch_id = rs.long(forColumn: "switch_id")
					
					objSwitch.switchbox_id = rs.string(forColumn: "switchbox_id")
					objSwitch.type = rs.long(forColumn: "type")
					objSwitch.status = rs.long(forColumn: "status")
					objSwitch.position = rs.long(forColumn: "position")
					objSwitch.master_mode_status = rs.long(forColumn: "master_mode_status")
					objSwitch.switch_name = rs.string(forColumn: "switch_name")
					objSwitch.switch_icon = rs.string(forColumn: "switch_icon")
                    objSwitch.wattage = rs.double(forColumn: "wattage")
					arrSwitch.add(objSwitch)
					
				}
				
			} catch _ as NSError  {
				rollback.pointee = true
			}
		}
		return arrSwitch
	}
	
	func allSwitchCountWithStatus(home_id:String) -> Void{
		
		/* var dict = NSMutableDictionary()
		
		dbQueue?.inTransaction { db, rollback in
		do {
		let rs = try db.executeQuery("SELECT count(*) as s_count from switch where home_id=?", values:[home_id])
		
		if rs.next() {
		
		let objSwitch = Switch()
		
		objSwitch.swid = rs.long(forColumn: "swid")
		objSwitch.switch_id = rs.long(forColumn: "switch_id")
		
		objSwitch.switchbox_id = rs.string(forColumn: "switchbox_id")
		objSwitch.type = rs.long(forColumn: "type")
		objSwitch.status = rs.long(forColumn: "status")
		objSwitch.position = rs.long(forColumn: "position")
		objSwitch.master_mode_status = rs.long(forColumn: "master_mode_status")
		objSwitch.add(objSwitch)
		
		}
		
		} catch _ as NSError  {
		rollback.pointee = true
		}
		}
		return arrSwitch*/
		
	}
	
	
    func updateSwitchStatus(_ obj: Switch,status: Int) {
		dbQueue?.inTransaction { db, rollback in
			do {
                try db.executeUpdate("update switch set status=?, position=? where switch_id=? and switchbox_id=?", values: [status,obj.position ?? 0,obj.switch_id!,obj.switchbox_id!])
			} catch let error as NSError  {
				SSLog(message:error)
				rollback.pointee = true
			}
		}
	}
	
	
	
	func updateSwitchMasterModeInOutStatus(_ obj: Switch,master_mode_status: String) {
		dbQueue?.inTransaction { db, rollback in
			do {
				try db.executeUpdate("update switch set master_mode_status=? where switch_id=? and switchbox_id=?", values: [master_mode_status, obj.switch_id!, obj.switchbox_id!])
			} catch let error as NSError  {
				SSLog(message:error)
				rollback.pointee = true
			}
		}
	}
	
	func updateMasterSwitchStatus(_ obj: Switch,status: String) {
		dbQueue?.inTransaction { db, rollback in
			do {
				// update switch set status=1 where switch_id=0 and switchbox_id='SB-5D69'
				try db.executeUpdate("update switch set status=? where switch_id=? and switchbox_id=?", values: [status, obj.switch_id!, obj.switchbox_id!])
			} catch let error as NSError  {
				SSLog(message:error)
				rollback.pointee = true
			}
		}
	}
	
	func updateSwitchNameAndSwitchImage(_ obj: Switch) {
		dbQueue?.inTransaction { db, rollback in
			do {
				//update switch set switch_name='Gaurav', switch_icon='' where switch_id=1 and switchbox_id='SB-5D69'
				try db.executeUpdate("update switch set switch_name=?, switch_icon=? where switch_id=? and switchbox_id=?", values: [obj.switch_name ?? "", obj.switch_icon ?? "", obj.switch_id!, obj.switchbox_id!])
			} catch let error as NSError  {
				SSLog(message:error)
				rollback.pointee = true
			}
		}
	}
    
    
    
    func checkSwitchIDExistsInSwitchBoxes(switch_id : Int,switchbox_id: String)->Bool
    {
        var count = 0
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT count(*) as h_count from switch where switch_id=? and switchbox_id=?", values:[switch_id,switchbox_id])
                
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
    
    func updateSwitchWattage(_ obj: Switch) {
        dbQueue?.inTransaction { db, rollback in
            do {
                //update switch set switch_name='Gaurav', switch_icon='' where switch_id=1 and switchbox_id='SB-5D69'
                try db.executeUpdate("update switch set wattage=? where switch_id=? and switchbox_id=?", values: [obj.wattage ?? 0, obj.switch_id!, obj.switchbox_id!])
            } catch let error as NSError  {
                SSLog(message:error)
                rollback.pointee = true
            }
        }
    }
    func updateSwitchFroSync(_ obj: Switch) {
        dbQueue?.inTransaction { db, rollback in
            do {
                //update switch set switch_name='Gaurav', switch_icon='' where switch_id=1 and switchbox_id='SB-5D69'
                try db.executeUpdate("update switch set type=?, status=?, position=?,master_mode_status=? where switch_id=? and switchbox_id=?", values: [obj.type!, obj.status ?? 0, obj.position ?? 0, obj.master_mode_status ?? 0, obj.switch_id!, obj.switchbox_id!])
            } catch let error as NSError  {
                SSLog(message:error)
                rollback.pointee = true
            }
        }
    }
}
