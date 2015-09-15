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

class HomeViewController: TableViewController, HomeHeaderViewDelegate {
    
    enum Section: Int {
        case General = 0
        case Notices = 1
        case GameResults = 2
        case Photos = 3
        
        var cellIdentifier: UITableView.CellIdentifier? {
            switch self {
            case .General:
                return .HomeGeneralCell
            case .Notices:
                return .HomeNoticeCell
            case .Photos:
                return .HomePhotoCell
            default:
                return nil
            }
        }
        
        var headerCellIdentifier: UITableView.HeaderViewIdentifier? {
            switch self {
            case .General:
                return .GeneralHeaderView
            default:
                return .HomeHeaderView
            }
        }
        
        var sectionImage: UIImage {
            switch self {
            case .Notices:
                return UIImage(image: .HeaderNotice)!
            case .GameResults:
                return UIImage(image: .HeaderGameResult)!
            case .Photos:
                return UIImage(image: .HeaderPhoto)!
            default:
                return UIImage()
            }
        }
        
        func cellIdentifierForGameResult(result: GameResult) -> UITableView.CellIdentifier {
            return .HomeGameResultCellRank
        }
        
        var indexSet: NSIndexSet {
            return NSIndexSet(index: self.rawValue)
        }
        
        var sectionName: String {
            switch self {
            case .Notices:
                return "お知らせ"
            case .GameResults:
                return "競技部門速報"
            case .Photos:
                return "会場フォト"
            default:
                return ""
            }
        }
        
        var showAllSegueIdentifier: UIViewController.SegueIdentifier {
            switch self {
            case .Notices:
                return .HomeShowNoticeList
            case .GameResults:
                return .HomeShowGameResultList
            case .Photos:
                return .HomeShowPhotoList
            default:
                return .HomeShowNothing
            }
        }
        
        static let count = 4
    }
    
    var notices: [Notice] = []
    var gameResults: [GameResult] = []
    var photos: [PhotoInfo] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appWillEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        if LocalSetting.sharedInstance.shouldActivateNotification {
            UIApplication.sharedApplication().activatePushNotification()
        } else {
            Logger.debug("notification setting not completed")
        }
        
        tableView.delaysContentTouches = false
        
        //tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        GAI.sharedInstance().sendShowScreen(.Home)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserContext.defaultContext.isLoggedIn &&
            LocalSetting.sharedInstance.shouldShowNotificationSettings {
                self.performSegueWithIdentifier(.HomeShowNotificationSetting, sender: nil)
        }
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0 // バッジを消す
        
        if let me = UserContext.defaultContext.me {
            // logged in
            let r = AppAPI.Endpoint.FetchUserInfo(user: me)
            AppAPI.sendRequest(r) { res in
                switch res {
                case .Success(let box):
                    Logger.debug("\(box.value)")
                case .Failure(let box):
                    Logger.error("\(box.value)")
                }
            }
        } else {
            // NOT logged in, show login view
            self.performSegueWithIdentifier(.HomeShowLogin, sender: nil)
        }
        
