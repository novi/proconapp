//
//  ResultInterfaceController.swift
//  ProconApp
//
//  Created by hanamiju on 2015/08/13.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import WatchKit
import Foundation
import ProconBase

class ResultInterfaceController: InterfaceController {
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var schoolTable: WKInterfaceTable!
    
    var gameResults: [GameResult] = []
    var gameResultIndex: Int?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let index = context as? Int {
            gameResultIndex = index
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        fetchContents()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func fetchContents() {
        if let me = UserContext.defaultContext.me {
            let r = AppAPI.Endpoint.FetchGameResults(user: me, count: 3)
            AppAPI.sendRequest(r) { res in
                switch res {
                case .Success(let box):
                    println(box.value)
                    self.gameResults = box.value
                    self.createGameData()
                    self.createTableData()
                case .Failure(let box):
                    // TODO, error
                    println(box.value)
                }
            }
        }
    }
    func createGameData() {
        let gameResult = gameResults[gameResultIndex!]
        titleLabel.setText(gameResult.title)
        timeLabel.setText(gameResult.startedAt.relativeDateString)
    }
    func createTableData() {
        let results = gameResults[gameResultIndex!].resultsByRank
        schoolTable.setNumberOfRows(results.count, withRowType: "SchoolTableCell")
        
        for i in 0..<results.count {
            var schoolCell = schoolTable.rowControllerAtIndex(i) as! SchoolTableCell
            schoolCell.result = results[i]
        }
    }
}

class SchoolTableCell: NSObject {
    
    @IBOutlet weak var schoolLabel: WKInterfaceLabel!
    @IBOutlet weak var rankLabel: WKInterfaceLabel!
    @IBOutlet weak var scoreLabel: WKInterfaceLabel!
    
    var result: GameResult.Result? {
        didSet {
            if let result = self.result {
                schoolLabel.setText(result.player.shortName)
                rankLabel.setText("\(result.rank)位")
                scoreLabel.setText("\(Int(result.score))\(result.scoreUnit)")
            }
        }
    }
    
}
