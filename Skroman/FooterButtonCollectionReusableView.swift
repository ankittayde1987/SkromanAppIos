//
//  FooterButtonCollectionReusableView.swift
//  Skroman
//
//  Created by Admin on 21/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class FooterButtonCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var vwSeprator: UIView!
    @IBOutlet weak var vwBottomContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnSave.titleLabel?.font = Font_SanFranciscoText_Regular_H16
        vwBottomContainer.backgroundColor = UICOLOR_BLUE
        btnSave.backgroundColor = UICOLOR_BLUE
        vwSeprator.backgroundColor = UICOLOR_SEPRATOR
        btnSave.setTitle(SSLocalizedString(key: "save").uppercased(), for: .normal)
        btnSave.setTitle(SSLocalizedString(key: "save").uppercased(), for: .selected)
    }
    
}
