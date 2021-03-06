//
//  AppDelegate.swift
//  ProconApp
//
//  Created by Yusuke on 2015/04/05.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UISwitch.appearance().tintColor = UIColor.appTintColor
        UISwitch.appearance().onTintColor = UIColor.appTintColor
        
        #if DEBUG
            Logger.debug("debug flag is on")
            Logger.debug(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String)
        #endif
        
        // app group test
        /*let group = AppGroup.sharedInstance
        group.setObject(NSDate(), forKey: "test")
        
        let appGroup = AppGroup.sharedInstance
        Logger.debug(appGroup.objectForKey("test"))
        */
        
        let gai = GAI.sharedInstance()
        gai.dispatchInterval = 30
        #if DEBUG
        gai.logger.logLevel = GAILogLevel.Verbose
        #endif
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Dummy token send test
        //LocalSetting.sharedInstance.registerAndUploadPushDeviceTokenIfNeeded("dummy token 1")
        //LocalSetting.sharedInstance.registerAndUploadPushDeviceTokenIfNeeded("dummy token 2")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: Push Notification
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        if let token = String(deviceTokenData: deviceToken) {
            Logger.debug("device token: \(token)")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                LocalSetting.sharedInstance.registerAndUploadPushDeviceTokenIfNeeded(token)
            })
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        Logger.error("\(error)")
    }
    

}

