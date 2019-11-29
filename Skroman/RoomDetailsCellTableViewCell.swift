//
//  RoomDetailsCellTableViewCell.swift
//  Skroman
//
//  Created by Sphinx Solutions on 9/14/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

protocol RoomDetailsCellTableViewCellDelegate {
	func tappedOnMenuButton(_ sender: UIButton,obj : SwitchBox)
	func tappedOnDataUsage(obj : SwitchBox)
	func longPressOnContainerView(_ sender: UIView, obj: Switch)
	func tappedOnMoods(strSwitchBox_id : String)
	func longPressOnSteapperView(obj: Switch)
    
    func updateMasterSwitchAPI(obj : Switch,status : String,indexPath : IndexPath)
}

class RoomDetailsCellTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,SwitchStatusCollectionViewCellDelegate {
	
	var delegate : RoomDetailsCellTableViewCellDelegate?
	let spacing: CGFloat = 12
	
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
	
	
	@IBOutlet weak var btnDataUsage: UIButton!
	@IBOutlet weak var btnMoods: UIButton!
	@IBOutlet weak var imagSettings: UIImageView!
	@IBOutlet weak var lblMoods: UILabel!
	@IBOutlet weak var vwMoods: UIView!
	
	
	@IBOutlet weak var vwBottomFix: UIView!
	@IBOutlet weak var vwCollectionViewBottomSeprator: UIView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var vwCollectionViewTopSeprator: UIView!
	@IBOutlet weak var imagGraph: UIImageView!
	@IBOutlet weak var lblDataUsageTitle: UILabel!
	@IBOutlet weak var btnSwitch: UIButton!
	@IBOutlet weak var lblActiveDeviceCount: UILabel!
	@IBOutlet weak var btnMenu: UIButton!
	@IBOutlet weak var lblDeviceName: UILabel!
	@IBOutlet weak var vwTopSeprator: UIView!
    var tableIndexPath : IndexPath!
	var objSwitchBoxes = SwitchBox()
	var objMasterSwitch = Switch()
	
