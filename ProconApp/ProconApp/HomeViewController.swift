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

class HomeViewController: UITableViewController, ContentsReloading {
    
    enum Section: Int {
        case Notices = 0
        case GameResults = 1
        var CellIdentifier: UITableView.CellIdentifier {
            switch self {
            case .Notices:
                return .HomeNoticeCell
            case .GameResults:
                return .HomeGameResultCell
            }
        }
        var indexSet: NSIndexSet {
            return NSIndexSet(index: self.rawValue)
        }
        static let count = 2
    }
    
    var notices: [Notice] = []
    var gameResults: [GameResult] = []

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
        
        if let me = UserContext.defaultContext.me {
            let r = AppAPI.Endpoint.FetchNotices(user: me, page: 0)
            AppAPI.sendRequest(r) { res in
                switch res {
                case .Success(let box):
                    println(box.value)
                    self.notices = box.value
                    self.tableView.reloadSections(Section.Notices.indexSet, withRowAnimation: .Automatic)
                case .Failure(let box):
                    // TODO, error
                    println(box.value)
                }
            }
            
            let rr = AppAPI.Endpoint.FetchGameResults(user: me, count: 3)
            AppAPI.sendRequest(rr) { res in
                switch res {
                case .Success(let box):
                    println(box.value)
                    self.gameResults = box.value
                    self.tableView.reloadSections(Section.GameResults.indexSet, withRowAnimation: .Automatic)
                case .Failure(let box):
                    // TODO, error
                    println(box.value)
                }
            }
        }
        
    }
    
    func reloadContents() {
        tableView.reloadData()
    }
    
    // MARK: Notification Settings
    
    @IBAction func notificationSettingDone(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Section.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .Notices:
            return notices.count
        case .GameResults:
            return gameResults.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .Notices:
            let cell = tableView.dequeueReusableCellWithIdentifier(section.CellIdentifier, forIndexPath: indexPath) as! UITableViewCell
            
            let notice = self.notices[indexPath.row]
            
            cell.textLabel?.text = notice.title
            cell.detailTextLabel?.text = notice.publishedAt.description
            
            return cell
        case .GameResults:
            let cell = tableView.dequeueReusableCellWithIdentifier(section.CellIdentifier, forIndexPath: indexPath) as! UITableViewCell
            
            let result = self.gameResults[indexPath.row]
            
            println("result \(result.id): \(result.results)")
            
            cell.textLabel?.text = result.title
            cell.detailTextLabel?.text = result.startedAt.description
            
            return cell
        }
    }

}

