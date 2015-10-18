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

public protocol ManageAPIRequest: Request {
    
}

extension ManageAPIRequest {
    public var baseURL: NSURL {
        return NSURL(string: Constants.ManageAPIBaseURL)!
    }
    
    public func configureURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        URLRequest.addValue(Constants.ManageAPIToken, forHTTPHeaderField: "X-Auth-Token")
        URLRequest.timeoutInterval = 15
        return URLRequest
    }
}

public struct ManageAPI {
    
}

extension ManageAPI {
    
    public struct UpdateGameResult: ManageAPIRequest {
        
        public typealias Response = AnyObject
        
        let result: [String: AnyObject]
        public init(result: [String: AnyObject]) {
            self.result = result
            Logger.debug("sending ... \(result)")
        }
        
        public var method: HTTPMethod {
            return .PUT
        }
        
        public var path: String {
            return "/game_results"
        }
        
        public var parameters: [String:AnyObject] {
            return result
        }
        
        public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
            return [:]
        }
    }
    
}
