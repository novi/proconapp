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
import APIKit


class NoticeInterfaceController: InterfaceController {

    @IBOutlet weak var contentLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!

    var notice: Notice?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.notice = (context as? NoticeObject)?.notice
        
        contentLabel.setAttributedText(NSAttributedString(string: "読み込み中..."))
        titleLabel.setText(notice?.title)
        dateLabel.setText(notice?.publishedAt.relativeDateString)
        
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
        if let notice = self.notice {
            if let me = UserContext.defaultContext.me {
                let req = AppAPI.FetchNoticeText(auth: me, notice: notice)
                API.sendRequest(req) { result in
                    switch result {
                    case .Success(let notice):
                        self.notice = notice
                        self.reloadContents()
                    case .Failure(let error):
                        Logger.error(error)
                    }
                }
            }
        }
    }
    
    override func reloadContents() {
        
        if let body = self.notice?.buildBody() {
            contentLabel.setAttributedText(body)
        }
    }
}
