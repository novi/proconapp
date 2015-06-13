//
//  AppAPI.swift
//  ProconBase
//
//  Created by ito on 2015/06/13.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation
import APIKit
import Himotoki

public class GitHub: API {
    override public class var baseURL: NSURL {
        return NSURL(string: "https://api.github.com")!
    }
    
    public class Endpoint {
        // https://developer.github.com/v3/search/#search-repositories
        public class SearchRepositories: APIKit.Request {
            public enum Sort: String {
                case Stars = "stars"
                case Forks = "forks"
                case Updated = "updated"
            }
            
            public enum Order: String {
                case Ascending = "asc"
                case Descending = "desc"
            }
            
            public typealias Response = [Repository]
            
            let query: String
            let sort: Sort
            let order: Order
            
            public var URLRequest: NSURLRequest? {
                return GitHub.URLRequest(
                    method: .GET,
                    path: "/search/repositories",
                    parameters: ["q": query, "sort": sort.rawValue, "order": order.rawValue]
                )
            }
            
            public init(query: String, sort: Sort = .Stars, order: Order = .Ascending) {
                self.query = query
                self.sort = sort
                self.order = order
            }
            
            public class func responseFromObject(object: AnyObject) -> Response? {
                return object["items"].flatMap(decode) ?? []
            }
        }
        
    }
}
