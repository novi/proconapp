//
//  GAI.swift
//  ProconApp
//
//  Created by ito on 2015/08/27.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation
import ProconBase

extension GAI {
    
    var tracker: GAITracker {
        return self.trackerWithTrackingId(Constants.GATrackingID)
    }
    
    enum Screen: String {
        case Home = "Home"
        case Social = "Social"
    }
    
    func sendShowScreen(screen: Screen) {
        tracker.set(kGAIScreenName, value: screen.rawValue)
        tracker.send(GAIDictionaryBuilder.createScreenView().build() as NSDictionary as [NSObject : AnyObject])
    }
}