	var reminder : Int = 0
    var tableViewWidth: CGFloat = 0
    
    
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		//		self.collectionView.dataSource = self
		//		self.collectionView.delegate = self
        initCell()
	}
	func initCell()
	{
		self.contentView.backgroundColor = UICOLOR_ROOM_CELL_BG
		self.vwTopSeprator.backgroundColor = UICOLOR_ROOM_CELL_SEPRATOR
		self.vwCollectionViewTopSeprator.backgroundColor = UICOLOR_ROOM_CELL_SEPRATOR
		self.vwCollectionViewBottomSeprator.backgroundColor = UICOLOR_ROOM_CELL_SEPRATOR
		self.vwBottomFix.backgroundColor = UICOLOR_MAIN_BG
        if Utility.isIpad()
        {
            self.vwBottomFix.backgroundColor = UICOLOR_ROOM_CELL_BG
            self.vwCollectionViewBottomSeprator.backgroundColor = UICOLOR_ROOM_CELL_BG
        }
        self.collectionView.backgroundColor = UICOLOR_ROOM_CELL_BG
		self.lblDeviceName.font = Font_SanFranciscoText_Regular_H18
		self.lblActiveDeviceCount.font = Font_SanFranciscoText_Regular_H16
		self.lblDataUsageTitle.font = Font_SanFranciscoText_Regular_H14
		
		//
		self.vwMoods.backgroundColor = UICOLOR_MOODS_BUTTON_BG
		self.vwMoods.layer.cornerRadius = 3.0
		self.lblMoods.font = Font_Titillium_Regular_H12
		self.lblMoods.text = SSLocalizedString(key: "moods")
		
		self.lblDataUsageTitle.text = SSLocalizedString(key: "data_usage")
		
		self.setupCollectionView()
        
    }

    
    
	fileprivate func setupCollectionView() {
		// Registering nibs
		collectionView.register(UINib.init(nibName: "SwitchStatusCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SwitchStatusCollectionViewCell")
		
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
    func configureCellWithSwitchBox(switchbox:SwitchBox, tableViewWidth: CGFloat,tableIndexPath: IndexPath)
	{
        self.tableIndexPath = tableIndexPath
        self.objSwitchBoxes = switchbox;
        //GET MASTER SWITCH FROM SWITCHBOX
        self.objMasterSwitch = self.objSwitchBoxes.getMasterSwitchDataFromSwitchBox()
        //REMOVE MASTER SWITCH FROM SWITCHBOX
        self.objSwitchBoxes.removeMasterSwitchDataFromMainSwitchBoxes()
        //REMOVE MOOD SWITCH FROM SWITCHBOX
        self.objSwitchBoxes.removeMoodSwitchDataFromMainSwitchBoxes()

        reminder = (self.objSwitchBoxes.switches?.count)! % 3
        self.lblDeviceName.text = self.objSwitchBoxes.name
        self.attributedStringForSwitchName()
        self.attributedStringForActiveDevices()

        //FOR MASTER SWITCH ON/OFF
        self.btnSwitch.isSelected = true
        if self.objMasterSwitch.status == 0
        {
            self.btnSwitch.isSelected = false
        }
        
        self.tableViewWidth = tableViewWidth
        collectionViewHeightConstraint.constant = 0
        if let switches = self.objSwitchBoxes.switches {
            let noOfRows = CGFloat(ceil(Double(switches.count)/3.0))
            let widthOfCell = ((self.tableViewWidth - (spacing * 4)) / 3.0)
            let height = (widthOfCell * noOfRows) + ((noOfRows + 1) * spacing)
            collectionViewHeightConstraint.constant = height
        }
		self.collectionView.reloadData()
	}
    
	fileprivate func attributedStringForActiveDevices() {
		let attributedString = NSMutableAttributedString()
		attributedString.append(NSAttributedString(string: SSLocalizedString(key: "active_devices"),
												   attributes: [.font: Font_Titillium_Regular_H14 ?? "",
																.foregroundColor: UICOLOR_WHITE]))
		attributedString.append(NSAttributedString(string: self.objSwitchBoxes.getActiveSwitchesCount(),
												   attributes: [.font: Font_Titillium_Regular_H14 ?? "",
																.foregroundColor: UICOLOR_SELECTEDORON_BG]))
		attributedString.append(NSAttributedString(string: "/" + self.objSwitchBoxes.getTotalSwitchesCount(),
												   attributes: [.font: Font_Titillium_Regular_H14 ?? "",
																.foregroundColor: UICOLOR_WHITE]))
		
		let style = NSMutableParagraphStyle()
		style.alignment = .left
		attributedString.addAttributes([.paragraphStyle: style], range: NSMakeRange(0, attributedString.length))
		
		lblActiveDeviceCount.attributedText = attributedString
	}
	
	fileprivate func attributedStringForSwitchName() {
		let attributedString = NSMutableAttributedString()
		attributedString.append(NSAttributedString(string: self.objSwitchBoxes.name!,
												   attributes: [.font: Font_Titillium_Regular_H14 ?? "",
																.foregroundColor: UICOLOR_WHITE]))
		attributedString.append(NSAttributedString(string: String(format:" %@",self.objSwitchBoxes.getSelectedMoodsName()),
												   attributes: [.font: Font_Titillium_Regular_H14 ?? "",
																.foregroundColor: UICOLOR_SELECTEDORON_BG]))
		let style = NSMutableParagraphStyle()
		style.alignment = .left
		attributedString.addAttributes([.paragraphStyle: style], range: NSMakeRange(0, attributedString.length))
		
		lblDeviceName.attributedText = attributedString
	}
	
//    class func hightForRoomDetailsCellTableViewCell(switchbox:SwitchBox, tableViewWidth: CGFloat) -> CGFloat {
//        var sizingCell: RoomDetailsCellTableViewCell? = nil
//        if sizingCell == nil {
//            let nib: [Any] = Bundle.main.loadNibNamed("RoomDetailsCellTableViewCell", owner: self, options: nil)!
//            sizingCell = (nib[0] as? RoomDetailsCellTableViewCell)
//        }
//        sizingCell?.configureCellWithSwitchBox(switchbox: switchbox, tableViewWidth: tableViewWidth)
//
//        SSLog(message: "sizingCell collectionView collectionViewContentSize height\(sizingCell?.collectionView.contentSize.height ?? 0)!")
//
////        return ((sizingCell?.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)! + (sizingCell?.collectionView.collectionViewLayout.collectionViewContentSize.height)!)
//
//        return ((sizingCell?.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)!)
//    }
	
    // MARK: - UICollectionViewDataSource
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if reminder > 0
		{
			return ((self.objSwitchBoxes.switches?.count)! + (3 - reminder))
		}
		return ((self.objSwitchBoxes.switches?.count)!)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell: SwitchStatusCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwitchStatusCollectionViewCell", for: indexPath) as! SwitchStatusCollectionViewCell
		cell.delegate = self
		
		var objSwitchToSend = Switch()
		var isAllowCellEditing : Bool? = true
		if (indexPath.row > (self.objSwitchBoxes.switches?.count)! - 1)
		{
			isAllowCellEditing = false
		}
		else
		{
			 objSwitchToSend = self.objSwitchBoxes.switches![indexPath.row]
		}
		cell.configureCellForSwitchStatusCollectionViewCell(obj:objSwitchToSend , isAllowEditing: isAllowCellEditing!, indexPath: indexPath)
		return cell
	}
	
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	}
	
	// MARK: - UICollectionViewDelegateFlowLayout
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = ((self.tableViewWidth - (spacing * 4)) / 3.0) // (collection view width - left side space - right side space - (2 * space between cells)) divide by no. of cells i.e. 3
		return CGSize(width: width, height: width)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		// vertical space between cells
		return spacing
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		// horizontal space between cells
		return spacing
	}
	
	//MARK:- IBAction
	@IBAction func tappedMenu(_ sender: UIButton) {
		self.delegate?.tappedOnMenuButton(sender, obj: self.objSwitchBoxes)
	}
	
	@IBAction func tappedSwitchOnOff(_ sender: Any) {
		
//        self.btnSwitch.isSelected = !self.btnSwitch.isSelected
		
		var str = "0"
		if self.btnSwitch.isSelected == false {
			// off
			str = "1"
		}
        self.delegate?.updateMasterSwitchAPI(obj: self.objMasterSwitch, status: str, indexPath: self.tableIndexPath)
	}
	
	@IBAction func tappedDataUsage(_ sender: Any) {
		self.delegate?.tappedOnDataUsage(obj: self.objSwitchBoxes)
	}
	
    
    
	//MARK:- SwitchStatusCollectionViewCellDelegate
	func longPressOnContainerView(_ sender: UIView, obj: Switch) {
		self.delegate?.longPressOnContainerView(sender, obj: obj)
	}
    
    
    
	func tappedOnSwitch(obj: Switch, status: Int, indexPath : IndexPath){
        
        
		//Need Help Sapanesh Sir
//        self.updateSwitchAPICall(obj: obj, status: status, indexPath : indexPath)
        self.delegate?.updateMasterSwitchAPI(obj: obj, status: "\(status)", indexPath: self.tableIndexPath)
	}
	
    
    
    
	@IBAction func tappedOnMoods(_ sender: Any) {
		self.delegate?.tappedOnMoods(strSwitchBox_id: self.objSwitchBoxes.switchbox_id!)
	}
	func longPressOnSteapperView(obj: Switch)
	{
		self.delegate?.longPressOnSteapperView(obj: obj)
	}
	
    
    
    
	//API CALL BY GAURAV 
	func updateSwitchAPICall(obj: Switch, status: Int, indexPath : IndexPath)
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API updateSwitchAPICall")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_UPDATE_SWITCH_ACK_APP) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_UPDATE_SWITCH_ACK_APP)
                SSLog(message: "Successsssss")
                //We got data from Server
                if let objSwitch : Switch? = Switch.decode(data!){
                     if objSwitch != nil{
                            if objSwitch == nil{
                                SSLog(message: " Check by ankit for mumbai acetech 2019 , remove once fixed from server end")
                            }
                            else{
                                DatabaseManager.sharedInstance().updateSwitchStatus(objSwitch!, status: objSwitch?.status ?? 0)
                            }
                    }}
                //On 29/04/2019 Remove below and handle on response like above
//                DatabaseManager.sharedInstance().updateSwitchStatus(obj, status: status)
                self.attributedStringForActiveDevices()
                self.collectionView.reloadItems(at: [indexPath])
                NotificationCenter.default.post(name: .switchValueChange, object: nil)
                print("here---- SSM_TOPIC_UPDATE_SWITCH_ACK_APP \(topic)")
                //                }
            }
            let dict =  NSMutableDictionary()
            dict.setValue(obj.switchbox_id, forKey: "switchbox_id");
            dict.setValue("\(obj.switch_id!)", forKey: "switch_id");
            dict.setValue("\(status)", forKey: "status");
            dict.setValue("\(obj.position!)", forKey: "position");
            dict.setValue("1", forKey: "slide_end");
            print("switchdata \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_UPDATE_SWITCH) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
}
