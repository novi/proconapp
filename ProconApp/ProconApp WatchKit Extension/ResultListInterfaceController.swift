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
        // Configure interface objects here.
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
                    println(box.value)
                    self.gameResults = box.value
                    self.createTableData()
                case .Failure(let box):
                    // TODO, error
                    println(box.value)
                }
            }
        }
    }
    
    func createTableData() {
        resultTable.setNumberOfRows(gameResults.count, withRowType: "ResultTableCell")
        
        for i in 0..<gameResults.count {
            var resultCell = resultTable.rowControllerAtIndex(i) as! ResultTableCell
            println(gameResults[i])
            resultCell.gameResult = gameResults[i]
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        self.pushControllerWithName("ResultInterfaceController", context: rowIndex)
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
