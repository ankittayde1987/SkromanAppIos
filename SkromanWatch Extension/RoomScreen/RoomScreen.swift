//
//  RoomScreen.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 12/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import WatchKit
import Foundation


class RoomScreen: WKInterfaceController {

    
    @IBOutlet weak var switchRemote: WKInterfaceButton!
    @IBOutlet weak var labelName: WKInterfaceLabel!
    @IBOutlet weak var tableSwitch: WKInterfaceTable!
    
    
    var rooms = Rooms()
    var dictSwitches = NSArray ()
    var newSwitchBoxes = SwitchBoxes()


    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        rooms = SKDatabase.getRoom()
        
        self.labelName.setText(rooms.room_name)
        
        let countSwitch : Int  = (rooms.arrayOfSwitchboxes as AnyObject).count ?? 0
        
        if countSwitch > 0 {
            
            dictSwitches = rooms.arrayOfSwitchboxes! as! NSArray
        }

        setUpNotificationCentre()
        setTableProperties()
    }

    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if SKDatabase.getRemoteAccess() == true {
            self.switchRemote.setBackgroundImageNamed("iRemoteAccessOn")
        }
        else{
            self.switchRemote.setBackgroundImageNamed("iRemoteAccessOff")
        }
    }

    
    func setUpNotificationCentre() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.dataReceivedFromServer),
            name: NSNotification.Name(rawValue: "RoomScreen"),
            object: nil)
    }
    
    
    @objc func dataReceivedFromServer(notification:NSNotification){
        
        var userInfo: [String: Any] = [:]
        userInfo = notification.userInfo as! [String : Any]
    }

    
    func setTableProperties() {
        
        self.tableSwitch.setNumberOfRows(dictSwitches.count , withRowType: "RoomCell")

        for x in 0 ..< dictSwitches.count {
            
            var row = RoomCell()
            row = self.tableSwitch.rowController(at: x ) as! RoomCell
            row.groupTable.setBackgroundColor(UIColor(red: 25/255, green: 27/255, blue: 42/255, alpha: 1.0))
            newSwitchBoxes = dictSwitches[x] as!SwitchBoxes
            row.labelSwitch.setText(newSwitchBoxes.name)
        }
    }

    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        newSwitchBoxes = dictSwitches[rowIndex] as!SwitchBoxes
        SKDatabase.saveSwitchBoxId(switchBoxId: newSwitchBoxes.switchbox_id!)
        self.pushController(withName: "SwitchScreen", context: nil)
    }

    
    @IBAction func switchRemoteValueChanged(_ sender: Any) {
        
        var valueRemote : Bool = false
        

        if SKDatabase.getRemoteAccess() == true {
                        self.switchRemote.setBackgroundImage(UIImage(named: "iRemoteAccessOn"))
            valueRemote = true
        }
        else{
                        self.switchRemote.setBackgroundImage(UIImage(named: "iRemoteAccessOff"))
            valueRemote = false
        }
        
        SKDatabase.saveRemoteAccess(flag: valueRemote)
        SKAPIManager.sharedInstance().sendRemoteAccess(flag: valueRemote)
    }
}
