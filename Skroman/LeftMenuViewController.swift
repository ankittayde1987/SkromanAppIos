//
//  LeftMenuViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SVProgressHUD

class LeftMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
	var dataSource: [String] = []
	var dataSourceIcons: [UIImage] = []
	var objUser = User()
	
    var defaultHomeName = ""
	@IBOutlet weak var btnVersion: UIButton!
	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var vwFixBottom: UIView!
	@IBOutlet weak var tableView: TPKeyboardAvoidingTableView!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupTableView()
        getDefaultHomeNameFromDb()
		initializeDataSource()
		NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: .defaultHomeChangeLeftMenu, object: nil)
		self.objUser = VVBaseUserDefaults.getUserObject()!
        
    }
    
    
	@objc func reloadData(_ notification: Notification)
	{
		self.getDefaultHomeNameFromDb()
		initializeDataSource()
		self.tableView.reloadData()
	}
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// Hiding default navigation bar
		navigationController?.setNavigationBarHidden(true, animated: true)
//       getDefaultHomeNameFromDb()
//        self.getUserDetailsAPICall()
	}
    
    func getDefaultHomeNameFromDb()
    {
        defaultHomeName = DatabaseManager.sharedInstance().getDefaultHome().home_name!
    }
    
	func setupTableView() {
		view.backgroundColor = UICOLOR_CONTAINER_BG
		tableView.backgroundColor = UICOLOR_CONTAINER_BG
		vwFixBottom.backgroundColor = UICOLOR_CONTAINER_BG
		vwSeprator.backgroundColor = UICOLOR_CONTAINER_BG
		btnVersion.titleLabel?.font = Font_SanFranciscoText_Regular_H15
		btnVersion.setTitle(SSLocalizedString(key: "version_no"), for: .normal)
		btnVersion.setTitle(SSLocalizedString(key: "version_no"), for: .selected)
		// Registering nibs
		tableView.register(UINib.init(nibName: "LMProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "LMProfileTableViewCell")
		tableView.register(UINib.init(nibName: "LeftMenuOptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftMenuOptionsTableViewCell")
	}
	
	// MARK: - Helper
	
	fileprivate func initializeDataSource() {
     
		dataSource = [
		defaultHomeName,
		SSLocalizedString(key: "settings").uppercased(),
        SSLocalizedString(key: "sync_title").uppercased()
		
		]
//        dataSourceIcons = [#imageLiteral(resourceName: "home_menu") , #imageLiteral(resourceName: "my_home") , #imageLiteral(resourceName: "setitng_menu")  ]
        dataSourceIcons = [#imageLiteral(resourceName: "home_menu") , #imageLiteral(resourceName: "my_home") , #imageLiteral(resourceName: "setitng_menu") , #imageLiteral(resourceName: "sync") ]
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	// MARK: - UITableView
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0
		{
			return 95
		}
		else
		{
			return 58
		}
		
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 1{
			return dataSource.count
		}
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "LMProfileTableViewCell", for: indexPath) as! LMProfileTableViewCell
			cell.configureCellWithUser(obj: self.objUser)
			return cell
		}
		else
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuOptionsTableViewCell", for: indexPath) as! LeftMenuOptionsTableViewCell
			
			if indexPath.row % 2 == 0 {
				cell.contentView.backgroundColor = UICOLOR_CONTAINER_BG
			} else {
				cell.contentView.backgroundColor = UICOLOR_ODD_CELL_BG
			}
			cell.configureCell(iconImage: dataSourceIcons[indexPath.row], title: dataSource[indexPath.row])
			return cell
		}

	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0
		{
			//My ProfileVC
			if indexPath.row == 0
			{
                let nibName = Utility.getNibNameForClass(class_name: String.init(describing: MyProfileViewController.self))
                let vc = MyProfileViewController(nibName: nibName , bundle: nil)
                vc.objUser = self.objUser
                self.navigationController?.pushViewController(vc, animated: true)
			}
		}
		else if indexPath.section == 1
		{
			if indexPath.row == 0
			{
				//Default Home
				self.dismiss(animated: true, completion: {
					
				})
			}
			else if indexPath.row == 1
			{
				//Settings
				let vc = SetingsViewController.init(nibName: "SetingsViewController", bundle: nil)
				navigationController?.pushViewController(vc, animated: true)
			}
			else if indexPath.row == 2
			{
				//Sync
                self.startSyncData()
			}
		}

	}
	func getUserDetailsAPICall()
	{
		SkromanAppAPI().getUserDetails(success: { (obj) in
		
			self.objUser = obj.result!
			self.tableView.reloadData()
		}) { (error) in
			
		}
	}
	
    //API CALL BY GAURAV ISSUE
	func startSyncData()
    {
       if Utility.isRestrictOperation()
            {
              self.syncGlobalData()
        }
        else
        {
            self.syncLocalData()
        }
    }
    
    
    func syncLocalData()
    {
        if !Utility.isAnyConnectionIssue()
        {
            SVProgressHUD.show(withStatus: SSLocalizedString(key: "sync..."))
            Utility.delay(2.0) {
                SVProgressHUD.dismiss()
            }
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_SYNC_EVERYTHING_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_SYNC_EVERYTHING_ACK)
                
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_SYNC_EVERYTHING_ACK)
                {
                    if let objSync : SyncData? = SyncData.decode(data!){
                        
                        if((objSync?.syncData?.count)!>0)
                        {
                            //delete old data and insert new data
                            SMQTTClient.sharedInstance().subscribeAllTopic()
                            DatabaseManager.sharedInstance().syncDataFormleftMenu(objSyncData: objSync!)
                        }
                        //Default Home
                        self.dismiss(animated: true, completion: {
                            
                        })
                        print("here---- SM_TOPIC_SYNC_EVERYTHING_ACK \(topic)")}
                    //redirect to home page
                    SVProgressHUD.dismiss()
                }
                
            }
            
            let dict =  NSMutableDictionary()
            dict.setValue("1", forKey: "sync");
            //            let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_SYNC_EVERYTHING) { (error) in
                if error != nil
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
    func syncGlobalData()
    {
        if !Utility.isAnyConnectionIssue()
        {
            SVProgressHUD.show(withStatus: SSLocalizedString(key: "sync..."))
            
            //Hide loader after 2 sec irrespective of result
            Utility.delay(2.0) {
                SVProgressHUD.dismiss()
            }
           SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU)
                
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU)
                {
                    if let objSync : SyncData? = SyncData.decode(data!){
                        
                        if((objSync?.syncData?.count)!>0)
                        {
                            //delete old data and insert new data
                            SMQTTClient.sharedInstance().subscribeAllTopic()
                            DatabaseManager.sharedInstance().syncDataFormleftMenu(objSyncData: objSync!)
                        }
                        //Default Home
                        self.dismiss(animated: true, completion: {
                            
                        })
                        print("here---- SM_TOPIC_SYNC_EVERYTHING_ACK \(topic)")}
                    //redirect to home page
                    SVProgressHUD.dismiss()
                }
                
            }
            
            let dict =  NSMutableDictionary()
            dict.setValue(VVBaseUserDefaults.getCurrentPIID(), forKey: "pi_id");
            dict.setValue(Utility.getCurrentUserId(), forKey: "user_id");
            //            let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_LEFT_MENU) { (error) in
                if error != nil
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        if UIDevice.current.orientation.isLandscape {
//            print("Landscape")
//            print("Landscape size.width\(size.width)")
//            print("Landscape size.height\(size.height)")
//
//        } else if UIDevice.current.orientation.isPortrait {
//            print("Portrait")
//            print("Portrait size.width\(size.width)")
//            print("Portrait size.height\(size.height)")
//        }
//        self.view.setNeedsLayout()
//        self.tableView.reloadData()
//
//    }
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.view.setNeedsDisplay()
////        self.view.setNeedsLayout()
//
//    }
}
