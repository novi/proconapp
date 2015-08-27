//
//  SocialFeedViewController.swift
//  ProconApp
//
//  Created by ito on 2015/08/06.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase
import Social

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var userIconImageView: LoadingImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    var tweet: Twitter.Tweet? {
        didSet {
            if let tw = tweet {
                userIconImageView.imageURL = tw.user.profileImageURLBigger
                nameLabel.text = tw.user.userName
                screenNameLabel.text = "@" + tw.user.screenName
                bodyLabel.text = tw.text
                dateLabel.text = tw.createdAt.relativeDateString

                userIconImageView.layer.cornerRadius = 3
                userIconImageView.layer.masksToBounds = true
            }
        }
    }
}

class SocialFeedHeaderView: UIView {
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel.text = "Twitterからの検索結果 #\(SocialFeedViewController.HASH_TAG) を表示しています。"
    }
}

class SocialFeedViewController: TableViewController {
    
    static let HASH_TAG = "procon26"
    
    var tweets:[Twitter.Tweet] = []
    
    enum Section: Int {
        case Tweets = 0
        case More = 1
        
        static let count = 2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.title = "#\(HASH_TAG)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "pullToRefresh:", forControlEvents: .ValueChanged)
    }
    
    func pullToRefresh(sender: UIRefreshControl) {
        fetchContents()
    }
    
    override func fetchContents() {
        if let me = UserContext.defaultContext.me {
            let r = AppAPI.Endpoint.FetchTwitterFeed(user: me)
            startContentsLoading()
            self.refreshControl?.beginRefreshing()
            AppAPI.sendRequest(r) { res in
                self.endContentsLoading()
                self.refreshControl?.endRefreshing()
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
        return tweets.count == 0 && !(self.refreshControl?.refreshing ?? false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchContentsIfNeeded()
        
        GAI.sharedInstance().sendShowScreen(.Social)
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .Tweets:
            break
        case .More:
            let hashTag = SocialFeedViewController.HASH_TAG
            if self.dynamicType.isTwitterInstalled {
                UIApplication.sharedApplication().openURL(NSURL(string: "twitter://search?query=%23\(hashTag)")!)
            } else {
                UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/search?q=%23\(hashTag)")!)
            }
        }
        if let selected = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(selected, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dst = segue.destinationViewController as? TweetViewController,
            let selected = tableView.indexPathForSelectedRow() {
            dst.tweet = tweets[selected.row]
        }
    }
    
    // MARK: Twitter App
    
    @IBAction func tweetTapped(sender: AnyObject) {
        
        let hashTag = SocialFeedViewController.HASH_TAG
        
        if self.dynamicType.isTwitterInstalled {
            let message = "%23\(hashTag)"
            let url = "twitter://post?message=\(message)"
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        } else {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc.setInitialText("#\(hashTag)")
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    static var isTwitterInstalled: Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(string: "twitter://post")!)
    }
}
