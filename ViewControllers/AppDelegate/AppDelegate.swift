//
//  AppDelegate.swift
//  TickTok User
//
//  Created by Excellent Webworld on 25/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Fabric
import Crashlytics
import SideMenuController
import SocketIO
import UserNotifications
import FirebaseMessaging
import Firebase
import FBSDKCoreKit
import GoogleSignIn


let googlApiKey = "AIzaSyAQPk1hdmEi1MgAsTK83gthxTDzQhGvZYM"
//"AIzaSyC_fgLRMBK6zBSAzUFwZ78EQQb74vURLMM"
//"AIzaSyAQPk1hdmEi1MgAsTK83gthxTDzQhGvZYM"
//"AIzaSyAQPk1hdmEi1MgAsTK83gthxTDzQhGvZYM"
//"AIzaSyDeLFTr-pqAWNHp-XLdUb-4UZve6g0IpN8"//"AIzaSyB7GS-O76Vp0jkS2nU-eZ_jkxLXJaUHAjg" //"AIzaSyBpHWct2Dal71hBjPis6R1CU0OHZNfMgCw"         // AIzaSyB08IH_NbumyQIAUCxbpgPCuZtFzIT5WQo
//let googlPlacesApiKey = "AIzaSyB7GS-O76Vp0jkS2nU-eZ_jkxLXJaUHAjg" // "AIzaSyCKEP5WGD7n5QWtCopu0QXOzM9Qec4vAfE"   //   AIzaSyBBQGfB0ca6oApMpqqemhx8-UV-gFls_Zk



let kGoogle_Client_ID : String = "243435127466-ehcnmq7f6qlftnbk2au3lnbqbmndis51.apps.googleusercontent.com"
//"1048315388776-2f8m0mndip79ae6jem9doe0uq0k25i7b.apps.googleusercontent.com"//"787787696945-nllfi2i6j9ts7m28immgteuo897u9vrl.apps.googleusercontent.com"
let kDeviceType : String = "1"

//AIzaSyBBQGfB0ca6oApMpqqemhx8-UV-gFls_Zk
@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate, GIDSignInDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var isAlreadyLaunched : Bool?
    var objMessage = MessageObject()
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        
    }
