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
    /*   var rid : Int?
     var room_id : String?
     var room_name : String?
     var home_id : String?
     

     */
    //MARK:- Directory Database Methods
    func addRoomWithHID (room_name : String , room_id : String ,home_id: String,image : String){
     
        dbQueue?.inTransaction { db, rollback in
            do {
               
                 try db.executeUpdate("INSERT INTO room(room_id,room_name,home_id,image) VALUES (?,?,?,?)", values: [room_id,room_name,home_id,image])
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
    }
    
    func deleteRoomWithRoomID(room_id: String){
        dbQueue?.inTransaction { db, rollback in
            do {
                try db.executeUpdate("delete from room where room_id=?", values: [room_id])
            } catch {
                rollback.pointee = true
            }
        }
    }
    
    func deleteRoomWithRoomIDs(room_ids: String){
        dbQueue?.inTransaction { db, rollback in
            do {
                try db.executeUpdate("delete from room where room_id in (\(room_ids))", values: nil)
            } catch {
                rollback.pointee = true
            }
        }
    }
   
    func getRoomWithRoomID(room_id:String) -> Room
    {
        let objRoom =  Room()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT * from room where room_id=?", values: [room_id])
                /*  var rid : Int?
                 var rname : String?
                 var runique_id : String?
                 var hid : Int?
                 
                 */
                while rs.next() {
                   
                    objRoom.rid = rs.long(forColumn: "rid")
                    objRoom.room_name = rs.string(forColumn: "room_name")!
                    objRoom.room_id = rs.string(forColumn: "room_id")!
                    objRoom.home_id = rs.string(forColumn: "home_id")
                    objRoom.image = rs.string(forColumn: "image")!
                    
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return objRoom
    }
    
    
    func getAllRoomWithHomeID(home_id:String) -> NSMutableArray
    {
        let arrRooms =  NSMutableArray()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT * from room where home_id=?", values:[home_id])
                
                while rs.next() {
                    let objRoom = Room()
                    objRoom.rid = rs.long(forColumn: "rid")
                    objRoom.room_name = rs.string(forColumn: "room_name")!
                    objRoom.room_id = rs.string(forColumn: "room_id")!
                    objRoom.home_id = rs.string(forColumn: "home_id")
                    if((rs.string(forColumn: "image")) != nil)
                    {
                        objRoom.image = rs.string(forColumn: "image")!
                    }
                    
                    arrRooms.add(objRoom)
                    
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return arrRooms
    }
    
    func getAllRoomIDsWithHomeID(home_id:String) -> NSMutableArray
    {
        let arrRooms =  NSMutableArray()
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT room_id from room where home_id=?", values:[home_id])
                
                while rs.next() {
                    if(rs.string(forColumn: "room_id") !=  nil)
                    {
                        arrRooms.add(String(format:"'%@'",rs.string(forColumn: "room_id")!))
                    }
                    
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return arrRooms
    }
	
	func updateRoomWithHID (room_name : String , room_id : String ,home_id: String,image : String){
		
		dbQueue?.inTransaction { db, rollback in
			do {
				try db.executeUpdate("update room set room_name=?, room_id=?, home_id=?, image=? where room_id=? and home_id=?", values: [room_name,room_id,home_id,image,room_id,home_id])
			} catch let error as NSError  {
				SSLog(message:error)
				rollback.pointee = true
			}
		}
	}
	

    
    func checkRoomIDExistsInHome(room_id : String)->Bool
    {
        var count = 0
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT count(*) as h_count from room where room_id=?", values:[room_id])
                
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
    
    func updateRoomName (obj:Room){
        
        dbQueue?.inTransaction { db, rollback in
            do {
                try db.executeUpdate("update room set room_name=? where room_id=? and home_id=?", values: [obj.room_name!,obj.room_id!,obj.home_id!])
            } catch let error as NSError  {
                SSLog(message:error)
                rollback.pointee = true
            }
        }
    }
    
    
    
    func isAlreadyRoomExistsInDB(room_id : String)->Bool
    {
        var count = 0
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT count(*) as h_count from room where room_id =?", values:[room_id])
                
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
