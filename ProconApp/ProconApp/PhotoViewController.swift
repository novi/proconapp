//
//  PhotoViewController.swift
//  ProconApp
//
//  Created by ito on 2015/08/01.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase

class PhotoViewController: ViewController, UIScrollViewDelegate {
    
    
    class ImageView: LoadingImageView {
        
        weak var parentViewController: PhotoViewController?
        
        override func didLoadImage(url: NSURL, image: UIImage) {
            self.sizeToFit()
            parentViewController?.viewDidLayoutSubviews()
            if let scrollView = self.parentViewController?.scrollView {
                scrollView.flashScrollIndicators()
                let scale = CGFloat(scrollView.bounds.size.width/image.size.width)
                scrollView.zoomScale = scale
            }
            parentViewController?.reloadIndicator()
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    weak var imageView: ImageView?
    
    var currentRequest: NSURLRequest?
    
    var photo: PhotoInfo? {
        didSet {
            fetchContents()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = ImageView(frame: CGRectZero)
        imageView.cacheImage = false
        imageView.contentMode = .TopLeft
        imageView.parentViewController = self
        scrollView.addSubview(imageView)
        self.imageView = imageView
        reloadIndicator()
    }
    
    override func fetchContents() {
        if let photo = self.photo, let imageView = self.imageView {
            imageView.imageURL = photo.originalURL
        }
    }
    
    func reloadIndicator() {
        if let image = self.imageView?.image {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchContents()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = imageView?.image?.size ?? CGSizeZero
        Logger.debug("scroll view content size: \(scrollView.contentSize)")
    }
    
    // MARK: Delegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
