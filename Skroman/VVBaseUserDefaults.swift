//
//  VVBaseUserDefaults.swift
//  getAMe
//
//  Created by admin on 6/15/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
private let kSettingExtraMessages: String = "kSettingExtraMessages"
private let kSettingLongMessage: String = "kSettingLongMessage"
private let kSettingEmptyMessages: String = "kSettingEmptyMessages"
private let kSettingSpringiness: String = "kSettingSpringiness"

private let kCurrentPID: String = "kCurrentPID"
private let kCurrentHOMEID: String = "kCurrentHOMEID"
private let kCurrentHOMEIP: String = "kCurrentHOMEIP"
private let kCurrentHOMESETTINGIP: String = "kCurrentHOMESETTINGIP"
private let kIPAccess: String = "kIPAccess"
private let kCurrentHOMENAME: String = "kCurrentHOMENAME"

private let kHOMEDict: String = "kHOMEDict"
private let kCurrentROOMID: String = "kCurrentROOMID"
private let kGlobalConnect: String = "kGlobalConnect"
private let kForcedGlobalConnect: String = "kForcedGlobalConnect"
private let kCurrentSSID: String = "kCurrentSSID"
private let kCurrentPASSWORD: String = "kCurrentPASSWORD"
class VVBaseUserDefaults: NSObject {
    
    class func setString(_ value: String, forKey key: String) {
        self.setStringForKey(key, value: value)
    }
    
    class func setInt(_ value: Int, forKey key: String) {
        self.setIntForKey(key, value: value)
    }
    
    class func setDict(_ value: [AnyHashable: Any], forKey key: String) {
        self.setDictForKey(key, value: value)
    }
    
    class func setArray(_ value: [Any], forKey key: String) {
        self.setArrayForKey(key, value: value)
    }
    
    class func setBool(_ value: Bool, forKey key: String) {
        self.setBoolForKey(key, value: value)
    }
 
    class func getStringForKey(_ key: String) -> String {
        var val: String = ""
        let standardUserDefaults = UserDefaults.standard
        if standardUserDefaults.string(forKey: key) != nil {
             val = standardUserDefaults.string(forKey: key)!
        }
       
        return val
    }
    
    class func getIntForKey(_ key: String) -> Int {
        var val: Int = 0
        let standardUserDefaults = UserDefaults.standard
        val = standardUserDefaults.integer(forKey: key)
        return val
    }
    
    class func getFloatForKey(_ key: String) -> CGFloat {
        var val: CGFloat = 0.0
        let standardUserDefaults = UserDefaults.standard
        val = CGFloat(standardUserDefaults.float(forKey: key))
        return val
    }
    
    class func getDictForKey(_ key: String) -> [AnyHashable: Any] {
        var val: [AnyHashable: Any]? = nil
        let standardUserDefaults = UserDefaults.standard
            val = standardUserDefaults.dictionary(forKey: key)
        return val!
    }
    
    class func getArrayForKey(_ key: String) -> [Any] {
        var val: [Any]? = nil
        let standardUserDefaults = UserDefaults.standard
            val = standardUserDefaults.array(forKey: key)
        return val!
    }
    
    class func getBoolForKey(_ key: String) -> Bool {
        var val: Bool = false
        let standardUserDefaults = UserDefaults.standard
            val = standardUserDefaults.bool(forKey: key)
        return val
    }
    
    class func getObjectForKey(_ key: String) -> Any {
        var val: Any?
        let standardUserDefaults = UserDefaults.standard
            val = standardUserDefaults.object(forKey: key)
        return val!
    }

        
    class func loadCustomObjectWithKey(key: String) -> AnyObject {
        let defaults: UserDefaults = UserDefaults.standard
       
        var object: AnyObject
        if(( defaults.object(forKey: key)) != nil)
        {
            let encodedObject: NSData = (defaults.object(forKey: key) as! NSData)
            object = NSKeyedUnarchiver.unarchiveObject(with: encodedObject as Data)! as AnyObject
            return object
        }
       return User() as AnyObject
        
    }
    
    // MARK: - Set values
    class func setStringForKey(_ key: String, value: String) {
        self.setObjectForKey(key, value: value)
    }
    
    class func setIntForKey(_ key: String, value: Int) {
        let standardUserDefaults = UserDefaults.standard
            standardUserDefaults.set(value, forKey: key)
            standardUserDefaults.synchronize()
    }
    
    class func setFloatForKey(_ key: String, value: CGFloat) {
        let standardUserDefaults = UserDefaults.standard
            standardUserDefaults.set(value, forKey: key)
            standardUserDefaults.synchronize()
    }
    
    class func setDictForKey(_ key: String, value: [AnyHashable: Any]) {
        self.setObjectForKey(key, value: value)
    }
    
    class func setArrayForKey(_ key: String, value: [Any]) {
        self.setObjectForKey(key, value: value)
    }

    class func setObjectForKey(_ key: String, value: Any) {
        let standardUserDefaults = UserDefaults.standard
            standardUserDefaults.set(value, forKey: key)
            standardUserDefaults.synchronize()
    }
    
