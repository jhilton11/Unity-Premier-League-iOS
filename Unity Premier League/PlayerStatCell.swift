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
        loadImage(view: playerImage, imageUrl: player.imageUrl)
        playerName.text = "\(player.name) (\(player.teamName ?? ""))"
        playerGoals.text = "\(player.goals)"
    }
    
    func loadImage(view: UIImageView, imageUrl: String) {
        DispatchQueue.global().async {
            let url = URL(string: imageUrl)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            
            DispatchQueue.main.async {
                //print("Main thread stuffs")
                view.image = UIImage(data: data!)
                
                //self.setNeedsLayout() //invalidate current layout
                //self.layoutIfNeeded() //update immediately
            }
        }
    }

}
