//
//  PhotoViewController.swift
//  ProconApp
//
//  Created by ito on 2015/08/01.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase

class PhotoViewController: ViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var currentRequest: NSURLRequest?
    
    var photo: PhotoInfo? {
        didSet {
            if webView != nil {
                fetchContents()
            }
        }
    }
    
    override func fetchContents() {
        if let photo = self.photo {
            let req = NSURLRequest(URL: photo.originalURL)
            webView.loadRequest(req)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchContents()
    }
}
