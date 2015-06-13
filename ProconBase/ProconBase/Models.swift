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
        get {
            return "user id = \(id)"
        }
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