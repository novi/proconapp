//
//  AppAPI.swift
//  ProconBase
//
//  Created by ito on 2015/06/13.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation
import APIKit
import Result
import Himotoki

public class AppAPI: API {
    override public class var baseURL: NSURL {
        return NSURL(string: Constants.APIBaseURL)!
    }
    
    public class Endpoint {
        
        public class BaseRequest {
            
            var user: UserIdentifier
            public init(user: UserIdentifier) {
                self.user = user
            }
            
            func buildRequestHeader(req: NSMutableURLRequest?) {
                if (user.token as NSString).length > 0 {
                    req?.setValue(user.token, forHTTPHeaderField: "X-User-Token")
                }
            }
        }
        
        public class CreateNewUser: APIKit.Request {
            
            public init() {
                
            }
            
            public var URLRequest: NSURLRequest? {
                return AppAPI.URLRequest(
                    method: .POST,
                    path: "/auth/new_user"
                )
            }
            
            public class func responseFromObject(object: AnyObject) -> User? {
                return decode(object)
            }
        }
        
        public class FetchUserInfo: BaseRequest, APIKit.Request {
            public var URLRequest: NSURLRequest? {
                let req = AppAPI.URLRequest(
                    method: .GET,
                    path: "/user/me/info",
                    parameters: [:]
                )
                buildRequestHeader(req) // TODO
                return req
            }
            
            public class func responseFromObject(object: AnyObject) -> User? {
                return decode(object)
            }
        }
        
        public class UpdatePushToken: BaseRequest, APIKit.Request {
            public var URLRequest: NSURLRequest? {
                let req = AppAPI.URLRequest(
                    method: .PUT,
                    path: "/user/me/push_token",
                    parameters: ["device_type": "ios", "device_token":pushToken]
                )
                buildRequestHeader(req) // TODO
                return req
            }
            
            let pushToken: String
            public init(user: UserIdentifier, pushToken: String) {
                self.pushToken = pushToken
                super.init(user: user)
            }
            
            public class func responseFromObject(object: AnyObject) -> AnyObject? {
                return object
            }
        }
        
        public class FetchNotices: BaseRequest, APIKit.Request {
            let page: Int
            
            public var URLRequest: NSURLRequest? {
                let req = AppAPI.URLRequest(
                    method: .GET,
                    path: "/notices/list",
                    parameters: ["page": page]
                )
                buildRequestHeader(req) // TODO
                return req
            }
            
            public init(user: UserIdentifier, page: Int = 0) {
                self.page = page
                super.init(user: user)
            }
            
            public class func responseFromObject(object: AnyObject) -> [Notice]? {
                return decodeArray(object)
            }
        }
        
        public class FetchNoticeText: BaseRequest, APIKit.Request {
            let notice: Notice
            
            public var URLRequest: NSURLRequest? {
                let req = AppAPI.URLRequest(
                    method: .GET,
                    path: "/notices/info",
                    parameters: ["id": notice.id]
                )
                buildRequestHeader(req) // TODO
                return req
            }
            
            public init(user: UserIdentifier, notice: Notice) {
                self.notice = notice
                super.init(user: user)
            }
            
            public class func responseFromObject(object: AnyObject) -> Notice? {
                return decode(object)
            }
        }
        
        public class FetchAllPlayers: BaseRequest, APIKit.Request {
            
            public var URLRequest: NSURLRequest? {
                let req = AppAPI.URLRequest(
                    method: .GET,
                    path: "/players"
                    //parameters: ]
                )
                buildRequestHeader(req) // TODO
                return req
            }
            
            public class func responseFromObject(object: AnyObject) -> [Player]? {
                return decodeArray(object)
            }
        }
        
    }
}

/*
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
*/
