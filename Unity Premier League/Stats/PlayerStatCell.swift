//
//  PlayerStatCell.swift
//  Unity Premier League
//
//  Created by APPLE on 11/6/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit

class PlayerStatCell: UITableViewCell {
    
    static var identifier = "scorersCell"
    
    lazy var posLabel: Label = {
        let label = Label()
        return label
    }()

    lazy var playerImage: ImageView = {
        let image = ImageView(frame: .zero)
        image.layer.cornerRadius = 20
        return image
    }()
    
    lazy var playerName: Label = {
        let label = Label()
        return label
    }()
    
    lazy var teamName: Label = {
        let label = Label()
        return label
    }()
    
    lazy var statsLabel: Label = {
        let label = Label()
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        playerImage.image = nil
    }
    
    func loadPlayerStat(player: Player) {
        playerImage.loadImage(imageUrl: player.imageUrl)
        playerName.text = "\(player.name) (\(player.teamName ?? ""))"
        teamName.text = player.teamName
        statsLabel.text = "\(player.goals)"
    }
    
    private func setConstraints() {
        contentView.addSubview(posLabel)
        contentView.addSubview(playerImage)
        contentView.addSubview(playerName)
//        contentView.addSubview(teamName)
        contentView.addSubview(statsLabel)
        
        let width = (contentView.bounds.width - 100)/2
        
        posLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
        }
        
        playerImage.snp.makeConstraints { make in
            make.leading.equalTo(posLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        playerName.snp.makeConstraints { make in
            make.leading.equalTo(playerImage.snp.trailing).offset(20)
            make.trailing.equalTo(statsLabel.snp.trailing).offset(10)
            make.centerY.equalTo(playerImage.snp.centerY)
            make.width.equalTo(width)
        }
        
//        teamName.snp.makeConstraints { make in
//            make.leading.equalTo(playerName.snp.trailing)
//            make.trailing.equalTo(statsLabel.snp.leading).offset(-10)
//            make.centerY.equalTo(posLabel.snp.centerY)
//        }
        
        statsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(posLabel.snp.centerY)
            make.width.equalTo(20)
        }
    }

}
