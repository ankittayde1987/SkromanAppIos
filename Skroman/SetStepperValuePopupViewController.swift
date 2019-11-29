//
//  SetStepperValuePopupViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 10/9/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import STPopup

protocol SetStepperValuePopupViewControllerDelegate {
	func didChangeTheSteeperValue(obj : Switch)
	func didChangeTheSteeperValueForMoodSettings(obj : Mood)
}
class SetStepperValuePopupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	var delegate : SetStepperValuePopupViewControllerDelegate?
	var steeperValuesArray = Array<Int>()
	var objSwitch = Switch()
	var objMood = Mood()
	var comeFrom : SetStepperValuePopupViewControllerComeFrom? = .roomDetails
	
	@IBOutlet weak var vwSteeper: UISlider!
	@IBOutlet weak var collectionView: UICollectionView!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		//Get Default Steeper value to type
		if self.comeFrom == .roomDetails
		{
			steeperValuesArray = self.objSwitch.getSteeperValueArray()
		}
		else
		{
			steeperValuesArray = self.objMood.getSteeperValueArray()
		}
		
		self.vwSteeper.thumbTintColor = UICOLOR_PINK
		self.vwSteeper.minimumTrackTintColor = UICOLOR_PINK
		self.initController()
		self.setupCollectionView()
		
		
    }
	func initController()
	{
        if Utility.isIpad()
        {
            self.contentSizeInPopup = CGSize.init(width: CONSTANT_IPAD_VIEW_WIDTH - 60, height: 92)
        }
        else
        {
            self.contentSizeInPopup = CGSize.init(width: SCREEN_SIZE.width - 60, height: 92)
        }
		
		self.view.backgroundColor = UICOLOR_WHITE
		self.view.layer.cornerRadius = 3.0
		self.view.layer.borderWidth = 1.0
		self.popupController?.containerView.layer.cornerRadius = 3.0
		self.popupController?.containerView.layer.borderWidth = 1.0
		self.popupController?.navigationBarHidden = true
		
		
		self.vwSteeper.minimumValue = Float(steeperValuesArray.first!)
		self.vwSteeper.maximumValue = Float(steeperValuesArray.last!)
//		self.vwSteeper.setContinuous = false
		self.vwSteeper.isContinuous = false
		
		if self.comeFrom == .roomDetails
		{
			if self.objSwitch.position == nil
			{
				self.objSwitch.position = 0
			}
			self.vwSteeper.value = Float(self.objSwitch.position!)
		}
		else
		{
			self.vwSteeper.value = Float(self.objMood.position)
		}

		

		let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tappedView(_:)))
		self.popupController?.backgroundView?.addGestureRecognizer(tapGestureRecognizer)
	}
	@objc func tappedView(_ sender : UIView)
	{
		self.popupController?.dismiss()
	}
	fileprivate func setupCollectionView() {
		// Registering nibs
		collectionView.register(UINib.init(nibName: "SteeperValueLabelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SteeperValueLabelCollectionViewCell")
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// MARK: - UICollectionViewDataSource
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return steeperValuesArray.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: SteeperValueLabelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SteeperValueLabelCollectionViewCell", for: indexPath) as! SteeperValueLabelCollectionViewCell

		cell.txtValue.text = "\(self.steeperValuesArray[indexPath.row])"
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	}
	
	// MARK: - UICollectionViewDelegateFlowLayout
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
//		let trackRect: CGRect = self.vwSteeper.trackRect(forBounds: self.vwSteeper.bounds)
//		let thumbRect: CGRect = self.vwSteeper.thumbRect(forBounds: self.vwSteeper.bounds, trackRect: trackRect, value: 0)
//		let thumbSize: CGSize = thumbRect.size
//		return CGSize(width: thumbSize.width, height: 30)

		return CGSize(width: 27, height: 30)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsMake(0, 0, 0, 0);
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		// vertical space between cells
		let totalWidthOfAllCells = 27 * CGFloat(self.steeperValuesArray.count)
		let totalWidthOfCollectionView = collectionView.frame.size.width
		let diff = totalWidthOfCollectionView - totalWidthOfAllCells
		let space = diff / CGFloat(self.steeperValuesArray.count - 1)
		return space
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		// horizontal space between cells
		return 0
	}
	
	@IBAction func didChangeStapperValue(_ sender: UISlider) {
		vwSteeper.value = roundf(vwSteeper.value);
		SSLog(message: vwSteeper.value)
		self.popupController?.dismiss(completion: {
			if self.comeFrom == .roomDetails
			{
				self.objSwitch.position = Int(roundf(self.vwSteeper.value));
				self.delegate?.didChangeTheSteeperValue(obj: self.objSwitch)
			}
			else
			{
				self.objMood.position = Int(roundf(self.vwSteeper.value));
				self.delegate?.didChangeTheSteeperValueForMoodSettings(obj: self.objMood)
			}
			
		})
	}
	
}
