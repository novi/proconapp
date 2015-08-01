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
        case HomePhotoCell = "HomePhoto"
        case HomeGameResultCellRank = "GameResultCellRank"
        case HomeGameResultCellScore = "GameResultCellScore"
        
        case NoticeListCell = "NoticeListCell"
        
        case GameResultListCell = "GameResultListCell"
        
        case PhotoListCell = "PhotoListCell"
    }
    
    enum HeaderViewIdentifier: String {
        case HomeHeaderView = "HomeHeaderView"
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
    
    enum SegueIdentifier: String {
        case HomeShowNoticeList = "ShowNoticeList"
        case HomeShowGameResultList = "GameResultList"
        case HomeShowPhotoList = "PhotoList"
    }
    
    enum UnwindSegueIdentifier: String {
        case UnwindNotificationSetting = "NotificationSettingDone"
    }
    
    func performSegueWithIdentifier(identifier: UnwindSegueIdentifier, sender: AnyObject?) {
        self.performSegueWithIdentifier(identifier.rawValue, sender: sender)
    }
    
    func performSegueWithIdentifier(identifier: SegueIdentifier, sender: AnyObject?) {
        self.performSegueWithIdentifier(identifier.rawValue, sender: sender)
    }
}


protocol ContentsReloading {
    func reloadContents()
    func fetchContents()
    
    var isContentsLoading: Bool { get }
    var contentsLoadingCount: Int { get }
    
    func startContentsLoading()
    func endContentsLoading()
    
    // todo: use protocol extension
}

class ViewController: UIViewController, ContentsReloading {
    
    func reloadContents() {
        fatalError("should be overridden on subclass")
    }
    
    func fetchContents() {
        fatalError("should be overridden on subclass")
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

class TableViewController: UITableViewController, ContentsReloading {
    
    func reloadContents() {
        fatalError("should be overridden on subclass")
    }
    
    func fetchContents() {
        fatalError("should be overridden on subclass")
    }
    
    func fetchContentsIfNeeded() {
        if isNeedRefreshContents {
            fetchContents()
        }
    }
    
    var isNeedRefreshContents: Bool {
        return false
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