//
//  ImageView.swift
//  ProconApp
//
//  Created by ito on 2015/08/01.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase

class LoadingImageView: UIImageView {
    
    var currentTask: NSURLSessionTask?
    
    static var imageURLSession: NSURLSession = ({
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    })()
    
    var cacheImage: Bool = true
    
    var imageURL: NSURL? {
        didSet {
            if oldValue == imageURL {
                return
            }
            
            currentTask?.cancel()
            
            if let url = imageURL {
                
                if let cachedImage = OnMemoryCache.sharedInstance.objectForKey(url) as? UIImage {
                    self.image = cachedImage
                    return
                }
                
                self.image = nil
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let req = NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
                    Logger.debug("loading image \(url.absoluteString)")
                    let task = LoadingImageView.imageURLSession.dataTaskWithRequest(req, completionHandler: { (data: NSData!, res: NSURLResponse!, error: NSError!) -> Void in
                        
                        if data == nil || error != nil {
                            // error
                            Logger.error("image download error \(error)")
                            return
                        }
                        if let image = UIImage(data: data) {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.image = image
                                if self.cacheImage {
                                    OnMemoryCache.sharedInstance.setObject(image, forKey: url)
                                }
                                self.didLoadImage(url, image: image)
                            })
                        } else {
                            Logger.error("image data error")
                            return
                        }
                    })
                    task.resume()
                })
            }
        }
    }
    
    func didLoadImage(url: NSURL, image: UIImage) {
        
    }
}
