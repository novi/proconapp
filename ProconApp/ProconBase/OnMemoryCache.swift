//
//  OnMemoryCache.swift
//  ProconApp
//
//  Created by ito on 2015/08/09.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation

public class OnMemoryCache {
    public static let sharedInstance = OnMemoryCache()
    
    let expires: NSTimeInterval = 600
    let size: Int = 30
    
    class Value {
        let createdAt: NSDate
        let obj: AnyObject
        init(_ obj: AnyObject) {
            self.obj = obj
            self.createdAt = NSDate()
        }
    }
    var bucket:NSMutableDictionary = [:]
    
    public func setObject(object: AnyObject, forKey key: NSCopying) {
        bucket.setObject(Value(object), forKey: key)
        cleanIfNeeded()
    }
    
    public func objectForKey(key: NSCopying) -> AnyObject? {
        if let val = bucket.objectForKey(key) as? Value {
            return val.obj
        }
        return nil
    }
    
    func cleanIfNeeded() {
        let s: Int = Int(Double(self.size) * 1.4)
        if bucket.count > s {
            var keysToRemove: [AnyObject] = []
            let now = NSDate().timeIntervalSince1970
            for (k, v) in bucket {
                if let vv = v as? Value {
                    if now - vv.createdAt.timeIntervalSince1970 > self.expires {
                        keysToRemove.append(k)
                    }
                }
            }
            Logger.debug("deleted \(keysToRemove)")
            bucket.removeObjectsForKeys(keysToRemove)
        }
    }
}