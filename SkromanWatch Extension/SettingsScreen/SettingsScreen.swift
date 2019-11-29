//
//  SettingsScreen.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 10/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import WatchKit
import Foundation


class SettingsScreen: WKInterfaceController {

    @IBOutlet weak var nameGroup: WKInterfaceGroup!
    @IBOutlet weak var imageUserIcon: WKInterfaceImage!
    @IBOutlet weak var labelName: WKInterfaceLabel!
    
    @IBOutlet weak var contactGroup: WKInterfaceGroup!
    @IBOutlet weak var labelEmail: WKInterfaceLabel!
    @IBOutlet weak var labelPhone: WKInterfaceLabel!

    @IBOutlet weak var homeGroup: WKInterfaceGroup!
    @IBOutlet weak var imageHome: WKInterfaceImage!
    @IBOutlet weak var buttonHome: WKInterfaceButton!

    @IBOutlet weak var syncGroup: WKInterfaceGroup!
    @IBOutlet weak var imageSync: WKInterfaceImage!
    @IBOutlet weak var buttonSync: WKInterfaceButton!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.setUpUserDetails()
        
        self.setUpNotificationCentre()
        
        self.nameGroup.setBackgroundColor(UIColor(red: 44/255, green: 45/255, blue: 63/255, alpha: 1.0))
        self.contactGroup.setBackgroundColor(UIColor(red: 56/255, green: 59/255, blue: 78/255, alpha: 1.0))
        self.homeGroup.setBackgroundColor(UIColor(red: 44/255, green: 45/255, blue: 63/255, alpha: 1.0))
        self.syncGroup.setBackgroundColor(UIColor(red: 56/255, green: 59/255, blue: 78/255, alpha: 1.0))

    }
    

    func setUpNotificationCentre() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.dataReceivedFromiPhone),
            name: NSNotification.Name(rawValue: "SettingsScreen"),
            object: nil)
    }
    
    
    @objc func dataReceivedFromiPhone(notification:NSNotification){
        
        self.setUpUserDetails()
    }


    func setUpUserDetails() {
        
        var dictonaryUser = NSMutableDictionary()
        dictonaryUser = SKDatabase.getUserInformation()
        
        if dictonaryUser.value(forKey: NAME) != nil && dictonaryUser.value(forKey: EMAIL) != nil && dictonaryUser.value(forKey: PHONE) != nil {
            
            self.labelName.setText(dictonaryUser.value(forKey: NAME) as? String)
            self.labelEmail.setText(dictonaryUser.value(forKey: EMAIL) as? String)
            self.labelPhone.setText(dictonaryUser.value(forKey: PHONE) as? String)
        }
        else{
            
            let dictonary:NSDictionary = [ "sendUpdatedJson" : "getUserInformation" ]
            SKAPIManager.sharedInstance().getUserInfo(dictonary: dictonary)
        }
    }
    
    
    @IBAction func buttonHomeClicked(sender: Any) {
        
        self.pushController(withName: "HomeListScreen", context: nil)
    }

    
    @IBAction func buttonSyncClicked(sender: Any) {

        let dictonary:NSDictionary = [ "sendUpdatedJson" : "sendUpdatedJson" ]
        
        SKDatabase.saveRemoteAccess(flag: false)
        SKAPIManager.sharedInstance().sendRemoteAccess(flag: false)
        self.pushController(withName: "InterfaceController", context: dictonary)
    }
}
