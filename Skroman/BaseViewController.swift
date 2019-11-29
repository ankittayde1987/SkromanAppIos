//
//  BaseViewController.swift
//  getAMe
//
//  Created by Mehul Shah on 6/10/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import SVProgressHUD
import Masonry

class BaseViewController: UIViewController {
    var lblNoRecord : UILabel!
    var homeNav = UINavigationController()
    var lblLoading : UILabel!
    var activityLoader: UIActivityIndicatorView?
    var vwOffline: NoInternetView?
	
	var isKeyboardVisible = false
	var keyboardAnimationDuration = TimeInterval()
	var keyboardAnimationCurve: UIViewAnimationCurve!
	var keyboardHeight = CGFloat()
	var keyboardY = CGFloat()
    
    let backButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationItem.leftBarButtonItem = nil
       // navigationItem.title = ""        
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setForegroundColor(UIColor.white)
        self.edgesForExtendedLayout = []
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func addCommonNavigationWithButton(arrIcons: NSArray?) {
        /*navigationItem.leftBarButtonItem = nil
         
         navigationItem.title = ""
         homeNav = NavigationViewController(nibName: "NavigationViewController", bundle: nil)
         homeNav.rightButtons = arrIcons
         // homeNav.comefrom = NavComeFromHome
         homeNav.navDelegate = self
         homeNav.view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_SIZE.width), height: CGFloat(44))
         let vw = UIView()
         vw.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_SIZE.width), height: CGFloat(44))
         vw.addSubview(homeNav.view)
         navigationItem.titleView = vw
         if (navigationController?.topViewController is HomeViewController) {
         homeNav.btnLeft.isHidden = true
         }
         else {
         homeNav.btnLeft.isHidden = false
         }*/
    }
	func showAlertViewWithMessage(_ message: String)
	{
		let alert = UIAlertController(title: APP_NAME_TITLE, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: SSLocalizedString(key: "ok"), style: UIAlertActionStyle.cancel, handler:{ action in
			self.clickOK()
			
		}))
		
