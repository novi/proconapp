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

extension UIColor {
    static var appTintColor: UIColor {
        return UIColor(red:46/255.0,green:63/255.0,blue:126/255.0,alpha:1.0)
    }
}
