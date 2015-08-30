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

    @IBOutlet weak var sectionTitleLabel: WKInterfaceLabel!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var schoolTable: WKInterfaceTable!
    
    @IBOutlet weak var noResultLabel: WKInterfaceLabel!
    
    var gameResults: [GameResult] = []
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
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
            let r = AppAPI.Endpoint.FetchGameResults(user: me, filter: .OnlyForNotification, count: 1)
            AppAPI.sendRequest(r) { res in
                switch res {
                case .Success(let box):
                    Logger.debug("\(box.value)")
                    self.gameResults = box.value
                    self.noResultLabel.setHidden(self.gameResults.count != 0)
                    self.createGameData()
                    self.createTableData()
                case .Failure(let box):
                    // TODO, error
                    Logger.error(box.value)
                }
            }
        }
    }
    func createGameData() {
        if let gameResult = gameResults.first {
            titleLabel.setText(gameResult.title)
        }
        
    }
    func createTableData() {
        if let results = gameResults.first?.resultsByRank {
            let count = min(results.count, 3)
            schoolTable.setNumberOfRows(count, withRowType: .GlanceSchool)
            
            for i in 0..<count {
                let cell = schoolTable.rowControllerAtIndex(i) as! SchoolTableCell
                cell.result = results[i]
            }
        }
    }

}
