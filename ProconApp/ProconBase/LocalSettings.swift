//
//  LocalSettings.swift
//  ProconApp
//
//  Created by ito on 2015/07/29.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation

public class AppGroup { // TODO: no public
    public static let sharedInstance = NSUserDefaults(suiteName: Constants.AppGroupID)!
}

public class LocalSetting {
    
    public static var sharedInstance = LocalSetting()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    public var shouldShowNotificationSettings: Bool {
        get {
            return !userDefaults.boolForKey(.NotificationSettingDone)
        }
        set {
            userDefaults.setBool(!newValue, forKey: .NotificationSettingDone)
            userDefaults.synchronize()
        }
    }
}


extension NSUserDefaults {
    enum Keys: String {
        case UserID = "user_id"
        case UserToken = "user_token"
        case NotificationSettingDone = "notification_setting_done"
    }
    
    func stringForKey(key: Keys) -> String? {
        return stringForKey(key.rawValue)
    }
    
    func integerForKey(key: Keys) -> Int {
        return integerForKey(key.rawValue)
    }
    
    func boolForKey(key: Keys) -> Bool {
        return boolForKey(key.rawValue)
    }
    
    func setObject(value: AnyObject?, forKey key: Keys) {
        setObject(value, forKey: key.rawValue)
    }
    
    func setInteger(value: Int, forKey key: Keys) {
        setInteger(value, forKey: key.rawValue)
    }
    
    func setBool(value: Bool, forKey key: Keys) {
        setBool(value, forKey: key.rawValue)
    }
    
    /*public static var appGroup: NSUserDefaults {
        println(Constants.AppGroupID)
        return AppGroup.sharedInstance
    }*/
}