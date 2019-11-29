//
//  HomeListScreen.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 10/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import WatchKit
import Foundation


class HomeListScreen: WKInterfaceController {

    @IBOutlet weak var tableHomesList: WKInterfaceTable!

    var newHome = Home()
    var syncData = SyncData()

    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setTableProperties()
 
    }

    
    func setTableProperties()  {
        
        syncData = SyncData().initwithJson(json: SKDatabase.getJson() as! [String : Any])

        self.tableHomesList.setNumberOfRows(syncData.arrayOfHomes!.count, withRowType: "HomeListCell")
        
        for x in 0 ..< syncData.arrayOfHomes!.count {
            
            var row = HomeListCell()
            row = self.tableHomesList.rowController(at: x ) as! HomeListCell
            row.listGroup.setBackgroundColor(UIColor(red: 25/255, green: 27/255, blue: 42/255, alpha: 1.0))

            newHome = syncData.arrayOfHomes![x] as! Home
            row.labelHome.setText(newHome.home_name)
            
        }
        
     }
    
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        newHome = syncData.arrayOfHomes![rowIndex] as! Home
        
        let yesAction = WKAlertAction( title: "YES", style: WKAlertActionStyle.default) { () -> Void in
                
            SKDatabase.saveHomeId(homeId: self.newHome.home_id!)
                SKDatabase.saveRemoteAccess(flag: false)
                SKAPIManager.sharedInstance().sendRemoteAccess(flag: false)
                self.changeDefaultHomeAndNavigate()
        }
        
        let noAction = WKAlertAction( title: "NO", style: WKAlertActionStyle.cancel) { () -> Void in
                
                print("NO")
        }
        
        let actionButtons = [yesAction, noAction]
        
        presentAlert( withTitle: newHome.home_name, message: "Make this default home", preferredStyle: .alert, actions: actionButtons)
    }

    func changeDefaultHomeAndNavigate(){
        
        self.pushController(withName: "InterfaceController", context: nil)
    }


}
