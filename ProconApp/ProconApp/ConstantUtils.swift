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
        case WebView = "WebView"
    }
    
    func instantiateViewControllerWithIdentifier(identifier: StoryboardIdentifier) -> UIViewController {
        return self.instantiateViewControllerWithIdentifier(identifier.rawValue) as! UIViewController
    }
}

extension UITableView {
    enum CellIdentifier: String {
        case NotificationSettingCell = "Cell"
        case HomeGeneralCell = "GeneralCell"
        case HomeNoticeCell = "NoticeCell"
        case HomePhotoCell = "HomePhoto"
        case HomeGameResultCellRank = "GameResultCellRank"
        case HomeGameResultCellScore = "GameResultCellScore"
        
        case NoticeListCell = "NoticeListCell"
        
        case GameResultListCell = "GameResultListCell"
        
        case PhotoListCell = "PhotoListCell"
        
        case SocialTweetCell = "SocialTweetCell"
        case SocialMoreCell = "SocialMoreCell"
    }
    
    enum HeaderViewIdentifier: String {
        case HomeHeaderView = "HomeHeaderView"
        case ResultHeaderView = "ResultHeaderView"
    }
    enum HeaderViewNib: String {
        case HomeHeaderNib = "HomeHeaderView"
        case ResultHeaderNib = "ResultHeaderView"
    }
    
    func dequeueReusableCellWithIdentifier(identifier: CellIdentifier, forIndexPath indexPath: NSIndexPath) -> AnyObject {
        return self.dequeueReusableCellWithIdentifier(identifier.rawValue, forIndexPath: indexPath)
    }
    func dequeueReusableCellWithIdentifier(identifier: CellIdentifier) -> AnyObject {
        return self.dequeueReusableCellWithIdentifier(identifier.rawValue)!
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
        case HomeShowNothing = ""
        case HomeShowNotificationSetting = "NotificationSetting"
        case HomeShowLogin = "ShowLogin"
    }
    
    enum UnwindSegueIdentifier: String {
        case UnwindNotificationSetting = "NotificationSettingDone"
        case UnwindLogin = "LoginDone"
    }
    
    func performSegueWithIdentifier(identifier: UnwindSegueIdentifier, sender: AnyObject?) {
        self.performSegueWithIdentifier(identifier.rawValue, sender: sender)
    }
    
    func performSegueWithIdentifier(identifier: SegueIdentifier, sender: AnyObject?) {
        self.performSegueWithIdentifier(identifier.rawValue, sender: sender)
    }
}

extension UIImage {
    
    enum Image: String {
        case HeaderNotice = "header-notice"
        case HeaderGameResult = "header-result"
        case HeaderPhoto = "header-photo"
    }
    
    convenience init?(image: Image) {
        self.init(named:image.rawValue)
    }
    
}


/*
extension UIViewController: ContentsReloading {
    
}
*/