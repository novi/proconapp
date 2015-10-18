//
//  NoticaListInterfaceController.swift
//  ProconApp
//
//  Created by hanamiju on 2015/08/13.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import WatchKit
import Foundation
import ProconBase
import APIKit

class NoticeListInterfaceController: InterfaceController {
    
    @IBOutlet weak var noticeTable: WKInterfaceTable!
    var notices: [Notice] = []
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        fetchContents()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func fetchContents() {
        if let me = UserContext.defaultContext.me {
            let r = AppAPI.FetchNotices(auth: me, page: 0, count: 10)
            API.sendRequest(r) { res in
                switch res {
                case .Success(let notices):
                    Logger.debug("\(notices)")
                    self.notices = notices
                    self.reloadContents()
                case .Failure(let error):
                    // TODO, error
                    Logger.error(error)
                }
            }
        }
    }
    
    override func reloadContents() {
        
        noticeTable.setNumberOfRows(notices.count, withRowType: .Notice)
        
        for i in 0..<notices.count {
            let cell = noticeTable.rowControllerAtIndex(i) as! NoticeTableCell
            cell.notice = notices[i]
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        self.pushControllerWithName(.Notice, context: NoticeObject(notices[rowIndex]))
    }
    
}

class NoticeTableCell: NSObject {
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    var notice: Notice? {
        didSet {
            if let notice = notice {
                titleLabel.setText(notice.title)
                dateLabel.setText(notice.publishedAt.relativeDateString)
            }
        }
    }
}