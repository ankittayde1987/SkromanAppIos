

import UIKit
import ReachabilitySwift
import AVFoundation
import TWMessageBarManager
import SystemConfiguration
import SVProgressHUD

private var duration: CGFloat = 2.0
class Utility: NSObject {
    class func isEmpty(val: String?) -> Bool {
        if  (val == "(null)") == false && (val == "<null>") == false && (val == "") == false && val?.isEqual(NSNull()) == false {
            return false
        }
        else {
            return true
        }
    }
    
    class func isInternetAvailable() -> Bool
    {
        if let reachability = Reachability() {
            if reachability.isReachable {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    class func isSystemGreaterThaniOS8() -> Bool {
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v: "8.0") {
            return true
        }
        else {
            return false
        }
    }
    class func getCustomImageFromPath(image : String) -> UIImage
    {
        var imagToShow = UIImage()
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(image)
            let image    = UIImage(contentsOfFile: imageURL.path)
            // Do whatever you want with the image
            if image != nil
            {
                imagToShow = image!
            }
            
        }
        return imagToShow
    }
    class func isRequestAccessForCamera() -> Bool {
        var allow: Bool = false
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .authorized {
            allow = true
            // NSLog("AVAuthorizationStatusAuthorized access to %@", AVMediaTypeVideo)
        }
        else if authStatus == .denied {
            // denied
            //NSLog("AVAuthorizationStatusDenied access to %@", AVMediaTypeVideo)
        }
        else if authStatus == .restricted {
            // restricted, normally won't happen
            //NSLog("AVAuthorizationStatusRestricted access to %@", AVMediaTypeVideo)
        }
        else if authStatus == .notDetermined {
            // not determined?!
            //SSLog("AVAuthorizationStatusNotDetermined access to %@", AVMediaTypeVideo)
        }
        
        return allow
    }
    
    class func isEmailValid(_ emailId: String) -> Bool {
        let emailRegex: String = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        let res: Bool = emailTest.evaluate(with: emailId)
        return res
    }
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    class func JSONValue(object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    class func validate(phoneNumber: String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }
    class func isImageNull(_ imageName : UIImage)-> Bool
    {
        
        let size = CGSize(width: 0, height: 0)
        if (imageName.size.width == size.width)
        {
            return true
        }
        return false
    }
    class  func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) min ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 min ago"
            } else {
                return "A min ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    class func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    class func showErrorNativeMessage(error : Error?) {
        
        Utility.showMessage(withTitle: SSError.getErrorMessage(error), message: "", type: TWMessageBarMessageType.error)
    }
    class func showMessage(withTitle title: String, message: String, type: TWMessageBarMessageType) {
        TWMessageBarManager.sharedInstance()
        TWMessageBarManager.sharedInstance().showMessage(withTitle: title, description: message, type: type, duration: duration)
    }
    class func showErrorMessage(withTitle title: String, message: String) {
        TWMessageBarManager.sharedInstance()
        TWMessageBarManager.sharedInstance().showMessage(withTitle: title, description: message, type: TWMessageBarMessageType.error, duration: duration)
    }
    class func isAllowToMakeAPICall() -> Bool
    {
        var isAllowToMakeAPICall : Bool = false
        if !VVBaseUserDefaults.getIsGlobalConnect()
        {
            if VVBaseUserDefaults.getCurrentSSID() == SSID.fetchSSIDInfo()
            {
                isAllowToMakeAPICall = true
            }
        }
        else{
          isAllowToMakeAPICall = true
        }
       
        return true
    }
    
    
    class func isSkromanWifiConnected(connect : Bool , flag : Int ) -> Bool
    {
        if flag == 0 {
            self.checkMQTTConnection()
        }
        return connect
    }
    
    class func checkMQTTConnection(){
        
        SMQTTClient.sharedInstance().connectToServer(success: { (error) in
            if((error) != nil){
                self.checkedConnection(val: false)
            }else{
                self.checkedConnection(val: true)
            }});
    }
    
    class func checkedConnection(val : Bool){
        
        let value : Bool =  self.isSkromanWifiConnected(connect: val, flag: 1)
        print(value)
    }

    
    
    class func getCurrentUserId() -> String{
        var strUserId: String = ""
        strUserId = VVBaseUserDefaults.getStringForKey(KEY_USER_ID)
        return strUserId
    }
    
    
    class func getUndlinedText(_ text: String ) -> NSMutableAttributedString {
        
        let commentString = NSMutableAttributedString(string: text)
        
