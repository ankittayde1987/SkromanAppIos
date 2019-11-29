//
//  SetingsViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class SetingsViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func setupTableView() {
		self.title = SSLocalizedString(key: "settings")
		view.backgroundColor = UICOLOR_MAIN_BG
		tableView.backgroundColor = UICOLOR_MAIN_BG
		// Registering nibs
		tableView.register(UINib.init(nibName: "SettingOptionTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingOptionTableViewCell")
	}
	// MARK: - UITableView
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			let cell = tableView.dequeueReusableCell(withIdentifier: "SettingOptionTableViewCell", for: indexPath) as! SettingOptionTableViewCell
		cell.contentView.layer.borderWidth = 1.0
		cell.contentView.layer.borderColor = UICOLOR_CONTAINER_BG.cgColor
        
        if indexPath.row == 0{
		cell.configureSettingOptionTableViewCellForSettingOptions(str: "add_devices")
        }
        else{
            cell.configureSettingOptionTableViewCellForSettingOptions(str: "Add_Homes")
        }
			return cell
	}
	
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if Utility.isRestrictOperation(){
//            Utility.showAlertMessage(strMessage: SSLocalizedString(key: "connect_to_local_for_this_action_message"))
//        }
//        else
//        {
            if indexPath.row == 0 {

                let nibName = Utility.getNibNameForClass(class_name: String.init(describing: AddDeviceViewController.self))
                let vc = AddDeviceViewController(nibName: nibName , bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
               
                let vc = MyHomesViewController.init(nibName: "MyHomesViewController", bundle: nil)
                navigationController?.pushViewController(vc, animated: true)
            }
//        }
    }

}
