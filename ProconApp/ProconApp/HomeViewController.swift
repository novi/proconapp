//
//  FirstViewController.swift
//  ProconApp
//
//  Created by Yusuke on 2015/04/05.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase
import APIKit

class HomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let me = UserContext.defaultContext.me {
            // logged in
            let r = AppAPI.Endpoint.FetchUserInfo(user: me)
            AppAPI.sendRequest(r) { res in
                switch res {
                case .Success(let box):
                    println(box.value)
                case .Failure(let box):
                    println(box.value)
                }
            }
            
            // activate push notification
            UIApplication.sharedApplication().activatePushNotification()
        } else {
            // NOT logged in, show login view
            let vc = storyboard!.instantiateViewControllerWithIdentifier(.Login)
            self.tabBarController?.presentViewController(vc, animated: true) { () -> Void in
                
            }
        }
        
        // TEST
        
        if let me = UserContext.defaultContext.me {
            let r = AppAPI.Endpoint.FetchNotices(user: me, page: 0)
            AppAPI.sendRequest(r) { res in
                switch res {
                case .Success(let box):
                    println(box.value)
                    
                    if let n = box.value[0] as Notice? {
                        let r = AppAPI.Endpoint.FetchNoticeText(user: me, notice: n)
                        AppAPI.sendRequest(r) { res in
                            switch res {
                            case .Success(let box):
                                println(box.value)
                            case .Failure(let box):
                                println(box.value)
                            }
                        }
                    }
                    
                case .Failure(let box):
                    println(box.value)
                }
            }
        }

        
        
    }
    
    // MARK: Notification Settings
    
    @IBAction func notificationSettingDone(segue: UIStoryboardSegue) {
        
    }


}

