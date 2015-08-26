//
//  TweetViewController.swift
//  ProconApp
//
//  Created by ito on 2015/08/26.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation
import ProconBase

class TweetViewController: WebViewController {
    var tweet: Twitter.Tweet? {
        didSet {
            if let tweet = self.tweet {
                self.URL = tweet.URLForThisTweet
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ツイート"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: SocialFeedViewController.isTwitterInstalled ? "Twitterで開くく" : "Safariで開く", style: .Plain, target: self, action: "openInSafari")
    }
    
    func openInSafari() {
        if let tweet = self.tweet {
            if SocialFeedViewController.isTwitterInstalled {
                UIApplication.sharedApplication().openURL(tweet.URLSchemeForThisTweet)
            } else {
                UIApplication.sharedApplication().openURL(tweet.URLForThisTweet)
            }
        }
    }
    
}