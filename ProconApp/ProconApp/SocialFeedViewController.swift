//
//  SocialFeedViewController.swift
//  ProconApp
//
//  Created by ito on 2015/08/06.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var userIconImageView: LoadingImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    var tweet: Twitter.Tweet? {
        didSet {
            if let tw = tweet {
                userIconImageView.imageURL = tw.user.profileImageURL
                nameLabel.text = tw.user.userName
                screenNameLabel.text = tw.user.screenName
                bodyLabel.text = tw.text
                dateLabel.text = tw.createdAt
            }
        }
    }
}


class SocialFeedViewController: TableViewController {
    
    var tweets:[Twitter.Tweet] = []
    
    enum Section: Int {
        case Tweets = 0
        case More = 1

        
        static let count = 2
    }
    
    override func fetchContents() {
        if let me = UserContext.defaultContext.me {
            let r = AppAPI.Endpoint.FetchTwitterFeed(user: me)
            startContentsLoading()
            AppAPI.sendRequest(r) { res in
                self.endContentsLoading()
                switch res {
                case .Success(let box):
                    println(box.value)
                    self.tweets = box.value
                    self.reloadContents()
                case .Failure(let box):
                    // TODO, error
                    println(box.value)
                }
            }
        }
    }
    
    override func reloadContents() {
        tableView.reloadData()
    }
    
    override var isNeedRefreshContents: Bool {
        return tweets.count == 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchContentsIfNeeded()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Section.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .Tweets:
            return tweets.count
        case .More:
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section)! {
        case .Tweets:
            return 80
        case .More:
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .Tweets:
            let cell = tableView.dequeueReusableCellWithIdentifier(.SocialTweetCell, forIndexPath: indexPath) as! TweetCell
            cell.tweet = tweets[indexPath.row]
            return cell
        case .More:
            let cell = tableView.dequeueReusableCellWithIdentifier(.SocialMoreCell, forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
    }
}
