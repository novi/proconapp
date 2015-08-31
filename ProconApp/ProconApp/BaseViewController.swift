//
//  ViewController.swift
//  ProconApp
//
//  Created by ito on 2015/08/07.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit



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
    
    var appearingViewController: UIViewController? {
        if let navc = self.tabBarController?.selectedViewController as? UINavigationController {
            return navc.viewControllers.last as? UIViewController
        }
        return nil
    }
}