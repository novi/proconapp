//
//  NotificationSettingViewController.swift
//  ProconApp
//
//  Created by ito on 2015/07/11.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase
import APIKit

class NotificationSettingViewController: TableViewController {
    
    class Switch: UISwitch {
        let player: Player
        init(player: Player) {
            self.player = player
            super.init(frame: CGRectZero)
            sizeToFit()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    var players: [Player] = []
    
    var settings: [PlayerID:Bool] = [:]
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let me = UserContext.defaultContext.me {
            startContentsLoading()
            let r = AppAPI.FetchAllPlayers(auth: me)
            API.sendRequest(r) { res in
                switch res {
                case .Success(let players):
                    Logger.debug("\(players)" as String)
                    self.players = players
                    
                    self.settings.removeAll(keepCapacity: true)
                    
                    let r = AppAPI.FetchGameNotificationSettings(auth: me)
                    API.sendRequest(r) { res in
                        switch res {
                        case .Success(let setting):
                            Logger.debug("current game settings: \(setting)")
                            for p in self.players {
                                if setting.count == 0 {
                                    self.settings[p.id] = true // 一つも設定されていない時はオールオン
                                } else {
                                    self.settings[p.id] = false
                                }
                            }
                            for id in setting {
                                self.settings[id] = true
                            }
                            self.reloadContents()
                        case .Failure(let error):
                            // TODO, error
                            Logger.error(error)
                        }
                        
                        self.endContentsLoading()
                    }
                    
                    self.reloadContents()
                case .Failure(let error):
                    // TODO, error
                    self.endContentsLoading()
                    Logger.error(error)
                }
            }
        }
        
        
        
    }
    
    // MARK: Contents Loading
    
    override func reloadContents() {
        tableView.reloadData()
    }
    
    // MARK: Table View

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "選択した学校の競技結果を通知します。\nまた、Apple Watch使用時に優先的に表示します。"
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(12)
        label.numberOfLines = 2
        label.textAlignment = .Center
        label.sizeToFit()
        return label
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
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
            self.startContentsLoading()
            let r = AppAPI.UpdateGameNotificationSettings(auth: me, ids: enableIds)
            API.sendRequest(r) { res in
                self.endContentsLoading()
                switch res {
                case .Success(_):
                    // Done
                    LocalSetting.sharedInstance.shouldShowNotificationSettings = false
                    
                    UIApplication.sharedApplication().activatePushNotification()
                    
                    self.performSegueWithIdentifier(.UnwindNotificationSetting, sender: self)
                case .Failure(let error):
                    Logger.error(error)
                    let alert = UIAlertController(title: "設定できませんでした", message: nil
                        , preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "設定をキャンセル", style: .Cancel, handler: { (_) -> Void in
                        self.performSegueWithIdentifier(.UnwindNotificationSetting, sender: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "再実行", style: .Default, handler: { (_) -> Void in
                        self.doneTapped(nil)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        } else {
            // error
            
        }
    }
    
}
