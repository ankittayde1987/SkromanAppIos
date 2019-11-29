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
    /* var hid : Int?
     var home_name : String?
     var home_id : String?
     var pi_id : String?

     */
    //MARK:- Directory Database Methods
    func addHome (home_name : String, home_id : String , pi_id : String){
     
        dbQueue?.inTransaction { db, rollback in
            do {
               
                 try db.executeUpdate("INSERT INTO home(home_name,home_id,pi_id)  VALUES (?,?,?)", values: [home_name,home_id,pi_id])
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
    }
    
    func deleteHomeWithHomeId(home_id: String){
        dbQueue?.inTransaction { db, rollback in
            do {
                try db.executeUpdate("delete from home where home_id=?", values: [home_id])
            } catch {
                rollback.pointee = true
            }
        }
    }
   
    func getHome(home_id:String) -> Home
    {
        let objHome =  Home()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT * from home where home_id=?", values: [home_id])
                
                while rs.next() {
                   
                    objHome.hid = rs.long(forColumn:"hid")
                    objHome.home_name = rs.string(forColumn: "home_name")!
                    objHome.home_id = rs.string(forColumn: "home_id")!
                    objHome.pi_id = rs.string(forColumn: "pi_id")!
                    objHome.is_default = rs.long(forColumn: "is_default")
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return objHome
    }
    func getDefaultHome() -> Home
    {
        let objHome =  Home()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT * from home where is_default=1", values: nil)
                
                if rs.next() {
                    
                    objHome.hid = rs.long(forColumn:"hid")
                    objHome.home_name = rs.string(forColumn: "home_name")!
                    objHome.home_id = rs.string(forColumn: "home_id")!
                    objHome.pi_id = rs.string(forColumn: "pi_id")!
                    objHome.is_default = rs.long(forColumn: "is_default")
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return objHome
    }
    
    func getAllHomes() -> NSMutableArray
    {
        let arrHome =  NSMutableArray()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT * from home", values:nil)
                
                while rs.next() {
                    let objHome = Home()
                    objHome.hid = rs.long(forColumn:"hid")
                    objHome.home_name = rs.string(forColumn: "home_name")!
                    objHome.home_id = rs.string(forColumn: "home_id")!
                    objHome.pi_id = rs.string(forColumn: "pi_id")!
                    objHome.is_default = rs.long(forColumn: "is_default")
                    arrHome.add(objHome)
                    
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return arrHome
    }
    
    func isAlreadyHaveDefaultHome()->Bool
    {
        var count = 0
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT count(*) as h_count from home where is_default=1", values:nil)
                
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
	
	
	
	func getHomeOnSwitchesCount() -> String
	{
		 var count = 0
		dbQueue?.inTransaction { db, rollback in
			do {
				//select count(s.switch_id) from room as r Inner join switchbox as sb On r.room_id = sb.room_id Inner join switch as s On sb.switchbox_id = s.switchbox_id where r.home_id = 'HM-28CD3' And s.status = 1
				
				
				//select count(s.switch_id) as on_count from room as r Inner join switchbox as sb On r.room_id = sb.room_id Inner join switch as s On (sb.switchbox_id = s.switchbox_id And s.switch_id != 0 And s.type != 2) where r.home_id = 'HM-28CD3' And s.status = 1
				let rs = try db.executeQuery("select count(s.switch_id) as on_count from room as r Inner join switchbox as sb On r.room_id = sb.room_id Inner join switch as s On (sb.switchbox_id = s.switchbox_id And s.switch_id != 0 And s.type != ?) where r.home_id = ? And s.status = 1", values: [SWITCH_TYPE_MOOD,VVBaseUserDefaults.getCurrentHomeID()])
				
				if rs.next() {
					
					count = rs.long(forColumn: "on_count")
				}
				
			} catch _ as NSError  {
				rollback.pointee = true
			}
		}
		return "\(count)"
	}
	
	func getHomeSwitchesCount() -> String
	{
		var count = 0
		dbQueue?.inTransaction { db, rollback in
			do {
				//select count(s.switch_id) from room as r Inner join switchbox as sb On r.room_id = sb.room_id Inner join switch as s On sb.switchbox_id = s.switchbox_id where r.home_id = 'HM-28CD3'
				let rs = try db.executeQuery("select count(s.switch_id) as all_count from room as r Inner join switchbox as sb On r.room_id = sb.room_id Inner join switch as s On (sb.switchbox_id = s.switchbox_id And s.switch_id != 0 And s.type != ?) where r.home_id = ?", values: [SWITCH_TYPE_MOOD,VVBaseUserDefaults.getCurrentHomeID()])
				
				if rs.next() {
					
					count = rs.long(forColumn: "all_count")
				}
				
			} catch _ as NSError  {
				rollback.pointee = true
			}
		}
		return "\(count)"
	}
	
	
	func updateAllDefaultHomeIdToZero() {
		dbQueue?.inTransaction { db, rollback in
			do {
				try db.executeUpdate("update home set is_default= 0", values: nil)
			} catch let error as NSError  {
				SSLog(message:error)
				rollback.pointee = true
			}
		}
	}
	
	func updateDefaultHome(obj: Home) {
		dbQueue?.inTransaction { db, rollback in
			do {
				try db.executeUpdate("update home set is_default = 0", values: nil)
				
				try db.executeUpdate("update home set is_default= 1 where home_id= ?", values: [obj.home_id!])
			} catch let error as NSError  {
				SSLog(message:error)
				rollback.pointee = true
			}
		}
	}
    
    
    
    
    func isAlreadyHomeExistsInDB(home_id : String)->Bool
    {
        var count = 0
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT count(*) as h_count from home where home_id=?", values:[home_id])
                
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
