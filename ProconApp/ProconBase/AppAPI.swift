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
                
                // TODO: set timeout globally
                req?.timeoutInterval = 15
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
            let count: Int
            
            public var URLRequest: NSURLRequest? {
                let req = AppAPI.URLRequest(
                    method: .GET,
                    path: "/notices/list",
                    parameters: ["page": page, "count":count]
                )
                buildRequestHeader(req) // TODO
                return req
            }
            
            public init(user: UserIdentifier, page: Int = 0, count: Int = 3) {
                self.page = page
                self.count = count
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
                    parameters: ["id": notice.id.val]
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
        
        public class FetchGameNotificationSettings: BaseRequest, APIKit.Request {
            
            public var URLRequest: NSURLRequest? {
                let req = AppAPI.URLRequest(
                    method: .GET,
                    path: "/user/me/game_notification"
                    //parameters: ]
                )
                buildRequestHeader(req) // TODO
                return req
            }
            
            public class func responseFromObject(object: AnyObject) -> [PlayerID]? {
                return ((object["ids"] as? [Int]) ?? []).map { PlayerID($0) }
            }
        }
        
        public class UpdateGameNotificationSettings: BaseRequest, APIKit.Request {
            
            var ids:[PlayerID]
            public var URLRequest: NSURLRequest? {
                let req = AppAPI.URLRequest(
                    method: .PUT,
                    path: "/user/me/game_notification",
                    parameters: ["ids":ids.map { $0.val } ]
                )
                buildRequestHeader(req) // TODO
                return req
            }
            
            public init(user: UserIdentifier, ids: [PlayerID]) {
                self.ids = ids
                super.init(user: user)
            }
            
            public class func responseFromObject(object: AnyObject) -> AnyObject? {
                return object
            }
        }
        
        public class FetchGameResults: BaseRequest, APIKit.Request {
            
            public enum Filter: String {
                case All = "all"
                case OnlyForNotification = "only_for_notification"
            }
            
            let count:Int
            let filter: Filter
            public var URLRequest: NSURLRequest? {
                let req = AppAPI.URLRequest(
                    method: .GET,
                    path: "/game/game_results",
                    parameters: ["count": count, "filter": filter.rawValue]
                )
                buildRequestHeader(req) // TODO
                return req
            }
            
            public init(user: UserIdentifier, filter: Filter = .All, count:Int = 5) {
                self.count = count
                self.filter = filter
                super.init(user: user)
            }
            
            public class func responseFromObject(object: AnyObject) -> [GameResult]? {
                return decodeArray(object)
            }
        }
        
        public class FetchPhotos: BaseRequest, APIKit.Request {
            
            var count:Int
            public var URLRequest: NSURLRequest? {
                let req = AppAPI.URLRequest(
                    method: .GET,
                    path: "/game/photos",
                    parameters: ["count": count]
                )
                buildRequestHeader(req) // TODO
                return req
            }
            
            public init(user: UserIdentifier, count:Int = 5) {
                self.count = count
                super.init(user: user)
            }
            
            public class func responseFromObject(object: AnyObject) -> [PhotoInfo]? {
                return decodeArray(object)
            }
        }
        
        public class FetchTwitterFeed: BaseRequest, APIKit.Request {
            
            var count:Int
            public var URLRequest: NSURLRequest? {
                let req = AppAPI.URLRequest(
                    method: .GET,
                    path: "/social_feed/twitter",
                    parameters: ["count": count]
                )
                buildRequestHeader(req) // TODO
                return req
            }
            
            public init(user: UserIdentifier, count:Int = 20) {
                self.count = count
                super.init(user: user)
            }
            
            public class func responseFromObject(object: AnyObject) -> [Twitter.Tweet]? {
                return object["statuses"].flatMap(decodeArray)
            }
        }
        
    }
}