        fetchContents()
        
    }
    
    override func fetchContents() {
        if let me = UserContext.defaultContext.me {
            let r = AppAPI.Endpoint.FetchNotices(user: me, page: 0, count: 3)
            self.startContentsLoading()
            AppAPI.sendRequest(r) { res in
                self.endContentsLoading()
                switch res {
                case .Success(let box):
                    Logger.debug("\(box.value)")
                    self.notices = box.value
                    //self.tableView.reloadData()
                    self.tableView.reloadSections(Section.Notices.indexSet, withRowAnimation: .None)
                    // セパレータが消失するworkaround
                    self.tableView.separatorStyle = .None;
                    self.tableView.separatorStyle = .SingleLine;
                case .Failure(let box):
                    // TODO, error
                    Logger.error("\(box.value)")
                }
            }
            
            let rr = AppAPI.Endpoint.FetchGameResults(user: me, count: 3)
            self.startContentsLoading()
            AppAPI.sendRequest(rr) { res in
                self.endContentsLoading()
                switch res {
                case .Success(let box):
                    Logger.debug("\(box.value)")
                    self.gameResults = box.value
                    //self.tableView.reloadData()
                    self.tableView.reloadSections(Section.GameResults.indexSet, withRowAnimation: .None)
                    self.tableView.separatorStyle = .None;
                    self.tableView.separatorStyle = .SingleLine;
                case .Failure(let box):
                    // TODO, error
                    Logger.error("\(box.value)")
                }
            }
            
            let photoReq = AppAPI.Endpoint.FetchPhotos(user: me, count: 1)
            self.startContentsLoading()
            AppAPI.sendRequest(photoReq) { res in
                self.endContentsLoading()
                switch res {
                case .Success(let box):
                    self.photos = box.value
                    //self.tableView.reloadData()
                    self.tableView.reloadSections(Section.Photos.indexSet, withRowAnimation: .None)
                    self.tableView.separatorStyle = .None;
                    self.tableView.separatorStyle = .SingleLine;
                case .Failure(let box):
                    // TODO, error
                    Logger.error("\(box.value)")
                }
            }
        }
    }
    
    override func reloadContents() {
        tableView.reloadData()
    }
    
    // MARK: Notification Settings
    
    @IBAction func notificationSettingDone(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: Login
    
    @IBAction func loginDone(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Section.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .General:
            return 0
        case .Notices:
            return notices.count
        case .GameResults:
            return gameResults.count
        case .Photos:
            return photos.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .General:
            let action: Selector = "generalCellButtonTapped:"
            let cell = tableView.dequeueReusableCellWithIdentifier(section.cellIdentifier!) as! GeneralCell
            cell.accessButton.addTarget(self, action: action, forControlEvents: .TouchUpInside)
            cell.programButton.addTarget(self, action: action, forControlEvents: .TouchUpInside)
            return cell
        case .Notices:
            let cell = tableView.dequeueReusableCellWithIdentifier(section.cellIdentifier!) as! NoticeCell
            
            cell.notice = self.notices[indexPath.row]
            
            return cell
        case .GameResults:
            
            let result = self.gameResults[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier(section.cellIdentifierForGameResult(result), forIndexPath: indexPath) as! GameResultCell
            cell.selectionStyle = .None
            Logger.debug("result \(result.id): \(result.results)")
            
            cell.result = result
            
            return cell
            
        case .Photos:
            let photo = self.photos[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(section.cellIdentifier!, forIndexPath: indexPath) as! PhotoCell
            cell.photoInfo = photo
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let section = Section(rawValue: section)!
        let nib = UINib(nibName: section.headerCellIdentifier!.rawValue, bundle: nil)
        var cell: UIView?
        switch section {
        case .General:
            let aCell = nib.instantiateWithOwner(nil, options: nil)[0] as? GeneralHeaderView
            let action: Selector = "generalCellButtonTapped:"
            aCell!.accessButton.addTarget(self, action: action, forControlEvents: .TouchUpInside)
            aCell!.programButton.addTarget(self, action: action, forControlEvents: .TouchUpInside)
            cell = aCell
        default:
            let aCell = nib.instantiateWithOwner(nil, options: nil)[0] as? HomeHeaderView
            aCell!.section = section
            aCell!.delegate = self
            cell = aCell
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (Section(rawValue: section)! == .General) {
            return 70
        }
        return 36
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = Section(rawValue: indexPath.section)!
        let height: CGFloat
        
        switch section {
        case .General:
            height = 70
        case .Notices:
            height = 44
        case .GameResults:
            height = 78
        case .Photos:
            height = 220
        }
        return height
    }
    
    func homeHeaderView(view: HomeHeaderView, didTapShowAllforSection section: HomeViewController.Section) {
        performSegueWithIdentifier(section.showAllSegueIdentifier, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? NoticeCell {
            let dst = segue.destinationViewController as! NoticeViewController
            dst.notice = cell.notice
            dst.title = cell.notice?.title ?? ""
        } else if let cell = sender as? PhotoCell {
            let dst = segue.destinationViewController as! PhotoViewController
            dst.photo = cell.photoInfo
            dst.title = cell.photoInfo?.title ?? ""
        }
    }
    
    func generalCellButtonTapped(sender: UIButton) {
        let web = storyboard!.instantiateViewControllerWithIdentifier(.WebView) as! WebViewController
        switch GeneralCell.Tag(rawValue: sender.tag)! {
        case .Access:
            web.URL = Constants.appLPURL("/docs/access")
            web.title = "アクセス"
        case .Program:
            web.URL = Constants.appLPURL("/docs/procon_program")
            web.title = "プログラム"
        }
        web.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(web, animated: true)
    }

    func appWillEnterForeground() {
        // TODO: super class?
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0 // バッジを消す
        if self.appearingViewController == self {
            fetchContents()
        }
    }
}

