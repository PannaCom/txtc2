//
//  AppDelegate.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/17/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Siren
import Fabric
import Crashlytics
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        GMSServices.provideAPIKey(GOOGLE_API.KEY)
        GMSPlacesClient.provideAPIKey(GOOGLE_API.KEY)

        let siren = Siren.shared
        siren.forceLanguageLocalization = .Vietnamese
        siren.alertType = .force
        siren.checkVersion(checkType: .immediately)

        Fabric.with([Crashlytics.self])

        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
                if !granted {
                    print("something went wrong")
                }
                else {
                    print("request noti ios 10")
                }
            }
        }
        else {
            if(UIApplication.instancesRespond(to: #selector(UIApplication.registerUserNotificationSettings(_:)))) {
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge], categories: nil))
            }
        }


        return true
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
        Siren.shared.checkVersion(checkType: .immediately)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Siren.shared.checkVersion(checkType: .immediately)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
//        print(notification.userInfo!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationCheckWhoWin"), object: nil, userInfo: notification.userInfo)
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("noti receive on ios 10")
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationCheckWhoWin"), object: nil, userInfo: notification.userInfo)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("noti ios 10")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationCheckWhoWin"), object: nil, userInfo: notification.request.content.userInfo)
    }
    
}

