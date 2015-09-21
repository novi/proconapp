//
//  Models.swift
//  ProconBase
//
//  Created by ito on 2015/06/13.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation
import Himotoki

public struct User: Decodable, Printable, UserIdentifier {
    public let id: Int
    public let token: String
    //let twitterID: String
    //let facebookID: String
    
    
    public static func decode(e: Extractor) -> User? {
        let c = { User($0) }
        return build(
            e <| "user_id",
            e <| "user_token"
        ).map(c)
    }
    
    public var description: String {
        return "user id = \(id)"
    }
}

public struct Notice: Decodable, Printable {
    public let id: NoticeID
    public let title: String
    public let body: String?
    public let publishedAt: NSDate
    
    let bodySize: Int
    
    public static func decode(e: Extractor) -> Notice? {
        let c = { Notice($0) }
        return build(
            (e <| "id").flatMap { NoticeID($0) },
            e <| "title",
            e <| "body",
            (e <| "published_at").flatMap { NSDate(timeIntervalSince1970: $0) },
            e <| "body_size"
            ).map(c)
    }
    
    public var description: String {
        return "id = \(id), \(title) at \(publishedAt)"
    }
    
    public var hasBody: Bool {
        return bodySize > 0
    }
    
}

public struct Player: Decodable, Printable {
    
    public let id: PlayerID
    public let fullName: String
    public let shortName: String
    
    public static func decode(e: Extractor) -> Player? {
        let c = { Player($0) }
        return build(
            (e <| "id").flatMap { PlayerID($0) },
            e <| "name",
            e <| "short_name"
            ).map(c)
    }
    
    public var description: String {
        return "id = \(id), \(fullName)(\(shortName))"
    }
    
}

public struct GameResult: Decodable, Printable {
    
    public struct Result: Decodable, Printable {
        let scores_: [Int]
        public let rank: Int
        public let player: Player
        public let scoreUnit: String
        public let advance: Bool
        
        public static func decode(e: Extractor) -> Result? {
            let c = { Result($0) }
            return build(
                (e <|| "scores"),
                e <| "rank",
                e <| "player",
                (e <|? "score_unit").map { $0 ?? "zk" }, // TODO
                e <| "advance"
                ).map(c)
        }
        
        public var description: String {
            return "score:\(scores) \(player)"
        }
        public var scores: [Int?] {
            return scores_.map { $0 < 0 ? nil : $0 }
        }
        public var scoresShortString: String {
            return join(",", scores.map({ $0.flatMap({ String($0) }) ?? "-" }) )
        }
    }
    
    public let id: GameResultID
    public let title: String
    public let startedAt: NSDate
    public let finishedAt: NSDate?
    public var results: [Result]
    
    let status: Int
    
    public static func decode(e: Extractor) -> GameResult? {
        let c = { GameResult($0) }
        return build(
            (e <| "id").flatMap { GameResultID($0) },
            e <| "title",
            (e <| "started_at").flatMap { NSDate(timeIntervalSince1970: $0) },
            (e <| "finished_at").flatMap { NSDate(timeIntervalSince1970: $0) },
            (e <|| "result").flatMap { $0 },
            e <| "status"
            ).map(c)
    }
    
    public var description: String {
        return "id = \(id), \(status):\(title) \(startedAt) - \(finishedAt), result count = \(results.count)"
    }
    
    public var resultsByRank: [Result] {
        return results.sorted { $1.rank > $0.rank }
    }
    
}

public struct PhotoInfo: Decodable, Printable {
    
    let id: Int
    public let title: String
    public let thumbnailURL: NSURL
    public let originalURL: NSURL
    public let createdAt: NSDate
    
    public static func decode(e: Extractor) -> PhotoInfo? {
        let c = { PhotoInfo($0) }
        return build(
            e <| "id",
            e <| "title",
            (e <| "thumbnail_url").flatMap { NSURL(string: $0)! },
            (e <| "original_url").flatMap { NSURL(string: $0)! },
            (e <| "created_at").flatMap { NSDate(timeIntervalSince1970: $0) }
            ).map(c)
    }
    
    public var description: String {
        return "id = \(id), \(title), \(originalURL)"
    }
    
}

public struct Twitter {
    
    public struct User: Decodable, Printable {
        
        let idStr: String
        public let screenName: String
        public let userName: String
        public let profileImageURL: NSURL
        
        public static func decode(e: Extractor) -> User? {
            let c = { User($0) }
            return build(
                e <| "id_str",
                e <| "screen_name",
                e <| "name",
                (e <| "profile_image_url_https").flatMap { NSURL(string: $0)! }
                ).map(c)
        }
        
        public var description: String {
            return "id = \(idStr), @\(screenName), \(userName)"
        }
        
    }
    
    public struct Tweet: Decodable, Printable {
        
        let idStr: String
        public let text: String
        public let user: User
        public let createdAt: NSDate
        
        public static func decode(e: Extractor) -> Tweet? {
            let c = { Tweet($0) }
            return build(
                e <| "id_str",
                e <| "text",
                e <| "user",
                (e <| "created_at").flatMap{ Twitter.dateFormatter.dateFromString($0) ?? NSDate() }
                ).map(c)
        }
        
        public var description: String {
            return "id = \(idStr), \(text), by @\(user.screenName)"
        }
    }
}

