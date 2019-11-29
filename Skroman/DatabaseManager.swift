//
//  DatabaseManager.swift
//  CalenderApp
//
//  Created by Pradip Parkhe on 2/26/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import FMDB

class DatabaseManager: NSObject {
    
    var dbQueue: FMDatabaseQueue?
    let DATABASE_NAME = "skroman.sqlite"
    class func sharedInstance() -> DatabaseManager {
        
        var sharedInstance: DatabaseManager {
            struct Static {
                static let instance = DatabaseManager()
            }
            return Static.instance
        }
        return sharedInstance
    }
    

    
    
    
    override init() {
        super.init()
        initializeResources()
    }
    
    func initializeResources() {
        self.copyDatabaseIfNeeded()
    }
    
    func copyDatabaseIfNeeded() {
        // Move database file from bundle to documents folder
        
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent(DATABASE_NAME)
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent(DATABASE_NAME)
            
            do {
                try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
                dbQueue = FMDatabaseQueue(path: finalDatabaseURL.path)
                print("Database copied at path: \(finalDatabaseURL.path)")
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
            
        } else {
            dbQueue = FMDatabaseQueue(path: finalDatabaseURL.path)

            print("Database file found at path: \(finalDatabaseURL.path)")
        }
        
    }
    
    
}
