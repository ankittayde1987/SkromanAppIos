//
//  MyRoomsHeaderCollectionReusableView.swift
//  Skroman
//
//  Created by ananadmahajan on 9/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
protocol MyRoomsHeaderCollectionReusableViewDelegate {
	func tappedAddMoodOrMenu()
	func tappedAddedMoodTitle()
}
class MyRoomsHeaderCollectionReusableView: UICollectionReusableView {
	
	var delegate : MyRoomsHeaderCollectionReusableViewDelegate?
	
	@IBOutlet weak var lblActiveCount: UILabel!
	@IBOutlet weak var btnMenu: UIButton!
	@IBOutlet weak var btnAddMood: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		btnAddMood.titleLabel?.font = Font_SanFranciscoText_Regular_H14
		
		btnAddMood.layer.cornerRadius = 3.0
		btnAddMood.backgroundColor = UICOLOR_ADD_MOOD_BG
		btnAddMood.setTitleColor(UICOLOR_WHITE, for: .normal)
		btnAddMood.setTitleColor(UICOLOR_WHITE, for: .selected)
		btnAddMood.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8)
		btnAddMood.setTitle(SSLocalizedString(key: "add_mood").uppercased(), for: .normal)
		btnAddMood.setTitle(SSLocalizedString(key: "add_mood").uppercased(), for: .selected)

    }
	
	//MARK:- IBAction
	@IBAction func tappedAddMood(_ sender: Any) {
		self.delegate?.tappedAddMoodOrMenu()
	}
	
	@IBAction func taooedAddedMoodTitle(_ sender: Any) {
		self.delegate?.tappedAddedMoodTitle()
	}
	
}
