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
    public let id: Int
    public let title: String
    public let summary: String
    public let text: String?
//    public let publishedAt: NSDate
    
    public static func decode(e: Extractor) -> Notice? {
        let c = { Notice($0) }
        return build(
            e <| "id",
            e <| "title",
            e <| "summary",
            e <| "text"
            ).map(c)
    }
    
    public var description: String {
        return "id = \(id), \(title) \(summary)"
    }
    
}

public struct Player: Decodable, Printable {
    
    public let id: Int
    public let fullName: String
    public let shortName: String
    
    public static func decode(e: Extractor) -> Player? {
        let c = { Player($0) }
        return build(
            e <| "_id",
            e <| "name",
            e <| "short_name"
            ).map(c)
    }
    
    public var description: String {
        return "id = \(id), \(fullName)(\(shortName))"
    }
    
}

// DEMO
public struct Repository: Decodable, Printable {
    let id: Int
    let name: String
    //let owner: User
    
    public static func decode(e: Extractor) -> Repository? {
        let create = { Repository($0) }
        return build(
            e <| "id",
            e <| "name"
            //e <| "owner"
            ).map(create)
    }
    
    public var description: String {
        get {
            return "\(id)-\(name)"
        }
    }
}