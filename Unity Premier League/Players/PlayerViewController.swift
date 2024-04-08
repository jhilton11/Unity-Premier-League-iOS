//
//  PlayerViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/8/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    var player: Player?

    lazy var playerImage = ImageView(frame: .zero)
    
    lazy var teamNameLbl: Label = {
        let label = Label(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    
    lazy var statsLabel: Label = {
        let label = Label()
        label.text = "Player Stats"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    lazy var goalsLabel: Label = {
        let label = Label()
        label.text = "(0)"
        //label.addTrailing(image: UIImage(named: "soccer_ball")!)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setConstraints()
        
        if let p = player {
            self.title = p.name;
            teamNameLbl.text = p.teamName?.capitalized
            
            playerImage.loadImage(imageUrl: player!.imageUrl)
        }
    }
    
    private func setConstraints() {
        view.addSubview(playerImage)
        view.addSubview(teamNameLbl)
        view.addSubview(statsLabel)
        view.addSubview(goalsLabel)
        
        playerImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        teamNameLbl.snp.makeConstraints { make in
            make.top.equalTo(playerImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        statsLabel.snp.makeConstraints { make in
            make.top.equalTo(teamNameLbl.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        
        goalsLabel.snp.makeConstraints { make in
            make.top.equalTo(statsLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
