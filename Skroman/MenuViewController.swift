//
//  MenuViewController.swift
//  CalenderApp
//
//  Created by Pradip Parkhe on 1/15/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

var fixedTableWidth : CGFloat = 200.0;
var topMargin : CGFloat = 50.0;
var trailingMargin : CGFloat = 10.0;
var spacingBetweenMenuAndButton : CGFloat = 20.0;

protocol MenuViewDelegate: NSObjectProtocol {
	func didSelectOption(indexPath: IndexPath, comeFrom: MenuViewControllerComeFrom, obj: Any)
}
class MenuViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
	
	@IBOutlet weak var myMenuWidth: NSLayoutConstraint!
	@IBOutlet weak var tableViewTrailing: NSLayoutConstraint!
	@IBOutlet weak var tableView:UITableView!

    @IBOutlet weak var myMenuHeight:NSLayoutConstraint!
    @IBOutlet weak var topCnt:NSLayoutConstraint!

    weak var menuDelegate: MenuViewDelegate?
    var comeFrom:MenuViewControllerComeFrom? = .room
    var arrList = Array <Category>()
    var arrMenuList = Array <String>()
    var selected_id  = "0"
	var tappedViewFrame : CGRect?
	var objSwitchBox : SwitchBox?
	var objSwitch : Switch?
	var objMood : Mood?
    override func viewDidLoad() {
        super.viewDidLoad()
		trailingMargin = 10
		tableView.layer.cornerRadius = 3.0
         tableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5);
		self.myMenuWidth.constant = fixedTableWidth
		if self.comeFrom == .room
        {
            arrMenuList = [SSLocalizedString(key: "rename"),
                           SSLocalizedString(key: "childlock"),
                           SSLocalizedString(key: "delete")]
            self.myMenuHeight.constant = 120
        }
		else if self.comeFrom == .switches
		{
			arrMenuList = [SSLocalizedString(key: "master_mode"),
						   SSLocalizedString(key: "edit")]
			self.myMenuHeight.constant = 80
		}
		else if self.comeFrom == .deviceMoods
		{
			arrMenuList = [SSLocalizedString(key: "configure_mood"),
						   SSLocalizedString(key: "rename")]
			self.myMenuHeight.constant = 80
			self.myMenuWidth.constant = 155
			self.tableView.layer.cornerRadius = 3.0
			self.tableView.layer.borderWidth = 1.0
			self.tableView.layer.borderColor = UICOLOR_DEVICE_MOOD_TABLE_BORDER.cgColor
		}
        else if self.comeFrom == .homeMoods
        {
            arrMenuList = [SSLocalizedString(key: "edit"),
                           SSLocalizedString(key: "rename"),
                           SSLocalizedString(key: "delete")]
            self.myMenuHeight.constant = 120
            self.myMenuWidth.constant = 155
            self.tableView.layer.cornerRadius = 3.0
            self.tableView.layer.borderWidth = 1.0
            self.tableView.layer.borderColor = UICOLOR_DEVICE_MOOD_TABLE_BORDER.cgColor
        }
        else if self.comeFrom == .roomMoods
        {
            arrMenuList = [SSLocalizedString(key: "edit"),
                           SSLocalizedString(key: "rename"),
                           SSLocalizedString(key: "delete")]
            self.myMenuHeight.constant = 120
            self.myMenuWidth.constant = 155
            self.tableView.layer.cornerRadius = 3.0
            self.tableView.layer.borderWidth = 1.0
            self.tableView.layer.borderColor = UICOLOR_DEVICE_MOOD_TABLE_BORDER.cgColor
        }

		//TO SHOW MENU
		let frame = CGRect(x: 0, y: (tappedViewFrame?.origin.y)!+(tappedViewFrame?.size.height)!+spacingBetweenMenuAndButton, width: tableView.frame.size.width, height: self.myMenuHeight.constant)
		
		if (UIAppDelegate.window?.frame.contains(frame))! {
			// show table below button
			topMargin = (tappedViewFrame?.origin.y)! + (tappedViewFrame?.size.height)!
		} else {
			// show table above button
			topMargin = (tappedViewFrame?.origin.y)! - self.myMenuHeight.constant
		}
		
		
		if self.comeFrom == .switches
		{
			topMargin = topMargin - spacingBetweenMenuAndButton
			trailingMargin = (UIAppDelegate.window?.frame.size.width)! - (tappedViewFrame?.origin.x)! - self.myMenuWidth.constant
			if trailingMargin < 0 {
				trailingMargin = 12
			}
		}
		else if self.comeFrom == .deviceMoods || self.comeFrom == .homeMoods || self.comeFrom == .roomMoods
		{
			topMargin = topMargin - 10
			trailingMargin = (UIAppDelegate.window?.frame.size.width)! - (tappedViewFrame?.origin.x)! - self.myMenuWidth.constant
			if trailingMargin < 0 {
				trailingMargin = 12
			}
		}
        else if self.comeFrom == .room
        {
            if Utility.isIpad()
            {
                let orientation = UIApplication.shared.statusBarOrientation
                if orientation == .landscapeLeft || orientation == .landscapeRight
                {
                    //120 is MyRoomsView width from HomeForIPadVC
                    let addToGetExactX = ((((UIAppDelegate.window?.frame.size.width)! - 120)/2) - (tappedViewFrame?.origin.x)!)
                    trailingMargin = (UIAppDelegate.window?.frame.size.width)! - (tappedViewFrame?.origin.x)! - self.myMenuWidth.constant + addToGetExactX
                    if trailingMargin < 0 {
                        trailingMargin = 12
                    }
                }
            }

        }
		self.tableView.layoutIfNeeded()
		self.showMenu()
    }
	
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
		return arrMenuList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 40;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath as IndexPath) as! MenuCell
		cell.selectionStyle = .none
		let obj = self.arrMenuList[indexPath.row];
		cell.lblTitle.text = obj
		cell.btnSwitch.isHidden = true
		cell.btnSwitchWidth.constant = 0
		if self.comeFrom == .room
		{
			if indexPath.row == 1
			{
				cell.btnSwitch.isHidden = false
				cell.btnSwitchWidth.constant = 43
			}
			cell.configureCellWith(obj: self.objSwitchBox!, comeFrom: self.comeFrom!)
		}
		else if self.comeFrom == .switches
		{
			if indexPath.row == 0
			{
				cell.btnSwitch.isHidden = false
				cell.btnSwitchWidth.constant = 43
			}
			cell.configureCellWith(obj: self.objSwitch!, comeFrom: self.comeFrom!)
		}
		else if self.comeFrom == .deviceMoods || self.comeFrom == .homeMoods || self.comeFrom == .roomMoods
		{
			cell.vwSeprator.backgroundColor = UICOLOR_DEVICE_MOOD_TABLE_BORDER
		}
		return cell
	}
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
		
		self.dismiss(animated: true) {
			if self.comeFrom == .room
			{
				if self.objSwitchBox == nil
				{
					self.objSwitchBox = SwitchBox()
				}
				self.menuDelegate?.didSelectOption(indexPath: indexPath, comeFrom: self.comeFrom!,obj: self.objSwitchBox!)
			}
			else if self.comeFrom == .switches
			{
				if self.objSwitch == nil
				{
					self.objSwitch = Switch()
				}
				self.menuDelegate?.didSelectOption(indexPath: indexPath, comeFrom: self.comeFrom!,obj: self.objSwitch!)
			}
			else if self.comeFrom == .deviceMoods
			{
				//TEMPORARY FOR
				if self.objMood == nil
				{
					self.objMood = Mood()
				}
				self.menuDelegate?.didSelectOption(indexPath: indexPath, comeFrom: self.comeFrom!,obj: self.objMood!)
			}
			else if self.comeFrom == .homeMoods
			{
				if self.objMood == nil
				{
					self.objMood = Mood()
				}
				self.menuDelegate?.didSelectOption(indexPath: indexPath, comeFrom: self.comeFrom!, obj: self.objMood!)
			}
            else if self.comeFrom == .roomMoods
            {
                if self.objMood == nil
                {
                    self.objMood = Mood()
                }
                self.menuDelegate?.didSelectOption(indexPath: indexPath, comeFrom: self.comeFrom!, obj: self.objMood!)
            }
		}
//		self.hideMenu()
    }
    
     func showMenu()
    {
        self.topCnt.constant = CGFloat(topMargin)
		self.tableViewTrailing.constant = CGFloat(trailingMargin)

        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 4.0, options: .curveEaseInOut, animations: {() -> Void in
            self.view.layoutIfNeeded()
        },completion: {(_ finished: Bool) -> Void in
        })
        UIView.commitAnimations()
    }
    
    @IBAction func hideMenu()
    {
		self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}
