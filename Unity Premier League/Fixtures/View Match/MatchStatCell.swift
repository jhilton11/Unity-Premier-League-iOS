//
//  MatchStatCell.swift
//  Unity Premier League
//
//  Created by APPLE on 10/16/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit

class MatchStatCell: UITableViewCell {
    
    static let identifier = "match-stat-cell"
    
    lazy var minuteLabel: Label = {
        let lbl = Label()
        return lbl
    }()
    
    lazy var homeEventImage: ImageView = {
        let imgView = ImageView(frame: .zero)
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    lazy var homePlayerLabel: Label = {
        let lbl = Label()
        return lbl
    }()
    
    lazy var awayEventImage: ImageView = {
        let imgView = ImageView(frame: .zero)
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    lazy var awayPlayerLabel: Label = {
        let lbl = Label()
        return lbl
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        homeEventImage.image = nil
        awayEventImage.image = nil
        homePlayerLabel.text = ""
        awayPlayerLabel.text = "" 
    }
    
    private func setConstraints() {
        contentView.addSubview(minuteLabel)
        contentView.addSubview(homeEventImage)
        contentView.addSubview(homePlayerLabel)
        contentView.addSubview(awayEventImage)
        contentView.addSubview(awayPlayerLabel)
        
        minuteLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
        }
        
        homeEventImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(minuteLabel.snp.trailing).offset(10)
            make.width.height.equalTo(25)
        }
        
        homePlayerLabel.snp.makeConstraints { make in
            make.leading.equalTo(homeEventImage.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.snp.centerX).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        awayPlayerLabel.snp.makeConstraints { make in
            make.trailing.equalTo(awayEventImage.snp.leading).offset(-10)
            make.leading.equalTo(contentView.snp.centerX).offset(10)
            make.centerY.equalToSuperview()
        }
        
        awayEventImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.width.height.equalTo(homeEventImage)
        }
    }
    
    func loadStat(stat: MatchStat) {
        minuteLabel.text = "\(stat.minute ?? "")'"
        if let isHm = stat.isHome {
            if isHm {
                homePlayerLabel.text = stat.playerName
                
                switch (stat.eventType) {
                case "yellow":
                    homeEventImage.image = UIImage(named: "yellow_card")
                    break
                case "second yellow":
                    homeEventImage.image = UIImage(named: "second_yellow")
                    break
                case "red":
                    homeEventImage.image = UIImage(named: "red_card")
                    break
                case "goal":
                    homeEventImage.image = UIImage(named: "soccer_ball_icon")
                    break
                case "penalty goal":
                    homeEventImage.image = UIImage(named: "soccer_ball_icon")
                    homePlayerLabel.text = "(Pen) \(stat.playerName)"
                    break
                case "own goal":
                    homeEventImage.image = UIImage(named: "own_goal")
                    homePlayerLabel.text = "(O.G) \(stat.playerName)"
                case "cancelled goal":
                    homeEventImage.image = UIImage(named: "cancelled_goal")
                    break
                case "missed penalty":
                    homeEventImage.image = UIImage(named: "missed_pen")
                    homePlayerLabel.text = "(Pen) \(stat.playerName)"
                    break
                default:
                    print("No item found that matches")
                }
            } else {
                awayPlayerLabel.text = stat.playerName
                
                switch (stat.eventType) {
                case "yellow":
                    awayEventImage.image = UIImage(named: "yellow_card")
                    break
                case "second yellow":
                    awayEventImage.image = UIImage(named: "second_yellow")
                    break
                case "red":
                    awayEventImage.image = UIImage(named: "red_card")
                    break
                case "goal":
                    awayEventImage.image = UIImage(named: "soccer_ball_icon")
                    break
                case "penalty goal":
                    awayEventImage.image = UIImage(named: "soccer_ball_icon")
                    awayPlayerLabel.text = "\(stat.playerName) (Pen)"
                    break
                case "own goal":
                    awayEventImage.image = UIImage(named: "own_goal")
                    awayPlayerLabel.text = "\(stat.playerName) (O.G)"
                case "cancelled goal":
                    awayEventImage.image = UIImage(named: "cancelled_goal")
                    break
                case "missed penalty":
                    awayEventImage.image = UIImage(named: "missed_pen")
                    break
                default:
                    print("No item found that matches")
                }
            }
        }
    }

}
