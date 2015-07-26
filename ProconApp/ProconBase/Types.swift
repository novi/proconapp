//
//  Types.swift
//  ProconApp
//
//  Created by ito on 2015/07/11.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import Foundation

// TODO: use protocol extenstion

public struct PlayerID: Printable {
    let id: Int
    init(_ id: Int) {
        self.id = id
    }
    public var description: String {
        return "id:\(id)"
    }
    var val: Int {
        return id
    }
}

extension PlayerID: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
}

extension PlayerID: Equatable {
    
}

public func ==(lhs: PlayerID, rhs: PlayerID) -> Bool {
    return lhs.val == rhs.val
}

public struct NoticeID: Printable {
    let id: Int
    init(_ id: Int) {
        self.id = id
    }
    public var description: String {
        return "id:\(id)"
    }
    var val: Int {
        return id
    }
}

public struct GameResultID: Printable {
    let id: Int
    init(_ id: Int) {
        self.id = id
    }
    public var description: String {
        return "id:\(id)"
    }
    var val: Int {
        return id
    }
}