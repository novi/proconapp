//
//  GameResultListViewController.swift
//  ProconApp
//
//  Created by ito on 2015/07/25.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase
import APIKit

class GameResultListViewController: TableViewController {
    
    var allGameResult: [GameResult] = []
    
    override func fetchContents() {
        if let me = UserContext.defaultContext.me {
            let r = AppAPI.FetchGameResults(auth: me, count: 30)
            startContentsLoading()
            API.sendRequest(r) { res in
                self.endContentsLoading()
                switch res {
                case .Success(let results):
                    Logger.debug("\(results)" as String)
                    self.allGameResult = results
                    self.reloadContents()
                case .Failure(let error):
                    // TODO, error
                    Logger.error(error)
                }
            }
        }
    }
    
    override func reloadContents() {
        tableView.reloadData()
    }
    
    override var isNeedRefreshContents: Bool {
        return allGameResult.count == 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchContentsIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title = "競技結果"
        
        tableView.registerNib(.ResultHeaderNib, forHeaderFooterViewReuseIdentifier: .ResultHeaderView)
    }
    
    // MARK: Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row = 0
        if (allGameResult.count > 0) {
            row = allGameResult[section].results.count
        }
        
        return row
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return allGameResult.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.GameResultListCell, forIndexPath: indexPath) as! GameResultListCell
        cell.result = allGameResult[indexPath.section].resultsByRank[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier(.ResultHeaderView) as! ResultHeaderView
        cell.gameResult = allGameResult[section]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
}


class GameResultListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var result: GameResult.Result? {
        didSet {
            if let result = self.result {
                rankLabel.text = "\(result.rank)"
                if result.advance {
                    rankLabel.backgroundColor = UIColor.advanceRankBackgroundColor
                } else {
                    rankLabel.backgroundColor = UIColor.normalRankBackgroundColor
                }
                
                titleLabel.text = result.player.shortName
                
                
                let str: String = result.scores.enumerate().map({ (i,s) -> String in
                    let noScore = "×"
                    return "問\(Int(i+1)):\(s.flatMap { String($0) } ?? noScore)"
                }).joinWithSeparator(",")
                scoreLabel.text = "\(str) (\(result.scoreUnit))"
            }
        }
    }
}

class ResultHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    var gameResult: GameResult? {
        didSet {
            titleLabel.text = gameResult?.title
            if let result = self.gameResult {
                let started = "開始: \(result.startedAt.timeString)"
                let finished = (result.finishedAt == nil) ? "(試合中)" : "終了: \(result.finishedAt!.timeString)"
                timeLabel.text = "\(started) - \(finished)"
            }
        }
    }
    
}