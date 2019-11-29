//
//  RegisterHeaderTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class RegisterHeaderTableViewCell: UITableViewCell {
	
	@IBOutlet weak var lblPlsRegisterToContinue: UILabel!
	@IBOutlet weak var lblAppName: UILabel!
	@IBOutlet weak var imagLogo: UIImageView!
	@IBOutlet weak var vwHeaderTopContainer: UIView!
	@IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
	
	let scrollHeight = SCREEN_SIZE.height - 58 - UIAppDelegate.windowSafeAreaInsets.bottom
	let topSpaceRatio: CGFloat = 0.09031198686
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		// Adjusting top space as per screen height
		topSpaceConstraint.constant = round(scrollHeight * topSpaceRatio)
		print("topSpaceConstraint: \(topSpaceConstraint.constant)")
		
		lblAppName.font = Font_Titillium_Semibold_H25
		lblAppName.text = SSLocalizedString(key: "skroman")
		lblPlsRegisterToContinue.font = Font_SanFranciscoText_Regular_H20
		lblPlsRegisterToContinue.text = SSLocalizedString(key: "please_register_to_continue")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
