//
//  SwitchScreen.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 13/09/19.
//  Copyright © 2019 admin. All rights reserved.
//



let LIGHTON  = "lightOn";
let LIGHTOFF = "lightOff";
let FANON    = "fanOn";
let FANOFF   = "fanOff";
let MASTERSWITCHOFF   = "masterswitchOff";
let MASTERSWITCHON   = "masterswitchOn";
let iREMOTEACCESSON   = "iRemoteAccessOn";
let iREMOTEACCESSOFF   = "iRemoteAccessOff";
let CHILDLOCKOPEN   = "childlock_open";
let CHILDLOCKCLOSE   = "childlock_close";



let NOT_REQUIRED : Int = 0

import WatchKit
import Foundation

protocol sliderCellDelegate: class {
    func setUpdatedSliderValue(value:Float , tag:NSInteger)
}



class SwitchScreen: WKInterfaceController, sliderCellDelegate {

    @IBOutlet weak var switchMaster: WKInterfaceButton!
    @IBOutlet weak var switchRemote: WKInterfaceButton!
    @IBOutlet weak var buttonChildLock: WKInterfaceButton!
    @IBOutlet weak var labelSwitchName: WKInterfaceLabel!
    @IBOutlet weak var labelActiveDevices: WKInterfaceLabel!
    @IBOutlet weak var tableDevices: WKInterfaceTable!
    @IBOutlet weak var longpPressOnImage: WKLongPressGestureRecognizer!


