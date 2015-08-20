//
//  NoticeInterfaceController.swift
//  ProconApp
//
//  Created by hanamiju on 2015/08/13.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import WatchKit
import Foundation
import ProconBase


class NoticeInterfaceController: InterfaceController {

    @IBOutlet weak var contentLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    var notice: Notice?
    var noticeIndex: Int?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let index = context as? Int {
            noticeIndex = index
        }
        
        fetchContents()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        titleLabel.setText(notice?.title)
        dateLabel.setText(notice?.publishedAt.relativeDateString)
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
                    self.notice = box.value[self.noticeIndex!] // TODO:
                    self.reloadContents()
                case .Failure(let box):
                    // TODO, error
                    println(box.value)
                }
            }
        }
    }
    
    override func reloadContents() {
        
        if let body = self.notice?.buildBody() {
            //contentLabel.text = nil
            contentLabel.setAttributedText(body)
        } else {
            contentLabel.setText("読み込み中...")
        }
        
        if let notice = notice {
            if notice.body == nil && notice.hasBody {
                // fetch body
                if let me = UserContext.defaultContext.me {
                    let req = AppAPI.Endpoint.FetchNoticeText(user: me, notice: notice)
                    AppAPI.sendRequest(req) { result in
                        switch result {
                        case .Success(let box):
                            self.notice = box.value
                            self.reloadContents()
                        case .Failure(let box):
                            println(box.value)
                        }
                    }
                }
            }
        }
    }
}
