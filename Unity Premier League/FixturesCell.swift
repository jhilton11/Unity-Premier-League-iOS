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
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayScore: UILabel!
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
        homeScore.text = "\(match.homeScore)"
        awayTeam.text = match.awayTeam
        awayScore.text = "\(match.awayScore)"
        
        loadImage(view: homeLogo, imageUrl: match.homeTeamImgUrl)
        loadImage(view: awayLogo, imageUrl: match.awayTeamImgUrl)
    }
    
    func loadImage(view: UIImageView, imageUrl: String) {
        DispatchQueue.global().async {
            let url = URL(string: imageUrl)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            
            DispatchQueue.main.async {
                print("Main thread stuffs")
                view.image = UIImage(data: data!)
                
                //self.setNeedsLayout() //invalidate current layout
                //self.layoutIfNeeded() //update immediately
            }
        }
    }
}
