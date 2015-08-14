//
//  GlanceController.swift
//  ProconApp WatchKit Extension
//
//  Created by ito on 2015/07/29.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import WatchKit
import Foundation
import ProconBase


class GlanceController: InterfaceController {

    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var schoolTable: WKInterfaceTable!
    
    var gameResults: [GameResult] = []
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        fetchContents()
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
        let gameResult = gameResults.first
        titleLabel.setText(gameResult!.title)
    }
    func createTableData() {
        let results = gameResults.first!.resultsByRank
        schoolTable.setNumberOfRows(results.count, withRowType: "GlanceSchoolTableCell")
        
        for i in 0..<results.count {
            println(schoolTable.rowControllerAtIndex(i))
            var schoolCell = schoolTable.rowControllerAtIndex(i) as! SchoolTableCell
            schoolCell.result = results[i]
        }
    }

}
