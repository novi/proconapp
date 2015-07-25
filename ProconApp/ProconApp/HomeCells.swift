//
//  HomeCells.swift
//  ProconApp
//
//  Created by ito on 2015/07/25.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase



class GameResultCell: UITableViewCell {
    var result: GameResult?
}

class GameResultScoreCell: GameResultCell {
    
    @IBOutlet var scores: [UILabel]!
    @IBOutlet var playerNames: [UILabel]!
    
    override var result: GameResult? {
        didSet {
            if let results = result?.resultsByScore {
                for i in 0..<scores.count {
                    if i<results.count {
                        scores[i].text = "\(results[i].score)"
                        playerNames[i].text = results[i].player.shortName
                    } else {
                        scores[i].text = nil
                        playerNames[i].text = nil
                    }
                }
            }
        }
    }
}

class GameResultRankCell: GameResultCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var playerNames: [UILabel]!
    
    override var result: GameResult? {
        didSet {
            if let result = result {
                dateLabel.text = result.startedAt.relativeDateString
                let results = result.resultsByRank
                for i in 0..<playerNames.count {
                    if i<results.count {
                        playerNames[i].text = results[i].player.shortName
                    } else {
                        playerNames[i].text = nil
                    }
                }
            }
        }
    }
}
