//
//  Models.swift
//  ProconBase
//
//  Created by ito on 2015/06/13.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation
import Himotoki


// TODO: id type struct

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
    public let id: Int
    public let title: String
    public let summary: String // TODO: 廃止?
    public let body: String?
    public let publishedAt: NSDate
    
    public static func decode(e: Extractor) -> Notice? {
        let c = { Notice($0) }
        return build(
            e <| "id",
            e <| "title",
            e <| "summary",
            e <| "text", // TODO: bodyに変更
            (e <| "published_at").flatMap { NSDate(timeIntervalSince1970: $0) }
            ).map(c)
    }
    
    public var description: String {
        return "id = \(id), \(title) \(summary) at \(publishedAt)"
    }
    
    public var hasBody: Bool {
        return true // TODO
    }
    
}

public struct Player: Decodable, Printable {
    
    public let id: Int
    public let fullName: String
    public let shortName: String
    
    public static func decode(e: Extractor) -> Player? {
        let c = { Player($0) }
        return build(
            (e <| "id" ?? e <| "_id"),
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
        public let player: Player
        
        // TODO: Rank
        
        public static func decode(e: Extractor) -> Result? {
            let c = { Result($0) }
            return build(
                e <| "score",
                e <| "player"
                ).map(c)
        }
        
        public var description: String {
            return "score:\(score) \(player)"
        }
    }
    
    public let id: Int
    public let title: String
    public let startedAt: NSDate
    public let finishedAt: NSDate?
    public var results: [Result]
    
    // TODO: Status
    
    public static func decode(e: Extractor) -> GameResult? {
        let c = { GameResult($0) }
        return build(
            e <| "id",
            e <| "title",
            (e <| "started_at").flatMap { NSDate(timeIntervalSince1970: $0) },
            (e <| "finished_at").flatMap { NSDate(timeIntervalSince1970: $0) },
            (e <|| "result").flatMap { $0 }
            ).map(c)
    }
    
    public var description: String {
        return "id = \(id), \(title) \(startedAt) - \(finishedAt), result count = \(results.count)"
    }
    
    public var isInGame: Bool {
        return false // TODO
    }
    
    public var resultsByScore: [Result] {
        return results.sorted({ (a: Result, b: Result) -> Bool in
            return b.score - a.score > 0
        })
    }
    
    public var resultsByRank: [Result] {
        return results.sorted({ (a: Result, b: Result) -> Bool in
            return true //TODO
        })
    }
    
}
