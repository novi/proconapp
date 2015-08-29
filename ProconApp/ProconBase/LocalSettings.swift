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
    
    public var shouldActivateNotification: Bool {
        return userDefaults.boolForKey(.NotificationSettingDone)
    }
    
    func isNeedSendPushToken(newToken: String) -> Bool {
        if let oldToken = userDefaults.stringForKey(.PushTokenLatestToken) {
            if oldToken != newToken {
                return true
            }
            Logger.debug("push token is same")
            if let lastSent = userDefaults.objectForKey(.PushTokenUploadedDate) as? NSDate {
                Logger.debug("push token last sent date lastSent:\(lastSent)")
                if NSDate().timeIntervalSince1970 - lastSent.timeIntervalSince1970 < 3600*24*1 {
                    return false
                }
            }
        }
        return true
    }
    
    func saveAsUploadedPushToken(token: String) {
        userDefaults.setObject(token, forKey: .PushTokenLatestToken)
        userDefaults.setObject(NSDate(), forKey: .PushTokenUploadedDate)
        userDefaults.synchronize()
    }
    
    public func registerAndUploadPushDeviceTokenIfNeeded(token: String) {
        if let me = UserContext.defaultContext.me {
            if self.isNeedSendPushToken(token) {
                let r = AppAPI.Endpoint.UpdatePushToken(user: me, pushToken: token)
                AppAPI.sendRequest(r) { res in
                    switch res {
                    case .Success(let box):
                        Logger.debug("push token uploaded")
                        self.saveAsUploadedPushToken(token)
                    case .Failure(let box):
                        Logger.debug("push token upload error: \(box.value)")
                    }
                }
                
            } else {
                Logger.debug("no need push token send")
            }
        }
    }
    
    public func registerAndUploadPushDeviceTokenIfNeeded_Dummy(token: String) {
        if let me = UserContext.defaultContext.me {
            if self.isNeedSendPushToken(token) {
                
                //Logger.debug("dummy sent failed")
                
                //Logger.debug("dummy sent success")
                //self.saveAsUploadedPushToken(token)
                
            } else {
                Logger.debug("no need push token send")
            }
        }
    }
}


extension NSUserDefaults {
    enum Keys: String {
        case UserID = "user_id"
        case UserToken = "user_token"
        case NotificationSettingDone = "notification_setting_done"
        
        case PushTokenUploadedDate = "push_token_last_uploaded"
        case PushTokenLatestToken = "push_token_latest_token"
    }
    
    func stringForKey(key: Keys) -> String? {
        return stringForKey(key.rawValue)
    }
    
    func objectForKey(key: Keys) -> AnyObject? {
        return objectForKey(key.rawValue)
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
        Logger.debug(Constants.AppGroupID)
        return AppGroup.sharedInstance
    }*/
}