        commentString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: commentString.length))
        
        return commentString
    }
    

    
    class func logoutFromApp()
    {
        
        //        User.setAsCurrentUser(obj: User())
        UIAppDelegate.navigateToLoginScreen()
    }
    
    class func getSSIDFromQRCodeString(_ qrcode: String) -> String
    {
        //ssid:%@-pwd:%@
        let arr = qrcode.components(separatedBy: "-")
        if(arr.count>0)
        {
            return arr[0].replacingOccurrences(of: "ssid:", with: "");
        }
        return "";
    }
    class func getSDDIPasswordFromQRCodeString(_ qrcode: String) -> String
    {
        //ssid:%@-pwd:%@
        let arr = qrcode.components(separatedBy: "-")
        if(arr.count>1)
        {
            return arr[1].replacingOccurrences(of: "pwd:", with: "");
        }
        return "";
    }
    
    
    class func createAJsonForDeviceOrHomeMoodSeeting(controllerArray: [RoomDetailForMoodSettingViewController],objMoodToEdit : Mood, objMoodWrapper: MoodWrapper,moodTypeForHomeOrDevice : Int) -> NSMutableDictionary
    {
        SSLog(message: "CreateFinalJSONHear")
        var allRoomSwitchBoxes = [SwitchBox]()
        controllerArray.forEach { (cnt) in
            let switchBoxesInCnt = cnt.getCurrentStatusOfRoom()
            for switchBox in switchBoxesInCnt
            {
                let addSwitchBox = Utility.addCurrentSwitchBoxOrNot(objSwitchBox: switchBox)
                if addSwitchBox
                {
                    allRoomSwitchBoxes.append(switchBox)
                }
            }
        }
        
        //Main Dict
        let moodDict = NSMutableDictionary()
        
        //Temporary for MoodID
        if !Utility.isEmpty(val: objMoodToEdit.mood_id)
        {
            moodDict.setValue(objMoodToEdit.mood_id, forKey: "mood_id")
        }
        
        //For Mood Status
        if !Utility.isEmpty(val: "\(objMoodToEdit.mood_status)")
        {
            moodDict.setValue(objMoodToEdit.mood_status, forKey: "mood_status")
        }
        
        //for mood name
        moodDict.setValue(objMoodWrapper.mood_id, forKey: "mood_id")
        
        //for mood name
        moodDict.setValue(objMoodWrapper.mood_name, forKey: "mood_name")
        
        //for mood time
        if !Utility.isEmpty(val: objMoodWrapper.mood_time)
        {
            moodDict.setValue(objMoodWrapper.mood_time, forKey: "mood_time")
        }
        else
        {
            moodDict.setValue("", forKey: "mood_time")
        }
        
        
        //for mood repeat
        moodDict.setValue(objMoodWrapper.arraySelectedDaysForMoodRepeat, forKey: "mood_repeat")
        
        //For mood_type
        moodDict.setValue(moodTypeForHomeOrDevice, forKey: "mood_type")
        
        //FOR SWITCH BOXES
        let switchBoxesArray = NSMutableArray()
        //MAIN DICT
        
        for switchBox in allRoomSwitchBoxes
        {
            let switchBoxDict = NSMutableDictionary()
            switchBox.removeMasterSwitchFromMoods()
            switchBox.moods?.insert(switchBox.masterSwitch!, at: 0)
            
            //For  switchbox_id
            var switchbox_id : String?
            switchbox_id = switchBox.switchbox_id
            switchBoxDict.setValue(switchbox_id, forKey: "switchbox_id")
            
            //For switch_id Array comma seprated
            let arrSwitchBoxIds = NSMutableArray()
            for objMood in switchBox.moods!
            {
                //				arrSwitchBoxIds.add(String(format:"%d",objMood.switch_id!))
                arrSwitchBoxIds.add(objMood.switch_id!)
            }
            switchBoxDict.setValue(arrSwitchBoxIds, forKey: "switch_id")
            
            //For status Array comma seprated
            let arrSwitchstatus = NSMutableArray()
            for objMood in switchBox.moods!
            {
                //				arrSwitchstatus.add(String(format:"%d",objMood.status))
                arrSwitchstatus.add(objMood.status)
            }
            switchBoxDict.setValue(arrSwitchstatus, forKey: "status")
            
            
            //For position Array comma seprated
            let arrSwitchposition = NSMutableArray()
            for objMood in switchBox.moods!
            {
                //				arrSwitchposition.add(String(format:"%d",objMood.position))
                arrSwitchposition.add(objMood.position)
            }
            switchBoxDict.setValue(arrSwitchposition, forKey: "position")
            
            switchBoxesArray.add(switchBoxDict)
        }
        moodDict.setValue(switchBoxesArray, forKey: "mood")
        //Need Help Sapanesh Sir
        SSLog(message: "Mood Dictionary To Send :")
         SSLog(message: moodDict)
        
        
        return moodDict
    }
    
    class func addCurrentSwitchBoxOrNot(objSwitchBox : SwitchBox) -> Bool
    {
        var isFound : Bool = false
        var foundIndex : Int = 0
        for currentIndex in 0..<(objSwitchBox.moods?.count)! {
            let obj = objSwitchBox.moods![currentIndex]
            if obj.status == 1
            {
                isFound = true
                foundIndex = currentIndex
                break
            }
        }
        return isFound
    }
    
    class func getTopicNameToCheck(topic : String) -> String{
        var topicCopy: String = topic
        if VVBaseUserDefaults.getIsGlobalConnect() {
            topicCopy = SM_GLOBAL_PREFIX_ACK + topicCopy
        }
        return topicCopy
    }
    
    
    class func showAlertMessage(strMessage : String){
        let alert = UIAlertController(title: APP_NAME_TITLE as String?, message: strMessage as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: SSLocalizedString(key: "ok"), style: UIAlertActionStyle.default, handler: nil))
        alert.show()
    }

    
    class func deleteEveryThingAPICall()
    {
        SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_DELETE_EVERYTHING_ACK) { (data, topic) in
            SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_DELETE_EVERYTHING_ACK)
            if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_DELETE_EVERYTHING_ACK)
            {
                SSLog(message: data)
                SSLog(message: "SUCCESSS")
                //DeleteEverythingFrom DataBase
                DatabaseManager.sharedInstance().deleteAllTableData()
            }
        }
        let dict =  NSMutableDictionary()
        dict.setValue(VVBaseUserDefaults.getCurrentPIID(), forKey: "pi_id");
        
        print("switchdata \(dict)")
        
        SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_DELETE_EVERYTHING) { (error) in
            print("error :\(String(describing: error))")
            if((error) != nil)
            {
                Utility.showErrorAccordingToLocalAndGlobal()
            }
        }

    }

    class func getJsonToShare()->NSMutableDictionary{
        //Main Dict
        let mainDictionary = NSMutableDictionary()
        //Array syncData
        let arrHomesFromDB = DatabaseManager.sharedInstance().getAllHomes() as! [Home]
        let syncData = NSMutableArray()
        for homeObj in arrHomesFromDB
        {
            //For each Home
            let homeDict = NSMutableDictionary()
            //For  home_id
            if !Utility.isEmpty(val: homeObj.home_id)
            {
                homeDict.setValue(homeObj.home_id, forKey: "home_id")
            }
            //For  home_name
            if !Utility.isEmpty(val: homeObj.home_name)
            {
                homeDict.setValue(homeObj.home_name, forKey: "home_name")
            }
            
            //Get Rooms For Home Form DB
            let arrRoomsFromDB = DatabaseManager.sharedInstance().getAllRoomWithHomeID(home_id: homeObj.home_id!) as! [Room]
            //Check whethere you get Rooms
            if arrRoomsFromDB.count > 0 && arrRoomsFromDB.isEmpty == false
            {
                let roomsArray = NSMutableArray()
                for roomObj in arrRoomsFromDB
                {
                    let roomDict = NSMutableDictionary()
                    //For  home_id
                    if !Utility.isEmpty(val: roomObj.home_id)
                    {
                        roomDict.setValue(roomObj.home_id, forKey: "home_id")
                    }
                    //For  room_id
                    if !Utility.isEmpty(val: roomObj.room_id)
                    {
                        roomDict.setValue(roomObj.room_id, forKey: "room_id")
                    }
                    //For  room_name
                    if !Utility.isEmpty(val: roomObj.room_name)
                    {
                        roomDict.setValue(roomObj.room_name, forKey: "room_name")
                    }
                    //For  image
                    if !Utility.isEmpty(val: roomObj.image)
                    {
                        roomDict.setValue(roomObj.image, forKey: "image")
                    }
                    //Get Rooms For Home From DB
                    let arrSwitchboxesInRoomsFromDB = DatabaseManager.sharedInstance().getAllSwitchBoxesWithRoomID(room_id: roomObj.room_id!) as! [SwitchBox]
                    
                    //Check whethere you get SwitchBoxes
                    if arrSwitchboxesInRoomsFromDB.count > 0 && arrSwitchboxesInRoomsFromDB.isEmpty == false
                    {
                        let switchboxesArray = NSMutableArray()
                        for switchBoxObj in arrSwitchboxesInRoomsFromDB
                        {
                            let switchBoxDict = NSMutableDictionary()
                            //For  room_id
                            if !Utility.isEmpty(val: switchBoxObj.room_id)
                            {
                                switchBoxDict.setValue(switchBoxObj.room_id, forKey: "room_id")
                            }
                            //For  switchbox_id
                            if !Utility.isEmpty(val: switchBoxObj.switchbox_id)
                            {
                                switchBoxDict.setValue(switchBoxObj.switchbox_id, forKey: "switchbox_id")
                            }
                            //For  mac_address
                            if !Utility.isEmpty(val: switchBoxObj.mac_address)
                            {
                                switchBoxDict.setValue(switchBoxObj.mac_address, forKey: "mac_address")
                            }
                            //For  child_lock
                            if switchBoxObj.child_lock != nil
                            {
                                switchBoxDict.setValue(switchBoxObj.child_lock, forKey: "child_lock")
                            }
                            //for name
                            if !Utility.isEmpty(val: switchBoxObj.name)
                            {
                                switchBoxDict.setValue(switchBoxObj.name, forKey: "name")
                            }
                            
                            //Get Switches From SwitchBox
                            let arrSwitchesFromSwitchBoxFromDB = DatabaseManager.sharedInstance().getAllSwitchWithSwitchBoxID(switchbox_id: switchBoxObj.switchbox_id!) as! [Switch]
                            
                            //Check whethere you get Switches
                            if arrSwitchesFromSwitchBoxFromDB.count > 0 && arrSwitchesFromSwitchBoxFromDB.isEmpty == false
                            {
                                let switchesArray = NSMutableArray()
                                for switchObj in arrSwitchesFromSwitchBoxFromDB
                                {
                                    //For Switch
                                    let switchDict = NSMutableDictionary()
                                    //For  switchbox_id
                                    if !Utility.isEmpty(val: switchObj.switchbox_id)
                                    {
                                        switchDict.setValue(switchObj.switchbox_id, forKey: "switchbox_id")
                                    }
                                    //For switch_id
                                    if switchObj.switch_id != nil
                                    {
                                        switchDict.setValue(switchObj.switch_id, forKey: "switch_id")
                                    }
                                    //For type
                                    if switchObj.type != nil
                                    {
                                        switchDict.setValue(switchObj.type, forKey: "type")
                                    }
                                    //For status
                                    if switchObj.status != nil
                                    {
                                        switchDict.setValue(switchObj.status, forKey: "status")
                                    }
                                    //For position
                                    if switchObj.position != nil
                                    {
                                        switchDict.setValue(switchObj.position, forKey: "position")
                                    }
                                    //For master_mode_status
                                    if switchObj.master_mode_status != nil
                                    {
                                        switchDict.setValue(switchObj.master_mode_status, forKey: "master_mode_status")
                                    }
                                    
                                    switchesArray.add(switchDict)
                                }
                                //Adding Switch in switches Array
                                switchBoxDict.setValue(switchesArray, forKey: "switches")
                            }
                            
                            //Get Moods From SwitchBox
                            let arrMoodsFromSwitchBoxFromDB = DatabaseManager.sharedInstance().getAllMoodWithSwitchboxId(switchbox_id: switchBoxObj.switchbox_id!) as! [Mood]
                            
                            //Check whethere you get Moods
                            if arrMoodsFromSwitchBoxFromDB.count > 0 && arrMoodsFromSwitchBoxFromDB.isEmpty == false
                            {
                                let moodsArray = NSMutableArray()
                                for moodObj in arrMoodsFromSwitchBoxFromDB
                                {
                                    //For Switch
                                    let moodDict = NSMutableDictionary()
                                    //For  switchbox_id
                                    if !Utility.isEmpty(val: moodObj.switchbox_id)
                                    {
                                        moodDict.setValue(moodObj.switchbox_id, forKey: "switchbox_id")
                                    }
                                    //For  home_id
                                    if !Utility.isEmpty(val: moodObj.home_id)
                                    {
                                        moodDict.setValue(moodObj.home_id, forKey: "home_id")
                                    }
                                    //For  mood_id
                                    if !Utility.isEmpty(val: moodObj.mood_id)
                                    {
                                        moodDict.setValue(moodObj.mood_id, forKey: "mood_id")
                                    }
                                    //For  mood_name
                                    if !Utility.isEmpty(val: moodObj.mood_name)
                                    {
                                        moodDict.setValue(moodObj.mood_name, forKey: "mood_name")
                                    }
                                    //For  mood_time
                                    if !Utility.isEmpty(val: moodObj.mood_time)
                                    {
                                        moodDict.setValue(moodObj.mood_time, forKey: "mood_time")
                                    }
                                    //For mood_repeat
                                    if moodObj.mood_repeat.count > 0
                                    {
                                        moodDict.setValue(moodObj.mood_repeat, forKey: "mood_repeat")
                                    }
                                    //For switch_id
                                    if moodObj.switch_id != nil
                                    {
                                        moodDict.setValue(moodObj.switch_id, forKey: "switch_id")
                                    }
                                    //For mood_type
                                    moodDict.setValue(moodObj.mood_type, forKey: "mood_type")
                                    //For status
                                    moodDict.setValue(moodObj.status, forKey: "status")
                                    //For position
                                    moodDict.setValue(moodObj.position, forKey: "position")
                                    //For mood_status
                                    moodDict.setValue(moodObj.mood_status, forKey: "mood_status")
                                    
                                    //Append Mood in MoodArray
                                    moodsArray.add(moodDict)
                                }
                                //Adding Moods in moods Array
                                switchBoxDict.setValue(moodsArray, forKey: "moods")
                            }
                            //Adding SwitchBox in switchboxes Array
                            switchboxesArray.add(switchBoxDict)
                        }
                        //Add switchboxes in Room
                        roomDict.setValue(switchboxesArray, forKey: "switchboxes")
                    }
                    roomsArray.add(roomDict)
                }
                //Add all rooms in homeDict
                homeDict.setValue(roomsArray, forKey: "rooms")
            }
            //Add each home to SyncData Array
            syncData.add(homeDict)
        }
        //Added sync data to main dict
        mainDictionary.setValue(syncData, forKey: "syncData")
        mainDictionary.setValue(VVBaseUserDefaults.getCurrentPIID(), forKey: "pi_id")
        mainDictionary.setValue(Utility.getCurrentUserId(), forKey: "user_id")

        SSLog(message: "FinalDict ::: \(mainDictionary)")
        return mainDictionary
    }

    class func createAJsonToShare()
    {
        //Main Dict
        let mainDictionary = NSMutableDictionary()
        //Array syncData
        let arrHomesFromDB = DatabaseManager.sharedInstance().getAllHomes() as! [Home]
        let syncData = NSMutableArray()
        for homeObj in arrHomesFromDB
        {
            //For each Home
            let homeDict = NSMutableDictionary()
            //For  home_id
            if !Utility.isEmpty(val: homeObj.home_id)
            {
                homeDict.setValue(homeObj.home_id, forKey: "home_id")
            }
            //For  home_name
            if !Utility.isEmpty(val: homeObj.home_name)
            {
                homeDict.setValue(homeObj.home_name, forKey: "home_name")
            }
            
            //Get Rooms For Home Form DB
            let arrRoomsFromDB = DatabaseManager.sharedInstance().getAllRoomWithHomeID(home_id: homeObj.home_id!) as! [Room]
            //Check whethere you get Rooms
            if arrRoomsFromDB.count > 0 && arrRoomsFromDB.isEmpty == false
            {
                let roomsArray = NSMutableArray()
                for roomObj in arrRoomsFromDB
                {
                    let roomDict = NSMutableDictionary()
                    //For  home_id
                    if !Utility.isEmpty(val: roomObj.home_id)
                    {
                        roomDict.setValue(roomObj.home_id, forKey: "home_id")
                    }
                    //For  room_id
                    if !Utility.isEmpty(val: roomObj.room_id)
                    {
                        roomDict.setValue(roomObj.room_id, forKey: "room_id")
                    }
                    //For  room_name
                    if !Utility.isEmpty(val: roomObj.room_name)
                    {
                        roomDict.setValue(roomObj.room_name, forKey: "room_name")
                    }
                    //For  image
                    if !Utility.isEmpty(val: roomObj.image)
                    {
                        roomDict.setValue(roomObj.image, forKey: "image")
                    }
                    //Get Rooms For Home From DB
                    let arrSwitchboxesInRoomsFromDB = DatabaseManager.sharedInstance().getAllSwitchBoxesWithRoomID(room_id: roomObj.room_id!) as! [SwitchBox]
                    
                    //Check whethere you get SwitchBoxes
                    if arrSwitchboxesInRoomsFromDB.count > 0 && arrSwitchboxesInRoomsFromDB.isEmpty == false
                    {
                        let switchboxesArray = NSMutableArray()
                        for switchBoxObj in arrSwitchboxesInRoomsFromDB
                        {
                            let switchBoxDict = NSMutableDictionary()
                            //For  room_id
                            if !Utility.isEmpty(val: switchBoxObj.room_id)
                            {
                                switchBoxDict.setValue(switchBoxObj.room_id, forKey: "room_id")
                            }
                            //For  switchbox_id
                            if !Utility.isEmpty(val: switchBoxObj.switchbox_id)
                            {
                                switchBoxDict.setValue(switchBoxObj.switchbox_id, forKey: "switchbox_id")
                            }
                            //For  mac_address
                            if !Utility.isEmpty(val: switchBoxObj.mac_address)
                            {
                                switchBoxDict.setValue(switchBoxObj.mac_address, forKey: "mac_address")
                            }
                            //For  child_lock
                            if switchBoxObj.child_lock != nil
                            {
                                switchBoxDict.setValue(switchBoxObj.child_lock, forKey: "child_lock")
                            }
                            //for name
                            if !Utility.isEmpty(val: switchBoxObj.name)
                            {
                                switchBoxDict.setValue(switchBoxObj.name, forKey: "name")
                            }
                            
                            //Get Switches From SwitchBox
                            let arrSwitchesFromSwitchBoxFromDB = DatabaseManager.sharedInstance().getAllSwitchWithSwitchBoxID(switchbox_id: switchBoxObj.switchbox_id!) as! [Switch]
                            
                            //Check whethere you get Switches
                            if arrSwitchesFromSwitchBoxFromDB.count > 0 && arrSwitchesFromSwitchBoxFromDB.isEmpty == false
                            {
                                let switchesArray = NSMutableArray()
                                for switchObj in arrSwitchesFromSwitchBoxFromDB
                                {
                                    //For Switch
                                    let switchDict = NSMutableDictionary()
                                    //For  switchbox_id
                                    if !Utility.isEmpty(val: switchObj.switchbox_id)
                                    {
                                        switchDict.setValue(switchObj.switchbox_id, forKey: "switchbox_id")
                                    }
                                    //For switch_id
                                    if switchObj.switch_id != nil
                                    {
                                        switchDict.setValue(switchObj.switch_id, forKey: "switch_id")
                                    }
                                    //For type
                                    if switchObj.type != nil
                                    {
                                        switchDict.setValue(switchObj.type, forKey: "type")
                                    }
                                    //For status
                                    if switchObj.status != nil
                                    {
                                        switchDict.setValue(switchObj.status, forKey: "status")
                                    }
                                    //For position
                                    if switchObj.position != nil
                                    {
                                        switchDict.setValue(switchObj.position, forKey: "position")
                                    }
                                    //For master_mode_status
                                    if switchObj.master_mode_status != nil
                                    {
                                        switchDict.setValue(switchObj.master_mode_status, forKey: "master_mode_status")
                                    }
                                    
                                    switchesArray.add(switchDict)
                                }
                                //Adding Switch in switches Array
                                switchBoxDict.setValue(switchesArray, forKey: "switches")
                            }
                            
                            //Get Moods From SwitchBox
                            let arrMoodsFromSwitchBoxFromDB = DatabaseManager.sharedInstance().getAllMoodWithSwitchboxId(switchbox_id: switchBoxObj.switchbox_id!) as! [Mood]
                            
                            //Check whethere you get Moods
                            if arrMoodsFromSwitchBoxFromDB.count > 0 && arrMoodsFromSwitchBoxFromDB.isEmpty == false
                            {
                                let moodsArray = NSMutableArray()
                                for moodObj in arrMoodsFromSwitchBoxFromDB
                                {
                                    //For Switch
                                    let moodDict = NSMutableDictionary()
                                    //For  switchbox_id
                                    if !Utility.isEmpty(val: moodObj.switchbox_id)
                                    {
                                        moodDict.setValue(moodObj.switchbox_id, forKey: "switchbox_id")
                                    }
                                    //For  home_id
                                    if !Utility.isEmpty(val: moodObj.home_id)
                                    {
                                        moodDict.setValue(moodObj.home_id, forKey: "home_id")
                                    }
                                    //For  mood_id
                                    if !Utility.isEmpty(val: moodObj.mood_id)
                                    {
                                        moodDict.setValue(moodObj.mood_id, forKey: "mood_id")
                                    }
                                    //For  mood_name
                                    if !Utility.isEmpty(val: moodObj.mood_name)
                                    {
                                        moodDict.setValue(moodObj.mood_name, forKey: "mood_name")
                                    }
                                    //For  mood_time
                                    if !Utility.isEmpty(val: moodObj.mood_time)
                                    {
                                        moodDict.setValue(moodObj.mood_time, forKey: "mood_time")
                                    }
                                    //For mood_repeat
                                    if moodObj.mood_repeat.count > 0
                                    {
                                        moodDict.setValue(moodObj.mood_repeat, forKey: "mood_repeat")
                                    }
                                    //For switch_id
                                    if moodObj.switch_id != nil
                                    {
                                        moodDict.setValue(moodObj.switch_id, forKey: "switch_id")
                                    }
                                    //For mood_type
                                    moodDict.setValue(moodObj.mood_type, forKey: "mood_type")
                                    //For status
                                    moodDict.setValue(moodObj.status, forKey: "status")
                                    //For position
                                    moodDict.setValue(moodObj.position, forKey: "position")
                                    //For mood_status
                                    moodDict.setValue(moodObj.mood_status, forKey: "mood_status")
                                    
                                    //Append Mood in MoodArray
                                    moodsArray.add(moodDict)
                                }
                                //Adding Moods in moods Array
                                switchBoxDict.setValue(moodsArray, forKey: "moods")
                            }
                            //Adding SwitchBox in switchboxes Array
                            switchboxesArray.add(switchBoxDict)
                        }
                        //Add switchboxes in Room
                        roomDict.setValue(switchboxesArray, forKey: "switchboxes")
                    }
                    roomsArray.add(roomDict)
                }
                //Add all rooms in homeDict
                homeDict.setValue(roomsArray, forKey: "rooms")
            }
            //Add each home to SyncData Array
            syncData.add(homeDict)
        }
        //Added sync data to main dict
        mainDictionary.setValue(syncData, forKey: "syncData")
        
        SSLog(message: "FinalDict ::: \(mainDictionary)")
        
        
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: mainDictionary,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
        }
        
        
    }
    
    
    
    class func isIpad() -> Bool{
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            return true
        }
        else
        {
            return false
        }
    }
    class func getNibNameForClass(class_name : String) -> String
    {
        if isIpad()
        {
            return "\(class_name)_iPad"
        }
        else
        {
            return "\(class_name)"
        }
    }
    class func insertEnergyDataFromTemporaryJSONFile()
    {
        //Temporary get energy data from json file and add
        DatabaseManager.sharedInstance().deleteEnergyData()
        let energyWrapper : EnergyDataWrapper? =  Utility.getEnergyConsumptionDataFromJsonFile()
        if let eneryDatawrapper = energyWrapper
        {
            DatabaseManager.sharedInstance().insertEnergyData(objEnergyDataWrapper: eneryDatawrapper)
        }
    }
    class func getEnergyConsumptionDataFromJsonFile() -> EnergyDataWrapper
    {
        let energyDataWrapper = EnergyDataWrapper()
        let filePath: String? = Bundle.main.path(forResource: "energy_data", ofType: "json")
        let localFileURL = URL.init(fileURLWithPath: filePath!)
        
        do {
            let contentOfLocalFile = try Data(contentsOf: localFileURL)
            print(contentOfLocalFile)
            let dictResponse = try JSONSerialization.jsonObject(with: contentOfLocalFile) as? NSDictionary
            let dictResponseForEnergyData = dictResponse?.value(forKey: "energy_data") as? NSDictionary
            let list : NSArray = dictResponseForEnergyData?.value(forKey: "energy_data") as! NSArray
            
            var arr = Array<EnergyData> ()
            for dict in list {
                print(dict)
                let dictEnergyData = dict as! NSDictionary
                let obj : EnergyData = EnergyData()
               
                if let week_start_date =  dictEnergyData["week_start_date"]{
                    obj.week_start_date = week_start_date as? String
                }
                
                let listOfSwitchBox : NSArray = dictEnergyData.value(forKey: "switchbox") as! NSArray
                var arrSwitchBox = Array<SwitchBox> ()
                for dict in listOfSwitchBox
                {
                    let dictSwitchBox = dict as! NSDictionary
                    let objSwitchBox : SwitchBox = SwitchBox()
                    
                    if let switchbox_id =  dictSwitchBox["switchbox_id"]{
                        objSwitchBox.switchbox_id = switchbox_id as? String
                    }
                    
                    let listOfSwitch : NSArray = dictSwitchBox.value(forKey: "switches") as! NSArray
                    var arrSwitch = Array<Switch> ()
                    for dict in listOfSwitch
                    {
                        let dictSwitch = dict as! NSDictionary
                        let objSwitch : Switch = Switch()
                        
                        if let switch_id =  dictSwitch["switch_id"]{
                            objSwitch.switch_id = switch_id as? Int
                        }
                        
                        if let kw =  dictSwitch["kw"]{
                            objSwitch.wattage = kw as? Double
                        }
                        arrSwitch.append(objSwitch)
                    }
                    objSwitchBox.switches = arrSwitch
                    arrSwitchBox.append(objSwitchBox)
                }
                obj.switchbox = arrSwitchBox
                arr.append(obj)
            }
            energyDataWrapper.energy_data = arr
        } catch {
            print(error)
        }
        return energyDataWrapper
        
    }
    //ENERGY DATA COMMENT
