
import UIKit
import CoreData
import GoogleSignIn
import UserNotifications
import RNLoadingButton_Swift
import TWMessageBarManager
import GooglePlaces
import AlamofireNetworkActivityLogger
import SideMenu
import MQTTClient
import GoogleSignIn
import Firebase


var skromanDateFormatter = SkromanDateFormatter.sharedInstance
@UIApplicationMain //100612408165
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate,GIDSignInDelegate {
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		
	}
	
    var manager: HotspotManager! = nil
    var isInterNetAvaliable : Bool = false
    var window: UIWindow?
    var device_token: String?
    var is_device_registed: Bool = false
	var windowSafeAreaInsets: UIEdgeInsets {
		if #available(iOS 11.0, *) {
			let window = UIApplication.shared.keyWindow
			guard (window != nil) else {
				return UIEdgeInsetsMake(0, 0, 0, 0)
			}
			return getSafeAreaInsets(window!)
		}
		return UIEdgeInsetsMake(0, 0, 0, 0)
	}
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		
		//TEMPORARYYY
//        VVBaseUserDefaults.setUserObject(value: User())
		
		
         UIApplication.shared.applicationIconBadgeNumber = 0
        GMSPlacesClient.provideAPIKey("AIzaSyAOwXNQqq7zQDVa9WYrdHAgq9FENtzIHqg")
        self.applyGlobalInterfaceAppearance()
        
		// Initializing window
		window = UIWindow.init(frame: UIScreen.main.bounds);
		window?.backgroundColor = UICOLOR_NAVIGATION_BAR;
		window?.tintColor = UICOLOR_NAVIGATION_BAR;
		window?.makeKeyAndVisible()
        self.manager = HotspotManager()
        self.tryConnectionWithServer()
		self.initControllerBasedOnSession()
        self.configureLogging()
        FirebaseApp.configure()
		GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_KEY
		GIDSignIn.sharedInstance().delegate=self
        
        
        //Added this for internet connection change
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
        return true
    }
    func initControllerBasedOnSession(){
        
        if Utility.isEmpty(val: Utility.getCurrentUserId()) || Utility.isEmpty(val: VVBaseUserDefaults.getCurrentPIID()) {
            self.navigateToLoginScreen()
        }else {
            self.navigateToHomeScreen()
        }
    }
    @objc func networkStatusChanged(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo
        var strStatus : String = ""
        strStatus = userInfo!["Status"] as! String
        print(strStatus)
        if strStatus == kOnlineConstant || strStatus == kOnlineConstantWWAN
        {
            self.isInterNetAvaliable = true
        }
        else
        {
            self.isInterNetAvaliable = false
        }
    }
    
    
    
	@available(iOS 9.0, *)
	func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
		-> Bool {
			return GIDSignIn.sharedInstance().handle(url,
													 sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
													 annotation: [:])
	}
	
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		return GIDSignIn.sharedInstance().handle(url,
												 sourceApplication: sourceApplication,
												 annotation: annotation)
	}
	func navigateToHomeScreen() {
		//Need to chnage this method once we know how login work
		var firstVC: UIViewController
        if Utility.isIpad()
        {
            let orientation = UIApplication.shared.statusBarOrientation
            if orientation == .landscapeLeft || orientation == .landscapeRight
            {
                 firstVC = HomeForIpadViewController.init(nibName: "HomeForIpadViewController", bundle: nil)
            }
            else
            {
                 firstVC = HomeForIpadViewController.init(nibName: "HomeForIpadViewController_portrait", bundle: nil)
            }
            setupSideMenu()
        }
        else
        {
            firstVC = HomeViewController.init(nibName: "HomeViewController", bundle: nil)
            
        }
        setupSideMenu()
		let navCnt = UINavigationController.init(rootViewController: firstVC)
		window?.rootViewController = navCnt;
	}
	fileprivate func setupSideMenu() {
		// Define the menus
		let sideMenuVC = LeftMenuViewController.init(nibName: "LeftMenuViewController", bundle: nil)
		let sideMenuNavCnt = UISideMenuNavigationController(rootViewController: sideMenuVC)
		// UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
		// Depending on language direction setting either left or right side menu
			SideMenuManager.default.menuLeftNavigationController = sideMenuNavCnt
			SideMenuManager.default.menuRightNavigationController = nil
		// Enable gestures. The left and/or right menus must be set up above for these to work.
		// Note that these continue to work on the Navigation Controller independent of the view controller it displays!
		if let navCnt = window?.rootViewController as? UINavigationController {
			SideMenuManager.default.menuAddPanGestureToPresent(toView: navCnt.navigationBar)
			SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: navCnt.view)
		}
		
		// Set side menu width
        if Utility.isIpad()
        {
           SideMenuManager.default.menuWidth = UIScreen.main.bounds.size.width - (UIScreen.main.bounds.size.width/2)
        }
        else
        {
            SideMenuManager.default.menuWidth = UIScreen.main.bounds.size.width - 64
        }
		
		
		// Don't hide side menu status bar
		SideMenuManager.default.menuFadeStatusBar = false
	}
    func navigateToLoginScreen() {
        let nibName = Utility.getNibNameForClass(class_name: String.init(describing: LoginViewController.self))
        let login_obj = LoginViewController(nibName: nibName , bundle: nil)
        let nav = UINavigationController(rootViewController: login_obj)
        window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    func configureLogging()
    {
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
    }
    
    class func isIOS9() -> Bool {
        if #available(iOS 9.0, *) {
            return true;
        } else {
            return false;
        }
    }
    
    func applyGlobalInterfaceAppearance() {
		// To hide the back button title
		UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UICOLOR_NAVIGATION_BAR], for: .normal)
		UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-300, 0), for:UIBarMetrics.default)
		// Changing the background color of navigation bar
		UINavigationBar.appearance().barTintColor = UICOLOR_NAVIGATION_BAR
		
		//Changing statusBarStyle to lightContent
		UIApplication.shared.statusBarStyle = .lightContent
		// Changing color of items on navigation bar - for example back button
		UINavigationBar.appearance().tintColor = UIColor.white
		
		// By default, the translucent property of navigation bar is set to YES. Additionally, there is a system blur applied to all navigation bars. Under this setting, iOS tends to desaturate the color of the bar.
		// Disabling translucent property - so we see orignal color without desaturation
		UINavigationBar.appearance().isTranslucent = false
		
		// The back indicator image is shown beside the back button.
		// The back indicator transition mask image is used as a mask for content during push and pop transitions
		// Note: These properties must both be set if you want to customize the back indicator image.
		// Changing back button image
		let myImage = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal) // In some cases the image color changes. So to avoid that rendering orignal image.
		UINavigationBar.appearance().backIndicatorImage = myImage
		UINavigationBar.appearance().backIndicatorTransitionMaskImage = myImage
		
		// Changing title text attributes - we can add as many attributes as we want
		// We can change font, add shadow, etc... here...
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		
		//To remove Navigation hairline
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
		UINavigationBar.appearance().shadowImage = UIImage()
		
    }
    
    func registerDevice() {
        //self.device_token = "5d095fe09ecee3f1db5f2c8826d601c60ad37f92"
       // ToastMessage.showSuccessMessage("In RegisterDevice")
        if(VVBaseUserDefaults.userId() != 0 && self.device_token != nil && is_device_registed == false)
        {
            
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

        self.device_token = deviceTokenString as String?
        print(self.device_token ?? "")
        self.registerDevice();
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
    {

    //func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print(">>>IN didReceiveRemoteNotification: \(userInfo)")
//        ToastMessage.showSuccessMessage("In didReceiveRemoteNotification")
//        Utility.logoutFromApp()
         self.handleRemoteNotifications(aps: userInfo)
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void)
    {
        print(">>>IN didReceiveRemoteNotification fetchCompletionHandler: \(userInfo)")
        self.handleRemoteNotifications(aps: userInfo)

//        ToastMessage.showSuccessMessage("PUSH RECEIVED - " + userInfo.description)
//        Utility.logoutFromApp()
    }

    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void)
    {
        print(">>>IN didReceiveRemoteNotification willPresent: \(notification.request.content.userInfo)")
        self.handleRemoteNotifications(aps: notification.request.content.userInfo)

    }
    
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void)
    {
    
        print(">>>IN didReceiveRemoteNotification fetchCompletionHandler: \(response.notification.request.content.userInfo)")
        self.handleRemoteNotifications(aps: response.notification.request.content.userInfo)
        
        /*
         {
         aps =    {
         alert = "GiftCard Recieved";
         };
         "gift_id" = 12;
         type = GR;
         }
         */
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
                
            case "show":
                // the user tapped our "show more info…" button
                print("Show more information…")
                break
                
            default:
                break
            }
        }
        
        // you must call the completion handler when you're done
        completionHandler()
    }

    //Navigation--Notification
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Reach().monitorReachabilityChanges()
        self.tryConnectionWithServer()
        if !Utility.isEmpty(val: Utility.getCurrentUserId()) && !Utility.isEmpty(val: VVBaseUserDefaults.getCurrentPIID()) {
            if VVBaseUserDefaults.getCurrentSSID() == SSID.fetchSSIDInfo()
            {
                SSLog(message: "************ applicationDidBecomeActive *************")
                self.startSyncData()
                SMQTTClient.sharedInstance().subscribeAllTopic();
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
	func getSafeAreaInsets(_ view: UIView) -> UIEdgeInsets {
		if #available(iOS 11.0, *) {
			return view.safeAreaInsets
		}
		return UIEdgeInsetsMake(0, 0, 0, 0)
	}
	
	func handleRemoteNotifications(aps : [AnyHashable: Any]) {
      //  aps = aps["aps"]
        let aps1 = aps["aps"] as? NSDictionary
//         UIAlertView(title: "Custom Action", message: "\(aps1)", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "").show()
       
        
        if(VVBaseUserDefaults.userId() == 0)
        {
            return
        }
        
        let rootview = self.window?.rootViewController;
        var topview : Any? = nil;
        
        if UIApplication.shared.applicationState == .active {
            if (aps1?["type"] as! String == "chat") {
                    
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: aps1?.value(forKey: "alert") as? String, description: nil, type: .info, duration: 2.0, callback: {
                        

                    })
                    //ToastMessage.showInfoMessage(aps1?.value(forKey: "alert") as! String)
                }
            }
            else
            {
                
            }
        }
    
    
	func showAlert(title: String?, message: String?, cancelButtonTitle: String?, controller: UIViewController) {
		let alertController = UIAlertController(title: title, message:
			message, preferredStyle: UIAlertControllerStyle.alert)
		let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
		alertController.addAction(cancelAction)
		controller.present(alertController, animated: true, completion: nil)
	}
    
    
    //API CALL BY GAURAV ISSUE
    func startSyncData()
    {
        if Utility.isRestrictOperation()
        {
            self.syncGlobalData()
        }
        else
        {
            self.syncLocalData()
        }
    }
    
    func syncLocalData()
    {
        if !Utility.isAnyConnectionIssue()
        {
            /*SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_SYNC_EVERYTHING_ACK) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_SYNC_EVERYTHING_ACK)
                
                
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_SYNC_EVERYTHING_ACK)
                {
                    if let objSync : SyncData? = SyncData.decode(data!){
                        if((objSync?.syncData?.count)!>0)
                        {
                            //delete old data and insert new data
                            DatabaseManager.sharedInstance().syncDataFormleftMenu(objSyncData: objSync!)
                            NotificationCenter.default.post(name: .defaultHomeChange, object: nil)
                        }
                        print("here---- SM_TOPIC_SYNC_EVERYTHING_ACK \(topic)")}
                    //redirect to home page
                    //                SVProgressHUD.dismiss()
                }
                else
                {
                    SSLog(message: "TOPIC...\(topic)")
                }
            }*/
            
            let dict =  NSMutableDictionary()
            dict.setValue("1", forKey: "sync");
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_SYNC_EVERYTHING) { (error) in
                if error != nil
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    func syncGlobalData()
    {
        if !Utility.isAnyConnectionIssue()
        {
            /*SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU) { (data, topic) in
                SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU)
                
                if topic == Utility.getTopicNameToCheck(topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU)
                {
                    if let objSync : SyncData? = SyncData.decode(data!){
                        
                        if((objSync?.syncData?.count)!>0)
                        {
                            //delete old data and insert new data
                            DatabaseManager.sharedInstance().syncDataFormleftMenu(objSyncData: objSync!)
                            NotificationCenter.default.post(name: .defaultHomeChange, object: nil)
                        }
                        //Default Home
                        print("here---- SM_TOPIC_SYNC_EVERYTHING_ACK \(topic)")}
                }
                
            }*/
            
            let dict =  NSMutableDictionary()
            dict.setValue(VVBaseUserDefaults.getCurrentPIID(), forKey: "pi_id");
            dict.setValue(Utility.getCurrentUserId(), forKey: "user_id");
            //            let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_GLOBAL_SYNC_FOR_VPS_LEFT_MENU) { (error) in
                if error != nil
                {
                    Utility.showErrorAccordingToLocalAndGlobal()
                }
            }
        }
    }
    func tryConnectionWithServer()
    {
        return;
        if VVBaseUserDefaults.getIsGlobalConnect() {
            SMQTTClient.sharedInstance().connectToServerGlobal { (error) in
                if((error) != nil)
                {
                    SSLog(message: "Connected To Global Server")
                }
                else
                {
                    SSLog(message: "error In Global Connection")
                }
            }
        }
        else{
            SMQTTClient.sharedInstance().connectToServer(success: { (error) in
                if((error) != nil)
                {
                    SSLog(message: "Connected In Local Connection")
                }
                else
                {
                    SSLog(message: "error To Local Server")
                }
            })
        }
    }
    
    func linkUserAndPiIdAPICallTemporary()
    {
        SSLog(message: "************** linkUserAndPiIdAPICall **************")
        SSLog(message: "linkUserAndPiIdAPICall")
        //        if !Utility.isAnyConnectionIssueToMakeGlobalAPI()
        //        {
        
        
        SMQTTClient.sharedInstance().subscribe(topic: SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK) { (data, topic) in
            SMQTTClient.sharedInstance().unsubscribe(topic: SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK)
            SSLog(message: "******************** SUCCESSSSSSSSSSSSSSSS ***********************")
        }
        
        let dict =  NSMutableDictionary()
        
        //{"user_id":"pradip12345678","pi_id":"PI-VI3MI5"}
        dict.setValue("5cdbf83da8500278f08c684f", forKey: "user_id");
        dict.setValue("PI-VI1MI1", forKey: "pi_id");
        SSLog(message: "DICT FOR LINKING : \(dict)")
        SMQTTClient.sharedInstance().publishJson(json: dict, topic: SM_TOPIC_LINK_USER_ID_AND_PI_ID) { (error) in
            if error != nil{
                Utility.showErrorAccordingToLocalAndGlobal()
            }
            //            }
        }
    }

}


