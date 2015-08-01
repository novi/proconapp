//
//  ImageView.swift
//  ProconApp
//
//  Created by ito on 2015/08/01.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit

class LoadingImageView: UIImageView {
    
    var currentTask: NSURLSessionTask?
    
    static var imageURLSession: NSURLSession = ({
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    })()
    
    var imageURL: NSURL? {
        didSet {
            if oldValue == imageURL {
                return
            }
            
            currentTask?.cancel()
            self.image = nil
            
            if let url = imageURL {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let req = NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
                    let task = LoadingImageView.imageURLSession.dataTaskWithRequest(req, completionHandler: { (data: NSData!, res: NSURLResponse!, error: NSError!) -> Void in
                        
                        if data == nil || error != nil {
                            // error
                            println("image download error", error)
                            return
                        }
                        let image = UIImage(data: data)
                        if image == nil {
                            println("image data error")
                            return
                        }
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.image = image
                        })
                    })
                    task.resume()
                })
            }
        }
    }
}
