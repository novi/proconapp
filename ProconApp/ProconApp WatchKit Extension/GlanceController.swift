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
import APIKit


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
            let r = AppAPI.FetchGameResults(auth: me, filter: .OnlyForNotification, count: 1)
            API.sendRequest(r) { res in
                switch res {
                case .Success(let results):
                    Logger.debug("\(results)")
                    self.gameResults = results
                    self.noResultLabel.setHidden(self.gameResults.count != 0)
                    self.noResultLabel.setText("設定した学校の競技結果はまだありません")
                    self.createGameData()
                    self.createTableData()
                case .Failure(let error):
                    // TODO, error
                    Logger.error(error)
                }
            }
        } else {
            self.noResultLabel.setHidden(false)
            self.noResultLabel.setText(MainInterfaceController.noLoginMessage)
            let delay = 2 * Double(NSEC_PER_SEC)
            let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                self.fetchContents()
            })
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
