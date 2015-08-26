//
//  InterfaceController.swift
//  ProconApp WatchKit Extension
//
//  Created by ito on 2015/07/29.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import WatchKit
import Foundation
import ProconBase


class MainInterfaceController: InterfaceController {

    //var user: User?
    
    @IBOutlet weak var messageLabel: WKInterfaceLabel!
    
    @IBOutlet weak var noticeButton: WKInterfaceButton!
    @IBOutlet weak var separator: WKInterfaceSeparator!
    @IBOutlet weak var resultButton: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        /*let appGroup = AppGroup.sharedInstance
        println(appGroup.objectForKey("test"))
        testLabel.setText((appGroup.objectForKey("test") as AnyObject? ?? "").description)
        */
        
        // Configure interface objects here.
        fetchContents()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        reloadContents()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func reloadContents() {
        if let me = UserContext.defaultContext.me {
            messageLabel.setHidden(true)
            
            noticeButton.setHidden(false)
            resultButton.setHidden(false)
            separator.setHidden(false)
        } else {
            noticeButton.setHidden(true)
            resultButton.setHidden(true)
            separator.setHidden(true)
            
            messageLabel.setHidden(false)
            messageLabel.setText("iPhoneで\n「はじめる」ボタンをタップして、アプリを設定してください。")
        }
    }
    
    override func fetchContents() {
        
        /*if let me = UserContext.defaultContext.me {
            // logged in
            let r = AppAPI.Endpoint.FetchUserInfo(user: me)
            AppAPI.sendRequest(r) { res in
                switch res {
                case .Success(let box):
                    println(box.value)
                    self.user = box.value
                    self.reloadContents()
                case .Failure(let box):
                    println(box.value)
                }
            }
        } else {
            println("not logged in")
        }*/
        
    }

}
