//
//  PlayerStatCell.swift
//  Unity Premier League
//
//  Created by APPLE on 11/6/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit

class PlayerStatCell: UITableViewCell {

    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerGoals: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadPlayerStat(player: Player) {
        Util.loadImage(view: playerImage, imageUrl: player.imageUrl)
        playerName.text = "\(player.name) (\(player.teamName ?? ""))"
        playerGoals.text = "\(player.goals)"
    }

}
