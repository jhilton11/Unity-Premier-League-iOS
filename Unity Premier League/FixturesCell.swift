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
        scoreLabel.text = "\(match.homeScore) - \(match.awayScore)"
        
        loadImage(view: homeLogo, imageUrl: match.homeTeamImgUrl)
        loadImage(view: awayLogo, imageUrl: match.awayTeamImgUrl)
    }
    
    func loadImage(view: UIImageView, imageUrl: String) {
        DispatchQueue.global().async {
            let url = URL(string: imageUrl)
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    view.image = UIImage(data: data)
                }
            } else {
                print("Unable to load image probably due to network")
            } //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            
        }
    }
}
