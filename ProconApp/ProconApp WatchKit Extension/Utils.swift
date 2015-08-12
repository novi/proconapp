//
//  Utils.swift
//  ProconApp
//
//  Created by ito on 2015/08/01.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import WatchKit

class InterfaceController: WKInterfaceController {
    
    func reloadContents() {
        fatalError("should be overridden on subclass")
    }
    
    func fetchContents() {
        fatalError("should be overridden on subclass")
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
    
    class func timeString(date: NSDate?) -> String {
        var dateString = ""
        if let theDate = date {
            var dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "ja")
            let calender: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let comps: NSDateComponents = calender.components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate: date!)
            
            dateFormatter.dateFormat = "H:m"
            dateString = dateFormatter.stringFromDate(date!)
        }
        return dateString
    }
}