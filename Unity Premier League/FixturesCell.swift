//
//  FixturesCell.swift
//  Unity Premier League
//
//  Created by APPLE on 10/15/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit

class FixturesCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var homeLogo: UIImageView!
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    @IBOutlet weak var awayLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMatch(match: Fixture) {
        if let no = match.cellNo {
            numberLabel.text = "\(no)"
        }
        
        homeTeam.text = match.homeTeam
        awayTeam.text = match.awayTeam
        
        if (match.status == "played") {
            scoreLabel.text = "\(match.homeScore) - \(match.awayScore)"
        } else if (match.status == "not played") {
            scoreLabel.text = "? - ?"
        } else {
            scoreLabel.text = "P - P"
        }
        
        Util.loadImage(view: homeLogo, imageUrl: match.homeTeamImgUrl)
        Util.loadImage(view: awayLogo, imageUrl: match.awayTeamImgUrl)
    }

}
