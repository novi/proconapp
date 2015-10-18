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
    
    var gameResult: GameResult?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        gameResult = (context as! GameResultObject).result
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
        self.reloadContents()
    }
    
    override func reloadContents() {
        
        if let gr = self.gameResult {
            titleLabel.setText(gr.title)
            timeLabel.setText(gr.startedAt.relativeDateString)
            let ranks = gr.resultsByRank
            schoolTable.setNumberOfRows(ranks.count, withRowType: .ResultSchool)
            for i in 0..<ranks.count {
                let cell = schoolTable.rowControllerAtIndex(i) as! SchoolTableCell
                cell.result = ranks[i]
            }
        }
    }
}

class SchoolTableCell: NSObject {
    
    @IBOutlet weak var schoolLabel: WKInterfaceLabel!
    @IBOutlet weak var rankLabel: WKInterfaceLabel!
    @IBOutlet weak var scoreLabel: WKInterfaceLabel!
    @IBOutlet weak var unitLabel: WKInterfaceLabel!
    
    var result: GameResult.Result? {
        didSet {
            if let result = self.result {
                schoolLabel.setText(result.player.shortName)
                rankLabel.setText("\(result.rank)位")
                scoreLabel.setText(result.scoresShortString)
                unitLabel.setText(result.scoreUnit)
            }
        }
    }
    
}
