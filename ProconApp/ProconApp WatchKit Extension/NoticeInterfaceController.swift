//
//  NoticeInterfaceController.swift
//  ProconApp
//
//  Created by Goodpatch on 2015/08/13.
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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let theNotice = context as? Notice {
            notice = theNotice
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        titleLabel.setText(notice?.title)
        dateLabel.setText(notice!.publishedAt.relativeDateString)
        contentLabel.setText(notice?.body)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
