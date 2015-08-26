//
//  Utils.swift
//  ProconApp
//
//  Created by ito on 2015/08/01.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import WatchKit
import ProconBase

class GameResultObject: NSObject {
    let result:GameResult
    init(_ result: GameResult) {
        self.result = result
    }
}

class NoticeObject: NSObject {
    let notice: Notice
    init(_ notice: Notice) {
        self.notice = notice
    }
}

class InterfaceController: WKInterfaceController {
    
    func reloadContents() {
        fatalError("should be overridden on subclass")
    }
    
    func fetchContents() {
        fatalError("should be overridden on subclass")
    }
}


extension WKInterfaceTable {
    
    enum TableCell: String {
        case Result = "ResultTableCell"
        case ResultSchool = "SchoolTableCell"
        case Notice = "NoticeTableCell"
        case GlanceSchool = "GlanceSchoolTableCell"
    }
    
    func setNumberOfRows(numberOfRows: Int, withRowType rowType: TableCell) {
        self.setNumberOfRows(numberOfRows, withRowType: rowType.rawValue)
    }
}

extension WKInterfaceController {
    enum ControllerName: String {
        case Result = "ResultInterfaceController"
        case Notice = "NoticeInterfaceController"
    }
    
    func pushControllerWithName(name: ControllerName, context: AnyObject?) {
        self.pushControllerWithName(name.rawValue, context: context)
    }
}