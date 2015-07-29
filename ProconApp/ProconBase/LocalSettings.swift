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


extension NSUserDefaults {
    enum Keys: String {
        case UserID = "user_id"
        case UserToken = "user_token"
    }
    
    func stringForKey(defaultName: Keys) -> String? {
        return stringForKey(defaultName.rawValue)
    }
    
    func integerForKey(defaultName: Keys) -> Int {
        return integerForKey(defaultName.rawValue)
    }
    
    func setObject(value: AnyObject?, forKey defaultName: Keys) {
        setObject(value, forKey: defaultName.rawValue)
    }
    
    func setInteger(value: Int, forKey defaultName: Keys) {
        setInteger(value, forKey: defaultName.rawValue)
    }
    
    public static var appGroup: NSUserDefaults {
        println(Constants.AppGroupID)
        return AppGroup.sharedInstance
    }
}