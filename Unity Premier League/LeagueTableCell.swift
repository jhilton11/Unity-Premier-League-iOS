//
//  LeagueTableCell.swift
//  Unity Premier League
//
//  Created by APPLE on 11/9/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit

class LeagueTableCell: UITableViewCell {

    @IBOutlet weak var pos: UILabel!
    @IBOutlet weak var teams: UILabel!
    @IBOutlet weak var played: UILabel!
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var draws: UILabel!
    @IBOutlet weak var lost: UILabel!
    @IBOutlet weak var goalDif: UILabel!
    @IBOutlet weak var points: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadHeader() {
        pos.text = "Pos"
        teams.text = "Teams"
        played.text = "P"
        wins.text = "W"
        draws.text = "D"
        lost.text = "L"
        goalDif.text = "GD"
        points.text = "Pts"
        print("Loading position 0")
    }
    
    func loadTeam(p: Int) {
        print("Loading position \(p)")
        pos.text = "\(p)"
        teams.text = "Barnet"
        played.text = "5"
        wins.text = "4"
        draws.text = "1"
        lost.text = "0"
        goalDif.text = "23"
        points.text = "13"
    }

}
