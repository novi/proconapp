//
//  ManageAPI.swift
//  ProconBase
//
//  Created by ito on 2015/06/13.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation
import APIKit
import Result
import Himotoki

public class ManageAPI: API {
    override public class var baseURL: NSURL {
        return NSURL(string: Constants.APIBaseURL)!
    }
    
    public class Endpoint {
        
        public class BaseRequest {
            
            func buildRequestHeader(req: NSMutableURLRequest?) {
                
                // TODO: set timeout globally
                req?.timeoutInterval = 15
            }
        }
    }
    
}