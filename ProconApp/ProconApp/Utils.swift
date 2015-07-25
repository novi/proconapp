//
//  Utils.swift
//  ProconApp
//
//  Created by ito on 2015/07/07.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase
import APIKit

extension UIApplication {
    
    func activatePushNotification() {
        let settings = UIUserNotificationSettings(forTypes: .Alert | .Sound | .Badge, categories: nil)
        self.registerUserNotificationSettings(settings)
    }
}

extension String {
    
    init?(deviceTokenData: NSData?) {
        if let deviceToken = deviceTokenData {
            let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
            var tokenString = ""
            
            for var i = 0; i < deviceToken.length; i++ {
                tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
            }
            self = tokenString
            return
        }
        return nil
    }
}


class LocalSettings {
    static let instance = LocalSettings()
    
    func registerAndUploadPushDeviceToken(token: String) {

        // TODO: save current push token to user defaults
        
        if let me = UserContext.defaultContext.me {
            let r = AppAPI.Endpoint.UpdatePushToken(user: me, pushToken: token)
            AppAPI.sendRequest(r) { res in
                switch res {
                case .Success(let box):
                    println(box.value)
                case .Failure(let box):
                    println(box.value)
                }
            }
        }
    }
    
}

extension NSDate {
    var relativeDateString: String {
        let timeDelta = NSDate().timeIntervalSince1970 - self.timeIntervalSince1970
        if timeDelta < 3600*24 {
            let hours = Int(timeDelta/3600)
            if hours >= 0 {
                if hours == 0 {
                    return "\(Int(timeDelta/60))分前"
                }
                return "\(Int(hours))時間前"
            }
        }
        
        // n日前
        let days = Int(timeDelta/(3600*24))
        return "\(days)日前"
    }
}
