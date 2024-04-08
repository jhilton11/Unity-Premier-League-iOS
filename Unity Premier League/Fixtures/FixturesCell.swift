//
//  FixturesCell.swift
//  Unity Premier League
//
//  Created by APPLE on 10/15/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import SnapKit

class FixturesCell: UITableViewCell {
    
    static var identifier = "fixture-cell"
    
    lazy var dateLabel: UILabel = {
        let label = Label()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = Label()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var homeLogo: ImageView = {
        let image = ImageView(frame: .zero)
        image.layer.borderColor = UIColor.clear.cgColor
        return image
    }()
    
    lazy var homeLabel: UILabel = {
        let label = Label()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    lazy var scoreLabel: UILabel = {
        let label = Label()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    lazy var awayLogo: ImageView = {
            let image = ImageView(frame: .zero)
            image.layer.borderColor = UIColor.clear.cgColor
            return image
    }()
    
    lazy var awayLabel: UILabel = {
        let label = Label()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
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
    
    private func setConstraints() {
        contentView.addSubview(numberLabel)
        contentView.addSubview(homeLogo)
        contentView.addSubview(homeLabel)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(awayLogo)
        contentView.addSubview(awayLabel)
        contentView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(homeLogo.snp.top)
            make.centerX.equalToSuperview()
        }
        
        numberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        homeLogo.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalTo(numberLabel.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        homeLabel.snp.makeConstraints { make in
            make.leading.equalTo(homeLogo.snp.trailing).offset(10)
            make.trailing.equalTo(scoreLabel.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
//            make.width.equalTo(40)
        }
        
        awayLabel.snp.makeConstraints { make in
            make.leading.equalTo(scoreLabel.snp.trailing).offset(10)
            make.trailing.equalTo(awayLogo.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        awayLogo.snp.makeConstraints { make in
            make.width.height.equalTo(homeLogo.snp.height)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    func setMatch(match: Fixture) {
        if let no = match.matchNo {
            numberLabel.text = "\(no)"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM YYYY"
        dateLabel.text = dateFormatter.string(from: match.date!)
        
        homeLabel.text = match.homeTeam
        awayLabel.text = match.awayTeam
        
        if (match.status == "played") {
            scoreLabel.text = "\(match.homeScore) - \(match.awayScore)"
        } else if (match.status == "not played") {
            scoreLabel.text = "? - ?"
        } else if (match.status == "live") {
            scoreLabel.text = "\(match.homeScore) - \(match.awayScore)"
        } else if (match.status == "half-time") {
            scoreLabel.text = "\(match.homeScore) - \(match.awayScore)"
        } else {
            scoreLabel.text = "P - P"
        }
        
        homeLogo.loadImage(imageUrl: match.homeTeamImgUrl)
        awayLogo.loadImage(imageUrl: match.awayTeamImgUrl)
    }

}
