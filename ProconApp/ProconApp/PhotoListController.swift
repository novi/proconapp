//
//  PhotoListController.swift
//  ProconApp
//
//  Created by ito on 2015/08/01.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase
import APIKit

class PhotoListViewController: TableViewController {
    
    var photos: [PhotoInfo] = []
    
    override func fetchContents() {
        if let me = UserContext.defaultContext.me {
            let r = AppAPI.FetchPhotos(auth: me, count: 30)
            startContentsLoading()
            API.sendRequest(r) { res in
                self.endContentsLoading()
                switch res {
                case .Success(let photos):
                    Logger.debug("\(photos)")
                    self.photos = photos
                    self.reloadContents()
                case .Failure(let error):
                    // TODO, error
                    Logger.error(error)
                }
            }
        }
    }
    
    override func reloadContents() {
        tableView.reloadData()
    }
    
    override var isNeedRefreshContents: Bool {
        return photos.count == 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchContentsIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title = "会場フォト"
    }
    
    // MARK: Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.PhotoListCell, forIndexPath: indexPath) as! PhotoCell
        cell.photoInfo = photos[indexPath.row]
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let cell = sender as? PhotoCell {
            let dst = segue.destinationViewController as! PhotoViewController
            dst.photo = cell.photoInfo
            dst.title = cell.photoInfo?.title ?? ""
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }

    
}