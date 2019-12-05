//
//  SMQTTClient.swift
//  Skroman
//
//  Created by Sphinx Solutions on 9/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import MQTTClient
import SVProgressHUD

typealias SPublishHandler = (_ error: Error?) -> Void


class SMQTTClient: NSObject,MQTTSessionDelegate {
    var isGolbalServer : Bool? = false
    var objSession : MQTTSession?
    var sPublishHandler : SPublishHandler?
    var sSubscibeHandler : ((_ data: Data?, _ topic:String) -> Void)?
    struct Static {
        static var instance = SMQTTClient()
    }
    class func sharedInstance() -> SMQTTClient {
        
        var sharedInstance: SMQTTClient {
            
            return Static.instance
        }
        return sharedInstance
    }
    
    func closeSession(success:@escaping()->Void)
    {
        
        if(self.objSession==nil)
        {
            success()
        }
        self.objSession?.delegate=nil;
        self.objSession?.close(disconnectHandler: { (error) in
            success()
        })
    }
    
 
    
    func changeLocalToGlobalServerWithCallbackNew(globalServer : Bool ,success:@escaping(_ success : String)->Void, failure:@escaping (Error?)->Void)
    {
        SMQTTClient.sharedInstance().closeSession {
            self.isGolbalServer = globalServer;
            Static.instance = SMQTTClient();
            
            if(self.isGolbalServer)!
            {
                
                SMQTTClient.sharedInstance().connectToServerGlobal(success: { (error) in
                    if((error) != nil)
                    {
                        failure(error)
                    }else{
                        success("success")
                    }});
            }
            else
            {
                SMQTTClient.sharedInstance().connectToServerForAddingHome(success: { (error) in
                    if((error) != nil)
                    {
                        failure(error)
                        
                    }else{
                        success("success")
                    }});
            }
        }
        
    }
    
    
    
    
    override init() {
        super.init()
    }
    
    func connectToServerForHomeChange(success:@escaping( _ error:Error?)->Void){
        
        let ipAddress : String = VVBaseUserDefaults.getCurrentHomeSettingIP()
        self.objSession  = MQTTSession()
        self.objSession?.delegate = self as MQTTSessionDelegate
        self.objSession?.connect(toHost:ipAddress, port: 1883, usingSSL: false, connectHandler: { (error) in
            SSLog(message: "CONNECTED TO LOCAL SUCCESSFULLY");
            
            
            success(error)
        })
    }


