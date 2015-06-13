//
//  Models.swift
//  ProconBase
//
//  Created by ito on 2015/06/13.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation
import Himotoki

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