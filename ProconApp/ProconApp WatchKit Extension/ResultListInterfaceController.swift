//
//  ResultListInterfaceController.swift
//  ProconApp
//
//  Created by hanamiju on 2015/08/13.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import WatchKit
import Foundation
import ProconBase

class ResultListInterfaceController: InterfaceController {

    @IBOutlet weak var resultTable: WKInterfaceTable!
    
    var gameResults: [GameResult] = []
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        fetchContents()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func fetchContents() {
        if let me = UserContext.defaultContext.me {
            let rr = AppAPI.Endpoint.FetchGameResults(user: me, filter: .OnlyForNotification, count: 10)
            AppAPI.sendRequest(rr) { res in
                switch res {
                case .Success(let box):
                    Logger.debug("\(box.value)")
                    self.gameResults = box.value
                    self.reloadContents()
                case .Failure(let box):
                    // TODO, error
                    Logger.error("\(box.value)")
                }
            }
        }
    }
    
    override func reloadContents() {
        resultTable.setNumberOfRows(gameResults.count, withRowType: .Result)
        
        for i in 0..<gameResults.count {
            var cell = resultTable.rowControllerAtIndex(i) as! ResultTableCell
            //Logger.debug(gameResults[i])
            cell.gameResult = gameResults[i]
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let result = gameResults[rowIndex]
        self.pushControllerWithName(.Result, context: GameResultObject(result))
    }
    
}

class ResultTableCell: NSObject {
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    
    var gameResult: GameResult? {
        didSet {
            if let gameResult = gameResult {
                titleLabel.setText(gameResult.title)
                timeLabel.setText(gameResult.startedAt.relativeDateString)
            }
        }
    }
    
}
