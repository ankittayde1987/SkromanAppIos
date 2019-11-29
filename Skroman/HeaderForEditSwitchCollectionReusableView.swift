//
//  HeaderForEditSwitchCollectionReusableView.swift
//  Skroman
//
//  Created by ananadmahajan on 9/18/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class HeaderForEditSwitchCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var txtPowerConsumption: UITextField!
    @IBOutlet weak var vwPowerConsumptionContainer: UIView!
    @IBOutlet weak var lblPowerConsumption: UILabel!
    @IBOutlet weak var lblSelectIcon: UILabel!
	@IBOutlet weak var txtSwitchName: UITextField!
	@IBOutlet weak var vwTxtSwitchNameContainer: UIView!
	@IBOutlet weak var lblSwitchName: UILabel!
	
	var objSwitch = Switch()
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		initCellComponents()
    }
	func initCellComponents()
	{
		lblSwitchName.font = Font_SanFranciscoText_Medium_H16
        lblPowerConsumption.font = Font_SanFranciscoText_Medium_H16
        
		lblSwitchName.text = SSLocalizedString(key: "switch_name")
        lblPowerConsumption.text = SSLocalizedString(key: "power_consumption")
        
		txtSwitchName.tintColor = .white
		txtSwitchName.font = Font_SanFranciscoText_Regular_H14
		txtSwitchName.attributedPlaceholder = NSAttributedString(string: SSLocalizedString(key: "enter_switch_name"),
															   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        txtPowerConsumption.tintColor = .white
        txtPowerConsumption.font = Font_SanFranciscoText_Regular_H14
        txtPowerConsumption.attributedPlaceholder = NSAttributedString(string: SSLocalizedString(key: "enter_power_consumption"),
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        
		lblSelectIcon.font = Font_SanFranciscoText_Medium_H16
		lblSelectIcon.text = SSLocalizedString(key: "select_icon")
		
		vwTxtSwitchNameContainer.backgroundColor = UICOLOR_CONTAINER_BG
        vwPowerConsumptionContainer.backgroundColor = UICOLOR_CONTAINER_BG
        
		 self.txtSwitchName.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        self.txtPowerConsumption.addTarget(self, action: #selector(self.textFieldDidChangeForTextCPowerConsumption), for: .editingChanged)
        addDoneButtonOnKeyboard()
	}
	
	func configureCollectionHeader(obj : Switch)
	{
		self.objSwitch = obj
		if !Utility.isEmpty(val: self.objSwitch.switch_name){
			self.txtSwitchName.text = self.objSwitch.switch_name
		}
		else{
			txtSwitchName.attributedPlaceholder = NSAttributedString(string: SSLocalizedString(key: "enter_switch_name"),
																	 attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
		}
        
        
        if self.objSwitch.wattage! > 0{
            self.txtPowerConsumption.text = "\(self.objSwitch.wattage ?? 0)"
        }
        else{
            txtPowerConsumption.attributedPlaceholder = NSAttributedString(string: SSLocalizedString(key: "enter_power_consumption"),
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        }
	}
	
	@objc func textFieldDidChange(_ textField: UITextField) -> Bool {
		self.objSwitch.switch_name = self.txtSwitchName.text
		return true
	}
    
    @objc func textFieldDidChangeForTextCPowerConsumption(_ textField: UITextField) -> Bool {
        self.objSwitch.wattage = Double(self.txtPowerConsumption.text!)
        return true
    }
    
    func addDoneButtonOnKeyboard() {
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: 50))
    doneToolbar.barStyle       = UIBarStyle.default
    let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem  = UIBarButtonItem(title: SSLocalizedString(key: "done"), style: UIBarButtonItemStyle.done, target: self, action: #selector(HeaderForEditSwitchCollectionReusableView.doneButtonAction))
    
    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(done)
    
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    
    self.txtPowerConsumption.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.txtPowerConsumption.resignFirstResponder()
    }
}