        func connectToServerForAddingHome(success:@escaping(_ error:Error?)->Void){
            
            var ipAddress : String = ""
                
            ipAddress = VVBaseUserDefaults.getCurrentHomeIP()
                
            self.objSession  = MQTTSession()
                // Client ID: For MQTT connection use client id with format – “skroman-XXXXXXXXXXXX”
               // self.objSession = MQTTSession.init(clientId: "skroman-123123123123")
                self.objSession?.delegate = self as MQTTSessionDelegate
                self.objSession?.connect(toHost: ipAddress, port: 1883, usingSSL: false, connectHandler: { (error) in
                    SSLog(message: "CONNECTED TO LOCAL SUCCESSFULLY");
                    //Subscribe
    //                self.subscribeAllTopic()
                    success(error)
                })
    //        }
        }
    func connectToServer(success:@escaping(_ error:Error?)->Void)
    {
            let homeName = VVBaseUserDefaults.getCurrentHomeNAME() as String
            var homeDictonary = NSMutableDictionary()
            homeDictonary = VVBaseUserDefaults.getHomeIpDictonary()
            
            var ipAddress : String = ""
            
            if homeName.isEmpty {
                ipAddress = VVBaseUserDefaults.getCurrentHomeIP()
            }
            else{
                let ipDictonary = homeDictonary.value(forKey:homeName) as! NSDictionary
                print(ipDictonary)
                ipAddress = ipDictonary.value(forKey: VVBaseUserDefaults.getCurrentHomeID()) as! String
            }

            
            
           self.objSession  = MQTTSession()
            // Client ID: For MQTT connection use client id with format – “skroman-XXXXXXXXXXXX”
           // self.objSession = MQTTSession.init(clientId: "skroman-123123123123")
            self.objSession?.delegate = self as MQTTSessionDelegate
            self.objSession?.connect(toHost: ipAddress, port: 1883, usingSSL: false, connectHandler: { (error) in
                SSLog(message: "CONNECTED TO LOCAL SUCCESSFULLY");
                //Subscribe
//                self.subscribeAllTopic()
                success(error)
            })
//        }
    }
    
    
    func forceConnectToServerGlobal(success:@escaping(_ error:Error?)->Void)
    {
        if self.objSession != nil  && self.objSession?.status == MQTTSessionStatus.connected
        {
            SMQTTClient.sharedInstance().unsubscribe(topic: "\(VVBaseUserDefaults.getCurrentPIID())/#")
            self.objSession?.disconnect()
            self.objSession?.delegate = nil
        }
            self.objSession  = MQTTSession()
            // Client ID: For MQTT connection use client id with format – “skroman-XXXXXXXXXXXX”
           // self.objSession = MQTTSession.init(clientId: "skroman-123123123123")
            self.objSession?.delegate = self as MQTTSessionDelegate
            self.objSession?.connect(toHost: "148.66.133.252", port: 1883, usingSSL: false, connectHandler: { (error) in
                SSLog(message: "CONNECTED TO GLOBAL SUCCESSFULLY");
                //Subscribe
                self.subscribeAllTopic()
                success(error)
            })
        
        
    }
    
    func connectToServerGlobal(success:@escaping(_ error:Error?)->Void)
    {
        if(self.objSession != nil  && self.objSession?.status == MQTTSessionStatus.connected)
        {
              self.subscribeAllTopic()
            success(nil)
        }else
        {
            //NEW IP AND PORT
            //IP: 148.66.133.252
            //PORT: 2448
            //OLD IP AND PORT
            //IP: 5.189.146.172
            //PORT: 1883
            self.objSession  = MQTTSession()
            // Client ID: For MQTT connection use client id with format – “skroman-XXXXXXXXXXXX”
           // self.objSession = MQTTSession.init(clientId: "skroman-123123123123")
            self.objSession?.delegate = self as MQTTSessionDelegate
            self.objSession?.connect(toHost: "148.66.133.252", port: 1883, usingSSL: false, connectHandler: { (error) in
                SSLog(message: "CONNECTED TO GLOBAL SUCCESSFULLY");
                //Subscribe
                self.subscribeAllTopic()
                success(error)
            })
        }
        
        
    }
    
