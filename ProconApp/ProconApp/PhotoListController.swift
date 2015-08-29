//
//  PhotoListController.swift
//  ProconApp
//
//  Created by ito on 2015/08/01.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase


class PhotoListViewController: TableViewController {
    
    var photos: [PhotoInfo] = []
    
    override func fetchContents() {
        if let me = UserContext.defaultContext.me {
            let r = AppAPI.Endpoint.FetchPhotos(user: me, count: 30)
            startContentsLoading()
            AppAPI.sendRequest(r) { res in
                self.endContentsLoading()
                switch res {
                case .Success(let box):
                    Logger.debug("\(box.value)")
                    self.photos = box.value
                    self.reloadContents()
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
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = 0
        let cell = tableView.dequeueReusableCellWithIdentifier(.PhotoListCell) as! PhotoCell
        cell.thumbnailImageView.imageURL = self.photos[indexPath.row].thumbnailURL
        
        height = cell.thumbnailImageView.frame.height + cell.margin
        return height
    }

    
}