//
//  ViewTeamViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/8/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Firebase

class ViewTeamViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var team: Team?
    var players: [Player] = []
    
    lazy var width: CGFloat = {
        let width = (view.bounds.width/3)-10
//        print("cell width is \(width)")
        return width
    }()

    lazy var teamLogo = ImageView(frame: .zero)
    
    lazy var registeredPlayersLbl: Label = {
        let label = Label(frame: .zero)
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var playerTable: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let table = UICollectionView(frame: .zero, collectionViewLayout: layout)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(TeamCell.self, forCellWithReuseIdentifier: TeamCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setConstraints()

        // Do any additional setup after loading the view.
        if let myTeam = team {
            self.title = "\(myTeam.name)"
            teamLogo.loadImage(imageUrl: myTeam.imageUrl)
            print("\(myTeam.name)")
            loadData(team: myTeam)
            
        } else {
            self.title = "Players"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(team: Team) {
        let db = Firestore.firestore()
        
        let leagueId = team.currentLeague
        print("League id: \(leagueId!)")
        db.collection("league_players").whereField("currentLeague", isEqualTo: leagueId!)
            .whereField("teamId", isEqualTo: team.id)
            .order(by: "name")
            .addSnapshotListener {querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    print("Error: \(error.debugDescription)")
                    return
                }
                
                print("Snapshot has \(querySnapshot!.count) players")
                
                self.players = []
                
                for document in snapshots {
                    let id = document.data()["id"] as! String
                    let name = document.data()["name"] as! String
                    let imageUrl = document.data()["imageUrl"] as! String
                    let teamName = document.data()["teamName"] as! String
                    
                    let player = Player(id: id, name: name, imageUrl: imageUrl)
                    player.teamName = teamName
                    print(team)
                    self.players.append(player);
                }
                
                let num = self.players.count 
                self.registeredPlayersLbl.text = "Registered players: \(num)"
                
                self.playerTable.reloadData()
        }
    }
    
    private func setConstraints() {
        view.addSubview(teamLogo)
        view.addSubview(registeredPlayersLbl)
        view.addSubview(playerTable)
        
        NSLayoutConstraint.activate([
            teamLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            teamLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            teamLogo.widthAnchor.constraint(equalToConstant: 180),
            teamLogo.heightAnchor.constraint(equalToConstant: 180),
            
            registeredPlayersLbl.topAnchor.constraint(equalTo: teamLogo.bottomAnchor, constant: 10),
            registeredPlayersLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            playerTable.topAnchor.constraint(equalTo: registeredPlayersLbl.bottomAnchor, constant: 10),
            playerTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            playerTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            playerTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamCell.identifier, for: indexPath) as! TeamCell
        let player = players[indexPath.row]
        cell.configure(with: player)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PlayerViewController()
        vc.player = players[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: width*1.2)
    }
    

}
