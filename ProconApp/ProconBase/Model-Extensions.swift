//
//  Model-Extensions.swift
//  ProconApp
//
//  Created by ito on 2015/08/07.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation


extension Twitter.Tweet {
    
    public var URLSchemeForThisTweet: NSURL {
        return NSURL(string: "twitter://status?id=\(idStr)")!
    }
    
    public var URLForThisTweet: NSURL {
        return NSURL(string: "https://twitter.com/\(user.screenName)/status/\(idStr)")!
    }
}

extension Twitter {
    
    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier:"en_US")
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return formatter
    }()
}