//    let SocketManager = SocketIOClient(socketURL: URL(string: SocketData.kBaseURL)!, config: [.log(false), .compress])
    
    let SocketManager = SocketIOClient(socketURL: URL(string: SocketData.kBaseURL)!)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        UINavigationBar.appearance().barTintColor = themeYellowColor
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: UIControlState.highlighted)
//        
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.regular(ofSize: 14.0)]

        // Set Stored Language from Local Database

        if (UserDefaults.standard.value(forKey: "i18n_language") == nil || (UserDefaults.standard.value(forKey: "i18n_language") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)  {

            #if targetEnvironment(simulator)
            let langStr = Locale.current.languageCode

            UserDefaults.standard.set(langStr, forKey: "i18n_language")
            UserDefaults.standard.synchronize()
            #else
            UserDefaults.standard.set("en", forKey: "i18n_language")
            UserDefaults.standard.synchronize()

            #endif
        }

        isAlreadyLaunched = false
        // Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
       
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localized
//        IQKeyboardManager.shared.toolbarNextBarButtonItemText = "Next".localized
//        IQKeyboardManager.shared.toolbarPreviousBarButtonItemText = "Previous".localized

        GMSServices.provideAPIKey(googlApiKey)
        GMSPlacesClient.provideAPIKey(googlApiKey)
        
        webserviceForTransportserviceList()
        Fabric.with([Crashlytics.self])
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = kGoogle_Client_ID
        GIDSignIn.sharedInstance().delegate = self
        googleAnalyticsTracking()
        
        // TODO: Move this to where you establish a user session
        //   self.logUser()
        
        // ------------------------------------------------------------


        var bgTask = UIBackgroundTaskIdentifier()
        bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(bgTask)
        })


        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = (window?.frame.width)! * 0.85//(((window?.frame.width)! / 2) + ((window?.frame.width)! / 4))
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
        SideMenuController.preferences.interaction.swipingEnabled = false
        SideMenuController.preferences.interaction.panningEnabled = false
        // ------------------------------------------------------------
        
        if ((UserDefaults.standard.object(forKey: "profileData")) != nil)
        {
            SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: UserDefaults.standard.object(forKey: "profileData") as? NSDictionary ?? NSDictionary())
            SingletonClass.sharedInstance.strPassengerID = String(describing: SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)
            SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array:  UserDefaults.standard.object(forKey: "carLists") as! NSArray)
            SingletonClass.sharedInstance.isUserLoggedIN = true
        }
        else
        {
            SingletonClass.sharedInstance.isUserLoggedIN = false
        }
        
        // For Passcode Set
        if UserDefaults.standard.object(forKey: "Passcode") as? String == nil || UserDefaults.standard.object(forKey: "Passcode") as? String == "" {
            SingletonClass.sharedInstance.setPasscode = ""
            UserDefaults.standard.set(SingletonClass.sharedInstance.setPasscode, forKey: "Passcode")
        }
        else {
            SingletonClass.sharedInstance.setPasscode = UserDefaults.standard.object(forKey: "Passcode") as! String
        }
        
        // For Passcode Switch
        if let isSwitchOn = UserDefaults.standard.object(forKey: "isPasscodeON") as? Bool {
            
            SingletonClass.sharedInstance.isPasscodeON = isSwitchOn
            UserDefaults.standard.set(SingletonClass.sharedInstance.isPasscodeON, forKey: "isPasscodeON")
        }
        else {
            SingletonClass.sharedInstance.isPasscodeON = false
            UserDefaults.standard.set(SingletonClass.sharedInstance.isPasscodeON, forKey: "isPasscodeON")
        }
        

        
        
        // Push Notification Code
        registerForPushNotification()
        
        let remoteNotif = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary
        
        //For foreground push
        UNUserNotificationCenter.current().delegate = self
        
        
        if remoteNotif != nil {
            let key = (remoteNotif as! NSDictionary).object(forKey: "gcm.notification.type")!
            NSLog("\n Custom: \(String(describing: key))")
            self.pushAfterReceiveNotification(typeKey: key as! String)
        }
        else {
            //            let aps = remoteNotif!["aps" as NSString] as? [String:AnyObject]
            NSLog("//////////////////////////Normal launch")
            //            self.pushAfterReceiveNotification(typeKey: "")
            
        }
        
        /*
         if let notification = launchOptions?[.remoteNotification] as? [String:AnyObject] {
         
         //            let aps = notification["aps"] as! [String:AnyObject]
         //            _ = NewsItems.makeNewsItems(aps)
         
         //            (window?.rootViewController as? UITabBarController)?.selectedIndex = 0
         }
         */
  
        return true
    }
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        
        let isFBOpenUrl = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        
        let isGoogleOpenUrl = GIDSignIn.sharedInstance().handle(url as URL?,
                                                                sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                                annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        if isFBOpenUrl
        {
            return true
            
        }
        if isGoogleOpenUrl
        {
            return true
        }
        return false
    }
    func googleAnalyticsTracking() {
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
        }
        gai.tracker(withTrackingId: googleAnalyticsTrackId)
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true
        
        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        gai.logger.logLevel = .verbose
    }
    
    //    func logUser() {
    //        // TODO: Use the current user's information
    //        // You can call any combination of these three methods
    //
    //        if ((UserDefaults.standard.object(forKey: "profileData")) != nil)
    //        {
    //            SingletonClass.sharedInstance.dictProfile = UserDefaults.standard.object(forKey: "profileData") as! NSMutableDictionary
    //            Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
    //            Crashlytics.sharedInstance().setUserIdentifier("12345")
    //            Crashlytics.sharedInstance().setUserName("Test User")
    //        }
    //
    //    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        SocketManager.connect()
        SocketManager.on(clientEvent: .connect) { (data, ack) in
            print ("socket connected in background")
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        let isSwitchOn = UserDefaults.standard.object(forKey: "isPasscodeON") as? Bool
        let passCode = SingletonClass.sharedInstance.setPasscode
        
        
        if isSwitchOn != nil
        {
            SingletonClass.sharedInstance.isPasscodeON = isSwitchOn!
        }
        
        
        if (passCode != "" && SingletonClass.sharedInstance.isPasscodeON) {
            
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
            
            initialViewController.isFromAppDelegate = true
            self.window?.rootViewController?.present(initialViewController, animated: true, completion: nil)
        }



//        SocketClientManager.sharedManager.establishConnection()
//        SocketIOManager.shared.socket.on(clientEvent: .connect) { (data, ack) in
//
//            print ("socket connected")
//        }
//        print(SocketIOManager.shared.isSocketOn)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Push Notification Methods
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let toketParts = deviceToken.map({ (data)-> String in
            return String(format: "%0.2.2hhx", data)
        })
        
        let token = toketParts.joined()
        print("Device Token: \(token)")
        Messaging.messaging().apnsToken = deviceToken as Data
        if let fcmToken = Messaging.messaging().fcmToken as? String {
            SingletonClass.sharedInstance.deviceToken = fcmToken
            UserDefaults.standard.set(SingletonClass.sharedInstance.deviceToken, forKey: "Token")
            UserDefaults.standard.synchronize()
        }
        
//        Messaging.messaging().apnsToken = deviceToken as Data
        
//        print("deviceToken : \(deviceToken)")
//
//
//        let fcmToken = Messaging.messaging().fcmToken
//        print("FCM token: \(fcmToken ?? "")")
//
//        if fcmToken == nil {
//
//        }
//        else {
//            SingletonClass.sharedInstance.deviceToken = fcmToken!
//            UserDefaults.standard.set(SingletonClass.sharedInstance.deviceToken, forKey: "Token")
//        }
        
        
        print("SingletonClass.sharedInstance.deviceToken : \(SingletonClass.sharedInstance.deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        
        let currentDate = Date()
        print("currentDate : \(currentDate)")
        
    }
    
    //Call when silent push coming or app on background
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        notificationHandler(userInfo)
        
        /*
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!
        
        if(application.applicationState == .background)
        {
            self.pushAfterReceiveNotification(typeKey: key as! String)
        }
        
 
        print(userInfo)
        if key as? String == "chatbid" {
            if !SingletonClass.sharedInstance.isChatBoxOpen {
                let dictData = userInfo["gcm.notification.data"] as! String
                let data = dictData.data(using: .utf8)!
                do
                {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                    {
                        var UserDict = [String:Any]()
//                        UserDict["BidId"] = jsonResponse["BidId"] as! String
//                        UserDict["SenderId"] = jsonResponse["SenderId"] as! String
                        if let vwController = ((gettopMostViewController()?.childViewControllers.first as? UINavigationController)?.viewControllers.last) {
                            if let vcChat = UIStoryboard.init(name: "ChatStoryboard", bundle: nil).instantiateViewController(withIdentifier: "BidChatViewController") as? BidChatViewController {
                                
                                guard let strBidID = jsonResponse["BidId"] as? String else {
                                    return
                                }
                                guard let strSenderID = jsonResponse["SenderId"] as? String else {
                                    return
                                }
                                vcChat.strDriverID = strSenderID
                                vcChat.strBidID = strBidID
                                vwController.navigationController?.pushViewController(vcChat, animated: true)
                            }
                        }
                      
                    }
                    else {
                        print("bad json")
                    }
                }
                catch let error as NSError
                {
                    print(error)
                }
            }
        }
        completionHandler(UIBackgroundFetchResult.newData)
        */
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print("Push Notification present method call : \(notification)")
        let userInfo = notification.request.content.userInfo
        print(Appdelegate.window?.rootViewController?.navigationController?.childViewControllers.first as Any)
        print(userInfo)
        if userInfo["gcm.notification.type"] as! String == "chatbid"{
            let BidId = userInfo["gcm.notification.b_id"] as! String
            
            let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController as? SideMenuController
            if vc != nil {
                if let vc : BidChatViewController = (vc?.childViewControllers.first as? UINavigationController)?.topViewController as? BidChatViewController {
                    if vc.strBidID != BidId {
                        
                        completionHandler([.alert, .sound])
                    }
                    else if vc.strBidID == BidId{
                        print(vc.strBidID)
                        if let response = userInfo["gcm.notification.data"] as? String {
                            let jsonData = response.data(using: .utf8)!
                            let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                            
                            if let MsgDataDictionary = dictionary  as? [String: Any]{
                                print(MsgDataDictionary)
                                
                                if MsgDataDictionary["Sender"] as! String == "Driver" {
                                    objMessage.isSender = false
                                }
                                else {
                                    objMessage.isSender = true
                                }
                                
                                objMessage.sender = MsgDataDictionary["Sender"] as? String ?? ""
                                objMessage.senderId = String(MsgDataDictionary["SenderId"] as? Int ?? 0)
                                objMessage.receiverId = MsgDataDictionary["ReceiverId"] as? String ?? ""
                                objMessage.receiver =  MsgDataDictionary["Receiver"] as? String ?? ""
                                objMessage.id = MsgDataDictionary["BidId"] as? String ?? ""
                                objMessage.date = MsgDataDictionary["Date"] as? String ?? ""
                                objMessage.strMessage = MsgDataDictionary["Message"] as? String ?? ""
                                print(objMessage)
                                vc.arrData.append(objMessage)
                                let indexPath = IndexPath.init(row: vc.arrData.count-1, section: 0)
                                vc.tblVw.insertRows(at: [indexPath], with: .bottom)
                                let path = IndexPath.init(row: vc.arrData.count-1, section: 0)
                                vc.tblVw.scrollToRow(at: path, at: .bottom, animated: true)
                            }
                        }
                    }
                }
                else{
                    
                    completionHandler([.alert, .badge, .sound])
                }
                
            }
            else{
                completionHandler([.alert, .badge, .sound])
            }
        }
    }
    func notificationHandler(_ notification:[AnyHashable : Any]) {
        if let apsData = (notification as! [String:AnyObject])["aps"] {
            print("APS Data: \(apsData)")
            
            if ((notification as! [String:AnyObject])["gcm.notification.type"]! as! String == "chatbid")
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if !SingletonClass.sharedInstance.isChatBoxOpen {
                         let dictData = notification["gcm.notification.data"] as! String
                          let data = dictData.data(using: .utf8)!
                        do
                        {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                            {
                                
                                if let vwController = ((self.gettopMostViewController()?.childViewControllers.first as? UINavigationController)?.viewControllers.last) {
                                    if let vcChat = UIStoryboard.init(name: "ChatStoryboard", bundle: nil).instantiateViewController(withIdentifier: "BidChatViewController") as? BidChatViewController {
                                        
                                        guard let strBidID = jsonResponse["BidId"] as? String else {
                                            return
                                        }
                                        var DriverId = ""
                                        if let strSenderId = jsonResponse["SenderId"] as? String {
                                            DriverId = strSenderId
                                        } else if let StrSenderId = jsonResponse["SenderId"] as? Int {
                                            DriverId = "\(StrSenderId)"
                                        }
                                        vcChat.strDriverID = DriverId
                                        vcChat.strBidID = strBidID
                                        vwController.navigationController?.pushViewController(vcChat, animated: true)
                                    }
                                }
                                
                            }
                            else {
                                print("bad json")
                            }
                        }
                        catch let error as NSError
                        {
                            print(error)
                        }
                    }
                }
            
            }else if ((notification as! [String:AnyObject])["gcm.notification.type"]! as! String == "RejectBid") {
//                BidListContainerViewController
                if let _ = ((gettopMostViewController()?.childViewControllers.first as? UINavigationController)?.viewControllers.last) as? BidListContainerViewController {
                    return
                }
                
                if let vwController = ((gettopMostViewController()?.childViewControllers.first as? UINavigationController)?.viewControllers.last) {
                    if let vwBidList = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BidListContainerViewController") as? BidListContainerViewController {
                        
                    
                        vwController.navigationController?.pushViewController(vwBidList, animated: true)
                    }
                }
            }else if ((notification as! [String:AnyObject])["gcm.notification.type"]! as! String == "BookLaterTripNotify") {
                //                BidListContainerViewController
                if let vwMyBooking = ((gettopMostViewController()?.childViewControllers.first as? UINavigationController)?.viewControllers.last) as? MyBookingViewController {
                    vwMyBooking.Upcomming()
                    return
                }
                
                if let vwController = ((gettopMostViewController()?.childViewControllers.first as? UINavigationController)?.viewControllers.last) {
                    if let vwMyBooking = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyBookingViewController") as? MyBookingViewController {
                        vwController.navigationController?.pushViewController(vwMyBooking, animated: true)
                          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            vwMyBooking.Upcomming()
                        }
                        
                    }
                }
            }
            /*
            if((notification as! [String:AnyObject])["gcm.notification.type"]! as! String == "silent") {
                NotificationCenter.default.post(name: .LogoutUser, object: nil)
            }else {
                if let topVw = UIApplication.topViewController() {
                    
                    if let vwTop = topVw as? NotificationsViewController {
                        vwTop.pageIndex = 1
                        vwTop.webserviceOfNotificationList(vwTop.pageIndex, showLoader: true)
                    }else {
                        if let rootVc = self.window?.rootViewController as? UINavigationController {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vwNotification = storyboard.instantiateViewController(withIdentifier: "NotificationsViewController") as!  NotificationsViewController
                            //                            OrderDetail.nameofLastViewController = "OrderViewController"
                            //                            OrderDetail.strOrderId = storeId
                            let navController = UINavigationController(rootViewController: vwNotification)
                            rootVc.present(navController, animated: true, completion: nil)
                        }
                    }
                    
                }
            } */
        }
    }
    
    /*
    func handleRemoteNotification(key : String, userInfo : NSDictionary, application: UIApplication)
    {
        
        if(application.applicationState == .background || application.applicationState == .inactive)
        {
            print(userInfo)
            
            
            if(application.applicationState == .inactive)
            {
                
                //                NotificationCenter.default.post(name: NotificationforOpenChatTerminatedApp, object: nil, userInfo: (userInfo as! [AnyHashable : Any]))
                    SingletonClass.sharedInstance.NotificationDetail = userInfo //as! NSDictionary)//[AnyHashable : Any])
                    SingletonClass.sharedInstance.strChatNotificationWhenAppTerminated = "ChatTerminatedApp"
            }
            else if(application.applicationState == .background)
            {
                NotificationCenter.default.post(name: NotificationforOpenChat, object: nil, userInfo: (userInfo as! [AnyHashable : Any]))
            }
            //            self.pushAfterReceiveNotification(typeKey: key, newsID: newsID)
        }
        else if (application.applicationState == .active)
        {
            print(userInfo)
            
            
            //            let AlertNotification = (userInfo["aps"] as! [String:Any])["alert"] as! [String:Any]
            //            let AlertTitle = AlertNotification["title"] as! String
            //            let AlertMessage = ((userInfo["aps"]! as! [String: AnyObject])["alert"]! as! [String: AnyObject])["body"]! as? String
            var strTicketID = String()
            
            
            if let TicketID =  userInfo["gcm.notification.ticket"] as? String
            {
                strTicketID = TicketID
            }
            else if let TicketID1 =  userInfo["TicketId"] as? String
            {
                strTicketID = TicketID1
            }
            
            if SingletonClass.sharedInstance.isChatBoxOpen == true && strTicketID == SingletonClass.sharedInstance.ChatBoxOpenedWithID
            {
                
                NotificationCenter.default.post(name: NotificationforUpdateChat, object: nil, userInfo: userInfo as? [AnyHashable : Any])
                
            }
            else
            {
                
                //                AudioServicesPlayAlertSound(SystemSoundID(1322))
                ////                let notificationBar = GLNotificationBar(title: AlertTitle, message: AlertMessage, preferredStyle: .simpleBanner) { (status) in
                //
                //                    var UserDict = [String:Any]()
                //                    UserDict["id"] = jsonResponse["sender_id"] as! String
                //                    UserDict["fullname"] = jsonResponse["sender_name"] as! String
                //                    UserDict["image"] = jsonResponse["sender_img"] as! String
                NotificationCenter.default.post(name: NotificationforOpenChat, object: nil, userInfo: (userInfo as! [AnyHashable : Any]))
                ////                }
            }
            
            //            let data = ((userInfo["aps"]! as! [String : AnyObject])["alert"]!) as! [String : AnyObject]
            //
            //            if let VC = self.gettopMostViewController() as? ChatViewController
            //            {
            //                print("Chat screen is already open")
            //
            //                NotificationCenter.default.post(name: NotificationforUpdateChatDetail, object: nil)
            ////                VC.dismiss(animated: true, completion: nil)
            //            }
            //            else
            //            {
            //                let vc2 = self.gettopMostViewController()
            //
            //                print(vc2)
            //            }
            //            let alert = UIAlertController(title: appName,
            //                                          message: data["body"] as? String,
            //                                          preferredStyle: UIAlertControllerStyle.alert)
            //
            //            if key == "news"
            //            {
            //                alert.addAction(UIAlertAction(title: "Get Media Details", style: .default, handler: { (action) in
            //                    self.pushAfterReceiveNotification(typeKey: key, newsID: newsID)
            //
            //                }))
            //            }
            //            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { (action) in
            //
            //            }))
            //
            //            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
        print(userInfo)
    }
*/
    //    call when app is close and tap on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
        print("Push Notification : \(response.notification.request.content.userInfo)")
        if let userInfo = response.notification.request.content.userInfo as? [String:Any]   {
            Messaging.messaging().appDidReceiveMessage(userInfo)
            let key = userInfo["gcm.notification.type"]
            
        if(UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive)
        {
            self.notificationHandler(response.notification.request.content.userInfo)
        }
        else if key as! String  == "chatbid" {
            let BidId = userInfo["gcm.notification.b_id"] as! String
            
            let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController as? SideMenuController
            if vc != nil {
                if let vc : BidChatViewController = (vc?.childViewControllers.first as? UINavigationController)?.topViewController as? BidChatViewController {
                    if let response = userInfo["gcm.notification.data"] as? String {
                        let jsonData = response.data(using: .utf8)!
                        let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                        var DriverID = ""
                        if let MsgDataDictionary = dictionary  as? [String: Any]{
                            print(MsgDataDictionary)
                            
                            guard let strBidID = MsgDataDictionary["BidId"] as? String else {
                                return
                            }
                            if let strSenderId = MsgDataDictionary["SenderId"] as? String {
                                DriverID = strSenderId
                            } else if let StrSenderId = MsgDataDictionary["SenderId"] as? Int {
                                DriverID = "\(StrSenderId)"
                            }
                            
                        }
                        vc.strDriverID = DriverID
                        vc.strBidID = BidId
                        vc.webserviceOfChatHistory()
                    }
                }
                else{
                    if let vwController = ((self.gettopMostViewController()?.childViewControllers.first as? UINavigationController)?.viewControllers.last) {
                        if let vcChat = UIStoryboard.init(name: "ChatStoryboard", bundle: nil).instantiateViewController(withIdentifier: "BidChatViewController") as? BidChatViewController {
                            
                            guard  let BidId = userInfo["gcm.notification.b_id"] as? String else {
                                return
                            }
                            if let response = userInfo["gcm.notification.data"] as? String {
                                let jsonData = response.data(using: .utf8)!
                                let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                                var DriverID = ""
                                if let MsgDataDictionary = dictionary  as? [String: Any]{
                                    print(MsgDataDictionary)
                                    
                                    if let strSenderId = MsgDataDictionary["SenderId"] as? String {
                                        DriverID = strSenderId
                                    } else if let StrSenderId = MsgDataDictionary["SenderId"] as? Int {
                                        DriverID = "\(StrSenderId)"
                                    }
                                    
                                }
                                vcChat.strDriverID = DriverID
                                vcChat.strBidID = BidId
                                vwController.navigationController?.pushViewController(vcChat, animated: true)
                            }
                            
                        }
                    }
                }
            }
        }
        
        
        }
        
       
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Push Notification Methods
    //-------------------------------------------------------------
    
    func registerForPushNotification() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
            
            print("Permissin granted: \(granted)")
            
            self.getNotificationSettings()
            
        })
        
    }
    
    
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {(settings) in
            
            print("Notification Settings: \(settings)")
            
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                
            }
            
        })
    }
    
    //-------------------------------------------------------------
    // MARK: - FireBase Methods
    //-------------------------------------------------------------
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
    }
    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Firebase registration token: \(fcmToken)")
