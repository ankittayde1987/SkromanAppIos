//
//  InterfaceController.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 10/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController , WCSessionDelegate {
    
    @IBOutlet weak var buttonSetting: WKInterfaceButton!
    @IBOutlet weak var switchRemote: WKInterfaceButton!
    @IBOutlet weak var labelNameOfRoom: WKInterfaceLabel!
    @IBOutlet weak var labelActiveDevices: WKInterfaceLabel!
    @IBOutlet weak var tableRooms: WKInterfaceTable!
    
    var syncData = SyncData()
    var newHome = Home()
    var newRoom = Rooms()
    var switches = Switches()


    var indexOfHomeObjectInDB : Int?
    var contextData = NSDictionary()
    var dictOfArrayRoom = NSArray ()
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        if SKDatabase.getRemoteAccess() == true {
            self.switchRemote.setBackgroundImageNamed("iRemoteAccessOn")
        }
        else{
            self.switchRemote.setBackgroundImageNamed("iRemoteAccessOff")
        }

        setUpWCSession()

        if let theData = context as? NSDictionary {
            self.contextData = theData
        }
        
        checkDataReceived()
    }
    
    
    func checkDataReceived() {
        
        let value = self.contextData.value(forKey: "sendUpdatedJson") as? String
        if value == "sendUpdatedJson" {
            
            sendToiPhone(dictonary: self.contextData as! [String : Any])
        }
        else{
              fillUpData()
        }
        
      /*  for sending data to iphone when selecting from switches  */
        setUpNotificationCentre()
    }
    
    
    
    func setUpWCSession(){
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void){
        
        DispatchQueue.main.async() {
            self.messageFromiPhone(message: message as NSDictionary )
        }

    }

    
    func messageFromiPhone(message: NSDictionary){

        if (message.value(forKey: NAME) != nil && message.value(forKey: EMAIL) != nil && message.value(forKey: PHONE) != nil ){
            
            let dictonary = NSMutableDictionary()
            dictonary.setValue(message.value(forKey: NAME), forKey: NAME)
            dictonary.setValue(message.value(forKey: EMAIL), forKey: EMAIL)
            dictonary.setValue(message.value(forKey: PHONE), forKey: PHONE)

            SKDatabase.saveUserInformation(user: dictonary)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SettingsScreen"), object: nil, userInfo: message as? [AnyHashable : Any])
        }

        if (message.value(forKey: SERVER_ID) != nil){
            
            SKDatabase.saveServerId(serverId: message.value(forKey: SERVER_ID) as! String)
        }
        
        if (message.value(forKey: USER_ID) != nil){
            
            SKDatabase.saveUserId(userId: message.value(forKey: USER_ID) as! String)
        }

        if (message.value(forKey: SYNCDATA) != nil){
            
            SKDatabase.saveJson(json: message)
            fillUpData()
        }
        
        if (message.value(forKey: CHILD_LOCK_STATUS) != nil){
            
            SKDatabase.saveChildLock(lock: message.value(forKey: CHILD_LOCK_STATUS) as! NSInteger)
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RoomScreen"), object: nil, userInfo: message as? [AnyHashable : Any])

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ResponseReceived"), object: nil, userInfo: message as? [AnyHashable : Any])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SwitchScreen"), object: nil, userInfo: message as? [AnyHashable : Any])

    }
    
    
    func sendToiPhone(dictonary: [String : Any]){
        
        setUpWCSession()
        
        if (WCSession.default.isReachable) {
            let session = WCSession.default
            session.sendMessage(dictonary , replyHandler: { (response) in
            }, errorHandler: { (error) in
                print("Error sending message: %@", error)
            })
        }
    }
    
    
    func fillUpData() {
        
        syncData = SyncData().initwithJson(json: SKDatabase.getJson() as! [String : Any])
        if syncData.pi_id == "" || syncData.pi_id == nil {}
        else{

            /* Steps to check if existing home id is not available , set it as first object of json parsed */

                var homeId = SKDatabase.getHomeId()
        
                if homeId.isEmpty {
                    
                    newHome = syncData.arrayOfHomes?[0] as! Home
                    SKDatabase.saveHomeId(homeId: newHome.home_id!)
                    homeId = SKDatabase.getHomeId()
                }
        
        
            /*  Steps to find out index of home object wrt home id  */

                for i in 0 ..< syncData.arrayOfHomes!.count {
            
                        newHome = syncData.arrayOfHomes?[i] as! Home
                    
                        let home_Id : String = newHome.home_id!
            
                        if homeId == home_Id{
                
                          indexOfHomeObjectInDB = i;
                            break
                        }
                }
        

            self.labelNameOfRoom.setText(newHome.home_name)

            dictOfArrayRoom = newHome.arrayOfRooms! as! NSArray
        
            self.setTableProperties()
        
        }
    }

    
    func setUpNotificationCentre(){
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.askForDataToiPhone),
        name: NSNotification.Name(rawValue: SendToMqttViaiPhone),
        object: nil)
    }
    
    
    @objc func askForDataToiPhone(notification:NSNotification){

        var userInfo: [String: Any] = [:]
        userInfo = notification.userInfo as! [String : Any]
        sendToiPhone(dictonary: userInfo)
    }

    
    func setTableProperties(){
        
        self.tableRooms.setNumberOfRows(dictOfArrayRoom.count, withRowType: "InterfaceCell")
        
        for x in 0 ..< dictOfArrayRoom.count {

            var row = InterfaceCell()
            row = self.tableRooms.rowController(at: x ) as! InterfaceCell
            
            row.groupTable.setBackgroundColor(UIColor(red: 25/255, green: 27/255, blue: 42/255, alpha: 1.0))
            newRoom = dictOfArrayRoom[x] as! Rooms
            row.labelRoom.setText(newRoom.room_name)
        }
        
        
        /* Below logic is for finding active devices in a home */
        var activeDevice : Int = 0
        var totalDevice : Int = 0

        for a in 0 ..< dictOfArrayRoom.count {
            
            newRoom = dictOfArrayRoom[a] as! Rooms
            
            var arrayOfSwitchBoxes = NSMutableArray()
            arrayOfSwitchBoxes = newRoom.arrayOfSwitchboxes as! NSMutableArray
            
            for b in 0 ..< arrayOfSwitchBoxes.count{
                
                let newSwitchBoxes = arrayOfSwitchBoxes.object(at: b) as! SwitchBoxes
                
                var arrayOfSwitches = NSMutableArray()
                arrayOfSwitches = newSwitchBoxes.arrayOfSwitches as! NSMutableArray

                for c in 0 ..< arrayOfSwitches.count{

                    let switches = arrayOfSwitches[c] as!Switches

                    if switches.type == 0 || switches.type == 1{

                        totalDevice = totalDevice + 1

                        if switches.status == SwitchStatusON {

                            activeDevice = activeDevice + 1
                        }
                    }
                }
            }
        }
        self.labelActiveDevices.setText(String(format: "Active devices %d/%d", activeDevice,totalDevice))

    }
    

    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        newRoom = dictOfArrayRoom[rowIndex] as! Rooms
        SKDatabase.saveRoomId(roomId: newRoom.room_id!)
        self.pushController(withName: "RoomScreen", context: nil)
    }

    
    @IBAction func switchRemoteValueChanged(_ sender: Any) {

        var valueRemote : Bool = false

        if SKDatabase.getRemoteAccess() == true {
            self.switchRemote.setBackgroundImageNamed("iRemoteAccessOn")
            valueRemote = true
        }
        else{
            self.switchRemote.setBackgroundImageNamed("iRemoteAccessOff")
            valueRemote = false
        }

        SKDatabase.saveRemoteAccess(flag: valueRemote)
        SKAPIManager.sharedInstance().sendRemoteAccess(flag: valueRemote)
    }
    
    
    @IBAction func buttonSettingClicked(_ sender: Any) {
        
        self.pushController(withName:"SettingsScreen", context: nil)
    }

    
}
