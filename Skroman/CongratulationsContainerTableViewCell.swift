//
//  CongratulationsContainerTableViewCell.swift
//  Skroman
//
//  Created by Admin on 22/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class CongratulationsContainerTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCongratulations: UILabel!
    @IBOutlet weak var imagTick: UIImageView!
    @IBOutlet weak var vwCenterContainer: UIView!

    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var imagInfo: UIImageView!
    @IBOutlet weak var vwInfo: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblCongratulations.font = Font_SanFranciscoText_Regular_H16
        self.lblCongratulations.text = SSLocalizedString(key: "congratulations_text")
        self.vwInfo.backgroundColor = UICOLOR_CONTAINER_BG
        self.lblInfo.font = Font_Titillium_Regular_H14
        self.lblInfo.textColor = UICOLOR_WHITE
        self.lblInfo.text = String(format: SSLocalizedString(key: "please_connect_to_xxx_wifi_before_continue"),VVBaseUserDefaults.getCurrentSSID())
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
