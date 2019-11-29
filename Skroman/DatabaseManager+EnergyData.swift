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
    func insertEnergyDataInDataBase(week_start_date : String,switchbox_id : String, switch_id : Int, kw : Double)
    {
        dbQueue?.inTransaction { db, rollback in
            do {
                
                try db.executeUpdate("INSERT INTO energy_data(week_start_date,switchbox_id,kw,switch_id)  VALUES (?,?,?,?)", values: [week_start_date,switchbox_id,kw,switch_id])
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
    }
    
    func insertEnergyData(objEnergyDataWrapper : EnergyDataWrapper)
    {
        if let objEneryDataList = objEnergyDataWrapper.energy_data
        {
            for objEneryData in objEneryDataList
            {
               if let objSBList = objEneryData.switchbox
                {
                    for objSB in objSBList
                    {
                        if let objSwitchList = objSB.switches
                        {
                            for objSwitch in objSwitchList
                            {
                               // print("week_start_date : \(objEneryData.week_start_date), switchbox_id : \(objSB.switchbox_id), switch_id : \(objSwitch.switch_id), kw : \(objSwitch.wattage)")
                                self.insertEnergyDataInDataBase(week_start_date: objEneryData.week_start_date ?? "", switchbox_id: objSB.switchbox_id ?? "0", switch_id: objSwitch.switch_id ?? 0, kw: objSwitch.wattage ?? 0)
                            }
                        }
                    }
                }
            }
        }
        
//        if let objSBList =  objEnergyData.switchbox{
//            dbQueue?.inTransaction { db, rollback in
//                do {
//                    for objSB in objSBList
//                    {
//                        if let objSwitchList = objSB.switches
//                        {
//                            for objSwitch in objSwitchList
//                            {
//                                //insert switches
//                                print("Insert called :::")
//                                try db.executeUpdate("INSERT INTO energy_data(week_start_date,switchbox_id,switch_id,kw) VALUES (?,?,?,?)", values:[objEnergyData.week_start_date ?? "",objSB.switchbox_id ?? "",objSwitch.switch_id ?? 0,objSwitch.wattage ?? 0])
//                            }
//                        }
//                    }
//                }
//                catch {
//                    rollback.pointee = true
//                }
//            }
//        }
    }
    
    func deleteEnergyData()
    {
            dbQueue?.inTransaction { db, rollback in
                do {
                    //insert switches
                    try db.executeUpdate("DELETE FROM energy_data", values: nil)

                } catch {
                    rollback.pointee = true
                }
            }
    }
    
    
    
    
    
    func getEnergyDataForHome(home_id : String) -> EnergyData
    {
        //ENERGY DATA COMMENT
        let arrEnergData =  EnergyData()
//        dbQueue?.inTransaction { db, rollback in
//            do {
//                let rs = try db.executeQuery("SELECT *  from energy_data where home_id=?", values:[home_id])
//
//                while rs.next() {
//                    let objSwitch = Switch()
////                    objSwitch._id = rs.string(forColumn: "_id")
//
//                    objSwitch.switchbox_id = rs.string(forColumn: "switchbox_id")
//
//                    objSwitch.switch_id = rs.long(forColumn: "switch_id")
//
//                    objSwitch.status = rs.long(forColumn: "status")
//
//                    objSwitch.wattage = rs.long(forColumn: "wattage")
//
//                    objSwitch.timestamp = rs.string(forColumn: "timestamp")
//
//                    arrEnergData.energy_data?.append(objSwitch)
//                }
//
//            } catch _ as NSError  {
//                rollback.pointee = true
//            }
//        }
        return arrEnergData
    }
    
    
    
    
    
    func getEnergyDataForHomeWithCalculations(home_id : String) -> EnergyData
    {
        //ENERGY DATA COMMENT
        let arrEnergData =  EnergyData()
//        dbQueue?.inTransaction { db, rollback in
//            do {
//                let rs = try db.executeQuery("select ed.*,sw.switch_name from energy_data as ed inner join switch as sw on(ed.switchbox_id = sw.switchbox_id and ed.switch_id = sw.switch_id) where home_id = ?", values:[home_id])
//
//                while rs.next() {
//                    let objSwitch = Switch()
////                    objSwitch._id = rs.string(forColumn: "_id")
//
//                    objSwitch.switchbox_id = rs.string(forColumn: "switchbox_id")
//
//                    objSwitch.switch_id = rs.long(forColumn: "switch_id")
//
//                    objSwitch.status = rs.long(forColumn: "status")
//
//                    objSwitch.wattage = rs.long(forColumn: "wattage")
//
//                    objSwitch.timestamp = rs.string(forColumn: "timestamp")
//
//                    objSwitch.switch_name = rs.string(forColumn: "switch_name")
//
//                    arrEnergData.energy_data?.append(objSwitch)
//                }
//
//            } catch _ as NSError  {
//                rollback.pointee = true
//            }
//        }
        return arrEnergData
    }
    
    
    
    func getTotalUsgaeForCurrentHome() -> String
    {
        var totalUsage = 0.0
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("select  SUM(kw) as totalUsage from energy_data", values: nil)
                
                if rs.next() {
                    
                    totalUsage = rs.double(forColumn: "totalUsage")
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return totalUsage.format(f: ".2")
    }
    func getTotalUsgaeForRoom(room_id : String) -> String
    {
        var totalUsage = 0.0
        dbQueue?.inTransaction { db, rollback in
            do {
                //Select SUM(eda.kw) as totalUsageForRoom from switchbox sb inner join energy_data eda ON sb.switchbox_id = eda.switchbox_id where sb.room_id = 'RM-7776'
                let rs = try db.executeQuery("Select SUM(eda.kw) as totalUsageForRoom from switchbox sb inner join energy_data eda ON sb.switchbox_id = eda.switchbox_id where sb.room_id = ?", values: [room_id])
                
                if rs.next() {
                    
                    totalUsage = rs.double(forColumn: "totalUsageForRoom")
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return totalUsage.format(f: ".2")
    }
    
    
    func getTotalUsgaeForSwitchBox(switchbox_id : String) -> String
    {
        var totalUsage = 0.0
        dbQueue?.inTransaction { db, rollback in
            do {
                //Select SUM(eda.kw) as totalUsageForRoom from switchbox sb inner join energy_data eda ON sb.switchbox_id = eda.switchbox_id where sb.room_id = 'RM-7776'
                let rs = try db.executeQuery("Select SUM(kw) as totalUsageForSwitchBox from energy_data where switchbox_id = ?", values: [switchbox_id])
                
                if rs.next() {
                    
                    totalUsage = rs.double(forColumn: "totalUsageForSwitchBox")
                }
                
            } catch _ as NSError  {
                rollback.pointee = true
            }
        }
        return totalUsage.format(f: ".2")
    }
    
    func getWeeklyEnergyDataConsumption() -> EnergyDataWrapper
    {
        //ENERGY DATA COMMENT
        let arrEnergyDataWrapper =  EnergyDataWrapper()
                dbQueue?.inTransaction { db, rollback in
                    do {
                        let rs = try db.executeQuery("SELECT SUM(kw) AS weeklyUsage,week_start_date FROM energy_data GROUP BY week_start_date", values : nil)
        
                        while rs.next() {
                            let objEnergyData = EnergyData()
        //                    objSwitch._id = rs.string(forColumn: "_id")
        
                            objEnergyData.week_start_date = rs.string(forColumn: "week_start_date")
                            objEnergyData.weekly_total_usage = rs.double(forColumn: "weeklyUsage").format(f: ".2")
                            arrEnergyDataWrapper.energy_data?.append(objEnergyData)
                        }
        
                    } catch _ as NSError  {
                        rollback.pointee = true
                    }
                }
        SSLog(message: arrEnergyDataWrapper)
        return arrEnergyDataWrapper
    }
    
    
    func checkEnergyDataExist()->Bool
    {
        var count = 0
        dbQueue?.inTransaction { db, rollback in
            do {
                let rs = try db.executeQuery("SELECT count(*) as h_count from energy_data", values:nil)
                
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
