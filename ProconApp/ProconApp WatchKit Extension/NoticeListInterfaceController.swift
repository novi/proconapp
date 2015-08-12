//
//  NoticaListInterfaceController.swift
//  ProconApp
//
//  Created by Goodpatch on 2015/08/13.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import WatchKit
import Foundation
import ProconBase

class NoticeListInterfaceController: InterfaceController {
    
    @IBOutlet weak var NoticeTable: WKInterfaceTable!
    var notices: [Notice] = []
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        fetchContents()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func fetchContents() {
        if let me = UserContext.defaultContext.me {
            let r = AppAPI.Endpoint.FetchNotices(user: me, page: 0, count: 3)
            AppAPI.sendRequest(r) { res in
                switch res {
                case .Success(let box):
                    println(box.value)
                    self.notices = box.value
                    self.createTableData()
                    self.reloadContents()
                case .Failure(let box):
                    // TODO, error
                    println(box.value)
                }
            }
        }
    }
    
    func createTableData() {
        NoticeTable.setNumberOfRows(notices.count, withRowType: "NoticeTableCell")
        
        for i in 0..<notices.count {
            var noticeCell = NoticeTable.rowControllerAtIndex(i) as! NoticeTableCell
            noticeCell.notice = notices[i]
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        self.pushControllerWithName("NoticeInterfaceController", context: notices[rowIndex] as? AnyObject)
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