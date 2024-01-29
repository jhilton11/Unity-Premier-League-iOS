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
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setConstraints()
        
        if let p = player {
            self.title = p.name;
            teamNameLbl.text = p.teamName
            
            playerImage.loadImage(imageUrl: player!.imageUrl)
        }
    }
    
    private func setConstraints() {
        view.addSubview(playerImage)
        view.addSubview(teamNameLbl)
        
        NSLayoutConstraint.activate([
            playerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            playerImage.widthAnchor.constraint(equalToConstant: 200),
            playerImage.heightAnchor.constraint(equalToConstant: 200),
            
            teamNameLbl.topAnchor.constraint(equalTo: playerImage.bottomAnchor, constant: 10),
            teamNameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
