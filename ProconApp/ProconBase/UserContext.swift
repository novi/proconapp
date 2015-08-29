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

struct MeIdentifier: UserIdentifier {
    var id: Int
    var token: String
    init?(id: Int, tokenStr: String?) {
        if let token = tokenStr as String? {
            self.id = id
            self.token = token
            return
        }
        return nil
    }
}

public class UserContext {
    
    public static let defaultContext = UserContext()
    
    public var me: UserIdentifier? // if nil, not logged in
    
    public var isLoggedIn: Bool {
        return me != nil
    }
    
    
    init() {
        let uds = [NSUserDefaults.standardUserDefaults(), AppGroup.sharedInstance]
        for ud in uds {
            me = MeIdentifier(id: ud.integerForKey(.UserID), tokenStr: ud.stringForKey(.UserToken))
            if me != nil {
                break
            }
        }
        Logger.debug("host:\(Constants.APIBaseURL)")
    }
    
    public func saveAsMe(user: UserIdentifier) {
        me = MeIdentifier(id: user.id, tokenStr: user.token)
        // save user token to both the app and its extension
        let uds = [NSUserDefaults.standardUserDefaults(), AppGroup.sharedInstance]
        for ud in uds {
            ud.setInteger(user.id, forKey: .UserID)
            ud.setObject(user.token, forKey: .UserToken)
            ud.synchronize()
        }
    }
    
}