//
//        // TODO: If necessary send token to application server.
//        // Note: This callback is fired at each app startup and whenever a new token is generated.
//
//        let token = Messaging.messaging().fcmToken
//        print("FCM token: \(token ?? "")")
//
//    }
    
    //-------------------------------------------------------------
    // MARK: - Actions On Push Notifications
    //-------------------------------------------------------------
    
    func pushAfterReceiveNotification(typeKey : String)
    {
        if(typeKey == "AddMoney")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "WalletHistoryViewController")
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "TransferMoney")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "WalletHistoryViewController")
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "Tickpay")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "PayViewController")
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "AcceptBooking")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController = navController?.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController") as! MyBookingViewController
                notificationController.bookingType = "accept"
                notificationController.isFromPushNotification = true
                
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "RejectBooking")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController = navController?.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController")  as! MyBookingViewController
                notificationController.bookingType = "reject"
                notificationController.isFromPushNotification = true
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "OnTheWay")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController = navController?.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController") as! MyBookingViewController
                notificationController.bookingType = "accept"
                notificationController.isFromPushNotification = true
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "Booking")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController = navController?.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController")  as! MyBookingViewController
                notificationController.bookingType = "reject"
                notificationController.isFromPushNotification = true
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "AdvanceBooking")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController = navController?.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController")  as! MyBookingViewController
                notificationController.bookingType = "reject"
                notificationController.isFromPushNotification = true
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
            }
        }
        
        //        else if(typeKey == "RejectDispatchJobRequest")
        //        {
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        //                let navController = self.window?.rootViewController as? UINavigationController
        //                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "PastJobsListVC")
        //                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
        //
        //                })
        //            }
        //        }
        //        else if(typeKey == "BookLaterDriverNotify")
        //        {
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        //                let navController = self.window?.rootViewController as? UINavigationController
        //                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "FutureBookingVC")
        //                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
        //
        //                })
        //            }
        //        }
    }
    
    // MARK:- Login & Logout Methods
    
    func GoToHome() {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let CustomSideMenu = storyborad.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! CustomSideMenuViewController
        let NavHomeVC = UINavigationController(rootViewController: CustomSideMenu)
        NavHomeVC.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = NavHomeVC
    }
    
    func GoToLogin() {
        
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let Login = storyborad.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        //        let customNavigation = UINavigationController(rootViewController: Login)
        let NavHomeVC = UINavigationController(rootViewController: Login)
        NavHomeVC.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = NavHomeVC
        
    }
    
    func GoToLogout() {
        
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
            
            if key == "Token" || key  == "i18n_language" {
                
            }
            else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        //        UserDefaults.standard.set(false, forKey: kIsSocketEmited)
        //        UserDefaults.standard.synchronize()
        
        SingletonClass.sharedInstance.strPassengerID = ""
        UserDefaults.standard.removeObject(forKey: "profileData")
        SingletonClass.sharedInstance.isUserLoggedIN = false
        //                self.performSegue(withIdentifier: "unwindToContainerVC", sender: self)
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        UserDefaults.standard.removeObject(forKey: "Passcode")
        SingletonClass.sharedInstance.setPasscode = ""
        
        UserDefaults.standard.removeObject(forKey: "isPasscodeON")
        SingletonClass.sharedInstance.isPasscodeON = false
        
        SingletonClass.sharedInstance.isPasscodeON = false
        self.GoToLogin()
    }
    
    func gettopMostViewController() -> UIViewController?
    {
        return UtilityClass.findtopViewController()
        
    }
    // webservice for getting the list tranport service like main furniture, labours only....
    func webserviceForTransportserviceList()
    {
        webserviceForTransportService("" as AnyObject) { (result, status) in
            if status
            {
                print(result)

                guard let arrTemp = (result as AnyObject).object(forKey: "percel") as? [[String : AnyObject]] else {
                    return
                }
                SingletonClass.sharedInstance.aryParcelTransport = arrTemp
            }
            else
            {
                print(result)
            }
        }
    }
}

