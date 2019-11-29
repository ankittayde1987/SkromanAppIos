//
//  HeaderCollectionReusableView.swift
//  Skroman
//
//  Created by ananadmahajan on 9/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
protocol HeaderCollectionReusableViewDelegate {
	func tappedAddRoom()
}
class HeaderCollectionReusableView: UICollectionReusableView {
	var delegate : HeaderCollectionReusableViewDelegate?
	@IBOutlet weak var lblHomeTitle: UILabel!
	@IBOutlet weak var lblRooms: UILabel!
	@IBOutlet weak var btnAddRoom: UIButton!
	@IBOutlet weak var vwRoomsLabelContainer: UIView!
	@IBOutlet weak var txtHomeName: UITextField!
	@IBOutlet weak var vwTxtFieldHomeNameContainer: UIView!
	
	var objHome = Home()
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		initCellComponents()
    }
    func initCellComponents()
	{
		
		lblHomeTitle.font = Font_SanFranciscoText_Regular_H16
		lblHomeTitle.text = SSLocalizedString(key: "home_title").uppercased()
		txtHomeName.tintColor = .white
		txtHomeName.font = Font_SanFranciscoText_Regular_H14
		txtHomeName.attributedPlaceholder = NSAttributedString(string: SSLocalizedString(key: "enter_home_name"),
															  attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
		lblRooms.font = Font_SanFranciscoText_Regular_H16
		lblRooms.text = SSLocalizedString(key: "rooms").uppercased()
		
		vwTxtFieldHomeNameContainer.backgroundColor = UICOLOR_CONTAINER_BG
		txtHomeName.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
		vwRoomsLabelContainer.backgroundColor = UICOLOR_CONTAINER_BG
	}
	func configureCell(home : Home)
	{
		self.objHome = home
		
		if !Utility.isEmpty(val: self.objHome.home_name)
		{
			self.txtHomeName.text = self.objHome.home_name
		}
	}
	@objc func textFieldDidChange(_ textField: UITextField) -> Bool {
		self.objHome.home_name = self.txtHomeName.text
		return true
	}
	@IBAction func tappedAddRoom(_ sender: Any) {
		self.delegate?.tappedAddRoom()
	}
}
