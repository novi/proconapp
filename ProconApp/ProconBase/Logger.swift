//
//  Logger.swift
//  ProconApp
//
//  Created by ito on 2015/08/29.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation

public struct Logger {
    
    public static func error(error: ErrorType) {
        self.error("\(error)" as String)
    }
    
    #if HOST_RELEASE
    public static func debug(message: String) {
        return
    }
    public static func error(message: String) {
        NSLog("%@", message)
    }
    #else
    public static func debug(message: String) {
        NSLog("%@", message)
        
    }
    public static func error(message: String) {
        NSLog("%@", message)
    }
    #endif
}