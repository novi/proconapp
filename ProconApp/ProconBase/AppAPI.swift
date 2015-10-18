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

public protocol AppAPIRequest: Request {
    var auth: UserIdentifier { get }
}

extension AppAPIRequest {
    public var baseURL: NSURL {
        return NSURL(string: Constants.APIBaseURL)!
    }
    
    public func configureURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        if (auth.token as NSString).length > 0 {
            URLRequest.setValue(auth.token, forHTTPHeaderField: "X-User-Token")
        }
        
        URLRequest.timeoutInterval = 15
        return URLRequest
    }
}

public struct AppAPI {

}

extension AppAPI {
    public struct CreateNewUser: AppAPIRequest {
    
        public typealias Response = User
        
        struct DummyIdentifier: UserIdentifier {
            let id: Int
            let token: String
        }
        
        public let auth: UserIdentifier
        public init() {
            self.auth = DummyIdentifier(id: 0, token: "")
        }
        
        public var method: HTTPMethod {
            return .POST
        }

        public var path: String {
            return "/auth/new_user"
        }

        public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
            return try? decode(object)
        }
    }
    
    public struct FetchUserInfo: AppAPIRequest {
        
        public typealias Response = User
        
        public let auth: UserIdentifier
        public init(auth: UserIdentifier) {
            self.auth = auth
        }
        
        public var method: HTTPMethod {
            return .GET
        }
        
        public var path: String {
            return "/user/me/info"
        }
        
        public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
            return try? decode(object)
        }
        
    }
    
    public struct UpdatePushToken: AppAPIRequest {
        
        public typealias Response = AnyObject
        
        public let auth: UserIdentifier
        let deviceToken: String
        public init(auth: UserIdentifier, deviceToken: String) {
            self.auth = auth
            self.deviceToken = deviceToken
        }
        
        public var method: HTTPMethod {
            return .PUT
        }
        
        public var parameters: [String:AnyObject] {
            return [
                "device_type": "ios",
                "device_token": deviceToken
            ]
        }
        
        public var path: String {
            return "/user/me/push_token"
        }
        
        public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
            return object
        }
    }
    
    public struct FetchNotices: AppAPIRequest {
        
        public typealias Response = [Notice]
        
        public let auth: UserIdentifier
        let page: Int
        let count: Int
        public init(auth: UserIdentifier, page: Int = 0, count: Int = 3) {
            self.page = page
            self.count = count
            self.auth = auth
        }
        
        public var method: HTTPMethod {
            return .GET
        }
        
        public var parameters: [String:AnyObject] {
            return ["page": page, "count":count]
        }
        
        public var path: String {
            return "/notices/list"
        }
        
        public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
            return try? decodeArray(object)
        }
    }
    
    public struct FetchNoticeText: AppAPIRequest {
        
        public typealias Response = Notice
        
        public let auth: UserIdentifier
        let notice: Notice
        public init(auth: UserIdentifier, notice: Notice) {
            self.notice = notice
            self.auth = auth
        }
        
        public var method: HTTPMethod {
            return .GET
        }
        
        public var parameters: [String:AnyObject] {
            return ["id": notice.id.val]
        }
        
        public var path: String {
            return "/notices/info"
        }
        
        public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
            return try? decode(object)
        }
    }
    
    public struct FetchAllPlayers: AppAPIRequest {
        
        public typealias Response = [Player]
        
        public let auth: UserIdentifier
        public init(auth: UserIdentifier) {
            self.auth = auth
        }
        
        public var method: HTTPMethod {
            return .GET
        }

        
        public var path: String {
            return "/players"
        }
        
        public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
            return try? decodeArray(object)
        }
    }
    
    public struct FetchGameNotificationSettings: AppAPIRequest {
        
        public typealias Response = [PlayerID]
        
        public let auth: UserIdentifier
        public init(auth: UserIdentifier) {
            self.auth = auth
        }
        
        public var method: HTTPMethod {
            return .GET
        }
        
        
        public var path: String {
            return "/user/me/game_notification"
        }
        
        public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
            return try? ((object["ids"] as? [Int]) ?? []).map { try PlayerID($0) }
        }
    }
    
    
    public struct UpdateGameNotificationSettings: AppAPIRequest {
        
        public typealias Response = AnyObject
        
        public let auth: UserIdentifier
        let ids:[PlayerID]
        public init(auth: UserIdentifier, ids: [PlayerID]) {
            self.ids = ids
            self.auth = auth
        }
        
        public var method: HTTPMethod {
            return .PUT
        }
        
        public var parameters: [String:AnyObject] {
            return ["ids":ids.map { $0.val } ]
        }
        
        public var path: String {
            return "/user/me/game_notification"
        }
        
        public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
            return object
        }
    }
    
    public struct FetchGameResults: AppAPIRequest {
        
        public enum Filter: String {
            case All = "all"
            case OnlyForNotification = "only_for_notification"
        }
        
        public typealias Response = [GameResult]
        
        public let auth: UserIdentifier
        let count:Int
        let filter: Filter
        public init(auth: UserIdentifier, filter: Filter = .All, count:Int = 5) {
            self.count = count
            self.filter = filter
            self.auth = auth
        }
        
        public var method: HTTPMethod {
            return .GET
        }
        
        public var parameters: [String:AnyObject] {
            return ["count": count, "filter": filter.rawValue]
        }
        
        public var path: String {
            return "/game/game_results"
        }
        
        public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
            return try? decodeArray(object)
        }
    }
    
    public struct FetchPhotos: AppAPIRequest {
        
        public typealias Response = [PhotoInfo]
        
        public let auth: UserIdentifier
        let count:Int
        public init(auth: UserIdentifier, count:Int = 5) {
            self.count = count
            self.auth = auth
        }
        
        public var method: HTTPMethod {
            return .GET
        }
        
        public var parameters: [String:AnyObject] {
            return ["count": count]
        }
        
        public var path: String {
            return "/game/photos"
        }
        
        public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
            return try? decodeArray(object)
        }
    }
    
    public struct FetchTwitterFeed: AppAPIRequest {
        
        public typealias Response = [Twitter.Tweet]
        
        public let auth: UserIdentifier
        let count:Int
        public init(auth: UserIdentifier, count:Int = 20) {
            self.count = count
            self.auth = auth
        }
        
        public var method: HTTPMethod {
            return .GET
        }
        
        public var parameters: [String:AnyObject] {
            return ["count": count]
        }
        
        public var path: String {
            return "/social_feed/twitter"
        }
        
        public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
            guard let statuses = object["statuses"] as? NSArray else {
                return nil
            }
            return try? decodeArray(statuses)
        }
    }
}


