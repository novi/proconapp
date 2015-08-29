//
//  NoticeListViewController.swift
//  ProconApp
//
//  Created by ito on 2015/07/25.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase

/*
class NoticeListCell: UITableViewCell {
    var notice: Notice? {
        didSet {
            
        }
    }
}*/


class NoticeListViewController: TableViewController {
    
    var allNotices: [Notice] = []
    
    override func fetchContents() {
        if let me = UserContext.defaultContext.me {
            let r = AppAPI.Endpoint.FetchNotices(user: me, page: 0, count:10)
            startContentsLoading()
            AppAPI.sendRequest(r) { res in
                self.endContentsLoading()
                switch res {
                case .Success(let box):
                    Logger.debug("\(box.value)")
                    self.allNotices = box.value
                    self.reloadContents()
                case .Failure(let box):
                    // TODO, error
                    Logger.error(box.value)
                }
            }
        }
    }
    
    override var isNeedRefreshContents: Bool {
        return allNotices.count == 0
    }
    
    override func reloadContents() {
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchContentsIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title = "すべてのお知らせ"
    }
    
    // MARK: Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.NoticeListCell, forIndexPath: indexPath) as! NoticeCell
        cell.notice = allNotices[indexPath.row]
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier(.NoticeListCell) as! NoticeCell
        cell.titleLabel.text = self.allNotices[indexPath.row].title
        var maxSize = self.view.frame.size
        
        var height = cell.titleLabel.sizeThatFits(maxSize).height + cell.margin
        return height
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? NoticeCell {
            let dst = segue.destinationViewController as! NoticeViewController
            dst.notice = cell.notice
        }
    }
}
