//
//  EmptyTableViewCell.swift
//  Ananajobs
//
//  Created by ADMIN on 03/10/17.
//  Copyright © 2017 anand mahajan. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    @IBOutlet weak var lblEmpty: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblEmpty.font = Font_SanFranciscoText_Medium_H16
        self.lblEmpty.textColor = UICOLOR_WHITE
        self.contentView.backgroundColor = UICOLOR_ROOM_CELL_BG
    
    }
    func configureCellWithEmptyMsg(emptyMsg : String ) {
        self.lblEmpty.preferredMaxLayoutWidth = SCREEN_SIZE.width - 30
        self.lblEmpty.numberOfLines = 0
        self.lblEmpty.text = emptyMsg
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
