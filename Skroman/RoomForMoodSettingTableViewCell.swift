//
//  RoomForMoodSettingTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/21/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

protocol RoomForMoodSettingTableViewCellDelegate {
	func longPressOnSteapperView(obj: Mood)
}

class RoomForMoodSettingTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,SwitchForMoodSettingCollectionViewCellDelegate {
	var delegate : RoomForMoodSettingTableViewCellDelegate?
	
    @IBOutlet weak var vwTopContainer: UIView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwCollectionBottomSeprator: UIView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var vwCollectionTopSeprator: UIView!
	@IBOutlet weak var btnSwitch: UIButton!
	@IBOutlet weak var lblDeviceName: UILabel!
	@IBOutlet weak var vwTopSeprator: UIView!
	
	var objSwitchBoxes = SwitchBox()
	var reminder : Int = 0
	let spacingConstant: CGFloat = 12
    var tableViewWidth: CGFloat = 0
    var horizontalRows : Int = 3
    var isDeviceOrientationLandscape : Bool? = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.initCell()
    }
	func initCell()
	{
		self.contentView.backgroundColor = UICOLOR_ROOM_CELL_BG
		self.vwTopSeprator.backgroundColor = UIColor.clear
		self.vwCollectionTopSeprator.backgroundColor = UICOLOR_ROOM_CELL_SEPRATOR
		self.vwCollectionBottomSeprator.backgroundColor = UICOLOR_ROOM_CELL_SEPRATOR
		self.collectionView.backgroundColor = UICOLOR_ROOM_CELL_BG
		self.lblDeviceName.font = Font_SanFranciscoText_Regular_H18
        
		self.setupCollectionView()
		
	}
	fileprivate func setupCollectionView() {
		// Registering nibs
		collectionView.register(UINib.init(nibName: "SwitchForMoodSettingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SwitchForMoodSettingCollectionViewCell")
		
	}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
    func configureCellWithSwitchBox(switchbox:SwitchBox, isDeviceOrientationLandscape : Bool)
	{
		self.objSwitchBoxes = switchbox;
		//GET MASTER SWITCH FROM SWITCHBOX
		self.objSwitchBoxes.masterSwitch = self.objSwitchBoxes.getMasterSwitchFromMoods()
		//REMOVE MASTER SWITCH FROM SWITCHBOX
		self.objSwitchBoxes.removeMasterSwitchFromMoods()
		//REMOVE MOOD TYPE SWITCH FROM MOODS
		self.objSwitchBoxes.removeMoodSwitchFromMoods()
        //For horizontalRows and Hight
        self.isDeviceOrientationLandscape = isDeviceOrientationLandscape
        if Utility.isIpad()
        {
            if self.isDeviceOrientationLandscape!
            {
                horizontalRows = 6
            }
            else
            {
                horizontalRows = 4
            }
            
        }
		
		//TO ADD DUMMY CELLS
		reminder = (self.objSwitchBoxes.moods?.count)! % horizontalRows
		
		self.lblDeviceName.text = self.objSwitchBoxes.name
		
		
		//FOR MASTER SWITCH ON/OFF
		self.btnSwitch.isSelected = true
		if self.objSwitchBoxes.masterSwitch?.status == 0
		{
			self.btnSwitch.isSelected = false
		}
        
       
        self.tableViewWidth = (UIAppDelegate.window?.frame.size.width)!
        collectionViewHeightConstraint.constant = 0
        if let switches = self.objSwitchBoxes.moods {
            let noOfRows = CGFloat(ceil(Double(switches.count)/Double(horizontalRows)))
            let widthOfCell = ((self.tableViewWidth - (self.spacingConstant * CGFloat(horizontalRows + 1))) / CGFloat(horizontalRows))
            let height = (widthOfCell * noOfRows) + ((noOfRows + 1) * self.spacingConstant)
            collectionViewHeightConstraint.constant = height
        }
		self.collectionView.reloadData()
	}
//    class func hightForRoomCellMoodSettingTableViewCell(switchbox:SwitchBox) -> CGFloat {
//        var sizingCell: RoomForMoodSettingTableViewCell? = nil
//        if sizingCell == nil {
//            let nib: [Any] = Bundle.main.loadNibNamed("RoomForMoodSettingTableViewCell", owner: self, options: nil)!
//            sizingCell = (nib[0] as? RoomForMoodSettingTableViewCell)
//        }
//        sizingCell?.configureCellWithSwitchBox(switchbox: switchbox)
//
//        return ((sizingCell?.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)! + (sizingCell?.collectionView.collectionViewLayout.collectionViewContentSize.height)!)
//    }
	// MARK: - UICollectionViewDataSource
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if reminder > 0
		{
			return ((self.objSwitchBoxes.moods?.count)! + (horizontalRows - reminder))
		}
			return ((self.objSwitchBoxes.moods?.count)!)
		}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell: SwitchForMoodSettingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwitchForMoodSettingCollectionViewCell", for: indexPath) as! SwitchForMoodSettingCollectionViewCell
		
		var objMoodToSend = Mood()
		var isAllowCellEditing : Bool? = true
		if (indexPath.row > (self.objSwitchBoxes.moods?.count)! - 1)
		{
			isAllowCellEditing = false
		}
		else
		{
			objMoodToSend = self.objSwitchBoxes.moods![indexPath.row]
		}
		cell.delegate = self
		cell.configureSwitchForMoodSettingCollectionViewCell(obj:objMoodToSend , isAllowEditing: isAllowCellEditing!, indexPath: indexPath)
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	}
	
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((self.tableViewWidth - (self.spacingConstant * CGFloat(horizontalRows + 1))) / CGFloat(horizontalRows)) // (collection view width - left side space - right side space - (2 * space between cells)) divide by no. of cells i.e. 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(self.spacingConstant, self.spacingConstant, self.spacingConstant, self.spacingConstant);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // vertical space between cells
        return self.spacingConstant
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // horizontal space between cells
        return self.spacingConstant
    }
	
	@IBAction func tappedOnSwitchOnOff(_ sender: Any) {
		self.btnSwitch.isSelected = !self.btnSwitch.isSelected
		
		var str = "1"
		if self.btnSwitch.isSelected == false {
			// off
			str = "0"
		}
		//		//MVC Data Will Be Updated
		self.objSwitchBoxes.masterSwitch?.status = Int(str)!
	}
	//MARK:- SwitchForMoodSettingCollectionViewCellDelegate
	func tappedOnSwitch(obj: Mood, status: String, indexPath : IndexPath)
	{
		collectionView.reloadItems(at: [indexPath])
	}
	func longPressOnSteapperView(obj: Mood)
	{
		self.delegate?.longPressOnSteapperView(obj: obj)
	}
}
