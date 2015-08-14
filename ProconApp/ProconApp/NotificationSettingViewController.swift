//
//  NotificationSettingViewController.swift
//  ProconApp
//
//  Created by ito on 2015/07/11.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase

class NotificationSettingViewController: TableViewController {
    
    class Switch: UISwitch {
        let player: Player
        init(player: Player) {
            self.player = player
            super.init(frame: CGRectZero)
            sizeToFit()
        }

        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    var players: [Player] = []
    
    var settings: [PlayerID:Bool] = [:]
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let me = UserContext.defaultContext.me {
            startContentsLoading()
            let r = AppAPI.Endpoint.FetchAllPlayers(user: me)
            AppAPI.sendRequest(r) { res in
                switch res {
                case .Success(let box):
                    println(box.value)
                    self.players = box.value
                    
                    self.settings.removeAll(keepCapacity: true)
                    
                    let r = AppAPI.Endpoint.FetchGameNotificationSettings(user: me)
                    AppAPI.sendRequest(r) { res in
                        switch res {
                        case .Success(let box):
                            println("current game settings", box.value)
                            for p in self.players {
                                if box.value.count == 0 {
                                    self.settings[p.id] = true // 一つも設定されていない時はオールオン
                                } else {
                                    self.settings[p.id] = false
                                }
                            }
                            for id in box.value {
                                self.settings[id] = true
                            }
                            self.reloadContents()
                        case .Failure(let box):
                            // TODO, error
                            println(box.value)
                        }
                        
                        self.endContentsLoading()
                    }
                    
                    self.reloadContents()
                case .Failure(let box):
                    // TODO, error
                    self.endContentsLoading()
                    println(box.value)
                }
            }
        }
        
        
        
    }
    
    // MARK: Contents Loading
    
    override func reloadContents() {
        tableView.reloadData()
    }
    
    // MARK:

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.NotificationSettingCell, forIndexPath: indexPath) as! UITableViewCell
        
        let player = players[indexPath.row]
        
        cell.textLabel?.text = "\(player.fullName) (\(player.shortName))"
        
        let sw = Switch(player: player)
        sw.addTarget(self, action: "switchChanged:", forControlEvents: .ValueChanged)
        sw.on = self.settings[player.id] ?? true
        sw.enabled = settings[player.id] != nil ? true: false
        
        cell.accessoryView = sw
        
        return cell
    }
    
    // MARK: Switch
    func switchChanged(sw: Switch) {
        self.settings[sw.player.id] = sw.on
    }
    
    @IBAction func doneTapped(sender: UIBarButtonItem?) {
        
        if isContentsLoading {
            return
        }
        
        sender?.enabled = false
        
        if let me = UserContext.defaultContext.me {
            var enableIds:[PlayerID] = []
            for (id, enabled) in settings {
                if enabled {
                    enableIds.append(id)
                }
            }
            let r = AppAPI.Endpoint.UpdateGameNotificationSettings(user: me, ids: enableIds)
            AppAPI.sendRequest(r) { res in
                switch res {
                case .Success(let box):
                    self.performSegueWithIdentifier(.UnwindNotificationSetting, sender: self)
                case .Failure(let box):
                    let alert = UIAlertController(title: "設定できませんでした", message: nil
                        , preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "設定をキャンセル", style: .Cancel, handler: { (_) -> Void in
                        self.performSegueWithIdentifier(.UnwindNotificationSetting, sender: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "再実行", style: .Default, handler: { (_) -> Void in
                        self.doneTapped(nil)
                    }))
                }
            }
        } else {
            // error
            
        }
    }
    
}
