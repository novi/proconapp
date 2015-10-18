//
//  NoticeViewController.swift
//  ProconApp
//
//  Created by ito on 2015/07/25.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase
import APIKit

class NoticeViewController: ViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var notice: Notice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.textContainerInset = UIEdgeInsetsMake(20, 5, 20, 5)
    }
    
    override func reloadContents() {
        // TODO: title and date
        if textView == nil {
            return
        }
        
        if let attrBody = self.notice?.buildBody() {
            textView.text = nil
            textView.attributedText = attrBody
        } else {
            textView.text = "読み込み中..."
        }
        
        if let notice = notice {
            if notice.body == nil && notice.hasBody {
                // fetch body
                if let me = UserContext.defaultContext.me {
                    let req = AppAPI.FetchNoticeText(auth: me, notice: notice)
                    startContentsLoading()
                    API.sendRequest(req) { result in
                        self.endContentsLoading()
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadContents()
    }
    
    

}
