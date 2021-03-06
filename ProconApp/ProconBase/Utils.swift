//
//  Utils.swift
//  ProconApp
//
//  Created by ito on 2015/08/14.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation

extension NSDate {
    public var relativeDateString: String {
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
    
    static var timeDateFormatter: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja")
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter // TODO: use static let
    }
    public var timeString: String {
        return self.dynamicType.timeDateFormatter.stringFromDate(self) ?? ""
    }
}

extension NSURL {
    enum Error: ErrorType {
        case NullURLString
        case InvalidURLString
    }
    static func fromJSON(str: String?) throws -> NSURL {
        guard let urlStr = str else {
            throw Error.NullURLString
        }
        guard let url = NSURL(string: urlStr) else {
            throw Error.InvalidURLString
        }
        return url
    }
}

extension Constants {
    public static func appLPURL(path: String) -> NSURL {
        return NSURL(string: Constants.AppLPURL)!.URLByAppendingPathComponent(path)
    }
}