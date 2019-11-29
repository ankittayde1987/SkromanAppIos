//
//  MyHomeTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import SwipeCellKit

class MyHomeTableViewCell: SwipeTableViewCell {
	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var btnSelectDeselectHome: UIButton!
	
	@IBOutlet weak var btnSelectDeselectLarge: UIButton!
	@IBOutlet weak var lblDefaultHomeIndicator: UILabel!
	@IBOutlet weak var lblHomeName: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		initCell()
    }
	func initCell()
	{
		self.contentView.backgroundColor = UICOLOR_MAIN_BG
		self.lblHomeName.font = Font_SanFranciscoText_Regular_H18
		self.lblDefaultHomeIndicator.font = Font_SanFranciscoText_Regular_H10
			self.vwSeprator.backgroundColor = UICOLOR_SEPRATOR
		
		self.btnSelectDeselectHome.isUserInteractionEnabled = false
		self.btnSelectDeselectLarge.isUserInteractionEnabled = false
	}
    func configureCell(objHome:Home)
    {
        self.lblHomeName.text = objHome.home_name
        
        if(objHome.is_default==0)
        {
            self.lblDefaultHomeIndicator.text = SSLocalizedString(key: "set_as_default")
            self.lblDefaultHomeIndicator.textColor = UIColor.white
			self.btnSelectDeselectHome.isSelected = false
        }
        else
        {
            self.lblDefaultHomeIndicator.text = SSLocalizedString(key: "default")
            self.lblDefaultHomeIndicator.textColor = UICOLOR_SELECTEDORON_BG
			self.btnSelectDeselectHome.isSelected = true
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	@IBAction func tappedHomeSelectDeselect(_ sender: Any) {
//		self.btnSelectDeselectHome.isSelected = !self.btnSelectDeselectHome.isSelected
	}
}
