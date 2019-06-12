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
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    var isAlreadyLaunched : Bool?
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

        if UserDefaults.standard.value(forKey: "i18n_language") == nil {
            UserDefaults.standard.set("en", forKey: "i18n_language")
            UserDefaults.standard.synchronize()
        }

        isAlreadyLaunched = false
        // Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
       
        IQKeyboardManager.shared.enable = true
        
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
        
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = (window?.frame.width)! * 0.85//(((window?.frame.width)! / 2) + ((window?.frame.width)! / 4))
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
        
        // ------------------------------------------------------------
        
        if ((UserDefaults.standard.object(forKey: "profileData")) != nil)
        {
            SingletonClass.sharedInstance.dictProfile = UserDefaults.standard.object(forKey: "profileData") as! NSMutableDictionary
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!
        
        if(application.applicationState == .background)
        {
            self.pushAfterReceiveNotification(typeKey: key as! String)
        }
        
        // Let FCM know about the message for analytics etc.
        
//        Messaging.messaging().appDidReceiveMessage(userInfo)

        
        //        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
        
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
        print(notification.request.content.userInfo)
        
        let dictNoti = notification.request.content.userInfo as! [String : AnyObject]
        let key = (dictNoti)["gcm.notification.type"] as! String
        
        if let NotificationType = notification.request.content.userInfo["gcm.notification.type"]! as? String
        {
            if NotificationType == "ChatNotification"
            {
                let dictData = notification.request.content.userInfo["gcm.notification.data"] as! String
                let data = dictData.data(using: .utf8)!
                do
                {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                    {
                        var UserDict = [String:Any]()
                        UserDict["Sender"] = jsonResponse["Sender"] as! String
                        UserDict["ReceiverId"] = jsonResponse["ReceiverId"] as! String
                        UserDict["TicketId"] = jsonResponse["TicketId"] as! String
                        UserDict["Message"] = jsonResponse["Message"] as! String
                        UserDict["Receiver"] = jsonResponse["Receiver"] as! String
                        UserDict["SenderId"] = jsonResponse["SenderId"] as! String
                        UserDict["Date"] = jsonResponse["Date"] as! String
                        let TicketID =  jsonResponse["TicketId"] as! String
                        
                        if SingletonClass.sharedInstance.isChatBoxOpen == true && TicketID == SingletonClass.sharedInstance.ChatBoxOpenedWithID
                        {
                            self.handleRemoteNotification(key: key, userInfo: UserDict as NSDictionary, application: UIApplication.shared)
                        }
                        else
                        {
                            completionHandler([.alert, .badge, .sound])
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
        else
        {
            completionHandler([.alert, .badge, .sound])
        }
        
    }
    
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

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print(response.notification.request.content.userInfo)
        let dictNoti = response.notification.request.content.userInfo as! [String : AnyObject]
        let key = (dictNoti)["gcm.notification.type"] as! String
        self.handleRemoteNotification(key: key, userInfo: dictNoti as NSDictionary, application: UIApplication.shared)
        
        /*
         // 1
         let userInfo = response.notification.request.content.userInfo
         let aps = userInfo["aps"] as! [String:AnyObject]
         
         // 2
         if let newsItem = NewsItem.makeNewsItems(aps) {
         (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
         
         // 3
         if response.actionIdentifier == "viewActionIdentifier",
         let url = URL(string: newsItem.link) {
         let safari = SFSafariViewController(url: url)
         window?.rootViewController?.present(safari, animated: true, completion: nil)
         }
         }
         // 4
         completionHandler()
         */
        
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
//        if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
//            // we set a default, just in case
//
//
//
//        }
//        if  UserDefaults.standard.string(forKey: "i18n_language") == nil
//        {
//            UserDefaults.standard.set("en", forKey: "i18n_language")
//            UserDefaults.standard.synchronize()
//        }

        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        print(lang)
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        print(path ?? "")
        print(bundle ?? "")
              return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

//i18n_language = sw

// ----------------------------------------------------------
// ----------------------------------------------------------

let LCLBaseBundle = "Base"
let secondLanguage = "fr" // "sw"


extension UILabel {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if self.text != nil {
            self.layoutIfNeeded()
            self.text =  self.text!.localized1()
            print("self.text: \(String(describing: self.text))")
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
            print("Path: \(path)")
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
            print("currentLanguage: \(currentLanguage)")
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
