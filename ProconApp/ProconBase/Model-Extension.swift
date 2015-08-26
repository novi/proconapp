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

extension Twitter.User {
    public var profileImageURLBigger: NSURL {
        let filename = profileImageURL.lastPathComponent ?? ""
        if let base = profileImageURL.URLByDeletingLastPathComponent {
            let biggerName = filename.stringByReplacingOccurrencesOfString("normal", withString: "bigger", options: .LiteralSearch, range: nil)
            return base.URLByAppendingPathComponent(biggerName)
        }
        return profileImageURL
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

extension Notice {
    public func buildBody() -> NSAttributedString? {
        if let html = body {
            if let data = html.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true) {
                return NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil, error: nil)
            }
        }
        return nil
    }
}