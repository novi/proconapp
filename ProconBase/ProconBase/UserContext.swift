//
//  UserContext.swift
//  ProconBase
//
//  Created by ito on 2015/06/13.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation

public protocol UserIdentifier {
    var id: Int { get }
    var token: String { get }
}

public class UserContext: UserIdentifier {
    
    public static let me = UserContext()
    
    public var id: Int // UserInfo
    public var token: String // UserInfo
    init() {
        self.id = 0
        self.token = ""
        
        let ud = NSUserDefaults.standardUserDefaults()
        if let id = ud.integerForKey(.UserID) as Int?, token = ud.stringForKey(.UserToken) as String? {
            self.id = id
            self.token = token
        }
    }
    
    public func saveAsMe(user: UserIdentifier) {
        self.id = user.id
        self.token = user.token
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setInteger(user.id, forKey: .UserID)
        ud.setObject(user.token, forKey: .UserToken)
        ud.synchronize()
    }
    
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
}