extension String {
    var localized: String {

        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }

    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
}

//i18n_language = sw

// ----------------------------------------------------------
// ----------------------------------------------------------

let LCLBaseBundle = "Base"
let secondLanguage = "fr" // "sw"
var count = 0

extension UILabel {

    override open func layoutSubviews() {
        super.layoutSubviews()
        if(shouldLocalize == true)
        {
            if self.text != nil {
                //            count = count + 1
                self.text =  self.text?.localized
                //            print("The count is \(count)")
            }
        }
    }
}



/// Internal current language key
let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"

/// Default language. English. If English is unavailable defaults to base localization.
let LCLDefaultLanguage = "en"

/// Base bundle as fallback.
//let LCLBaseBundle = "Base"

/// Name for language change notification
public let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"

// MARK: Localization Syntax
/**
 Swift 1.x friendly localization syntax, replaces NSLocalizedString
 - Parameter string: Key to be localized.
 - Returns: The localized string.
 */
public func Localized(_ string: String) -> String {
    return string.localized1()
}

/**
 Swift 1.x friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
 - Parameter string: Key to be localized.
 - Returns: The formatted localized string with arguments.
 */
public func Localized(_ string: String, arguments: CVarArg...) -> String {
    return String(format: string.localized1(), arguments: arguments)
}

