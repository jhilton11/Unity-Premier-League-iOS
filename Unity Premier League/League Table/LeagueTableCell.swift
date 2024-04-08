//
//  LeagueTableCell.swift
//  Unity Premier League
//
//  Created by APPLE on 11/9/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit

class LeagueTableCell: UITableViewCell {
    
    static var identifier = "leagueTableCell"
    
    lazy var posLabel: Label = {
        let label = Label()
        return label
    }()
    
    lazy var teamImage: ImageView = {
        let image = ImageView(frame: .zero)
        image.clipsToBounds = true
        return image
    }()
    
    lazy var teamsLabel: Label = {
        let label = Label()
        return label
    }()
    
    lazy var playedLabel: Label = {
        let label = Label()
        return label
    }()
    
    lazy var winsLabel: Label = {
        let label = Label()
        return label
    }()
    
    lazy var drawsLabel: Label = {
        let label = Label()
        return label
    }()
    
    lazy var lostLabel: Label = {
        let label = Label()
        return label
    }()
    
    lazy var gfLabel: Label = {
        let label = Label()
        return label
    }()
    
    lazy var gaLabel: Label = {
        let label = Label()
        return label
    }()
    
    lazy var gdLabel: Label = {
        let label = Label()
        return label
    }()
    
    lazy var pointsLabel: Label = {
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
        teamImage.image = nil
    }
    
    private func setConstraints() {
        contentView.addSubview(posLabel)
        contentView.addSubview(teamImage)
        contentView.addSubview(teamsLabel)
        contentView.addSubview(playedLabel)
        contentView.addSubview(winsLabel)
        contentView.addSubview(drawsLabel)
        contentView.addSubview(lostLabel)
        contentView.addSubview(gfLabel)
        contentView.addSubview(gaLabel)
        contentView.addSubview(gdLabel)
        contentView.addSubview(pointsLabel)
        
        lazy var width = 27
        
        posLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(width)
        }
        
        teamImage.snp.makeConstraints { make in
            make.leading.equalTo(posLabel.snp.trailing)//.offset(5)
            make.width.height.equalTo(30)
            make.centerY.equalTo(posLabel)
        }
        
        teamsLabel.snp.makeConstraints { make in
            make.leading.equalTo(teamImage.snp.trailing).offset(10)
            make.trailing.equalTo(playedLabel.snp.leading).offset(-5)
            make.centerY.equalTo(posLabel.snp.centerY)
        }
        
        playedLabel.snp.makeConstraints { make in
            make.trailing.equalTo(winsLabel.snp.leading)//.offset(10)
            make.centerY.equalTo(posLabel.snp.centerY)
            make.width.equalTo(width)
        }
        
        winsLabel.snp.makeConstraints { make in
            make.trailing.equalTo(drawsLabel.snp.leading)//.offset(10)
            make.centerY.equalTo(posLabel.snp.centerY)
            make.width.equalTo(width)
        }
        
        drawsLabel.snp.makeConstraints { make in
            make.trailing.equalTo(lostLabel.snp.leading)//.offset(10)
            make.centerY.equalTo(posLabel.snp.centerY)
            make.width.equalTo(width)
        }
        
        lostLabel.snp.makeConstraints { make in
            make.trailing.equalTo(gfLabel.snp.leading)//.offset(10)
            make.centerY.equalTo(posLabel.snp.centerY)
            make.width.equalTo(width)
        }
        
        gfLabel.snp.makeConstraints { make in
            make.trailing.equalTo(gaLabel.snp.leading)//.offset(10)
            make.centerY.equalTo(posLabel.snp.centerY)
            make.width.equalTo(width)
        }
        
        gaLabel.snp.makeConstraints { make in
            make.trailing.equalTo(gdLabel.snp.leading)//.offset(10)
            make.centerY.equalTo(posLabel)
            make.width.equalTo(width)
        }
        
        gdLabel.snp.makeConstraints { make in
            make.trailing.equalTo(pointsLabel.snp.leading).offset(-5)
            make.centerY.equalTo(posLabel.snp.centerY)
            make.width.equalTo(width)
        }
        
        pointsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(posLabel.snp.centerY)
            make.width.equalTo(width)
        }
    }
    
    func loadHeader() {
        posLabel.text = "Pos"
        teamsLabel.text = "Teams"
        playedLabel.text = "P"
        winsLabel.text = "W"
        drawsLabel.text = "D"
        lostLabel.text = "L"
        gfLabel.text = "GF"
        gaLabel.text = "GA"
        gdLabel.text = "GD"
        pointsLabel.text = "Pts"
        print("Loading header position")
    }
    
    func loadTeam(p: Int, team: Team) {
        posLabel.text = "\(p)"
        teamImage.loadImage(imageUrl: team.imageUrl)
        teamsLabel.text = team.name
        playedLabel.text = "\(team.played)"
        winsLabel.text = "\(team.win)"
        drawsLabel.text = "\(team.draws)"
        lostLabel.text = "\(team.losses)"
        gfLabel.text = "\(team.gf)"
        gaLabel.text = "\(team.ga)"
        gdLabel.text = "\(team.gd)"
        pointsLabel.text = "\(team.points)"
    }
    
    func loadDummyData() {
        posLabel.text = "1"
        teamsLabel.text = "Otokiti Rocks FC"
        playedLabel.text = "12"
        winsLabel.text = "5"
        drawsLabel.text = "5"
        lostLabel.text = "2"
        gfLabel.text = "40"
        gaLabel.text = "13"
        gdLabel.text = "27"
        pointsLabel.text = "17"
    }

}
