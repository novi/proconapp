//
//  HomeCells.swift
//  ProconApp
//
//  Created by ito on 2015/07/25.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import ProconBase



class GameResultCell: UITableViewCell {
    var result: GameResult?
    let margin: CGFloat = 78
}

class GameResultScoreCell: GameResultCell {
    
    @IBOutlet var scores: [UILabel]!
    @IBOutlet var playerNames: [UILabel]!
    @IBOutlet weak var gameNameLabel: UILabel!
    
    override var result: GameResult? {
        didSet {
            if let results = result?.resultsByScore {
                gameNameLabel.text = "\(result!.title) の得点"
                for i in 0..<scores.count {
                    if i<results.count {
                        scores[i].text = "\(Int(results[i].score))\(results[i].scoreUnit)"
                        playerNames[i].text = results[i].player.shortName
                        playerNames[i].hidden = false
                        scores[i].hidden = false
                    } else {
                        scores[i].text = nil
                        playerNames[i].text = nil
                        playerNames[i].hidden = true
                        scores[i].hidden = true
                    }
                }
            }
        }
    }
}

class GameResultRankCell: GameResultCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var playerNames: [UILabel]!
    @IBOutlet var ranks: [UILabel]!
    
    @IBOutlet weak var gameNameLabel: UILabel!
    
    override var result: GameResult? {
        didSet {
            if let result = result {
                dateLabel.text = result.startedAt.relativeDateString
                gameNameLabel.text = "\(result.title) の順位"
                let results = result.resultsByRank
                for i in 0..<playerNames.count {
                    if i<results.count {
                        playerNames[i].text = results[i].player.shortName
                        ranks[i].text = "\(results[i].rank)"
                        playerNames[i].hidden = false
                        ranks[i].hidden = false
                    } else {
                        playerNames[i].text = nil
                        ranks[i].text = nil
                        playerNames[i].hidden = true
                        ranks[i].hidden = true
                    }
                }
            }
        }
    }
}

protocol HomeHeaderViewDelegate : NSObjectProtocol {
    func homeHeaderView(view: HomeHeaderView, didTapShowAllforSection section: HomeViewController.Section)
}

class HomeHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func showAllTapped(sender: UIButton) {
        Logger.debug("show all tapped")
        if let section = section {
            delegate?.homeHeaderView(self, didTapShowAllforSection: section)
        }
    }
    
    weak var delegate: HomeHeaderViewDelegate?
    
    var section: HomeViewController.Section? {
        didSet {
            titleLabel.text = section?.sectionName
            imageView.image = section?.sectionImage
        }
    }
    
}

class GeneralCell: UITableViewCell {
    
    @IBOutlet weak var accessButton: UIButton!
    @IBOutlet weak var programButton: UIButton!
    
    enum Tag: Int {
        case Program = 1
        case Access = 2
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        accessButton.removeTarget(nil, action: nil, forControlEvents: .TouchUpInside)
        accessButton.removeTarget(nil, action: nil, forControlEvents: .TouchUpInside)
    }
}

class NoticeCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    let margin: CGFloat = 27
    var notice: Notice? {
        didSet {
            if let notice = notice {
                titleLabel.text = notice.title
                dateLabel.text = notice.publishedAt.relativeDateString
                self.accessoryType = notice.hasBody ? .DisclosureIndicator : .None
                self.userInteractionEnabled = notice.hasBody ? true: false
            }
        }
    }
}

class PhotoCell: UITableViewCell {
    
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: LoadingImageView!
    let margin: CGFloat = 80
    
    override func awakeFromNib() {
        thumbnailImageView.clipsToBounds = true
    }
    
    var photoInfo: PhotoInfo? {
        didSet {
            if let info = photoInfo {
                dateLabel.text = info.createdAt.relativeDateString
                titleLabel.text = info.title
                thumbnailImageView.imageURL = info.thumbnailURL
            }
        }
    }
    
    let OVERLAY_VIEW_ALPHA: CGFloat = 0.6
    
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if overlayView != nil {
            overlayView.hidden = false
            func anim() {
                self.overlayView.alpha = highlighted ? self.OVERLAY_VIEW_ALPHA : 0
            }
            func comp(c: Bool) {
                overlayView.hidden = !highlighted
            }
            if !highlighted {
                //overlayView.alpha = highlighted ? 0 : self.OVERLAY_VIEW_ALPHA
                UIView.animateWithDuration(0.25, animations: anim, completion: comp)
            } else {
                anim()
                comp(true)
            }
        }
    }
}
