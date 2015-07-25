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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchContents()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title = "競技結果"
    }
    
    // MARK: Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGameResult.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.GameResultListCell, forIndexPath: indexPath) as! GameResultListCell
        cell.gameResult = allGameResult[indexPath.row]
        return cell
    }
    
}


class GameResultListCell: UITableViewCell {
    
    @IBOutlet weak var gameNameLabel: UILabel!
    
    
    var gameResult: GameResult? {
        didSet {
            println(gameResult)
            gameNameLabel.text = gameResult?.title
        }
    }
}