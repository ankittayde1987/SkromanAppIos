//
//  CongratualationsViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SVProgressHUD

class CongratualationsViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var vwTableFooter: UIView!
    @IBOutlet weak var vwConstant_iPadWidth: NSLayoutConstraint!
    @IBOutlet weak var tableView: TPKeyboardAvoidingTableView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var vwSeprator: UIView!
    @IBOutlet weak var vwBottomContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initViewController()
        self.setupTableView()
        self.customiseUIForIPad()
        SMQTTClient.sharedInstance().connectToServer(success: { (error) in
        })
    }
    func customiseUIForIPad()
    {
        if Utility.isIpad()
        {
            self.vwConstant_iPadWidth.constant = CONSTANT_IPAD_VIEW_WIDTH
            self.vwTableFooter.backgroundColor = UICOLOR_MAIN_BG
            self.tableView.backgroundColor = UICOLOR_MAIN_BG
            self.tableView.tableFooterView = self.vwTableFooter
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hiding default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Hiding default navigation bar
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func initViewController()
    {
        self.view.backgroundColor = UICOLOR_MAIN_BG
        self.vwBottomContainer.backgroundColor = UICOLOR_BLUE
        self.vwSeprator.backgroundColor = UICOLOR_SEPRATOR
        self.btnContinue.backgroundColor = UICOLOR_BLUE
        self.btnContinue.titleLabel?.font = Font_SanFranciscoText_Regular_H16
        self.btnContinue.setTitle(SSLocalizedString(key: "continue").uppercased(), for: .normal)
        self.btnContinue.setTitle(SSLocalizedString(key: "continue").uppercased(), for: .selected)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func tappedOnContinue(_ sender: Any) {
        SVProgressHUD.show(withStatus: SSLocalizedString(key: "connecting"))
        Utility.delay(2, closure: {
            DispatchQueue.main.async {
                SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: false, success: { (success) in
                    VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: false)
                    self.syncSwitchBoxWithDeviceAPICall()
                }) { (error) in
                    SVProgressHUD.dismiss()
                    self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_local_server"))
                }
            }
        })
    }
    
    func setupTableView() {
        // Registering nibs
        tableView.register(UINib.init(nibName: "CongratulationsContainerTableViewCell", bundle: nil), forCellReuseIdentifier: "CongratulationsContainerTableViewCell")
        
        // Stop auto adjustment of content inset
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if Utility.isIpad()
        {
            //            return (self.tableView.frame.size.height * 0.75)
            return self.tableView.frame.size.height / 2
        }
        else
        {
            return self.tableView.frame.size.height
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CongratulationsContainerTableViewCell", for: indexPath) as! CongratulationsContainerTableViewCell
        cell.lblInfo.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //API CALL BY GAURAV
    func syncSwitchBoxWithDeviceAPICall()
    {
        SVProgressHUD.show();
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API syncSwitchBoxWithDeviceAPICall")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_CREATE_SWITCHBOX_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_CREATE_SWITCHBOX_ACK)
                SSLog(message: "Successsssss :")
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_CREATE_SWITCHBOX_ACK)
                {
                    if let objSwitchBox : SwitchBoxWrapperForAddDevice? = SwitchBoxWrapperForAddDevice.decode(data!){
                        DatabaseManager.sharedInstance().insertSwitchBoxAfterAdded(obj: (objSwitchBox?.switchbox_json)!)
                        self.tryConnectToGlobalForSyncData(piid: VVBaseUserDefaults.getCurrentPIID())
                    }
                    print("here---- SM_TOPIC_CREATE_SWITCHBOX_ACK \(topic)")
                }
            }
            let dict =  NSMutableDictionary()
            dict.setValue("configuration_data", forKey: "request");
            //            dict.setValue("request", forKey: "configuration_data");
            print("switchdata \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_GET_CONFIGURATION_DATA) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
    
    
    
    
    func globalSyncData(piid : String)
    {
        SSLog(message: "************** globalSyncData **************")
        SVProgressHUD.show(withStatus: SSLocalizedString(key: "sync"))
        SSLog(message: "globalSyncData")
        if !Utility.isAnyConnectionIssue()
        {
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK)
                SSLog(message: "******************** globalSyncData SUCCESSSSSSSSSSSSSSSS ***********************")
              
                self.connectToLocalAndRedirectToHome()
                print("here---- SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK \(topic)")
            }
            let dict =  NSMutableDictionary()
            dict.setValue(piid, forKey: "pi_id");
            dict.setValue(Utility.getCurrentUserId(), forKey: "user_id");
            SSLog(message: "DICT FOR Global Sync : \(dict)")
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS) { (error) in
                if error != nil{
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
   func connectToLocalAndRedirectToHome()
    {
        SVProgressHUD.show(withStatus: SSLocalizedString(key: "connecting_to_local"))
        Utility.delay(2) {
            DispatchQueue.main.async {
                SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: false, success: { (success) in
                    SVProgressHUD.dismiss()
                    VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: false)
                    SMQTTClient.sharedInstance().subscribeAllTopic();
                    DispatchQueue.main.async {
                        UIAppDelegate.navigateToHomeScreen()
                        SVProgressHUD.dismiss()
                    }
                    
                }) { (error) in
                    SVProgressHUD.dismiss()
                    self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_local_server"))
                    DispatchQueue.main.async {
                        SMQTTClient.sharedInstance().subscribeAllTopic();
                        UIAppDelegate.navigateToHomeScreen()
                        SVProgressHUD.dismiss()
                    }
                }
            }
        }
        
    }
    func tryConnectToGlobalForSyncData(piid: String)
        
    {
        SVProgressHUD.show(withStatus: SSLocalizedString(key: "connecting_to_global"))
        Utility.delay(2, closure: {
            DispatchQueue.main.async {
                SMQTTClient.sharedInstance().changeLocalToGlobalServerWithCallbackNew(globalServer: true, success: { (success) in
                    VVBaseUserDefaults.setIsGlobalConnect(isGlobalConnect: true)
                    self.globalSyncData(piid: piid)
                }) { (error) in
                    SVProgressHUD.dismiss()
                    self.showAlertViewWithMessage(SSLocalizedString(key: "unable_to_connect_global_server"))
                }
            }
        })
    }
}

