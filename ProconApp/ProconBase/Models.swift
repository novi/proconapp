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
        public let score: Float
        public let rank: Int
        public let player: Player
        
        public static func decode(e: Extractor) -> Result? {
            let c = { Result($0) }
            return build(
                e <| "score",
                e <| "rank",
                e <| "player"
                ).map(c)
        }
        
        public var description: String {
            return "score:\(score) \(player)"
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
    
    public var isInGame: Bool {
        return status == 1
    }
    
    public var resultsByScore: [Result] {
        return results.sorted { $1.score > $0.score }
    }
    
    public var resultsByRank: [Result] {
        return results.sorted { $1.rank > $0.rank }
    }
    
}
