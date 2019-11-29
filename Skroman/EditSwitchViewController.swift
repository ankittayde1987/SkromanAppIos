//
//  EditSwitchViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/18/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

protocol EditSwitchViewControllerDelegate {
	func updateSwitchName(obj : Switch)
}

class EditSwitchViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,SwitchIconCollectionViewCellDelegate{
    let spacing: CGFloat = 15
    var reminder : Int = 0
    var delegate : EditSwitchViewControllerDelegate?
    @IBOutlet weak var collectionView: TPKeyboardAvoidingCollectionView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var vwSeprator: UIView!
    @IBOutlet weak var vwBottomContainer: UIView!
    
    @IBOutlet weak var vwConstant_iPadWidth: NSLayoutConstraint!
    var imagesArray = Array<String>()
    var objSwitch = Switch()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initViewController()
        setupCollectionView()
        
        //Get Default Images According to type
        imagesArray = self.objSwitch.getDefaultImagesArrayAccordingToType()
        
        //To Show Dummy cells and maintain 3*3
        reminder = self.imagesArray.count % 3
        customiseUIForIPad()
    }
    func customiseUIForIPad()
    {
        if Utility.isIpad()
        {
            self.vwConstant_iPadWidth.constant = CONSTANT_IPAD_VIEW_WIDTH
        }
        else
        {
            btnSave.titleLabel?.font = Font_SanFranciscoText_Regular_H16
            setFont()
            setColor()
            localizeText()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    fileprivate func setupCollectionView() {
        // Registering nibs
        collectionView.register(UINib.init(nibName: "SwitchIconCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SwitchIconCollectionViewCell")
        
        
        collectionView.register(UINib.init(nibName: "HeaderForEditSwitchCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderForEditSwitchCollectionReusableView")
        
        collectionView.register(UINib.init(nibName: "FooterButtonCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterButtonCollectionReusableView")
        // Disabling automatic content inset behaviour
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
    }
    func initViewController()
    {
        self.title = SSLocalizedString(key: "edit_switch")
        view.backgroundColor = UICOLOR_MAIN_BG
        collectionView.backgroundColor = UICOLOR_MAIN_BG
    }
    func setFont()
    {
        btnSave.titleLabel?.font = Font_SanFranciscoText_Regular_H16
    }
    func setColor()
    {
        vwBottomContainer.backgroundColor = UICOLOR_BLUE
        btnSave.backgroundColor = UICOLOR_BLUE
        vwSeprator.backgroundColor = UICOLOR_SEPRATOR
    }
    func localizeText()
    {
        btnSave.setTitle(SSLocalizedString(key: "save").uppercased(), for: .normal)
        btnSave.setTitle(SSLocalizedString(key: "save").uppercased(), for: .selected)
    }
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if reminder > 0
        {
            return ( imagesArray.count + (3 - reminder))
        }
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SwitchIconCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwitchIconCollectionViewCell", for: indexPath) as! SwitchIconCollectionViewCell
        
        var isAllowCellEditing : Bool? = true
        var imageNameToSet : String? = ""
        if (indexPath.row > self.imagesArray.count - 1)
        {
            isAllowCellEditing = false
        }
        else
        {
            imageNameToSet = self.imagesArray[indexPath.row]
        }
        cell.delegate = self
        cell.configureSwitchIconCollectionViewCell(obj: self.objSwitch, imageName: imageNameToSet!, isAllowEditing: isAllowCellEditing!, indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let collectionHeaderView: HeaderForEditSwitchCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderForEditSwitchCollectionReusableView", for: indexPath) as! HeaderForEditSwitchCollectionReusableView
            collectionHeaderView.configureCollectionHeader(obj: self.objSwitch)
            return collectionHeaderView
            
        case UICollectionElementKindSectionFooter:
            let collectionHeaderView: FooterButtonCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterButtonCollectionReusableView", for: indexPath) as! FooterButtonCollectionReusableView
            collectionHeaderView.btnSave.addTarget(self, action: #selector(tappedOnSave(_:)), for: .touchUpInside)
            return collectionHeaderView
            
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView.init()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - (spacing * 4)) / 3.0 // (collection view width - left side space - right side space - (2 * space between cells)) divide by no. of cells i.e. 3
        return CGSize(width: width, height: 87.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, spacing, spacing, spacing);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // vertical space between cells
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // horizontal space between cells
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if Utility.isIpad()
        {
            return CGSize(width: collectionView.frame.size.width, height: 110)
        }
        else
        {
            return CGSize(width: 0, height: 0)
        }
        
    }
    //MARK:- IBAction
    @IBAction func tappedOnSave(_ sender: Any) {
        //Need Help Sapanesh Sir
        if self.objSwitch.wattage! > 0
        {
            //API call
            self.powerConsumptionAPICall()
        }
        
        DatabaseManager.sharedInstance().updateSwitchNameAndSwitchImage(self.objSwitch)
        self.delegate?.updateSwitchName(obj: self.objSwitch)
        
        //integrate Api Here for saving name
        
        SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_RENAME_SWITCH) { (data, topic) in
            SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_RENAME_SWITCH)
            if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_RENAME_SWITCH)
            {
                SSLog(message: data)
                SSLog(message: "SUCCESSS")
//                //DeleteEverythingFrom DataBase
//                DatabaseManager.sharedInstance().deleteAllTableData()
            }
        }
        let dict =  NSMutableDictionary()
        dict.setValue(self.objSwitch.switchbox_id, forKey: "switchbox_id");
        dict.setValue(self.objSwitch.switch_id, forKey: "switch_id");
        dict.setValue(self.objSwitch.switch_name, forKey: "name");

        print("switchdata \(dict)")
        
        SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_RENAME_SWITCH_ACK) { (error) in
            print("error :\(String(describing: error))")
            if((error) != nil)
            {
                Utility.showErrorAccordingToLocalAndGlobal()
            }
            else{
                // what to do wit the response received here
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK:- validateUserEnteredData method
    func validateUserEnteredData() -> Bool {
        if(Utility.isEmpty(val: self.objSwitch.switch_name)){
            showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_switch_name"))
            return false
        }
        return true
    }
    
    
    //MARK:- SwitchIconCollectionViewCellDelegate
    func selectIconForSwitch(obj: Switch, selectedIconName: String, indexPath: IndexPath) {
        self.objSwitch.switch_icon = selectedIconName
        self.collectionView.reloadData()
        //		collectionView.reloadItems(at: [indexPath])
    }
    
    
    //MARK:- powerConsumptionAPICall
    func powerConsumptionAPICall()
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API powerConsumptionAPICall")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_SET_WATTAGE_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_SET_WATTAGE_ACK)
                
                SSLog(message: "TOPICCCCC:: \(topic)")
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_SET_WATTAGE_ACK)
                {
                    SSLog(message: "SUCCESSSSSSSSSSSS")
                    //We got data from Server
                    if let objSwitch : Switch? = Switch.decode(data!){
                        //Handle Success
                        SSLog(message: objSwitch)
                        print("here---- SM_TOPIC_SET_WATTAGE_ACK \(topic)")
                        DatabaseManager.sharedInstance().updateSwitchWattage(self.objSwitch)
                    }
                }
            }
            let dict =  NSMutableDictionary()
            dict.setValue(self.objSwitch.switchbox_id, forKey: "switchbox_id");
//            dict.setValue("\(self.objSwitch.switch_id!)", forKey: "switch_id");
            dict.setValue(self.objSwitch.switch_id, forKey: "switch_id")
            dict.setValue(self.objSwitch.wattage, forKey: "wattage")
            print("switchdata \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_SET_WATTAGE) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
}
