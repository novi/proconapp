//
//  ConstantUtils.swift
//  ProconApp
//
//  Created by ito on 2015/07/07.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit

extension UIStoryboard {
    enum StoryboardIdentifier: String {
        case Login = "Login"
    }
    
    func instantiateViewControllerWithIdentifier(identifier: StoryboardIdentifier) -> UIViewController {
        return self.instantiateViewControllerWithIdentifier(identifier.rawValue) as! UIViewController
    }
}

extension UITableView {
    enum CellIdentifier: String {
        case NotificationSettingCell = "Cell"
        
        case HomeNoticeCell = "NoticeCell"
        case HomeGameResultCellRank = "GameResultCellRank"
        case HomeGameResultCellScore = "GameResultCellScore"
    }
    
    func dequeueReusableCellWithIdentifier(identifier: CellIdentifier, forIndexPath indexPath: NSIndexPath) -> AnyObject {
        return self.dequeueReusableCellWithIdentifier(identifier.rawValue, forIndexPath: indexPath)
    }
}

extension UIViewController {
    enum UnwindSegueIdentifier: String {
        case UnwindNotificationSetting = "NotificationSettingDone"
    }
    
    func performSegueWithIdentifier(identifier: UnwindSegueIdentifier, sender: AnyObject?) {
        self.performSegueWithIdentifier(identifier.rawValue, sender: sender)
    }
}


protocol ContentsReloading {
    func reloadContents()
    
    var isContentsLoading: Bool { get }
    var contentsLoadingCount: Int { get }
    
    func startContentsLoading()
    func endContentsLoading()
    
    // todo: use protocol extension
}

class TableViewController: UITableViewController, ContentsReloading {
    
    func reloadContents() {
        
    }
    
    var contentsLoadingCount: Int = 0
    
    var isContentsLoading: Bool {
        return contentsLoadingCount > 0
    }
    
    func startContentsLoading() {
        contentsLoadingCount++
    }
    
    func endContentsLoading() {
        contentsLoadingCount--
    }
}

/*
extension UIViewController: ContentsReloading {
    
}
*/