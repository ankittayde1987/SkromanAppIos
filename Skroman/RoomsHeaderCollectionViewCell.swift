//
//  RoomsHeaderCollectionViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 9/25/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

protocol RoomsHeaderCollectionViewCellDelegate {
	func tappedOnMore(_ sender: UIButton,moodsCount:String)
    func tappedOnMoodBtn(obj : Mood,moodsCount:String)
	func longPressOnButtonMood(_ sender: UIButton, obj : Mood)
}

class RoomsHeaderCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,MoodButtonCollectionViewCellDelegate {
    
	
    @IBOutlet weak var lblScenes: UILabel!
    var delegate : RoomsHeaderCollectionViewCellDelegate?

	@IBOutlet weak var lblActiveDevicesCount: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var btnMenu: UIButton!
	
    
	var arrMoodsForHome = NSMutableArray()
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblScenes.font = Font_Titillium_Semibold_H16
        self.lblScenes.textColor = UICOLOR_WHITE
        self.lblScenes.text = SSLocalizedString(key: "scenes").uppercased()
		self.setupCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleMoodButtonAddition(_:)), name: .handleMoodButtonAddition, object: nil)

    }
	
	func configureCellWith(arr : NSMutableArray)
	{
        self.arrMoodsForHome.removeAllObjects()
        self.arrMoodsForHome = NSMutableArray()
		self.arrMoodsForHome = arr
		self.attributedStringForActiveDevices()
		self.collectionView.reloadData()
	}
	
    
	fileprivate func setupCollectionView() {
		//IF VERTICAL SCROLLING IS THERE THEN HIDE BELOW CODE
//		let layout = GauravCollectionViewFlowLayout()
//		layout.scrollDirection = .vertical
//		collectionView.collectionViewLayout = layout
		
		// Registering nibs
		collectionView.register(UINib.init(nibName: "MoodButtonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MoodButtonCollectionViewCell")
	}
		
    @objc func handleMoodButtonAddition(_ notification: Notification){
        
        self.collectionView.reloadData()
    }
	// MARK: - UICollectionViewDataSource
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.arrMoodsForHome.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let objMood = arrMoodsForHome[indexPath.row] as! Mood
		let cell: MoodButtonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoodButtonCollectionViewCell", for: indexPath) as! MoodButtonCollectionViewCell
		cell.delegate = self
		cell.configureCellWith(obj: objMood, indexPath: indexPath)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
	
	// MARK: - UICollectionViewDelegateFlowLayout
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		//Need to calculate Width for Button according to text here
		let obj = self.arrMoodsForHome[indexPath.row] as! Mood
		let str =  obj.mood_name
		var rect: CGRect = str!.boundingRect(with: CGSize(width: 500, height: 500), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: Font_SanFranciscoText_Regular_H14!], context: nil)
		rect.size.width += 20;
		rect.size.width = ceil(rect.size.width);
		
		return CGSize(width: rect.size.width, height: 28)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsMake(spacing, 14, spacing, 14)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		// vertical space between cells
		return spacing
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		// horizontal space between cells
		return spacing
	}

	class func cellHeight() -> CGFloat {
		var sizingCell: RoomsHeaderCollectionViewCell? = nil
		if sizingCell == nil {
			let nib: [Any] = Bundle.main.loadNibNamed("RoomsHeaderCollectionViewCell", owner: self, options: nil)!
			sizingCell = (nib[0] as? RoomsHeaderCollectionViewCell)
		}
		return ((sizingCell?.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)! + (sizingCell?.collectionView.collectionViewLayout.collectionViewContentSize.height)!)
	}
	
	//MARK:- IBAction Methods
	@IBAction func tappedOnMore(_ sender: UIButton)
	{
        if self.arrMoodsForHome.count == 8
        {
            //show error
            let alert = UIAlertController(title: APP_NAME_TITLE as String?, message: SSLocalizedString(key: "max_eight_home_mood") as String, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: SSLocalizedString(key: "ok"), style: UIAlertActionStyle.default, handler: nil))
            alert.show()
        }
        else
        {
            if self.arrMoodsForHome.count == 1
            {
                let obj = self.arrMoodsForHome[0] as! Mood
                if obj.mood_id == DUMMY_MOOD_ID
                {
                    self.delegate?.tappedOnMore(sender, moodsCount: "\(self.arrMoodsForHome.count)")
                }
                else
                {
                    self.delegate?.tappedOnMore(sender, moodsCount: "\(self.arrMoodsForHome.count + 1)")
                }
                
            }
            else
            {
                self.delegate?.tappedOnMore(sender, moodsCount: "\(self.arrMoodsForHome.count + 1)")
            }
            
        }
		
	}
	
	//MARK:- MoodButtonCollectionViewCellDelegate
	func tappedOnMoodBtn(obj : Mood,indexPath : IndexPath)
	{
        if self.arrMoodsForHome.count == 8 && obj.mood_id == DUMMY_MOOD_ID
        {
            //show error
            let alert = UIAlertController(title: APP_NAME_TITLE as String?, message: SSLocalizedString(key: "max_eight_home_mood") as String, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: SSLocalizedString(key: "ok"), style: UIAlertActionStyle.default, handler: nil))
            alert.show()
        
        }
        else
        {
            
            if self.arrMoodsForHome.count == 1
            {
                let obj = self.arrMoodsForHome[0] as! Mood
                if obj.mood_id == DUMMY_MOOD_ID
                {
                    self.delegate?.tappedOnMoodBtn(obj: obj, moodsCount: "\(self.arrMoodsForHome.count)")
                }
                else
                {
                    self.triggerMood(objMood: obj, indePath: indexPath)
//                    self.delegate?.tappedOnMoodBtn(obj: obj, moodsCount: "\(self.arrMoodsForHome.count + 1)")
                }
                
            }
            else
            {
                if obj.mood_id != DUMMY_MOOD_ID
                {
                    self.triggerMood(objMood: obj, indePath: indexPath)
                    //                collectionView.reloadItems(at: [indexPath])
                }
                else
                {
                     self.delegate?.tappedOnMoodBtn(obj: obj, moodsCount: "\(self.arrMoodsForHome.count + 1)")
                }
            }
           
        }
        

	}
	func longPressOnButtonMood(_ sender: UIButton, obj : Mood)
	{
        if obj.mood_id != DUMMY_MOOD_ID
        {
            self.delegate?.longPressOnButtonMood(sender, obj: obj)
        }
		
	}
	
	
	
	fileprivate func attributedStringForActiveDevices() {
		let attributedString = NSMutableAttributedString()
		attributedString.append(NSAttributedString(string: SSLocalizedString(key: "active_devices"),
												   attributes: [.font: Font_Titillium_Regular_H14 ?? "",
																.foregroundColor: UICOLOR_WHITE]))
		attributedString.append(NSAttributedString(string: DatabaseManager.sharedInstance().getHomeOnSwitchesCount(),
												   attributes: [.font: Font_Titillium_Regular_H14 ?? "",
																.foregroundColor: UICOLOR_SELECTEDORON_BG]))
		attributedString.append(NSAttributedString(string: "/" + DatabaseManager.sharedInstance().getHomeSwitchesCount(),
												   attributes: [.font: Font_Titillium_Regular_H14 ?? "",
																.foregroundColor: UICOLOR_WHITE]))
		
		let style = NSMutableParagraphStyle()
		style.alignment = .left
		attributedString.addAttributes([.paragraphStyle: style], range: NSMakeRange(0, attributedString.length))
		
		lblActiveDevicesCount.attributedText = attributedString
	}
    
    
    
    //API CALL BY GAURAV
    func triggerMood(objMood : Mood, indePath : IndexPath)
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API triggerMood")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_HARDWARD_MOOD_TRIGGERED_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_HARDWARD_MOOD_TRIGGERED_ACK)
                
                //We got data from Server
                //Handle Success
                var responseDict : NSDictionary?
                do {
                    let obj = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(obj)
                    responseDict = obj as? NSDictionary
                } catch let error {
                    print(error)
                }
                var mood_status = 0
                //Need to handle it here
                if let str = responseDict?.value(forKey: "mood_status") as? Int {
                      mood_status = str
                }
                var mood_id = ""
                if let str1 = responseDict?.value(forKey: "mood_id") as? String {
                      mood_id = str1
                }
                
               
                DatabaseManager.sharedInstance().updateMoodStatus(moodStatus: mood_status, moodId: mood_id)
                
                self.collectionView.reloadData()
                

//                let objMood = DatabaseManager.sharedInstance().getMood(mood_id: mood_id)
//                let cell: MoodButtonCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MoodButtonCollectionViewCell", for: indePath) as! MoodButtonCollectionViewCell
//                cell.configureCellWith(obj: objMood, indexPath: indePath)
                
//                self.objMood.mood_name = responseDict?.value(forKey: "mood_name") as? String
//                DatabaseManager.sharedInstance().updateMood(objMood: self.objMood)
                print("here---- SM_TOPIC_HARDWARD_MOOD_TRIGGERED_ACK \(topic)")
            }
            let dict =  NSMutableDictionary()
            dict.setValue(objMood.mood_id, forKey: "mood_id");
            dict.setValue(objMood.mood_type, forKey: "mood_type");
            
            print("dict \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_HARDWARD_MOOD_TRIGGERED) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
}