/**
 Swift 1.x friendly plural localization syntax with a format argument
 
 - parameter string:   String to be formatted
 - parameter argument: Argument to determine pluralisation
 
 - returns: Pluralized localized string.
 */
public func LocalizedPlural(_ string: String, argument: CVarArg) -> String {
    return string.localizedPlural(argument)
}


public extension String {
    /**
     Swift 2 friendly localization syntax, replaces NSLocalizedString
     - Returns: The localized string.
     */
    func localized1() -> String {
        if let path = Bundle.main.path(forResource: Localize.currentLanguage(), ofType: "lproj"), let bundle = Bundle(path: path) {
//            print("Path: \(path)")
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        else if let path = Bundle.main.path(forResource: LCLBaseBundle, ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        return self
    }
    
    
    /**
     Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
     - Returns: The formatted localized string with arguments.
     */
    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: localized1(), arguments: arguments)
    }
    
    /**
     Swift 2 friendly plural localization syntax with a format argument
     
     - parameter argument: Argument to determine pluralisation
     
     - returns: Pluralized localized string.
     */
    func localizedPlural(_ argument: CVarArg) -> String {
        return NSString.localizedStringWithFormat(localized1() as NSString, argument) as String
    }
}



// MARK: Language Setting Functions

open class Localize: NSObject {
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    open class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.index(of: "Base"), excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    /**
     Current language
     - Returns: The current language. String.
     */
    open class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: "i18n_language") as? String {
//            print("currentLanguage: \(currentLanguage)")
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    /**
     Change the current language
     - Parameter language: Desired language.
     */
    open class func setCurrentLanguage(_ language: String) {
        
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        }
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    open class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return LCLDefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }
    
    /**
     Resets the current language to the default
     */
    open class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    open class func displayNameForLanguage(_ language: String) -> String {
        let locale : Locale = Locale(identifier: currentLanguage())
        if let displayName = (locale as NSLocale).displayName(forKey: NSLocale.Key.languageCode, value: language) {
            return displayName
        }
        return String()
    }
}




func localizeString(stringToLocalize:String) -> String
{
    // Get the corresponding bundle path.
    let selectedLanguage = Localize.currentLanguage()
    let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj")
    
    // Get the corresponding localized string.
    let languageBundle = Bundle(path: path!)
    return languageBundle!.localizedString(forKey: stringToLocalize, value: "", table: nil)
}

func localizeUI(parentView:UIView)
{
    for view:UIView in parentView.subviews
    {
        if let potentialButton = view as? UIButton
        {
            if let titleString = potentialButton.titleLabel?.text {
                potentialButton.setTitle(localizeString(stringToLocalize: titleString), for: .normal)
            }
        }
            
        else if let potentialLabel = view as? UILabel
        {
            if potentialLabel.text != nil {
                potentialLabel.text = localizeString(stringToLocalize: potentialLabel.text!)
            }
        }
        
        localizeUI(parentView: view)
    }
}

extension UIApplication {
    
    var currentVisibleViewController: UIViewController? {
        
        guard let rootViewController = keyWindow?.rootViewController else {
            return nil
        }
        
        return getVisibleViewController(rootViewController)
    }
    
    private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        
        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }
        
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }
        
        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }
        
        return rootViewController
    }
}
