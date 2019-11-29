//
//  AddNewRoomViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import PEPhotoCropEditor

protocol AddNewRoomViewControllerDelegate {
	func reloadAddRoomControllerOnSuccessOfAddOrEditRoom()
}

class AddNewRoomViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,RoomIconCollectionViewCellDelegate,PECropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
	let spacing: CGFloat = 15
	@IBOutlet weak var btnSave: UIButton!
	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var vwBottomContainer: UIView!
	@IBOutlet weak var collectionView: TPKeyboardAvoidingCollectionView!
	let picker = UIImagePickerController()
	var imgAttachment = UIImage()
	var isCustomImage : Bool? = false
	
    @IBOutlet weak var vwConstant_iPadWidth: NSLayoutConstraint!
    var delegate : AddNewRoomViewControllerDelegate?
	var comeFrom : AddNewRoomViewControllerComeFrom? = .addNewRoom
	var objRoom : Room?
	var imagesArray = Array<String>()
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		initViewController()
		setupCollectionView()
		
		imagesArray = (self.objRoom?.getDefaultImagesArray())!
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
		collectionView.register(UINib.init(nibName: "RoomIconCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RoomIconCollectionViewCell")
		
		
		collectionView.register(UINib.init(nibName: "HeaderForAddRoomCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderForAddRoomCollectionReusableView")
        
        collectionView.register(UINib.init(nibName: "FooterButtonCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterButtonCollectionReusableView")
        
        
		// Disabling automatic content inset behaviour
		if #available(iOS 11.0, *) {
			collectionView.contentInsetAdjustmentBehavior = .never
		}
	}
	func initViewController()
	{
		self.title = SSLocalizedString(key: "add_room")
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
		return imagesArray.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: RoomIconCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomIconCollectionViewCell", for: indexPath) as! RoomIconCollectionViewCell
		cell.delegate = self
		if imagesArray.count == indexPath.row + 1
		{
			isCustomImage = true
		}
        else
        {
          isCustomImage = false
        }
		cell.configureRoomIconCollectionViewCell(obj: self.objRoom!, imageName: imagesArray[indexPath.row], isAllowEditing: true, indexPath: indexPath, isCustomIcon: isCustomImage!, attachImage: self.imgAttachment)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch kind {
			
		case UICollectionElementKindSectionHeader:
			let collectionHeaderView: HeaderForAddRoomCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderForAddRoomCollectionReusableView", for: indexPath) as! HeaderForAddRoomCollectionReusableView
			collectionHeaderView.configureCellWith(obj: self.objRoom!)
			return collectionHeaderView
            
        case UICollectionElementKindSectionFooter:
            let collectionHeaderView: FooterButtonCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterButtonCollectionReusableView", for: indexPath) as! FooterButtonCollectionReusableView
            collectionHeaderView.btnSave.addTarget(self, action: #selector(tappedSave(_:)), for: .touchUpInside)
            return collectionHeaderView
			
		default:
			assert(false, "Unexpected element kind")
			return UICollectionReusableView.init()
			
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if imagesArray.count == indexPath.row + 1
//        {
//            isCustomImage = true
//        }
//        else
//        {
//            isCustomImage = false
//        }
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
		
		return CGSize(width: collectionView.frame.size.width, height: 188)
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

	@IBAction func tappedSave(_ sender: Any) {
		let isValidData: Bool = validateUserEnteredData()
		if isValidData {
			//Need Help Sapanesh Sir
			if self.comeFrom == .addNewRoom
			{
				self.addNewRoom()
			}
			else if self.comeFrom == .editRoom
			{
				self.editRoom()
			}
		}
	}
	
	// MARK:- validateUserEnteredData method
	func validateUserEnteredData() -> Bool {
		if(Utility.isEmpty(val: self.objRoom?.room_name)){
			showAlertMessage(strMessage: SSLocalizedString(key: "please_enter_room_name"))
			return false
		}
		return true
	}
	
	//MARK:- RoomIconCollectionViewCellDelegate
	func selectIconForRoom(obj: Room, selectedIconName: String, indexPath : IndexPath,isCustomIcon : Bool) {
		if isCustomIcon
		{
			self.view.endEditing(true)
			self.tappedOnCustomImage()
		}
		else
		{
			self.objRoom?.image = selectedIconName
			self.collectionView.reloadData()
		}
		
	}
	
	//API CALL BY GAURAV
	func addNewRoom()
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API addroom")
             let topicToack = "\(VVBaseUserDefaults.getCurrentPIID())/\(VVBaseUserDefaults.getCurrentHomeID())/create_room_ack"
            SMQTTClient.sharedInstance().subscribe(topic: topicToack) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: topicToack)
                
                if topic == Utility.getTopicNameToCheck(topic: topicToack)
                {
                    var responseDict : NSDictionary?
                    do {
                        let obj = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(obj)
                        responseDict = obj as? NSDictionary
                    } catch let error {
                        print(error)
                    }
                    
                    
                    
                    //We got data from Server
                    if let objRoom : Room? = Room.decode(data!){
                        
                        //Check Room Already Exist if yes don't insert else insert inDB
                        
                        if !DatabaseManager.sharedInstance().isAlreadyRoomExistsInDB(room_id: objRoom?.room_id ?? "")
                        {
                            //Handle Success
                            if self.isCustomImage!
                            {
                                if !Utility.isImageNull(self.imgAttachment)
                                {
                                    self.objRoom?.image = self.testForImage(obj: objRoom!)
                                }
                            }
                            
                            DatabaseManager.sharedInstance().addRoomWithHID(room_name: (objRoom?.room_name!)!, room_id: (objRoom?.room_id!)!, home_id: (self.objRoom?.home_id)!, image: (self.objRoom?.image)!)
                            self.delegate?.reloadAddRoomControllerOnSuccessOfAddOrEditRoom()
                             DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                            NotificationCenter.default.post(name: .defaultHomeChange, object: nil)
                        }
                        else
                        {
                            SSLog(message: "Room Already exists")
                            //Show error message Home already exists!!!
                            self.showAlertMessage(strMessage: SSLocalizedString(key: "room_already_exists"))
                            return
                        }
                        
                        
                        print("here---- SM_TOPIC_CREATE_ROOM_ACK \(topic)")
                    }
                }
            }
            let dict =  NSMutableDictionary()
            dict.setValue(self.objRoom?.room_name, forKey: "room_name");
            
            print("SM_TOPIC_CREATE_ROOM \(dict)")
//            print("VVBaseUserDefaults.getCurrentHomeID() \(VVBaseUserDefaults.getCurrentHomeID())")
            let topicTosend = "\(VVBaseUserDefaults.getCurrentPIID())/\(VVBaseUserDefaults.getCurrentHomeID())/create_room"
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: topicTosend) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }

	//API CALL BY GAURAV
	func editRoom()
    {
        if !Utility.isAnyConnectionIssue()
        {
            SSLog(message: "API editroom")
            SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_RENAME_ROOM_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_RENAME_ROOM_ACK)
                
                //We got data from Server
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_RENAME_ROOM_ACK)
                {
                    if let objRoom : Room? = Room.decode(data!){
                        //Handle Success
                        if self.isCustomImage!
                        {
                            if !Utility.isImageNull(self.imgAttachment)
                            {
                                //To Avoid crash
                                objRoom?.room_id = self.objRoom?.room_id
                                self.objRoom?.image = self.testForImage(obj: objRoom!)
                            }
                        }
                        DatabaseManager.sharedInstance().updateRoomWithHID(room_name: (objRoom?.room_name!)!, room_id: (objRoom?.unique_room_id!)!, home_id: (self.objRoom?.home_id)!, image: (self.objRoom?.image)!)
                        self.delegate?.reloadAddRoomControllerOnSuccessOfAddOrEditRoom()
                         DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        NotificationCenter.default.post(name: .defaultHomeChange, object: nil)
                        print("here---- SM_TOPIC_RENAME_ROOM_ACK \(topic)")
                    }
                }
            }
            let dict =  NSMutableDictionary()
            dict.setValue(self.objRoom?.room_name, forKey: "room_name");
            dict.setValue(self.objRoom?.room_id, forKey: "unique_room_id");
            
            print("SM_TOPIC_RENAME_ROOM \(dict)")
            
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_RENAME_ROOM) { (error) in
                print("error :\(String(describing: error))")
                if((error) != nil)
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }

	
	func tappedOnCustomImage()
	{
		self.picker.delegate = self
		func noCamera(){
			let alertVC = UIAlertController(
				title: APP_NAME_TITLE,
				message: SSLocalizedString(key: "sorry_this_device_has_no_camera"),
				preferredStyle: .alert)
			let okAction = UIAlertAction(
				title: SSLocalizedString(key: "ok"),
				style:.default,
				handler: nil)
			alertVC.addAction(okAction)
			
			
			present(
				alertVC,
				animated: true,
				completion: nil)
		}
		
		let actionSheetController: UIAlertController = UIAlertController(title: APP_NAME_TITLE, message: SSLocalizedString(key: "add_room_logo"), preferredStyle: .actionSheet)
		
		let cancelAction: UIAlertAction = UIAlertAction(title: SSLocalizedString(key: "cancel"), style: .cancel) { action -> Void in
		}
		actionSheetController.addAction(cancelAction)
		let takePictureAction: UIAlertAction = UIAlertAction(title: SSLocalizedString(key: "camera"), style: .default) { action -> Void in
			if UIImagePickerController.isSourceTypeAvailable(.camera) {
				self.picker.allowsEditing = false
				self.picker.sourceType = UIImagePickerControllerSourceType.camera
				self.picker.cameraCaptureMode = .photo
				self.picker.modalPresentationStyle = .fullScreen
				self.present(self.picker,animated: true,completion: nil)
			} else {
				noCamera()
			}
			
			
		}
		actionSheetController.addAction(takePictureAction)
		let choosePictureAction: UIAlertAction = UIAlertAction(title: SSLocalizedString(key: "gallary"), style: .default) { action -> Void in
			self.picker.allowsEditing = false
			self.picker.sourceType = .photoLibrary
			self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
			self.picker.modalPresentationStyle = .popover
			self.present(self.picker, animated: true, completion: nil)
			
		}
		
		actionSheetController.addAction(choosePictureAction)
		UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
		
		self.present(actionSheetController, animated: true, completion: nil)
	}
	
	//MARK: - ImagePickerDelegate
	
	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
		
		UINavigationBar.appearance().tintColor = UIColor.white
		let image: UIImage? = (info[UIImagePickerControllerOriginalImage] as? UIImage)
		dismiss(animated: true) {
			let controller = PECropViewController()
			controller.delegate = self
			controller.image = image
			let width: CGFloat? = image?.size.width
			let height: CGFloat? = image?.size.height
			let length: CGFloat = min(width!, height!)
			controller.keepingCropAspectRatio = false
			controller.imageCropRect = CGRect(x: (width! - length) / 2, y: (height! - length) / 2, width: length, height: length)
			controller.toolbarHidden = true
			controller.title = "Zoom and Crop"
			let navController = UINavigationController(rootViewController: controller)
			navController.navigationBar.tintColor = UIColor.white
			navController.toolbar.tintColor = UIColor.white
			navController.navigationBar.tintColor = UICOLOR_WHITE
			
			self.present(navController, animated:true, completion: nil)
		}
		
	}
	
	
	func cropViewController(_ controller: PECropViewController, didFinishCroppingImage croppedImage: UIImage) {
		
		let image : UIImage = croppedImage;
		// self.imgBarCode.contentMode = .scaleToFill
		self.imgAttachment = image
		// self.isUploadBarcode = true
		controller.dismiss(animated: true, completion: nil)
		// call upload document api here
		
		let indexPath = IndexPath(row: (imagesArray.count - 1), section: 0) // indexPath for top profile cell
		self.collectionView.reloadItems(at: [indexPath])
		//API CALL
		//self.uploadCompanyDocumeny()
	}
	
	func cropViewControllerDidCancel(_ controller: PECropViewController) {
		//applyGlobalInterfaceAppearance()
		UIAppDelegate.applyGlobalInterfaceAppearance()
		controller.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		UIAppDelegate.applyGlobalInterfaceAppearance()
		dismiss(animated: true, completion: nil)
	}
	func testForImage(obj : Room) -> String
	{
		// get the documents directory url
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		// choose a name for your image
		let fileName = String(format : "%@%@",IMAGENAME,(obj.room_id)!)
		// create the destination file url to save your image
		let fileURL = documentsDirectory.appendingPathComponent(fileName)
		// get your UIImage jpeg data representation and check if the destination file url already exists
		if let data = UIImageJPEGRepresentation(imgAttachment, 0.5),
			!FileManager.default.fileExists(atPath: fileURL.path) {
			do {
				// writes the image data to disk
				try data.write(to: fileURL)
				print("file saved")
			} catch {
				print("error saving file:", error)
			}
		}
		return fileName
	}
}