//   class func getEnergyConsumptionDataFromJsonFile() -> EnergyData
//   {
//    let energyData = EnergyData()
//        let filePath: String? = Bundle.main.path(forResource: "energy_data", ofType: "json")
//        let localFileURL = URL.init(fileURLWithPath: filePath!)
//
//        do {
//            let contentOfLocalFile = try Data(contentsOf: localFileURL)
//            print(contentOfLocalFile)
//            let dictResponse = try JSONSerialization.jsonObject(with: contentOfLocalFile) as? NSDictionary
//            //print(dictResponse!)
//            let list : NSArray = dictResponse?.value(forKey: "energy_data") as! NSArray
//            // print(dictResponse!)
//
//            var arr = Array<Switch> ()
//            for dict in list {
//                print(dict)
//                let dictSwitch = dict as! NSDictionary
//                let obj : Switch = Switch()
////                if let _id = dictSwitch["_id"]{
////                    obj._id = _id as? String
////                }
//                if let switchbox_id =  dictSwitch["switchbox_id"]{
//                    obj.switchbox_id = switchbox_id as? String
//                }
//
//                if let switch_id = dictSwitch["switch_id"]{
//                    obj.switch_id = switch_id as? Int
//                }
//
//                if let status = dictSwitch["status"]{
//                    obj.status = status as? Int
//                }
//
//                if let watt = dictSwitch["wattage"]{
//                    obj.wattage = watt as? Int
//                }
//
//                if let timestamp = dictSwitch["timestamp"]{
//                    obj.timestamp = timestamp as? String
//                }
//                arr.append(obj)
//            }
//
//            energyData.energy_data = arr
//        } catch {
//            print(error)
//        }
//    return energyData
//    }


    class func isAnyConnectionIssue() -> Bool
    {
       
        var canShowError : Bool = false
        
        if !self.isAllowToMakeAPICall()
        {
            self.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_skorman_wifi"))
            canShowError = true
            SVProgressHUD.dismiss()
        }
            
        else if VVBaseUserDefaults.getIsGlobalConnect()
        {
            if !UIAppDelegate.isInterNetAvaliable
            {
                self.showAlertMessage(strMessage: SSLocalizedString(key: "no_internet_connection"))
                canShowError = true
                SVProgressHUD.dismiss()
            }
        }
        return canShowError
    }
    
    
    class func isAnyConnectionIssueToMakeGlobalAPI() -> Bool
    {
        var canShowError : Bool = false
        if !UIAppDelegate.isInterNetAvaliable
        {
            self.showAlertMessage(strMessage: SSLocalizedString(key: "no_internet_connection"))
            canShowError = true
            SVProgressHUD.dismiss()
        }
        return canShowError
    }
    
    
    class func showErrorAccordingToLocalAndGlobal()
    {
        if VVBaseUserDefaults.getIsGlobalConnect()
        {
            //Show ErrorMessage for global
            Utility.showAlertMessage(strMessage: SSLocalizedString(key: "unable_to_connect_skorman_server_global"))
            SVProgressHUD.dismiss()
        }
        else
        {
            //Show ErrorMessage for local
            Utility.showAlertMessage(strMessage: SSLocalizedString(key: "unable_to_connect_skorman_server_local"))
            SVProgressHUD.dismiss()
        }
    }
    
    
    
    
    
    class func createAJsonForDeviceOrHomeMoodSeetingToStoreInDatabase(controllerArray: [RoomDetailForMoodSettingViewController],objMoodToEdit : Mood, objMoodWrapper: MoodWrapper,moodTypeForHomeOrDevice : Int) -> NSMutableDictionary
    {
        SSLog(message: "CreateFinalJSONHear")
        var allRoomSwitchBoxes = [SwitchBox]()
        controllerArray.forEach { (cnt) in
            let switchBoxesInCnt = cnt.getCurrentStatusOfRoom()
            for switchBox in switchBoxesInCnt
            {
                allRoomSwitchBoxes.append(switchBox)
            }
        }
        
        //Main Dict
        let moodDict = NSMutableDictionary()
        
        //Temporary for MoodID
        if !Utility.isEmpty(val: objMoodToEdit.mood_id)
        {
            moodDict.setValue(objMoodToEdit.mood_id, forKey: "mood_id")
        }
        
        //For Mood Status
//        if !Utility.isEmpty(val: "\(objMoodToEdit.mood_status)")
//        {
//            moodDict.setValue(objMoodToEdit.mood_status, forKey: "mood_status")
//        }
        moodDict.setValue(0, forKey: "mood_status")
        
        //for mood name
        moodDict.setValue(objMoodWrapper.mood_id, forKey: "mood_id")
        
        //for mood name
        moodDict.setValue(objMoodWrapper.mood_name, forKey: "mood_name")
        
        //for mood time
        if !Utility.isEmpty(val: objMoodWrapper.mood_time)
        {
            moodDict.setValue(objMoodWrapper.mood_time, forKey: "mood_time")
        }
        else
        {
            moodDict.setValue("", forKey: "mood_time")
        }
        
        
        //for mood repeat
        moodDict.setValue(objMoodWrapper.arraySelectedDaysForMoodRepeat, forKey: "mood_repeat")
        
        //For mood_type
        moodDict.setValue(moodTypeForHomeOrDevice, forKey: "mood_type")
        
        //FOR SWITCH BOXES
        let switchBoxesArray = NSMutableArray()
        //MAIN DICT
        
        for switchBox in allRoomSwitchBoxes
        {
            let switchBoxDict = NSMutableDictionary()
            switchBox.removeMasterSwitchFromMoods()
            switchBox.moods?.insert(switchBox.masterSwitch!, at: 0)
            
            
            //For  switchbox_id
            var switchbox_id : String?
            switchbox_id = switchBox.switchbox_id
            switchBoxDict.setValue(switchbox_id, forKey: "switchbox_id")
            
            //For switch_id Array comma seprated
            let arrSwitchBoxIds = NSMutableArray()
            for objMood in switchBox.moods!
            {
                //                arrSwitchBoxIds.add(String(format:"%d",objMood.switch_id!))
                arrSwitchBoxIds.add(objMood.switch_id!)
            }
            switchBoxDict.setValue(arrSwitchBoxIds, forKey: "switch_id")
            
            //For status Array comma seprated
            let arrSwitchstatus = NSMutableArray()
            for objMood in switchBox.moods!
            {
                //                arrSwitchstatus.add(String(format:"%d",objMood.status))
                arrSwitchstatus.add(objMood.status)
            }
            switchBoxDict.setValue(arrSwitchstatus, forKey: "status")
            
            
            //For position Array comma seprated
            let arrSwitchposition = NSMutableArray()
            for objMood in switchBox.moods!
            {
                //                arrSwitchposition.add(String(format:"%d",objMood.position))
                arrSwitchposition.add(objMood.position)
            }
            switchBoxDict.setValue(arrSwitchposition, forKey: "position")
            
            switchBoxesArray.add(switchBoxDict)
        }
        moodDict.setValue(switchBoxesArray, forKey: "mood")
        //Need Help Sapanesh Sir
        
        SSLog(message: "Mood Dictionary To Store :")
        SSLog(message: moodDict)
        
        
        return moodDict
    }
    
    
    
    class func isRestrictOperation() -> Bool
    {
        var isRestrictOperation : Bool = false
        if VVBaseUserDefaults.getIsGlobalConnect()
        {
           isRestrictOperation = true
        }
        return isRestrictOperation
    }
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    class func insertEnergyDataForDefaultHomeWithCallbackNew(success:@escaping(_ success : String)->Void, failure:@escaping (Error?)->Void)
    {
        
        if !Utility.isAnyConnectionIssue()
        {
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_GET_ENERGY_CONSUMPTION_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_GET_ENERGY_CONSUMPTION_ACK)
                SSLog(message: "TOPIC NAME : \(topic)")
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_GET_ENERGY_CONSUMPTION_ACK)
                {
                    if let objEnergyDataWrapper : MainEnergyDataWrapper? = MainEnergyDataWrapper.decode(data!){
                        if let obj = objEnergyDataWrapper?.energy_data
                        {
                            DatabaseManager.sharedInstance().deleteEnergyData()
                            DatabaseManager.sharedInstance().insertEnergyData(objEnergyDataWrapper: (obj))
                            success("success")
                        }
                        print("here---- SM_TOPIC_GET_ENERGY_CONSUMPTION_ACK \(topic)")
                    }
                }
            }
            //        {"request":"energy_data"}
            let dict =  NSMutableDictionary()
            dict.setValue("energy_data", forKey: "request");
            let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