    var swiBoxes = SwitchBoxes()
    var switches = Switches()
    var arrayOfSwitches = NSMutableArray()
    var masterSwitchStatus : Bool?


    

    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.loadView()
    }
    
    
    func loadView() {
        
        swiBoxes = SKDatabase.getSwitchBoxes()
        
        self.labelSwitchName.setText(swiBoxes.name);

        self.setRemoteAccess()
        self.setUpNotificationCentre()

        self.setMasterSwitch()
        self.setChildLock()
        self.setUpArrayForTable()
        self.setTableProperties()
    }
    
    
    func setRemoteAccess() {
        
        if SKDatabase.getRemoteAccess() == true {
            self.switchRemote.setBackgroundImageNamed(iREMOTEACCESSON)
        }
        else{
            self.switchRemote.setBackgroundImageNamed(iREMOTEACCESSOFF)
        }
    }
    
    
    func setUpNotificationCentre() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.dataFromMQTTServer),
            name: NSNotification.Name(rawValue: "SwitchScreen"),
            object: nil)
    }
    
    
    @objc func dataFromMQTTServer(notification:NSNotification){
        
        self.loadView()
    }


    func setMasterSwitch() {
        
        arrayOfSwitches.removeAllObjects()
        arrayOfSwitches = NSMutableArray()
        arrayOfSwitches = swiBoxes.arrayOfSwitches as! NSMutableArray

        switches = arrayOfSwitches[0] as! Switches
        
        if switches.status == 0 {
            self.masterSwitchStatus = false
            self.switchMaster.setBackgroundImageNamed(MASTERSWITCHOFF)
        }
        else{
            self.masterSwitchStatus = true
            self.switchMaster.setBackgroundImageNamed(MASTERSWITCHON)
        }
    }
    
    
    func setChildLock(){
        
        if SKDatabase.getChildLock() == 0 {
            self.buttonChildLock.setBackgroundImageNamed(CHILDLOCKCLOSE)
        }
        else{
            self.buttonChildLock.setBackgroundImageNamed(CHILDLOCKOPEN)
        }
    }
    
    
    func setUpArrayForTable() {
        
        /* for removing masterswitch */

        arrayOfSwitches.removeObject(at: 0)
        
        
        /* for removing type 2 devices */

        for x in 0 ..< arrayOfSwitches.count {
            
            switches = arrayOfSwitches[x] as! Switches
            
            if switches.type == 2{
            
                arrayOfSwitches.removeObject(at: x)
                break
            }
        }
        
        
        /* for removing type 3 devices */

        for y in 0 ..< arrayOfSwitches.count {
            
            switches = arrayOfSwitches[y] as! Switches
            
            if switches.type == 3{
                
                arrayOfSwitches.removeObject(at: y)
                break
            }
        }

        
        /* for finding active devices */
        
        var activeDevice : Int = 0
        let totalDevice : Int = arrayOfSwitches.count
        
        for z in 0 ..< arrayOfSwitches.count {
            
            switches = arrayOfSwitches.object(at: z) as! Switches
            
            if switches.status == SwitchStatusON {
                
                activeDevice = activeDevice + 1
            }
        }

        self.labelActiveDevices.setText(String(format: "Active devices %d/%d", activeDevice,totalDevice))
    }
        
        
    func setTableProperties() {

        self.tableDevices.setNumberOfRows(arrayOfSwitches.count, withRowType: "SwitchCell")
        for x in 0 ..< arrayOfSwitches.count {
            
            var row = SwitchCell()
            row = self.tableDevices.rowController(at: x ) as! SwitchCell
            row.groupSwitchNumber.setBackgroundColor(UIColor(red: 233/255, green: 107/255, blue: 130/255, alpha: 1.0))
            row.groupCell.setBackgroundColor(UIColor(red: 25/255, green: 27/255, blue: 42/255, alpha: 1.0))
            row.sliderBrightness.setValue(1)
            row.delegate=self
            
            
            switches = arrayOfSwitches[x] as! Switches
            
            /* switch master or switch mood is switched off*/
            
            if switches.switch_id == 0 {
                
                row.sliderBrightness.setHidden(true)
            }
            else if switches.type == 2 {
                
                row.sliderBrightness.setHidden(true)
            }
            else{
                
                /* switch button is switched off*/
                
                if (switches.type == SwitchOnOffType) && (switches.status == SwitchStatusOFF) {
                    
                    row.imageSwitch.setImageNamed(LIGHTOFF)
                    row.sliderBrightness.setHidden(true)
                }
                
                /* switch button is switched on*/

                else if (switches.type == SwitchOnOffType) && (switches.status == SwitchStatusON) {
                    
                    row.imageSwitch.setImageNamed(LIGHTON)
                    row.sliderBrightness.setHidden(true)
                }
                
                /* switch fan is switched off*/

                else if (switches.type == SwitchSpeedType) && (switches.status == SwitchStatusOFF) {
                    
                    row.imageSwitch.setImageNamed(FANOFF)
                    row.sliderBrightness.setHidden(false)
                    row.sliderBrightness.setValue(switches.position!)
                }
                
                /* switch fan is switched on*/

                else if (switches.type == SwitchSpeedType) && (switches.status == SwitchStatusON) {
                    
                    row.imageSwitch.setImageNamed(FANON)
                    row.sliderBrightness.setHidden(false)
                    row.sliderBrightness.setValue(switches.position!)
                }
                row.tagg = x
                row.labelSwitchName.setText(switches.switchbox_id)
                row.labelSwitchNumber.setText(String(format: "%d", x+1))
            }
        }
    }

    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        switches = arrayOfSwitches.object(at: rowIndex) as! Switches
        
        let jsonToBeSent = NSMutableDictionary()
        
         /* for status key */
        
        if switches.status == SwitchStatusOFF {
            jsonToBeSent.setValue(String(format: "%d",SwitchStatusON), forKey: STATUS)
        }
        else{
            jsonToBeSent.setValue(String(format: "%d",SwitchStatusOFF), forKey: STATUS)
        }
        jsonToBeSent.setValue(String(format: "%d",switches.position!) , forKey: POSITION)
        jsonToBeSent.setValue("1", forKey: SLIDE_END)
        jsonToBeSent.setValue(switches.switchbox_id, forKey: SWITCHBOX_ID)
        jsonToBeSent.setValue(String(format: "%d",switches.switch_id!), forKey: SWITCH_ID)
        jsonToBeSent.setValue(String(format: "%d",switches.type!), forKey: TYPE)
        jsonToBeSent.setValue(String(format: "%d",switches.master_mode_status!), forKey: MASTER_MODE_STATUS)
        jsonToBeSent.setValue(SKDatabase.getHomeId(), forKey: HOME_ID)
        jsonToBeSent.setValue(SKDatabase.getRoomId(), forKey: ROOM_ID)
        jsonToBeSent.setValue(String(format: "%d",switches.wattage!), forKey: WATTAGE)
        jsonToBeSent.setValue(arrayOfSwitches.count, forKey: "switchesCount")


        SKAPIManager.sharedInstance().sendSwitchStatus(dictonary: jsonToBeSent)
        self.presentController(withName: "LoaderaView", context: nil)
    }


    func setUpdatedSliderValue(value:Float , tag:NSInteger){
        
        switches = arrayOfSwitches.object(at: tag) as! Switches
        
        let jsonToBeSent = NSMutableDictionary()
        
        /* for status key */
//        if switches.status == SwitchStatusOFF {
//            jsonToBeSent.setValue(String(format: "%d",SwitchStatusON), forKey: STATUS)
//        }
//        else{
            jsonToBeSent.setValue(String(format: "%d",SwitchStatusON), forKey: STATUS)
//        }

        /* for position key */
        
        let num = NSNumber(value: value)
        let formatter : NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let sliderVal = formatter.string(from: num)!
 
        jsonToBeSent.setValue(sliderVal, forKey: POSITION)
        jsonToBeSent.setValue("1", forKey: SLIDE_END)
        jsonToBeSent.setValue(switches.switchbox_id, forKey: SWITCHBOX_ID)
        jsonToBeSent.setValue(String(format: "%d",switches.switch_id!), forKey: SWITCH_ID)
        jsonToBeSent.setValue(String(format: "%d",switches.type!), forKey: TYPE)
        jsonToBeSent.setValue(String(format: "%d",switches.master_mode_status!), forKey: MASTER_MODE_STATUS)
        jsonToBeSent.setValue(SKDatabase.getHomeId(), forKey: HOME_ID)
        jsonToBeSent.setValue(SKDatabase.getRoomId(), forKey: ROOM_ID)
        jsonToBeSent.setValue(String(format: "%d",switches.wattage!), forKey: WATTAGE)
        jsonToBeSent.setValue(arrayOfSwitches.count, forKey: "switchesCount")

        
        SKAPIManager.sharedInstance().sendSwitchStatus(dictonary: jsonToBeSent)
        self.presentController(withName: "LoaderaView", context: nil)
    }

    
    @IBAction func switchRemoteValueChanged(_ sender: Any) {
        
        var valueRemote : Bool = false
        
        if SKDatabase.getRemoteAccess() == true {
            self.switchRemote.setBackgroundImageNamed(iREMOTEACCESSON)
            valueRemote = true
        }
        else{
            self.switchRemote.setBackgroundImageNamed(iREMOTEACCESSOFF)
            valueRemote = false
        }
        
        SKDatabase.saveRemoteAccess(flag: valueRemote)
        SKAPIManager.sharedInstance().sendRemoteAccess(flag: valueRemote)
        self.presentController(withName: "LoaderaView", context: nil)
    }

    
    @IBAction func switchMasterSwitch(_ sender: Any) {
        
        switches = arrayOfSwitches.object(at: 0) as! Switches
        
        let jsonToBeSent = NSMutableDictionary()
        
        /* for status key */
        if masterSwitchStatus == false {
            jsonToBeSent.setValue(String(format: "%d",SwitchStatusON), forKey: STATUS)
        }
        else{
            jsonToBeSent.setValue(String(format: "%d",SwitchStatusOFF), forKey: STATUS)
        }
        jsonToBeSent.setValue(SKDatabase.getHomeId(), forKey: HOME_ID)
        jsonToBeSent.setValue(SKDatabase.getRoomId(), forKey: ROOM_ID)
        jsonToBeSent.setValue(switches.switchbox_id,  forKey: SWITCHBOX_ID)
        jsonToBeSent.setValue("0", forKey: SWITCH_ID)
        jsonToBeSent.setValue("1", forKey: POSITION)
        jsonToBeSent.setValue("1", forKey: SLIDE_END)
        jsonToBeSent.setValue("", forKey: TYPE)
        jsonToBeSent.setValue("", forKey: MASTER_MODE_STATUS)
        jsonToBeSent.setValue("", forKey: WATTAGE)
        jsonToBeSent.setValue(arrayOfSwitches.count, forKey: "switchesCount")

        SKAPIManager.sharedInstance().sendSwitchStatus(dictonary: jsonToBeSent)
        self.presentController(withName: "LoaderaView", context: nil)
    }
    
    
    @IBAction func buttonChildLockClicked(_ sender: Any) {
        
        let dictonary = NSMutableDictionary()
        
        dictonary.setValue(SKDatabase.getSwitchBoxId(), forKey: SWITCHBOX_ID)
        
        if SKDatabase.getChildLock() == 1 {
            dictonary.setValue(String(format: "%d",ChildLockON), forKey: CHILD_LOCK_ACTIVE)
        }
        else{
            dictonary.setValue(String(format: "%d",ChildLockOFF), forKey: CHILD_LOCK_ACTIVE)
        }
        SKAPIManager.sharedInstance().sendChildLock(dictonary: dictonary)
        self.presentController(withName: "LoaderaView", context: nil)
    }
    
    
    @IBAction func longPressCellPressed(_ sender: Any) {
        
        if WKGestureRecognizerState.ended == self.longpPressOnImage.state {
            
            let location = (sender as AnyObject).locationInObject()
            
            let yCoordinate = location.y
            
            let cellNumber : Int =  Int(yCoordinate) / Int(CellSize)
            
            print(yCoordinate)

            print(cellNumber)

            let onAction = WKAlertAction( title: "ON", style: WKAlertActionStyle.default) { () -> Void in
                
                self.switchMasterModeForIndividualSwitch(cell: cellNumber, status: true)
            }
            
            let offAction = WKAlertAction( title: "OFF", style: WKAlertActionStyle.cancel) { () -> Void in
                
                self.switchMasterModeForIndividualSwitch(cell: cellNumber, status: false)
            }
            
            let cancelAction = WKAlertAction( title: "Cancel", style: WKAlertActionStyle.cancel) { () -> Void in
                
            }
            
            let actionButtons = [cancelAction , offAction , onAction]
            
            presentAlert( withTitle: "Alert", message: "Master Mode", preferredStyle: .alert, actions: actionButtons)
        }
    }
    
    
    func switchMasterModeForIndividualSwitch(cell : NSInteger , status : Bool)  {
        
        let cellNumber : NSInteger = cell
        
        switches = arrayOfSwitches.object(at: cellNumber) as! Switches
        
        let jsonToBeSent = NSMutableDictionary()
        
        /* for status key */
        if status == false {
            jsonToBeSent.setValue(String(format: "%d",MasterModeOFF), forKey: MASTER_MODE_ACTIVE)
        }
        else{
            jsonToBeSent.setValue(String(format: "%d",MasterModeON), forKey: MASTER_MODE_ACTIVE)
        }
        jsonToBeSent.setValue(String(format: "%d",cellNumber+1), forKey: MASTER_MODE_SWITCH_ID)
        jsonToBeSent.setValue(switches.switchbox_id, forKey: SWITCHBOX_ID)
        jsonToBeSent.setValue(String(format: "%d",switches.master_mode_status!), forKey: MASTER_MODE_STATUS)
        jsonToBeSent.setValue(SKDatabase.getHomeId(), forKey: HOME_ID)
        jsonToBeSent.setValue(SKDatabase.getRoomId(), forKey: ROOMID)
        jsonToBeSent.setValue(String(format: "%d",switches.wattage!), forKey: WATTAGE)
        jsonToBeSent.setValue(String(format: "%d",switches.position!), forKey: POSITION)
        jsonToBeSent.setValue(String(format: "%d",switches.switch_id!), forKey: SWITCH_ID)
        jsonToBeSent.setValue(String(format: "%d",switches.type!), forKey: TYPE)
        jsonToBeSent.setValue(String(format: "%d",switches.status!), forKey: STATUS)
        jsonToBeSent.setValue(arrayOfSwitches.count, forKey: "switchesCount")

        SKAPIManager.sharedInstance().sendMasterMode(dictonary: jsonToBeSent)
        self.presentController(withName: "LoaderaView", context: nil)
    }
}
