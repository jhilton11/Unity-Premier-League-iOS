//
//  TeamCell.swift
//  Unity Premier League
//
//  Created by APPLE on 10/6/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit

class TeamCell: UICollectionViewCell {
    
    static let identifier = "team-cell"
    
    var width = 0.0
    
    lazy var teamImage: ImageView = {
        let image = ImageView(frame: .zero)
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var nameLbl: Label = {
        let label = Label(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        width = frame.width - 30
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with team: Team) {
        teamImage.loadImage(imageUrl: team.imageUrl)
        nameLbl.text = team.name.capitalized
    }
    
    func configure(with player: Player) {
        teamImage.loadImage(imageUrl: player.imageUrl)
        nameLbl.text = player.name
    }
    
    private func setConstraints() {
        contentView.addSubview(teamImage)
        contentView.addSubview(nameLbl)
        
        NSLayoutConstraint.activate([
            teamImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            teamImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            teamImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            teamImage.heightAnchor.constraint(equalToConstant: width),
            
            nameLbl.topAnchor.constraint(equalTo: teamImage.bottomAnchor, constant: 10),
            nameLbl.leadingAnchor.constraint(equalTo: teamImage.leadingAnchor),
            nameLbl.trailingAnchor.constraint(equalTo: teamImage.trailingAnchor),
        ])
    }

}
