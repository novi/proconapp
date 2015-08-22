//
//  GameResultListViewController.swift
//  ProconApp
//
//  Created by ito on 2015/07/25.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase

class GameResultListViewController: TableViewController {
    
    var allGameResult: [GameResult] = []
    
    override func fetchContents() {
        if let me = UserContext.defaultContext.me {
            let r = AppAPI.Endpoint.FetchGameResults(user: me, count: 30)
            startContentsLoading()
            AppAPI.sendRequest(r) { res in
                self.endContentsLoading()
                switch res {
                case .Success(let box):
                    println(box.value)
                    self.allGameResult = box.value
                    self.reloadContents()
                case .Failure(let box):
                    // TODO, error
                    println(box.value)
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
                titleLabel.text = result.player.fullName
                rankLabel.text = "\(result.rank)"
                scoreLabel.text = "\(Int(result.score))\(result.scoreUnit)"
            }
        }
    }
}

class ResultHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var gameResult: GameResult? {
        didSet {
            titleLabel.text = gameResult?.title
            if let result = self.gameResult {
                var started = "開始: \(result.startedAt.timeString)"
                var finished = (result.finishedAt == nil || result.isInGame ) ? "(試合中)" : "終了: \(result.finishedAt!.timeString)"
                timeLabel.text = "\(started) - \(finished)"
            }
        }
    }
    
}