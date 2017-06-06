//
//  AppDelegate.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/16/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit
import Fabric
import DigitsKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import XMPPFramework

import AVFoundation


var appDelegate: AppDelegate?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let custObj: customClassViewController = customClassViewController()
    
    
    var xmppControllerr: XMPPController!
    let gcmMessageIDKey = "gcm.message_id"

    var arrOfSelectedCategory: NSMutableArray = NSMutableArray()
    var dictOfCategories: NSMutableDictionary = NSMutableDictionary()
    var dictSeekerReg: NSMutableDictionary = NSMutableDictionary()
    var dictPosterReg: NSMutableDictionary = NSMutableDictionary()
    var dictPosJob: NSMutableDictionary = NSMutableDictionary()
    var arrOfRoster: NSMutableArray = NSMutableArray()
    var isForCatEdit: Bool = false
    var isForSeekerEdit: Bool = false
    var arrIndexForCatEdit: Int = 0
    var arrIndexForRosterEdit: Int = 0
    var distanceToPostJob: Double = -1//100
    var locationForReg: String = ""//"Australia"
    var currentUserIdForChat: String = ""
    var isInCompleted: Bool = false
    var dictFilter: NSMutableDictionary = NSMutableDictionary()
    var isTerminated: Bool = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        sleep(2)
        (ATAppUpdater.sharedUpdater() as AnyObject).showUpdateWithConfirmation()
        API.setIsFromNotification(type: false)
        API.setup()
        API.setDeviceToken(token: "")
        API.setToken(token: "123")
        API.setPageIndex(page: -1)
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = Google_Client_ID
        
        
        Fabric.with([Digits.self])

        NotificationCenter.default.addObserver(self, selector: #selector(self.showNoti), name: NSNotification.Name(rawValue: "showNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showMsgNoti), name: NSNotification.Name(rawValue: "showMsgNoti"), object: nil)
        UserDefaults.standard.setValue("", forKey: "currentChatId")
        UserDefaults.standard.setValue(false, forKey: "fromPush")
        UserDefaults.standard.synchronize()
        
        FIRApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        UserDefaults.standard.set("", forKey: "deviceToken")
        UserDefaults.standard.synchronize()
        if #available(iOS 10.0, *)
        {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
            
            FIRMessaging.messaging().remoteMessageDelegate = self
            application.registerForRemoteNotifications()
            
        }
        else
        {
            let types: UIUserNotificationType = UIUserNotificationType([.alert, .badge, .sound])
            
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: types, categories: nil)
            
            application.registerUserNotificationSettings( settings )
            application.registerForRemoteNotifications()
            
        }
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        
        if API.getIsLogin() == true
        {
            if API.getRole() == "1"
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let dashboard: dashboardSeeker = storyboard.instantiateViewController(withIdentifier: "dashboardSeeker") as! dashboardSeeker
                let homeNavigation = UINavigationController(rootViewController: dashboard)
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = homeNavigation
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let dashboard: dashboardPoster = storyboard.instantiateViewController(withIdentifier: "dashboardPoster") as! dashboardPoster
                let homeNavigation = UINavigationController(rootViewController: dashboard)
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = homeNavigation
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        if AppDelegate.sharedDelegate().xmppControllerr != nil
        {
            AppDelegate.sharedDelegate().xmppControllerr.disConnect()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "connectToXMPP"), object: nil)
        if AppDelegate.sharedDelegate().xmppControllerr != nil
        {
            AppDelegate.sharedDelegate().xmppControllerr.connect()
        }
        if API.getIsLogin() == true
        {
            if API.getRoleName().lowercased() == "Poster".lowercased()
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDashboardPoster"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadJobsPoster"), object: nil)
            }
            else
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDashboardSeeker"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadJobsSeeker"), object: nil)
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    //MARK:- Social Login Back Url
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        if API.getRegType() == "1"
        {
            let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
            // Add any custom logic here.
            return handled
        }
        else
        {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        }
    }
    
    //MARK:- Shared Delegate
    class func sharedDelegate() -> AppDelegate
    {
        if nil == appDelegate
        {
            appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        }
        return appDelegate!
    }
    //MARK:- Firebase method
    func tokenRefreshNotification(_ notification: Notification)
    {
        if let refreshedToken = FIRInstanceID.instanceID().token()
        {
            print("InstanceID token: \(refreshedToken)")
            
            UserDefaults.standard.set(refreshedToken, forKey: DEVICE_TOKEN)
            UserDefaults.standard.synchronize()
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        let dictPush : NSDictionary = userInfo as NSDictionary
        print(dictPush)
       
        if API.getIsLogin() == false
        {
            return
        }
        let notiType: String = dictPush.object(forKey: "NotificationType") as! String
        let state: UIApplicationState = UIApplication.shared.applicationState // or use  let state =  UIApplication.sharedApplication().applicationState
        
        if state == .active
        {
            if notiType == "1" // Update, new category where added
            {
            }
            else
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showNoti"), object: dictPush)
            }
            if API.getRoleName().lowercased() == "Poster".lowercased()
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDashboardPoster"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadJobsPoster"), object: nil)
            }
            else
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDashboardSeeker"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadJobsSeeker"), object: nil)
            }
            return
        }
        if isTerminated == true
        {
            API.setIsFromNotification(type: true)
            API.setNotiDict(dict: dictPush)
            isTerminated = false
            return
        }
        isTerminated = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if notiType == "0" // Update, new category where added
        {
            custObj.alertMessage(withTitle: dictPush.object(forKey: "title") as! String!, with: dictPush.object(forKey: "body") as! String!)
        }
        else //if notiType == "1"   // Chat Notification
        {
            API.setIsFromNotification(type: true)
            API.setNotiDict(dict: dictPush)
            if API.getRoleName().lowercased() == "Poster".lowercased()
            {
                let dashboard: dashboardPoster = storyboard.instantiateViewController(withIdentifier: "dashboardPoster") as! dashboardPoster
                let homeNavigation = UINavigationController(rootViewController: dashboard)
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = homeNavigation
            }
            else
            {
                let dashboard: dashboardSeeker = storyboard.instantiateViewController(withIdentifier: "dashboardSeeker") as! dashboardSeeker
                let homeNavigation = UINavigationController(rootViewController: dashboard)
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = homeNavigation
            }
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    //MARK:- NOTIFICATION Delegate
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        var token: String = ""
        for i in 0..<deviceToken.count
        {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        //        UserDefaults.standard.set(token, forKey: DEVICE_TOKEN)
        //        UserDefaults.standard.synchronize()
        //        print(token)
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.unknown)
        
        print("tokenString: \(token)")
        
        if let refreshedToken = FIRInstanceID.instanceID().token()
        {
            print("InstanceID token: \(refreshedToken)")
            API.setDeviceToken(token: refreshedToken)
        }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        API.setDeviceToken(token: "")
        print(error)
    }
    
    // Receive displayed notifications for iOS 10 devices.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
    
    func showMsgNoti(n:NSNotification)
    {
        AudioServicesPlaySystemSound (1315)
        let dictMessage: NSDictionary = n.object as! NSDictionary
        print(dictMessage)
        TSMessage.showNotification(in: self.window?.rootViewController, title: dictMessage.object(forKey: "FromUserName") as! String, subtitle: dictMessage.object(forKey: "MessageText") as! String, image: UIImage(named:"AppIcon_WB"), type: TSMessageNotificationType.message, duration: 5, callback: {
            print("user tapped")
        }, buttonTitle: "", buttonCallback: {
            print("user tapped")
        }, at: TSMessageNotificationPosition.top, canBeDismissedByUser: true)
    }
    func showNoti(n:NSNotification)
    {
        let dictPush: NSDictionary = n.object as! NSDictionary
        let notiType: String = dictPush.object(forKey: "NotificationType") as! String
        let dictAps: NSDictionary = (dictPush.object(forKey: "aps") as! NSDictionary).object(forKey: "alert") as! NSDictionary
        
        AudioServicesPlaySystemSound (1315)
        TSMessage.showNotification(in: self.window?.rootViewController, title: dictAps.object(forKey: "title") as! String!, subtitle: dictAps.object(forKey: "body") as! String!, image: UIImage(named:"notiLogo"), type: TSMessageNotificationType.warning, duration: 5, callback: {
            print("user tapped")
        }, buttonTitle: "", buttonCallback: {
            print("user tapped")
        }, at: TSMessageNotificationPosition.top, canBeDismissedByUser: true)
    }
}
extension AppDelegate : FIRMessagingDelegate
{
    // Receive data message on iOS 10 devices while app is in the  foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage:   FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}

