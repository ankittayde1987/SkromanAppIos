//
//  AddIPAddressViewController.swift
//  Skroman
//
//  Created by Skroman on 23/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MQTTClient

protocol addIPAddressDelegate : NSObjectProtocol {
    func didReceivedIP(ipValue : String, from : String) -> Void;
}
protocol addIPAddressDelegateForExistingHome : NSObjectProtocol {
    func didReceivedIPForExistingHome(ipValue : String, homeObj : Home) -> Void;
}

class AddIPAddressViewController: UIViewController , UITextFieldDelegate , MQTTSessionDelegate {

    
    @IBOutlet weak var labelIpAddress: UILabel!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var viewSeprator: UIView!
    @IBOutlet weak var lblIPAdress: UILabel!
    @IBOutlet weak var textfieldIpAddress: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    var objSession : MQTTSession?
    var objHome : Home?
    weak var ipDelegate : addIPAddressDelegate?
    weak var ipDelegateForExisting : addIPAddressDelegateForExistingHome?
    var jumpedFrom : String?

    


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func buttonCloseTapped(_ sender: Any) {
//        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet(charactersIn:"0123456789.:").inverted
        let components = string.components(separatedBy: allowedCharacters)
        let filtered = components.joined(separator: "")
            
            if string == filtered {
                return true
            } else {
                return false
            }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textfieldIpAddress.resignFirstResponder()
        return true
    }
    

    
    
    
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        self.textfieldIpAddress.resignFirstResponder()

        let valid : Bool = validateIpAddress(ipToValidate: self.textfieldIpAddress.text!)
        
        if valid == false{
            // show error popup
        }
        else{
            if  jumpedFrom == nil {
                jumpedFrom = ""
            }
            
            if objHome == nil {
                
                self.ipDelegate?.didReceivedIP(ipValue: self.textfieldIpAddress.text!, from: self.jumpedFrom!)
            }
            else{
                
                self.ipDelegateForExisting?.didReceivedIPForExistingHome(ipValue: self.textfieldIpAddress.text!, homeObj: objHome!)
            }
            self.navigationController?.dismiss(animated: true, completion: nil)
 /*           // step 1 : make successful connection to mqtt add port as ip
            // step 2 : make pubish call get_pi_id using dictonary {"user_unique_id":"send:me:pi:id"}
            // step 3 : on getting pi_id - home process continues -- so home name link with ip address entered
            // step 4 : so when home is selected , get ip address from userdefaults for that home and make connection
            
            self.tryConnectingToMQTT(success: { (error) in
                if((error) != nil){
                    SSLog(message: "Connected In Local Connection")
                    self.makePublishCall()
                }
                else{
                    SSLog(message: "error To Local Server")
                }
            })
        */
        }

    }

    
//    func tryConnectingToMQTT(success:@escaping(_ error:Error?)->Void) {
//
//        if(self.objSession != nil  && self.objSession?.status == MQTTSessionStatus.connected){
//
//            success(nil)
//            print("successfully connected")
//        }else
//        {
//            self.objSession  = MQTTSession()
//            self.objSession?.delegate = self as MQTTSessionDelegate
//            self.objSession?.connect(toHost: self.textfieldIpAddress.text, port: 1883, usingSSL: false, connectHandler: { (error) in
//                SSLog(message: "CONNECTED TO LOCAL SUCCESSFULLY");
//                //Subscribe
//                //                self.subscribeAllTopic()
//                success(error)
//            })
//        }
//    }


//    func makePublishCall() {
//
//        SMQTTClient.sharedInstance().subscribe(topic: SM_GET_PI_ID_ACK) { (data, topic) in
//            SMQTTClient.sharedInstance().unsubscribe(topic: SM_GET_PI_ID_ACK)
//        }
//
//        let data = NSMutableDictionary()
//        data.setValue("send:me:pi:id", forKey: "user_unique_id")
//
//        SMQTTClient.sharedInstance().publishJson(json:data, topic: SM_GET_PI_ID ){
//            (error) in
//            print("error :\(String(describing: error))")
//            if((error) != nil) {
//                Utility.showErrorAccordingToLocalAndGlobal()
//            }
//            else{
//
////                self.sendDataToWatch()
//                // If response doesn't comes back to this point try sending it from below method from SMQTTClient class
//            }
//        }
//    }


//    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
//        print("newMessage Received \(String(describing: data)) on:\(String(describing: topic)) q\(qos) r\(retained) m\(mid)")
//        let backToString = String(data: data!, encoding: String.Encoding.utf8)
//        print("Received \(String(describing: backToString))")
//
//
//    }

}