//            SMQTTClient.sharedInstance().publishData(data: data, topic: SM_TOPIC_GET_ENERGY_CONSUMPTION) { (error) in
//                print("error :\(String(describing: error))")
//                if error != nil
//                {
//                    Utility.showErrorAccordingToLocalAndGlobal()
//                    failure(error)
//                }
//            }
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_GET_ENERGY_CONSUMPTION) { (error) in
                print("error :\(String(describing: error))")
                if error != nil
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                    failure(error)
                }

            }
        }
        
    }

}
extension String {
	func removingWhitespaces() -> String {
		return components(separatedBy: .whitespaces).joined()
	}
}
extension Notification.Name {
	public static let switchValueChange = Notification.Name("switchValueChange")
	public static let defaultHomeChange = Notification.Name("defaultHomeChange")
	public static let defaultHomeChangeLeftMenu = Notification.Name("defaultHomeChangeLeftMenu")
    public static let changeHomeMode = Notification.Name("changeHomeMode")
    
    //NOTIFICATIONS FOR SUBSCRIBE ALL TOPIC
    public static let handleUpdateSwitchAPISuccess = Notification.Name("handleUpdateSwitchAPISuccess")
    public static let handleRenameSwitchboxAPISuccess = Notification.Name("handleRenameSwitchboxAPISuccess")
    public static let handleLinkUserIdAndPIIDAPISuccess = Notification.Name("handleLinkUserIdAndPIIDAPISuccess")
    public static let handleUpdateMoodStatusAck = Notification.Name("handleUpdateMoodStatusAck")
    public static let handleMoodButtonAdded = Notification.Name("handleMoodButtonAdded")
    public static let handleMoodButtonAddition = Notification.Name("handleMoodButtonAddition")
    public static let updateMoodButtonColorNotification = Notification.Name("updateMoodButtonColorNotification")
    public static let checkMQTTConnectivity = Notification.Name("checkMQTTConnectivity")
    public static let checkMQTTSignalConnectivity = Notification.Name("checkMQTTSignalConnectivity")


    


    
    
    //TO Dismiss Popup on API success
    public static let dismissPopup = Notification.Name("dismissPopup")
    
}
extension String {
    var withoutSpecialCharacters: String {
        return self.components(separatedBy: CharacterSet.symbols).joined(separator: "")
    }
}

extension Date {
    
    func offsetFrom(fromDate : Date , toDate : Date) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: fromDate, to: toDate);
        
        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    
}

public extension UIAlertController {
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindowLevelAlert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
    
    
}


import Foundation
import SystemConfiguration.CaptiveNetwork

public class SSID {
    class func fetchSSIDInfo() -> String {
        var currentSSID = ""
        if let interfaces = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces) {
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if let interfaceData = unsafeInterfaceData as? [String: AnyObject] {
                    currentSSID = interfaceData["SSID"] as! String
//                    let BSSID = interfaceData["BSSID"] as! String
//                    let SSIDDATA = interfaceData["SSIDDATA"] as! String
                    debugPrint("ssid=\(currentSSID)")
                }
            }
        }
        return currentSSID
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
