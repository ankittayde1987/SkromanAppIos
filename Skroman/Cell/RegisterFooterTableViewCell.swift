//
//  RegisterFooterTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
protocol RegisterFooterTableViewCellDelegate {
	func tappedSubmit()
	func tappedTermsAndConditions()
}

class RegisterFooterTableViewCell: UITableViewCell {

	var delegate : RegisterFooterTableViewCellDelegate?
	@IBOutlet weak var btnTermsAndCondition: UIButton!
	@IBOutlet weak var btnSubmit: UIButton!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		btnSubmit.titleLabel?.font = Font_SanFranciscoText_Medium_H16
		btnTermsAndCondition.titleLabel?.font = Font_SanFranciscoText_Regular_H14
		btnSubmit.backgroundColor = UICOLOR_BLUE
		btnSubmit.setTitle(SSLocalizedString(key: "submit").uppercased(), for: .normal)
		btnSubmit.setTitle(SSLocalizedString(key: "submit").uppercased(), for: .selected)
		btnTermsAndCondition.setTitle(SSLocalizedString(key: "terms_and_condition").uppercased(), for: .normal)
		btnTermsAndCondition.setTitle(SSLocalizedString(key: "submit").uppercased(), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	@IBAction func tappedSubmit(_ sender: Any) {
		self.delegate?.tappedSubmit()
	}
	
	@IBAction func tappedTermsAndCondition(_ sender: Any) {
		self.delegate?.tappedTermsAndConditions()
	}
}
