//
//  NoticeViewController.swift
//  ProconApp
//
//  Created by ito on 2015/07/25.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase

class NoticeViewController: ViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var notice: Notice?
    
    override func reloadContents() {
        // TODO: title and date
        if textView == nil {
            return
        }
        
        if let attrBody = self.buildBody() {
            textView.text = nil
            textView.attributedText = attrBody
        } else {
            textView.text = "loading..."
        }
        
        if let notice = notice {
            if notice.body == nil && notice.hasBody {
                // fetch body
                if let me = UserContext.defaultContext.me {
                    let req = AppAPI.Endpoint.FetchNoticeText(user: me, notice: notice)
                    startContentsLoading()
                    AppAPI.sendRequest(req) { result in
                        self.endContentsLoading()
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadContents()
    }
    
    func buildBody() -> NSAttributedString? {
        if let html = notice?.body {
            if let data = html.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true) {
                return NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil, error: nil)
            }
        }
        return nil
    }

}