		self.present(alert, animated: true, completion: nil)
	}
	func clickOK()  {
		
		
	}
    // MARK:- backButtonSetup method
    func addRightButton(arrIcons: NSArray?)
    {
        let arrButtons = NSMutableArray ();
        for (index, _) in (arrIcons?.enumerated())!
        {
            let icon_name = arrIcons?[index];
            let tempButton = UIButton(type: .custom)
            tempButton.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(30), height: CGFloat(30))
            tempButton.backgroundColor = UIColor.clear
            tempButton.setImage(UIImage(named: icon_name as! String), for: .normal)
            tempButton.addTarget(self, action: #selector(self.rightButtonTapped), for: .touchUpInside)
            tempButton.tag = index;
            let btnBack = UIBarButtonItem(customView: tempButton)
            arrButtons.addObjects(from: [btnBack as Any]);
        }
        self.navigationItem.rightBarButtonItems = (arrButtons as NSArray) as? [UIBarButtonItem];
    }
    
	@objc func rightButtonTapped(sender: AnyObject) {
        print(sender.tag);
    }
    
    func setNavigationLayout(isModelView: Bool) {
       // if(self.homeNav)
       // {
            //self.homeNav.setNavigationLayout(isModelView: isModelView);
       // }
    }
    
    func clickRightNavButtons(_ sender: Int)
    {
        
    }
    
    func clickLeftNavButton()
    {
        
    }
    
    // MARK:- EmptyLabel SetUp
    func initEmptyDataLabelWithFrame(frame: CGRect) {
        self.lblNoRecord = UILabel(frame: frame)
        self.lblNoRecord.numberOfLines = 0
//        self.lblNoRecord.font = FONT_MONT_REGULAR_H14 Gaurav
        self.lblNoRecord.textColor = UICOLOR_NAVIGATION_BAR
        self.lblNoRecord.textAlignment = .center
        self.view!.addSubview(self.lblNoRecord)
        self.lblNoRecord.isHidden = true
    }
    
    func initEmptyDataLabel() {
        self.initEmptyDataLabelWithFrame(frame: CGRect(x: CGFloat(0), y: SCREEN_SIZE.height / 2.0 - 45, width: CGFloat(SCREEN_SIZE.width), height: 30))
    }
    
    func showEmptyDataLabelWithMsg(message: String) {
        self.lblNoRecord.text = message
        self.lblNoRecord.isHidden = false
        self.view.bringSubview(toFront: self.lblNoRecord)
    }
    
    // MARK:- backButtonSetup method
    func backButtonSetup(){
        backButton.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(30), height: CGFloat(30))
        backButton.backgroundColor = UIColor.clear
        backButton.contentHorizontalAlignment = .left;
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backButtonTapped), for: .touchUpInside)
        let btnBack = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = btnBack
    }
    func hideNavigationBackButton(){
        navigationItem.leftBarButtonItem = nil
//        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    // MARK:- backButtonTapped method
	@objc func backButtonTapped(){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    
    func initLoaderActivity(withFrame frame: CGRect) {
        activityLoader = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityLoader?.frame = frame
        activityLoader?.tintColor = UIColor.black
        view.addSubview(activityLoader!)
        activityLoader?.isHidden = true
        lblLoading = UILabel(frame: CGRect(x: CGFloat(8), y: CGFloat((activityLoader?.frame.size.height)! + (activityLoader?.frame.origin.y)! + 10), width: CGFloat(SCREEN_SIZE.width - 16), height: CGFloat(17)))
//        lblLoading?.font = FONT_MONT_LIGHT_H14 Gaurav
        lblLoading?.translatesAutoresizingMaskIntoConstraints = true
        lblLoading?.textAlignment = .center
        lblLoading?.textColor = UIColor.black
        view.addSubview(lblLoading!)
        lblLoading?.isHidden = true
    }
    
    
    func initLoaderActivity() {
        initLoaderActivity(withFrame: CGRect(x: CGFloat((SCREEN_SIZE.width / 2.0) - 10), y: CGFloat((SCREEN_SIZE.height / 2.0) - 50), width: CGFloat(20), height: CGFloat(20)))
    }
    
    func initLoaderActivity(withYposition yPostion: CGFloat) {
        initLoaderActivity(withFrame: CGRect(x: CGFloat((SCREEN_SIZE.width / 2.0) - 10), y: yPostion, width: CGFloat(20), height: CGFloat(20)))
    }
    
    
    func startLoadingActivity() {
        activityLoader?.isHidden = false
        lblLoading?.isHidden = false
        activityLoader?.startAnimating()
    }
    
    func stopLoadingActivity() {
        activityLoader?.isHidden = true
        lblLoading?.isHidden = true
        if (activityLoader?.isAnimating)! {
            activityLoader?.stopAnimating()
        }
    }
    
    func initOfflineView() {
        initOfflineView(withFrame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_SIZE.width), height: CGFloat(SCREEN_SIZE.height)))
    }
    
    func initOfflineView(withFrame frame: CGRect) {
        vwOffline = UINib(nibName: "NoInternetView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? NoInternetView
        vwOffline?.frame = frame
        view.addSubview(vwOffline!)
        
        _ =  self.vwOffline?.mas_makeConstraints { (make:MASConstraintMaker?) in
            _ = make?.width.equalTo()(frame.size.width)
            _ = make?.top.equalTo()(frame.origin.y)
            _ = make?.height.equalTo()(frame.size.height)
            _ = make?.left.equalTo()(frame.origin.x)
        }
         vwOffline?.isHidden = true
    }
    
    func showOfflineView(_ show: Bool, error: String?) {
        if show {
            vwOffline?.showConnectivityMessage(error)
            vwOffline?.isHidden = false
        }
        else {
            vwOffline?.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func showAlertMessage(strMessage : String){
		let alert = UIAlertController(title: APP_NAME_TITLE as String?, message: strMessage as String, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: SSLocalizedString(key: "ok"), style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	// MARK: - Keyboard Methods
	
	@objc func willShowKeyboard(notification: NSNotification) {
		keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect).size.height
		keyboardY = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect).origin.y
		keyboardAnimationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
		let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey]  as! Int
		keyboardAnimationCurve = UIViewAnimationCurve(rawValue: curve)
		isKeyboardVisible = true
	}
	
	@objc func willHideKeyboard(notification: NSNotification) {
		keyboardAnimationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
		let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey]  as! Int
		keyboardAnimationCurve = UIViewAnimationCurve(rawValue: curve)
	}
	
	@objc func didHideKeyboard(notification: NSNotification) {
		isKeyboardVisible = false
	}
	
	func hideKeyboard(_ done: @escaping () -> Void) {
		if isKeyboardVisible {
			view.endEditing(true)
			
			//            let deadlineTime = DispatchTime.now() + keyboardAnimationDuration
			//            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
			//                done()
			//            }
			
			DispatchQueue.main.asyncAfter(deadline: .now() + keyboardAnimationDuration) {
				done()
			}
		} else {
			done()
		}
	}
}