    func subscribeAllTopic()
    {
        
        if !Utility.isEmpty(val: VVBaseUserDefaults.getCurrentPIID()) {
            
            if Utility.isRestrictOperation() //GLOBAL MODE HANDLING
            {
                SMQTTClient.sharedInstance().unsubscribe(topic: "#")
                SMQTTClient.sharedInstance().subscribe(topic: "#", sSubscibeHandler: { (data, topic) in
                    SSLog(message: "**********Success GLOBAL SM_TOPIC_SUBSCRIBE_ALL********** \(topic)")
                    SSLog(message: "********Utility.getTopicNameToCheck(topic: SM_TOPIC_UPDATE_SWITCH_ACK_APP)********** \(Utility.getTopicNameToCheck(topic: SM_TOPIC_UPDATE_SWITCH_ACK_APP))")
                    if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_UPDATE_SWITCH_ACK_APP)
                    {
                        self.handleUpdateSwitchAPI(data, topic)
                    }
                    if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU)
                    {
                        self.handleSyncEverythingLocalAPI(data, topic)
                    }
                    if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_HARDWARD_MOOD_TRIGGERED_ACK)
                    {
                        self.handleTriggerHomeOrHardwareMoodAPI(data, topic)
                    }
                    if topic == SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK
                    {
                        self.handleLinkUserIdAndPIIDAPI(data, topic)
                    }
                })
            }
            else //LOCAL MODE HANDLING
            {
                SMQTTClient.sharedInstance().unsubscribe(topic: "\(VVBaseUserDefaults.getCurrentPIID())/#")
                SMQTTClient.sharedInstance().subscribe(topic: "\(VVBaseUserDefaults.getCurrentPIID())/#", sSubscibeHandler: { (data, topic) in
                    SSLog(message: "**********Success LOCAL SM_TOPIC_SUBSCRIBE_ALL********** \(topic)")
                    SSLog(message: "********Utility.getTopicNameToCheck(topic: SM_TOPIC_UPDATE_SWITCH_ACK_APP)********** \(Utility.getTopicNameToCheck(topic: SM_TOPIC_UPDATE_SWITCH_ACK_APP))")
                    if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_UPDATE_SWITCH_ACK_APP)
                    {
                        self.handleUpdateSwitchAPI(data, topic)
                    }
                    if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_SYNC_EVERYTHING_ACK)
                    {
                        self.handleSyncEverythingLocalAPI(data, topic)
                    }
                    if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_HARDWARD_MOOD_TRIGGERED_ACK)
                    {
                        self.handleTriggerHomeOrHardwareMoodAPI(data, topic)
                    }
                    if topic == SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK
                    {
                        self.handleLinkUserIdAndPIIDAPI(data, topic)
                    }
                })
            }
            
            
            
        }
    }
    
    func publishData(data:Data!,topic:String,spublishHandler: @escaping SPublishHandler)
    {
        if(self.objSession != nil && self.objSession?.status == MQTTSessionStatus.connected)
        {
            self.objSession?.publishData(data, onTopic: topic)
            
            spublishHandler(nil)
            
        }
        else
        {
            
            self.connectToServer(success: { (error) in
                spublishHandler(error)
            })
        }
    }
    
    func checkingMQTTConnectivityTimeToTime() {
        
        let dictonaryMQTT = NSMutableDictionary()

        let statusMqtt = objSession?.status

        if statusMqtt == MQTTSessionStatus.connected {

            dictonaryMQTT.setValue("connected", forKey: "connection")
        }
        else{
            dictonaryMQTT.setValue("notconnected", forKey: "connection")
        }
        NotificationCenter.default.post(name: .checkMQTTConnectivity, object: nil, userInfo: (dictonaryMQTT as! [AnyHashable : Any]))
        NotificationCenter.default.post(name: .checkMQTTSignalConnectivity, object: nil, userInfo: (dictonaryMQTT as! [AnyHashable : Any]))

    }
    
    
        func publishJson(json:NSDictionary!,topic:String,spublishHandler: @escaping SPublishHandler)
    {
        var topicCopy = self.handlePi_iDnHome_iDChange(topicName: topic)
        
        self.checkingMQTTConnectivityTimeToTime()

        //FOR GLOBAL CONNECT

        var flagGlobalConnect : Bool = false
        if VVBaseUserDefaults.getIsGlobalConnect() {
            flagGlobalConnect = true
            if !topicCopy.contains(SM_GLOBAL_PREFIX) {
                 topicCopy = SM_GLOBAL_PREFIX + topicCopy
            }
        }
        if(self.objSession != nil && self.objSession?.status == MQTTSessionStatus.connected)
        {
            SSLog(message: "***** publishJson TOPIC ***** \(topicCopy)")
            self.objSession?.publishJson(json, onTopic: topicCopy)
            spublishHandler(nil)
            
        }
        else
        {
//            self.changeLocalToGlobalServer(globalServer: flagGlobalConnect)
            self.changeLocalToGlobalServerWithCallbackNew(globalServer: flagGlobalConnect, success: { (str) in
                
            }, failure: { (error) in
                SSLog(message: "show errorrr")
                SVProgressHUD.dismiss()
                Utility.showAlertMessage(strMessage: SSLocalizedString(key: "unable_to_connect_skorman_server"))
            })
        }
        
    }
    
    func  subscribe( topic:String ,sSubscibeHandler : @escaping  (_ data: Data?, _ topic:String) -> Void) -> Void
    {
        //FOR GLOBAL CONNECT
        var topicCopy = self.handlePi_iDnHome_iDChange(topicName: topic)
        
        if topicCopy != SM_TOPIC_SUBSCRIBE_ALL
        {
            if VVBaseUserDefaults.getIsGlobalConnect() {
                if !topicCopy.contains(SM_GLOBAL_PREFIX_ACK) {
                     topicCopy = SM_GLOBAL_PREFIX_ACK + topicCopy
                }
            }
        }
       
        
        
        self.sSubscibeHandler = sSubscibeHandler
        self.objSession?.subscribe(toTopic: topicCopy, at: MQTTQosLevel.exactlyOnce)
    }
    func unsubscribe( topic:String) -> Void {
        //FOR GLOBAL CONNECT
        var topicCopy = self.handlePi_iDnHome_iDChange(topicName: topic)

        if VVBaseUserDefaults.getIsGlobalConnect() {
            if !topicCopy.contains(SM_GLOBAL_PREFIX_ACK) {
                topicCopy = SM_GLOBAL_PREFIX_ACK + topicCopy
            }
        }
        self.objSession?.unsubscribeTopic(topicCopy)
    }
    
    
    func handleEvent(_ session: MQTTSession!, event eventCode: MQTTSessionEvent, error: Error!) {
        print("handleEvent \(eventCode)")
        //        switch eventCode {
        //        case .connected:
        //            sessionConnected = true
        //        case .connectionClosed:
        //            sessionConnected = false
        //        default:
        //            sessionError = true
        //        }
    }
    
    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        print("newMessage Received \(data) on:\(topic) q\(qos) r\(retained) m\(mid)")
        var backToString = String(data: data!, encoding: String.Encoding.utf8) as String!
        print("Received \(backToString)")
        
        if((self.sSubscibeHandler) != nil)
        {
            self.sSubscibeHandler?(data,topic)
            
        }
        
    }
    
    
    private func newMessageWithFeedback(_ session:MQTTSession, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32)
    {
        let backToString = String(data: data!, encoding: String.Encoding.utf8) as String?
        print("newMessageWithFeedback \(String(describing: backToString))  ")
        
    }
    func subAckReceived(_ session: MQTTSession!, msgID: UInt16, grantedQoss qoss: [NSNumber]!) {
        //  sessionConnected = true;
        print("subAckReceived \(msgID)")
        
    }
    func  messageDelivered(_ session: MQTTSession!, msgID: UInt16) {
        print("messageDelivered \(msgID)")
        
    }
    
    
    
    func handleUpdateSwitchAPI(_ data: Data?, _ topic:String)
    {
        SSLog(message: "Success handleUpdateSwitchAPI")
        
//        let objSwitch = Switch()
//        var responseDict : NSDictionary?
        do {
            let obj = try JSONSerialization.jsonObject(with: data!, options: [])
            print(obj)
//            responseDict = obj as? NSDictionary
        } catch let error {
            print(error)
        }
        
        if let obj : Switch? = Switch.decode(data!){
            SSLog(message: "****_SWITCH_ID_**** :\(obj?.switch_id ?? -1) , ****_POSITION_****: \(obj?.position ?? -1)")
           
            
            if obj == nil{
                SSLog(message: " Check by ankit for mumbai acetech 2019 , remove once fixed from server end")
            }
            else{
                DatabaseManager.sharedInstance().updateSwitchStatus(obj!, status: obj?.status ?? 0)
                NotificationCenter.default.post(name: .handleUpdateSwitchAPISuccess, object: nil)
            }
        }
    }
    
    
    func handleRenameSwitchBoxAPI(_ data: Data?, _ topic:String)
    {
        SSLog(message: "Success handleRenameSwitchBoxAPI")
        let objSwitchBox = SwitchBox()
        var responseDict : NSDictionary?
        do {
            let obj = try JSONSerialization.jsonObject(with: data!, options: [])
            print(obj)
            responseDict = obj as? NSDictionary
        } catch let error {
            print(error)
        }
        if let switchbox_id = responseDict?.value(forKey: "unique_switchbox_id") as? String
        {
            objSwitchBox.switchbox_id =  switchbox_id
        }
        if let name = responseDict?.value(forKey: "switchbox_name") as? String
        {
            objSwitchBox.name =  name
        }
        DatabaseManager.sharedInstance().updateSwitchBoxName(switchboxNew_name: objSwitchBox.name ?? "", switchbox_id: objSwitchBox.switchbox_id ?? "")
        NotificationCenter.default.post(name: .handleRenameSwitchboxAPISuccess, object: nil)
    }
    
    func handleSyncEverythingLocalAPI(_ data: Data?, _ topic:String)
    {
        if let objSync : SyncData? = SyncData.decode(data!)
        {
            if((objSync?.syncData?.count)!>0)
            {
                //delete old data and insert new data
                DatabaseManager.sharedInstance().syncDataFormleftMenu(objSyncData: objSync!)
//               NotificationCenter.default.post(name: .defaultHomeChange, object: nil)
            }
        }
    }
    
    func handleTriggerHomeOrHardwareMoodAPI(_ data: Data?, _ topic:String)
    {
        var responseDict : NSDictionary?
        do {
            let obj = try JSONSerialization.jsonObject(with: data!, options: [])
            print(obj)
            responseDict = obj as? NSDictionary
        } catch let error {
            print(error)
        }
        
         let mood_status = responseDict?.value(forKey: "mood_status") as! Int
         let mood_id = responseDict?.value(forKey: "mood_id") as! String
        DatabaseManager.sharedInstance().updateMoodStatus(moodStatus: mood_status, moodId: mood_id)
        NotificationCenter.default.post(name: .handleMoodButtonAdded, object: nil)
        
        
//            dictonaryMQTT.setValue("notconnected", forKey: "connection")
//
//        NotificationCenter.default.post(name: .updateMoodButtonColorNotification, object: nil, userInfo: (dictonaryMQTT as! [AnyHashable : Any]))

//        NotificationCenter.default.post(name: .handleLinkUserIdAndPIIDAPISuccess, object: nil)
    }
    
    func handleLinkUserIdAndPIIDAPI(_ data: Data?, _ topic:String)
    {
         NotificationCenter.default.post(name: .handleLinkUserIdAndPIIDAPISuccess, object: nil)
    }
    
    
    
    func handlePi_iDnHome_iDChange(topicName:String) -> String{
        
        var newTopicName : String = ""

        let array = topicName.components(separatedBy: "/") as NSArray

        if array.count == 3 {

            if (topicName.contains("link_user_and_pi") || topicName.contains("sync_for_vps")){

                let topicNameFirst : String = array.object(at: 0) as! String
                let topicNameLast : String = array.lastObject as! String
                newTopicName = String(format:"%@/%@/%@",topicNameFirst,VVBaseUserDefaults.getCurrentPIID(),topicNameLast)
            }
            else if (topicName.contains("get_previous_data")){

                let topicNameFirst : String = array.object(at: 0) as! String
                let topicNameLast : String = array.lastObject as! String
                newTopicName = String(format:"%@/%@/%@",topicNameFirst,Utility.getCurrentUserId(),topicNameLast)
                }
            else{

                let topName : String = array.lastObject as! String
                newTopicName = String(format:"%@/%@/%@",VVBaseUserDefaults.getCurrentPIID(),VVBaseUserDefaults.getCurrentHomeID(),topName)
            }
        }
        else if array.count == 2{

            let topName : String = array.lastObject as! String
            newTopicName = String(format:"%@/%@",VVBaseUserDefaults.getCurrentPIID(),topName)
        }
        else{
            newTopicName = String(format:"%@",topicName)
        }

        
        return newTopicName
    }
}


