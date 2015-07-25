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
    
    enum HeaderViewIdentifier: String {
        case HomeHeaderView = "HeaderCell"
    }
    enum HeaderViewNib: String {
        case HomeHeaderNib = "HomeHeaderView"
    }
    
    func dequeueReusableCellWithIdentifier(identifier: CellIdentifier, forIndexPath indexPath: NSIndexPath) -> AnyObject {
        return self.dequeueReusableCellWithIdentifier(identifier.rawValue, forIndexPath: indexPath)
    }
    func dequeueReusableHeaderFooterViewWithIdentifier(identifier: HeaderViewIdentifier) -> AnyObject? {
        return self.dequeueReusableHeaderFooterViewWithIdentifier(identifier.rawValue)
    }
    
    func registerNib(nibName: HeaderViewNib, forHeaderFooterViewReuseIdentifier identifier: HeaderViewIdentifier) {
        let nib = UINib(nibName: nibName.rawValue, bundle: nil)
        self.registerNib(nib, forHeaderFooterViewReuseIdentifier: identifier.rawValue)
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
        // TODO
        if contentsLoadingCount > 0 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func endContentsLoading() {
        contentsLoadingCount--
        if contentsLoadingCount > 0 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}

/*
extension UIViewController: ContentsReloading {
    
}
*/