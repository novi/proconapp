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
        return NSURL(string: Constants.ManageAPIBaseURL)!
    }
    
    public class Endpoint {
        
        public class BaseRequest {
            
            func buildRequestHeader(req: NSMutableURLRequest?) {
                
                req?.addValue(Constants.ManageAPIToken, forHTTPHeaderField: "X-Auth-Token")
                // TODO: set timeout globally
                req?.timeoutInterval = 15
            }
        }
        
        public class UpdateGameResult: BaseRequest, APIKit.Request {
            public var URLRequest: NSURLRequest? {
                let req = AppAPI.URLRequest(
                    method: .PUT,
                    path: "/game_results",
                    parameters: [:]
                )
                buildRequestHeader(req) // TODO
                return req
            }
            
            let result: AnyObject
            public init(result: AnyObject) {
                self.result = result
            }
            
            public class func responseFromObject(object: AnyObject) -> AnyObject? {
                return [:]
            }
        }
    }
    
}