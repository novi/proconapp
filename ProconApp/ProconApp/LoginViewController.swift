//
//  LoginViewController.swift
//  ProconApp
//
//  Created by ito on 2015/07/07.
//  Copyright (c) 2015年 Procon. All rights reserved.
//


import UIKit
import APIKit
import ProconBase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func loginTapped(sender: UIButton) {
        
        loginButton.enabled = false
        
        let r = AppAPI.Endpoint.CreateNewUser()
        AppAPI.sendRequest(r) { res in
            switch res {
            case .Success(let box):
                UserContext.defaultContext.saveAsMe(box.value)
                self.performSegueWithIdentifier(.UnwindLogin, sender: nil)
                println(box.value)
            case .Failure(let box):
                println(box.value)
                let alert = UIAlertController(title: "サーバーに接続できませんでした", message: nil, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) -> Void in
                    self.loginButton.enabled = true
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
}