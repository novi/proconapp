//
//  Models.swift
//  ProconBase
//
//  Created by ito on 2015/06/13.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation
import Himotoki

public struct User: Decodable, CustomStringConvertible, UserIdentifier {
    public let id: Int
    public let token: String
    //let twitterID: String
    //let facebookID: String
    
    
    public static func decode(e: Extractor) throws -> User {
        return try build(User.init)(
            e <| "user_id",
            e <| "user_token"
        )
    }
    
    public var description: String {
        return "user id = \(id)"
    }
}

public struct Notice: Decodable, CustomStringConvertible {
    public let id: NoticeID
    public let title: String
    public let body: String?
    public let publishedAt: NSDate
    
    let bodySize: Int
    
    public static func decode(e: Extractor) throws -> Notice {
        return try build(Notice.init)(
            NoticeID(e <| "id"),
            e <| "title",
            e <|? "body",
            NSDate(timeIntervalSince1970: (e <| "published_at")),
            e <| "body_size"
            )
    }
    
    public var description: String {
        return "id = \(id), \(title) at \(publishedAt)"
    }
    
    public var hasBody: Bool {
        return bodySize > 0
    }
    
}

public struct Player: Decodable, CustomStringConvertible {
    
    public let id: PlayerID
    public let fullName: String
    public let shortName: String
    
    public static func decode(e: Extractor) throws -> Player {
        return try build(Player.init)(
            PlayerID(e <| "id"),
            e <| "name",
            e <| "short_name"
            )
    }
    
    public var description: String {
        return "id = \(id), \(fullName)(\(shortName))"
    }
    
}

public struct GameResult: Decodable, CustomStringConvertible {
    
    public struct Result: Decodable, CustomStringConvertible {
        let scores_: [Int]
        public let rank: Int
        public let player: Player
        public let scoreUnit: String
        public let advance: Bool
        
        public static func decode(e: Extractor) throws -> Result {
            return try build(Result.init)(
                (e <|| "scores"),
                e <| "rank",
                e <| "player",
                ((e <|? "score_unit") ?? "zk" ),
                e <| "advance"
                )
        }
        
        public var description: String {
            return "score:\(scores) \(player)"
        }
        public var scores: [Int?] {
            return scores_.map { $0 < 0 ? nil : $0 }
        }
        public var scoresShortString: String {
            return scores.map({ $0.flatMap({ String($0) }) ?? "-" }).joinWithSeparator("," )
        }
    }
    
    public let id: GameResultID
    public let title: String
    public let startedAt: NSDate
    public let finishedAt: NSDate?
    public var results: [Result]
    
    let status: Int
    
    public static func decode(e: Extractor) throws -> GameResult {
        return try build(GameResult.init)(
            GameResultID(e <| "id"),
            e <| "title",
            NSDate(timeIntervalSince1970: (e <| "started_at")),
            (e <|? "finished_at").flatMap { NSDate(timeIntervalSince1970: $0) },
            (e <|| "result"),
            e <| "status"
            )
    }
    
    public var description: String {
        return "id = \(id), \(status):\(title) \(startedAt) - \(finishedAt), result count = \(results.count)"
    }
    
    public var resultsByRank: [Result] {
        return results.sort { $1.rank > $0.rank }
    }
    
}

public struct PhotoInfo: Decodable, CustomStringConvertible {
    
    let id: Int
    public let title: String
    public let thumbnailURL: NSURL
    public let originalURL: NSURL
    public let createdAt: NSDate
    
    public static func decode(e: Extractor) throws -> PhotoInfo {
        return try build(PhotoInfo.init)(
            e <| "id",
            e <| "title",
            NSURL(string: (e <| "thumbnail_url"))!,
            NSURL(string: (e <| "original_url"))!,
             NSDate(timeIntervalSince1970: (e <| "created_at"))
            )
    }
    
    public var description: String {
        return "id = \(id), \(title), \(originalURL)"
    }
    
}

public struct Twitter {
    
    public struct User: Decodable, CustomStringConvertible {
        
        let idStr: String
        public let screenName: String
        public let userName: String
        public let profileImageURL: NSURL
        
        public static func decode(e: Extractor) throws -> User {
            return try build(User.init)(
                e <| "id_str",
                e <| "screen_name",
                e <| "name",
                NSURL.fromJSON( (e <| "profile_image_url_https") as String)
                )
        }
        
        public var description: String {
            return "id = \(idStr), @\(screenName), \(userName)"
        }
        
    }
    
    public struct Tweet: Decodable, CustomStringConvertible {
        
        let idStr: String
        public let text: String
        public let user: User
        public let createdAt: NSDate
        
        public static func decode(e: Extractor) throws -> Tweet {
            return try build(Tweet.init)(
                e <| "id_str",
                e <| "text",
                e <| "user",
                Twitter.dateFormatter.dateFromString((e <| "created_at")) ?? NSDate()
                )
        }
        
        public var description: String {
            return "id = \(idStr), \(text), by @\(user.screenName)"
        }
    }
}

