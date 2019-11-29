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
    func addMood (objMood:Mood){
        
        var is_present = false
        dbQueue?.inTransaction { db, rollback in
            do {
                
                let rs = try db.executeQuery("SELECT * from mood where mood_id=?", values: [objMood.mood_id ?? ""])
                
                if rs.next() {
                    is_present = true
                }
                
                if(!is_present)
                {
                    /*  case mood_id
                     case mood_name
                     case switchbox_id
                     case home_id
                     case switch_id
                     case mood_type
                     case status
                     case position
                     case mood_repeat
                     case mood_time
                     case mood_status
                     
                     */
					
					
					
                    try db.executeUpdate("INSERT INTO mood(mood_id,mood_name,switchbox_id,home_id,switch_id,mood_type,status,position,mood_repeat,mood_time,mood_status) VALUES (?,?,?,?,?,?,?,?,?,?,?)", values: [objMood.mood_id ?? "",objMood.mood_name ?? "",objMood.switchbox_id ?? "",objMood.home_id ?? "",objMood.switch_id,objMood.mood_type,objMood.status,objMood.position,objMood.mood_repeat ?? "",objMood.mood_time ?? "",objMood.mood_status])
                }
                else{
                    try db.executeUpdate("update mood set  mood_name=?,switchbox_id=?,home_id=?,switch_id=?,mood_type=?,status=?,position=?,mood_repeat=?,mood_time=?,mood_status=? where mood_id=?", values: [objMood.mood_name ?? "",objMood.switchbox_id ?? "",objMood.home_id ?? "",objMood.switch_id,objMood.mood_type,objMood.status,objMood.position,objMood.mood_repeat ?? "",objMood.mood_time ?? "",objMood.mood_status,objMood.mood_id ?? ""])
                    
                }
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
    }
    
    func deleteMoodWithMoodId(mood_id: String){
		
		dbQueue?.inTransaction { db, rollback in
            do {
                try db.executeUpdate("delete from mood where mood_id=?", values: [mood_id])
            } catch {
                rollback.pointee = true
            }
        }
    }
    
    func deleteAllMoodWithHomeId(home_id: String){
        dbQueue?.inTransaction { db, rollback in
            do {
                try db.executeUpdate("delete from mood where home_id=?", values: [home_id])
            } catch {
                rollback.pointee = true
            }
        }
    }
    func getMood(mood_id:String) -> Mood
    {
        let objMood =  Mood()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT * from mood where mood_id=?", values: [mood_id])
                
				if rs.next() {
					objMood.mid = rs.long(forColumn: "mid")
					objMood.mood_id = rs.string(forColumn: "mood_id")
					objMood.mood_name = rs.string(forColumn: "mood_name")
					objMood.mood_type = rs.long(forColumn: "mood_type")
					objMood.home_id = rs.string(forColumn: "home_id")
					objMood.position = rs.long(forColumn: "position")
					objMood.status = rs.long(forColumn: "status")
					objMood.mood_type = rs.long(forColumn: "mood_type")
					let moodRepeatStr = rs.string(forColumn: "mood_repeat")
					objMood.mood_repeat = objMood.getArrayFormString(str: moodRepeatStr!)
					objMood.mood_time = rs.string(forColumn: "mood_time")
					objMood.mood_status = rs.long(forColumn: "mood_status")
					objMood.switch_id = rs.long(forColumn: "switch_id")
					objMood.switchbox_id = rs.string(forColumn: "switchbox_id")
				}
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return objMood
    }
    
    
    func getAllMoodWithSwitchboxId(switchbox_id:String) -> NSMutableArray
    {
        let arrMoods =  NSMutableArray()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT * from mood where switchbox_id=?", values:[switchbox_id])
                
                while rs.next() {
                    let objMood = Mood()
                    objMood.mid = rs.long(forColumn: "mid")
                    objMood.mood_id = rs.string(forColumn: "mood_id")
                    objMood.mood_name = rs.string(forColumn: "mood_name")
                    objMood.mood_type = rs.long(forColumn: "mood_type")
                    objMood.home_id = rs.string(forColumn: "home_id")
                    objMood.position = rs.long(forColumn: "position")
                    objMood.status = rs.long(forColumn: "status")
                    objMood.mood_type = rs.long(forColumn: "mood_type")
					let moodRepeatStr = rs.string(forColumn: "mood_repeat")
					objMood.mood_repeat = objMood.getArrayFormString(str: moodRepeatStr!)
                    objMood.mood_time = rs.string(forColumn: "mood_time")
                    objMood.mood_status = rs.long(forColumn: "mood_status")
                    objMood.switch_id = rs.long(forColumn: "switch_id")
                    objMood.switchbox_id = rs.string(forColumn: "switchbox_id")
                    arrMoods.add(objMood)
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return arrMoods
    }
	
	
	
	
	func addOrEditHomeMood (objMood:Mood){
		
		var is_present = false
		dbQueue?.inTransaction { db, rollback in
			do {
				//Temporery there is no mood_id
				let rs = try db.executeQuery("SELECT * from mood where mood_id=? and switchbox_id=? and switch_id=?", values: [objMood.mood_id ?? "",objMood.switchbox_id!,objMood.switch_id!])
				
				if rs.next() {
					is_present = true
				}
				
				if(!is_present)
				{
					SSLog(message: "INSERT CALLED")
					try db.executeUpdate("INSERT INTO mood(mood_id,mood_name,switchbox_id,home_id,switch_id,mood_type,status,position,mood_repeat,mood_time,mood_status) VALUES (?,?,?,?,?,?,?,?,?,?,?)", values: [objMood.mood_id ?? "",objMood.mood_name ?? "",objMood.switchbox_id ?? "",objMood.home_id ?? "",objMood.switch_id!,objMood.mood_type,objMood.status,objMood.position,objMood.mood_repeat ?? "",objMood.mood_time ?? "",objMood.mood_status])
				}
				else{
					SSLog(message: "update CALLED")
					try db.executeUpdate("update mood set  mood_name=?,switchbox_id=?,home_id=?,switch_id=?,mood_type=?,status=?,position=?,mood_repeat=?,mood_time=?,mood_status=? where mood_id=?", values: [objMood.mood_name ?? "",objMood.switchbox_id ?? "",objMood.home_id ?? "",objMood.switch_id!,objMood.mood_type,objMood.status,objMood.position,objMood.mood_repeat ?? "",objMood.mood_time ?? "",objMood.mood_status,objMood.mood_id ?? ""])
					
				}
			} catch _ as NSError  {
				rollback.pointee = true
			}
		}
	}
	
	
	func insertBulkHomeMood (arrMood:[Mood]){
		
        
		dbQueue?.inTransaction { db, rollback in
			do {
              //  db.traceExecution = true
			 var is_present = false
			 try arrMood.forEach({ (objMood) in
//                SSLog(message: "MOOD_ID : \(objMood.mood_id)")
//                SSLog(message: "SWITCHBOX_ID : \(objMood.switchbox_id)")
//                SSLog(message: "SWITCH_ID : \(objMood.switch_id)")
                is_present = false
//                let query = "SELECT * from mood where mood_id='" + objMood.mood_id! +  "' and switchbox_id='" + \(objMood.switchbox_id!)
                
                let query = String(format : "SELECT * from mood where mood_id='%@' and switchbox_id= '%@' and switch_id= '%ld'", objMood.mood_id!,objMood.switchbox_id!,objMood.switch_id!)
                
                SSLog(message: "****query = \(query)")
                let rs = try db.executeQuery(query, values:nil);
//                    let rs = try db.executeQuery("SELECT * from mood where mood_id=? and switchbox_id=? and switch_id=?", values: [objMood.mood_id! ,objMood.switchbox_id!,objMood.switch_id!])
                
					if rs.next() {
						is_present = true
					}
//                 SSLog(message: "****query = \(rs.query)")
					if(!is_present)
					{
						SSLog(message: "INSERT CALLED")
						try db.executeUpdate("INSERT INTO mood(mood_id,mood_name,switchbox_id,home_id,switch_id,mood_type,status,position,mood_repeat,mood_time,mood_status) VALUES (?,?,?,?,?,?,?,?,?,?,?)", values: [objMood.mood_id ?? "",objMood.mood_name ?? "",objMood.switchbox_id ?? "",objMood.home_id ?? "",objMood.switch_id!,objMood.mood_type,objMood.status,objMood.position,objMood.mood_repeat ?? "",objMood.mood_time ?? "",objMood.mood_status])
					}
					else{
						SSLog(message: "update CALLED")
						try db.executeUpdate("update mood set  mood_name=?,switchbox_id=?,home_id=?,switch_id=?,mood_type=?,status=?,position=?,mood_repeat=?,mood_time=?,mood_status=? where mood_id=? and switch_id=? and switchbox_id= ?", values: [objMood.mood_name ?? "",objMood.switchbox_id ?? "",objMood.home_id ?? "",objMood.switch_id!,objMood.mood_type,objMood.status,objMood.position,objMood.mood_repeat ?? "",objMood.mood_time ?? "",objMood.mood_status,objMood.mood_id ?? "",objMood.switch_id!,objMood.switchbox_id!])
					}
				})
				
			} catch _ as NSError  {
				rollback.pointee = true
			}
		}
	}
	
	
	
	
	
    func addOrEditHomeMoodWithDictionary (moodDict:NSMutableDictionary){
		
		let moodArray : [NSDictionary]? = moodDict.value(forKey: "mood") as? [NSDictionary]
		var arrMoods = [Mood]()
		let timestamp: String = self.getTimeStamp()
		for obj : NSDictionary in moodArray! {
			let mood_status_array : [Int] = obj.value(forKey: "status") as! [Int]
			let mood_position_array : [Int] = obj.value(forKey: "position") as! [Int]
			let mood_switchIds_array : [Int] = obj.value(forKey: "switch_id") as! [Int]
			
			for index in stride(from: 0, to: mood_status_array.count, by: 1){
				let objMood = Mood()
				objMood.status = mood_status_array[index]
				objMood.switch_id = mood_switchIds_array[index]
				objMood.position = mood_position_array[index]
				
				objMood.switchbox_id = obj.value(forKey: "switchbox_id") as? String
				
				objMood.mood_name = moodDict.value(forKey: "mood_name") as? String
				objMood.mood_time = moodDict.value(forKey: "mood_time") as? String
                if (moodDict.value(forKey: "mood_repeat") != nil)
                {
                    //CRASH
                    let arrayRepeat = moodDict.value(forKey: "mood_repeat") as! [Int]
                    
                    if arrayRepeat.isEmpty {
                        SSLog(message: "SKIPPP")
                    }
                    else
                    {
                         objMood.mood_repeat = arrayRepeat
                    }
                 
                }
				
				objMood.mood_type = moodDict.value(forKey: "mood_type") as! Int
				
				//FOR Home Id Now Setting Default Home ID
				objMood.home_id = VVBaseUserDefaults.getCurrentHomeID()
				
				if moodDict.value(forKey: "mood_id") as? String != nil
				{
					objMood.mood_id = moodDict.value(forKey: "mood_id") as? String
				}
				else
				{
					//For Temporery added a MoodID
					objMood.mood_id = "\(timestamp)"
				}
				//For Mood Status
				objMood.mood_status = moodDict.object(forKey: "mood_status") as! Int
				arrMoods.append(objMood)
			}

			SSLog(message: "ARRAY COUNT :: %@ \(arrMoods.count)")
            SSLog(message: "OBJ : \(arrMoods)")
			self.insertBulkHomeMood(arrMood: arrMoods)
            arrMoods = [Mood]();
		}
	}
	
	//TEMPORARY
	func getTimeStamp() -> String {
		return "\(Date().timeIntervalSince1970 * 1000)"
	}
	

    func getAllMoodsForRoomWithRoomId(room_id:String) -> NSMutableArray{
        
        let arrMoods =  NSMutableArray()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("Select distinct mood_id, mood_name,mood_status,mood_time,mood_repeat,mood_type from mood where room_id =? and mood_type = ? order by mood_id asc", values:[room_id, MOOD_TYPE_ROOM])
                
                while rs.next() {
                    let objMood = Mood()
                    objMood.mood_id = rs.string(forColumn: "mood_id")
                    objMood.mood_name = rs.string(forColumn: "mood_name")
                    objMood.mood_status = rs.long(forColumn: "mood_status")
                    objMood.mood_time = rs.string(forColumn: "mood_time")
                    let moodRepeatStr = rs.string(forColumn: "mood_repeat")
                    objMood.mood_repeat = objMood.getArrayFormString(str: moodRepeatStr!)
                    objMood.mood_type = rs.long(forColumn: "mood_type")
                    arrMoods.add(objMood)
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return arrMoods
    }

    
	func getAllMoodsForHomeWithHomeId(home_id:String) -> NSMutableArray
	{
		let arrMoods =  NSMutableArray()
		dbQueue?.inTransaction { db, rollback in
			do {
				let rs = try db.executeQuery("Select distinct mood_id, mood_name,mood_status,mood_time,mood_repeat,mood_type from mood where home_id =? and mood_type = ? order by mood_id asc", values:[home_id, MOOD_TYPE_HOME])
				
				while rs.next() {
					let objMood = Mood()
					objMood.mood_id = rs.string(forColumn: "mood_id")
					objMood.mood_name = rs.string(forColumn: "mood_name")
					objMood.mood_status = rs.long(forColumn: "mood_status")
					objMood.mood_time = rs.string(forColumn: "mood_time")
					let moodRepeatStr = rs.string(forColumn: "mood_repeat")
					objMood.mood_repeat = objMood.getArrayFormString(str: moodRepeatStr!)
					objMood.mood_type = rs.long(forColumn: "mood_type")
					arrMoods.add(objMood)
				}
				
			} catch _ as NSError  {
				rollback.pointee = true
			}
		}
		return arrMoods
	}
	
	func updateMood(objMood:Mood)
	{
		dbQueue?.inTransaction { db, rollback in
			do {
					 try db.executeUpdate("update mood set mood_name=?,mood_status=? where mood_id=?", values: [objMood.mood_name ?? "",objMood.mood_status,objMood.mood_id ?? ""])
				
			} catch _ as NSError  {
				rollback.pointee = true
			}
		}
	}
    
    func updateMoodStatus(moodStatus:Int,moodId : String)
    {
        dbQueue?.inTransaction { db, rollback in
            do {
                try db.executeUpdate("update mood set mood_status=? where mood_id=?", values: [moodStatus,moodId])
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
    }
    
	func getAllMoodsForDeviceMoodSettings(switchBox_id : String) -> NSMutableArray
	{
		let arrDeviceMoods =  NSMutableArray()
		dbQueue?.inTransaction { db, rollback in
			do {
				let rs = try db.executeQuery("Select distinct mood_id,mood_name,mood_status,mood_type from mood where switchbox_id =? and mood_type =? order by mood_id asc", values:[switchBox_id,MOOD_TYPE_DEVICE])
				
				while rs.next() {
					let objMood = Mood()
					objMood.mid = rs.long(forColumn: "mid")
					objMood.mood_id = rs.string(forColumn: "mood_id")
					objMood.mood_name = rs.string(forColumn: "mood_name")
					objMood.mood_type = rs.long(forColumn: "mood_type")
					objMood.home_id = rs.string(forColumn: "home_id")
					objMood.position = rs.long(forColumn: "position")
					objMood.status = rs.long(forColumn: "status")
					objMood.mood_type = rs.long(forColumn: "mood_type")
					let moodRepeatStr = rs.string(forColumn: "mood_repeat")
					if moodRepeatStr != nil
					{
						objMood.mood_repeat = objMood.getArrayFormString(str: moodRepeatStr!)
					}

					objMood.mood_time = rs.string(forColumn: "mood_time")
					objMood.mood_status = rs.long(forColumn: "mood_status")
					objMood.switch_id = rs.long(forColumn: "switch_id")
					objMood.switchbox_id = rs.string(forColumn: "switchbox_id")
					arrDeviceMoods.add(objMood)
				}
				
			} catch _ as NSError  {
				rollback.pointee = true
			}
		}
		return arrDeviceMoods
	}
    
    
    func deleteAllMoodWithSWitchBoxId(switchbox_id: String){
        dbQueue?.inTransaction { db, rollback in
            do {
                //delete from mood where mood_id in (select mood_id from mood where switchbox_id = 'SB-0848')
                //delete from mood where mood_id in (select distinct mood_id from mood where switchbox_id = 'SB-0848')
                try db.executeUpdate("delete from mood where mood_id in (select mood_id from mood where switchbox_id=?)", values: [switchbox_id])
            } catch {
                rollback.pointee = true
            }
        }
    }
}
