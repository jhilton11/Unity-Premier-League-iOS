//
//  MatchStatCell.swift
//  Unity Premier League
//
//  Created by APPLE on 10/16/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit

class MatchStatCell: UITableViewCell {

    @IBOutlet weak var homeEvent: UIImageView!
    @IBOutlet weak var homePlayer: UILabel!
    @IBOutlet weak var awayEvent: UIImageView!
    @IBOutlet weak var awayPlayer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadStat(stat: MatchStat) {
        if let isHm = stat.isHome {
            if isHm {
                homePlayer.text = stat.playerName
                
                switch (stat.eventType) {
                case "yellow":
                    homeEvent.image = UIImage(named: "yellow_card")
                    break
                case "red":
                    homeEvent.image = UIImage(named: "red_card")
                    break
                case "goal":
                    homeEvent.image = UIImage(named: "soccer_ball")
                    break
                default:
                    print("No item found that matches")
                }
            } else {
                awayPlayer.text = stat.playerName
                
                switch (stat.eventType) {
                case "yellow":
                    awayEvent.image = UIImage(named: "yellow_card")
                    break
                case "red":
                    awayEvent.image = UIImage(named: "red_card")
                    break
                case "goal":
                    awayEvent.image = UIImage(named: "soccer_ball")
                    break
                default:
                    print("No item found that matches")
                }
            }
        }
    }

}