    class func setBoolForKey(_ key: String, value: Bool) {
        let standardUserDefaults = UserDefaults.standard
            standardUserDefaults.set(value, forKey: key)
            standardUserDefaults.synchronize()
    }
    
    class func saveCustomObject(object: AnyObject, key: String) {
        let encodedObject: NSData = NSKeyedArchiver.archivedData(withRootObject: object) as NSData
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(encodedObject, forKey: key)
        defaults.synchronize()
    }
	class func setUserObject<T : Encodable>( value: T) {
		let standardUserDefaults = UserDefaults.standard
		standardUserDefaults.set(try? PropertyListEncoder().encode(value), forKey: "User")
		standardUserDefaults.synchronize()
	}
	class func getUserObject<T : Decodable>() -> T? {
		let standardUserDefaults = UserDefaults.standard
		if let data = standardUserDefaults.value(forKey:"User") as? Data {
			return try? PropertyListDecoder().decode(T.self, from: data)
		}
		return User() as? T
	}
    class func removeObjectForKey (key: String) {
    
    }
    
    class func userId() -> Int {
        let obj : User? = self.getUserObject()
        if(!Utility.isEmpty(val: obj?.user_id))
        {
            return Int(obj!.user_id!)!
        }
        return 0;
    }
    
	
    
    class func setCurrentPIID(pi_id:String) {
         UserDefaults.standard.set(pi_id, forKey: kCurrentPID)
    }
    
    class func setCurrentHomeID(home_id:String) {
        UserDefaults.standard.set(home_id, forKey: kCurrentHOMEID)
    }

    class func setCurrentHomeName(home_name:String) {
        UserDefaults.standard.set(home_name, forKey: kCurrentHOMENAME)
    }

    class func setCurrentHomeIP(home_ip:String) {
        UserDefaults.standard.set(home_ip, forKey: kCurrentHOMEIP)
    }

    class func setHomeIpDictonary(home_dict:NSMutableDictionary) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.setValue(home_dict, forKey: kHOMEDict)
        defaults.synchronize()
    }

    
    class func setCurrentRoomID(room_id:String) {
        UserDefaults.standard.set(room_id, forKey: kCurrentROOMID)
    }

    
    class func getCurrentPIID() -> String {
        var strCurrentPID: String = ""
        strCurrentPID = VVBaseUserDefaults.getStringForKey(kCurrentPID)
        return strCurrentPID
    }
    
    class func getCurrentHomeID() -> String {
        return VVBaseUserDefaults.getStringForKey(kCurrentHOMEID)
    }

    class func getCurrentHomeNAME() -> String {
        return VVBaseUserDefaults.getStringForKey(kCurrentHOMENAME)
    }

    class func getCurrentHomeIP() -> String {
        return VVBaseUserDefaults.getStringForKey(kCurrentHOMEIP)
    }
    
    class func getHomeIpDictonary () -> NSMutableDictionary {
        
        let defaults: UserDefaults = UserDefaults.standard
        let loadedValue = defaults.dictionary(forKey: kHOMEDict) 

            if loadedValue == nil {
                let emptyJson = NSMutableDictionary()
                return emptyJson
            }
            else{
                let dictNSMutable = NSMutableDictionary(dictionary: loadedValue!)
                return dictNSMutable
            }
    }

    class func getCurrentRoomID() -> String {
        return VVBaseUserDefaults.getStringForKey(kCurrentROOMID)
    }

    class func setIsGlobalConnect(isGlobalConnect:Bool) {
        UserDefaults.standard.set(isGlobalConnect, forKey: kGlobalConnect)
    }
    
    class func getIsGlobalConnect() -> Bool {
        return VVBaseUserDefaults.getBoolForKey(kGlobalConnect)
    }
    
    class func setCurrentSSID(ssid:String) {
        UserDefaults.standard.set(ssid, forKey: kCurrentSSID)
    }
    
    class func getCurrentSSID() -> String {
        return VVBaseUserDefaults.getStringForKey(kCurrentSSID)
    }
    
    class func setCurrentPASSWORD(password:String) {
        UserDefaults.standard.set(password, forKey: kCurrentPASSWORD)
    }
    
    class func getCurrentPASSWORD() -> String {
        return VVBaseUserDefaults.getStringForKey(kCurrentPASSWORD)
    }
    
    class func setCurrentHomeSettingIP(home_ip:String) {
        UserDefaults.standard.set(home_ip, forKey: kCurrentHOMESETTINGIP)
    }

    class func getCurrentHomeSettingIP() -> String {
        return VVBaseUserDefaults.getStringForKey(kCurrentHOMESETTINGIP)
    }

    
    class func setHomeIPAccess(status:Bool) {
        UserDefaults.standard.set(status, forKey: kIPAccess)
    }
    
    class func getHomeIPAccess() -> Bool {
        return VVBaseUserDefaults.getBoolForKey(kIPAccess)
    }

}
