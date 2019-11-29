//
//  AddDeviceViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SVProgressHUD
import Alamofire
import AlamofireNetworkActivityLogger
import AlamofireJsonToObjects
import STPopup
class AddDeviceViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,SelectHomeOrRoomTableViewCellDelegate,SelectOptionViewControllerDelegate,QRCodeScannerViewControllerDelegate,SkromanSocketDelegate,RetryPopUpViewControllerDelegate {

    @IBOutlet weak var vwConstant_iPadWidth: NSLayoutConstraint!
    @IBOutlet var vwTableFooter: UIView!
    @IBOutlet weak var tableView: TPKeyboardAvoidingTableView!
	@IBOutlet weak var btnScanQrCode: UIButton!
	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var vwBottomContainer: UIView!
    
    let host = "192.168.4.1"
    let port = 54312
    var jsonString : String? = ""
    var client: TCPClient?
    
    var timer: Timer?
    var timerMessage: Timer?
    
    var deviceAddTryCounter: Int = 0
	var messageTimerCounter: Int = 0
    
    let skromanSocket = SkromanSocket()
	var objHome : Home?

	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupTableView()
		self.getDefaultHomeNameFromDb()
        self.customiseUIForIPad()
        
        client = TCPClient(address: host, port: Int32(port))
		
    }
    func customiseUIForIPad()
    {
        if Utility.isIpad()
        {
            self.vwConstant_iPadWidth.constant = CONSTANT_IPAD_VIEW_WIDTH
            self.vwTableFooter.backgroundColor = UICOLOR_MAIN_BG
            self.tableView.tableFooterView = self.vwTableFooter
        }
    }
	func getDefaultHomeNameFromDb()
	{
		self.objHome = DatabaseManager.sharedInstance().getDefaultHome()
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	//MARK :- Helper Method
	func setFont()
	{
		btnScanQrCode.titleLabel?.font = Font_SanFranciscoText_Regular_H16
	}
	func setColor()
	{
		vwBottomContainer.backgroundColor = UICOLOR_BLUE
		btnScanQrCode.backgroundColor = UICOLOR_BLUE
		vwSeprator.backgroundColor = UICOLOR_SEPRATOR
	}
	func localizeText()
	{
		btnScanQrCode.setTitle(SSLocalizedString(key: "scan_qr_code").uppercased(), for: .normal)
		btnScanQrCode.setTitle(SSLocalizedString(key: "scan_qr_code").uppercased(), for: .selected)
	}
	func setupTableView() {
		self.title = SSLocalizedString(key: "add_device")
		view.backgroundColor = UICOLOR_MAIN_BG
		tableView.backgroundColor = UICOLOR_MAIN_BG
		setFont()
		setColor()
		localizeText()
		
		

		// Registering nibs
		tableView.register(UINib.init(nibName: "SelectHomeOrRoomTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectHomeOrRoomTableViewCell")
		tableView.register(UINib.init(nibName: "DeviceNameTableViewCell", bundle: nil), forCellReuseIdentifier: "DeviceNameTableViewCell")
	}
	
	// MARK: - UITableView
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
		headerView.backgroundColor = UICOLOR_MAIN_BG
		return headerView
	}
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 110
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 2
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceNameTableViewCell", for: indexPath) as! DeviceNameTableViewCell
			cell.configureCell(obj: self.objHome!)
			return cell
		}
		else
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "SelectHomeOrRoomTableViewCell", for: indexPath) as! SelectHomeOrRoomTableViewCell
			cell.delegate = self;
			cell.configureSelectHomeOrRoomTableViewCell(indexPath: indexPath, obj: self.objHome!)
			return cell
		}

	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}

	// MARK:- IBAction method
	@IBAction func tappedScanQrCode(_ sender: Any) {
//        self.tryAddDevice();
//        return;
        let isValidData: Bool = validateUserEnteredData()
        if isValidData {
            //handle valid data action
            SSLog(message: self.objHome)
            let vc = QRCodeScannerViewController.init(nibName: "QRCodeScannerViewController", bundle: nil)
            vc.comefrom = QRCodeScannType.device
            vc.delegate = self
//            navigationController?.pushViewController(vc, animated: true)
            let nav = UINavigationController.init(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
	}
		
	//MARK:- SelectHomeOrRoomTableViewCellDelegate
	func tappedOnSelectHome(obj : Home)
	{
		let vc = SelectOptionViewController.init(nibName: "SelectOptionViewController", bundle: nil)
		vc.comeFrom = .selectHome
		vc.delegate = self
		vc.objHome = obj
		let navigationVC = UINavigationController(rootViewController: vc)
		self.present(navigationVC, animated: true, completion: nil)
	}
	func tappedOnSelectRoom(obj : Home)
	{
		let vc = SelectOptionViewController.init(nibName: "SelectOptionViewController", bundle: nil)
		vc.comeFrom = .selectRoom
		vc.delegate = self
		vc.objHome = obj
		let navigationVC = UINavigationController(rootViewController: vc)
		self.present(navigationVC, animated: true, completion: nil)
	}
	
	
	// MARK:- validateUserEnteredData method
	func validateUserEnteredData() -> Bool {
		if Utility.isEmpty(val: self.objHome?.home_id){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_select_home"))
			return false
		}
		else if Utility.isEmpty(val: self.objHome?.roomToAdd?.room_id){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_select_room"))
			return false
		}
		else if Utility.isEmpty(val: self.objHome?.deviceName){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_device_name"))
			return false
		}
		return true
	}
    //MARK:-QRCodeScannerViewControllerDelegate methods
    func didSuccess(ssid : String, password : String) -> Void
    {
        messageTimerCounter  = 0
        SSLog(message: "QRCodeScannerViewControllerDelegate ************")
        timerMessage =   Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.timerMessageTick), userInfo: nil, repeats: true)
        
        Utility.delay(10) {
            let parameters = NSMutableDictionary()
            parameters.setValue(ssid, forKey: "dev_id")
            parameters.setValue(VVBaseUserDefaults.getCurrentSSID(), forKey: "ssid")
            parameters.setValue(VVBaseUserDefaults.getCurrentPASSWORD(), forKey: "password")
            parameters.setValue("slide", forKey: "dev_type")
            parameters.setValue(self.objHome?.home_id ?? "", forKey: "homeid")
            parameters.setValue(VVBaseUserDefaults.getCurrentPIID(), forKey: "piid")
            parameters.setValue(self.objHome?.roomToAdd?.room_id ?? "", forKey: "roomid")
            parameters.setValue(self.objHome?.deviceName ?? "", forKey: "name")
            parameters.setValue(VVBaseUserDefaults.getCurrentHomeIP(), forKey: "broker_ip")

            SSLog(message: parameters)
            //SVProgressHUD.show(withStatus:SSLocalizedString(key:"connecting_to_device"))
            let str = Utility.JSONValue(object: parameters)
            
            self.jsonString = "";
            self.jsonString = str
            
            self.tryAddDevice();
            
//            self.skromanSocket.delegate = self
//            self.skromanSocket.setupNetworkCommunication()
//            self.skromanSocket.configureDevice(jsonString: str ?? "")
        }
    }
    
    func didFailure() -> Void
    {
        
		SSLog(message: "QRCode Scan failure **********")
        SVProgressHUD.dismiss()
        self.showAlertMessage(strMessage: SSLocalizedString(key: "unable_to_connect"))
    }
    
    @objc func timerMessageTick()
    {
        if(messageTimerCounter==2)
        {
            SVProgressHUD.show(withStatus:SSLocalizedString(key:"searching_for_wifi"))
        }
        if(messageTimerCounter==4)
        {
             SVProgressHUD.show(withStatus:SSLocalizedString(key:"connecting_with_wifi"))
        }else if(messageTimerCounter==8)
        {
             SVProgressHUD.show(withStatus:SSLocalizedString(key:"connecting_to_device"))
        }
        
        
        messageTimerCounter = messageTimerCounter + 2;
        if(messageTimerCounter>=10)
        {
            timerMessage?.invalidate()
        }
        
    }
    
	//MARK:- SelectOptionViewControllerDelegate
	func didSelectHomeOrRoom(obj: Home, comeFrom: SelectOptionViewControllerComeFrom) {
		
		self.objHome = obj
		self.tableView.reloadData()
	}
    
    //MARK:- SkromanSocketDelegate
    func success()
    {
      SVProgressHUD.show(withStatus: SSLocalizedString(key: "please_wait"))
        Utility.delay(8) {
            SVProgressHUD.dismiss()
            let nibName = Utility.getNibNameForClass(class_name: String.init(describing: CongratualationsViewController.self))
            let vc = CongratualationsViewController(nibName: nibName , bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func failure()
    {
        SVProgressHUD.dismiss()
        Utility.showAlertMessage(strMessage: SSLocalizedString(key: "unable_to_connect_device_please_try_again"))
        
        
        
//        let controller = RetryPopUpViewController.init(nibName: "RetryPopUpViewController", bundle: nil)
//        controller.delegate = self;
//        let cntPopup = STPopupController.init(rootViewController: controller)
//        cntPopup.present(in: self)
    }
   func retryAPI()
   {
        SSLog(message: self.jsonString)
        SVProgressHUD.show(withStatus:SSLocalizedString(key:"connecting_to_device"))
        self.skromanSocket.delegate = self
        self.skromanSocket.setupNetworkCommunication()
        self.skromanSocket.configureDevice(jsonString: self.jsonString ?? "")
    }
    
    
    
    
    ////////***********////////////
    func tryAddDevice()
    {
        SSLog(message: "tryAddDevice calling")
        guard let client = client else { return }
        
        switch client.connect(timeout: 100) {
        case .success:
            SSLog(message: "Connection Success")
            if let response = sendRequest(string: "GET / HTTP/1.0\n\n", using: client) {
                SSLog(message:  "Response: \(response)")
            }
        case .failure(let error):
            SSLog(message: String(describing: error))
              SSLog(message:  "failure: \(String(describing: error))")
        }
    }
    
    
    private func sendRequest(string: String, using client: TCPClient) -> String? {
        
        
       // var sbb = "{\"dev_id\":\"DevFi9\",\"dev_type\" :\"slide\",\"homeid\": \"HM-02A0F\",\"name\" : \"cjcjcjc\",\"password\" :\"pi123456\",\"piid\" :\"PI-VI3MI5\",\"roomid\":\"RM-0A55\",\"ssid\":\"Skrs72\"}";
        SSLog(message: self.jsonString!)
        switch client.send(string: self.jsonString!){
        case .success:
            readResponse(from: client);
            return "";
        case .failure(let error):
             SSLog(message: String(describing: error))
              SSLog(message:  "failure111: \(String(describing: error))")
            return nil
        }
    }
    
    private func readResponse(from client: TCPClient) -> String? {
         timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.delayedAction), userInfo: nil, repeats: true)
        return ""
    }
    @objc private func delayedAction()->String?
    {
        guard let response = self.client?.read(1024*10) else { return nil }
        print("here")
        print(String(bytes: response, encoding: .utf8))

        let str = String(bytes: response, encoding: .utf8)!
        
       // var dict =  Utility.convertToDictionary(text: str)
       // print(dict as Any)
        print(str)
        if(str.contains("received_server_credentials"))
        {
            //
            self.success();
          //  deviceAddTryCounter = 0;
            self.timer?.invalidate();
        }
        if(self.deviceAddTryCounter>5)
        {
            //Error
            self.failure()
            self.timer?.invalidate();
            //deviceAddTryCounter = 0;
        }
        deviceAddTryCounter = deviceAddTryCounter+1;
        return ""
    }
}
