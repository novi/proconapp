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
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            Logger.debug("activatePushNotification")
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
            self.registerUserNotificationSettings(settings)
        })
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


extension UIColor {
    static var appTintColor: UIColor {
        return UIColor(red:46/255.0,green:63/255.0,blue:126/255.0,alpha:1.0)
    }
}


class SafariActivity: UIActivity {
    
    var url: NSURL?
    
    override class func activityCategory() -> UIActivityCategory {
        return .Action
    }
    
    override func activityType() -> String? {
        return "SafariActivity"
    }
    
    override func activityTitle() -> String? {
        return "Safariで開く"
    }
    override func activityImage() -> UIImage? {
        return UIImage(image: .ActivitySafari)
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        for obj in activityItems {
            if let url = obj as? NSURL {
                self.url = url
                return true
            }
        }
        return false
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for obj in activityItems {
            if let url = obj as? NSURL {
                self.url = url
                return
            }
        }
    }
    
    override func performActivity() {
        
        let completed: Bool
        if let url = self.url {
            completed = UIApplication.sharedApplication().openURL(url)
        } else {
            completed = false
        }
        self.activityDidFinish(completed)
    }
}