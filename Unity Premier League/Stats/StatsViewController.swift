//
//  StatsViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/7/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Firebase

class StatsViewController: UIViewController {
    
    var goalScorers: [Player] = []
    var stats: [MatchStat] = []
    var leagues: [String] = []
    var leagueNames: [String] = []
    var leagueId = ""
    
    fileprivate var mode: Mode = .goals
    
    lazy var goalsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 0
        button.setTitle("Goals", for: .normal)
        button.backgroundColor = .purple
        button.addTarget(self, action: #selector(didTapGoals), for: .touchUpInside)
        return button
    }()
    
    lazy var yellowsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 0
        button.setTitle("Yellow Cards", for: .normal)
        button.setTitleColor(.purple, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTapYellow), for: .touchUpInside)
        return button
    }()
    
    lazy var redsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 0
        button.setTitle("Red Cards", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.purple, for: .normal)
        button.addTarget(self, action: #selector(didTapRed), for: .touchUpInside)
        return button
    }()
    
    lazy var scorersTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(PlayerStatCell.self, forCellReuseIdentifier: PlayerStatCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var leaguePicker = Picker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Stats"
        view.backgroundColor = .white
        loadLeagues()
        setConstraints()
        
        leaguePicker.didSelect {  [weak self]
            selectedText, index, id in
            self?.leagueId = self!.leagues[index]
            self?.loadStats(leagueId: self!.leagueId)
            print("Selected \(selectedText)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func toggleButtonStates(_ first: UIButton, _ second: UIButton, _ third: UIButton) {
        first.backgroundColor = .purple
        first.setTitleColor(.white, for: .normal)
        
        second.backgroundColor = .white
        second.setTitleColor(.purple, for: .normal)
        
        third.backgroundColor = .white
        third.setTitleColor(.purple, for: .normal)
    }
    
    @objc private func didTapGoals() {
        toggleButtonStates(goalsButton, yellowsButton, redsButton)
        mode = .goals
        loadStats(leagueId: leagueId)
    }
    
    @objc private func didTapYellow() {
        toggleButtonStates(yellowsButton, goalsButton, redsButton)
        mode = .yellow
        loadStats(leagueId: leagueId)
    }
    
    @objc private func didTapRed() {
        toggleButtonStates(redsButton, yellowsButton, goalsButton)
        mode = .red
        loadStats(leagueId: leagueId)
    }
    
    private func loadLeagues() {
        let db = Firestore.firestore()
        
        db.collection("leagues")
            .order(by: "number", descending: true)
            .addSnapshotListener { [weak self]
                querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    return
                }
                
                self?.leagues = []
                self?.leagueNames = []
                
                for document in snapshots {
                    let id = document.data()["id"] as! String
                    
                    self?.leagues.append(id)
                    let name = id.replacingOccurrences(of: "_", with: "/")
                    self?.leagueNames.append(name)
                    print(name)
                }
                
                self?.leaguePicker.optionArray = self!.leagueNames
                
                if !self!.leagues.isEmpty {
                    self?.leaguePicker.text = self?.leagueNames[0] ?? ""
                    self?.loadStats(leagueId: self!.leagues[0])
                }
        }
    }
    
    private func loadStats(leagueId: String) {
        let db = Firestore.firestore()
        
        db.collection("stats").whereField("leagueId", isEqualTo: leagueId)
            .whereField("type", isEqualTo: mode.rawValue)
            .addSnapshotListener {querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    print("Error: \(error.debugDescription)")
                    return
                }
                
                print("Snapshot has \(querySnapshot?.count) stats")
                
                self.stats = []
                
                for document in snapshots {
                    let id = document.data()["id"] as! String
                    let name = document.data()["name"] as! String
                    let playerId = document.data()["playerId"] as! String
                    let imageUrl = document.data()["playerImageUrl"] as! String
                    let matchId = document.data()["matchId"] as! String
                    let leagueId = document.data()["leagueId"] as! String
                    let teamName = document.data()["teamName"] as! String
                    let type = document.data()["type"] as! String
                    let isHome = document.data()["home"] as! Bool
                    
                    let stat = MatchStat(id: id, name: name, playerId: playerId, url: imageUrl, matchId: matchId, type: type, league: leagueId)
                    stat.isHome = isHome
                    stat.teamName = teamName
                    self.stats.append(stat);
                }
                self.goalScorers = self.getScorers(stats: self.stats)
                
                self.scorersTable.reloadData()
        }
    }
    
    func getScorers(stats: [MatchStat]) -> [Player] {
        //create an empty dictionary of players
        var playerDict: [String:Player] = [:]
        
        //for each stat, search for playerId in stat dictionary. If its there, increase the number of goals by one. Otherwise add it to the dictionary and set number of goals to one
        for stat in stats {
            let playerId = stat.playerId
            
            if let player = playerDict[playerId] {
                let goals = player.goals + 1
                player.goals = goals
                playerDict[playerId] = player
            } else {
                let name = stat.playerName
                let id = stat.playerId
                let imageUrl = stat.playerImageUrl
                let p: Player = Player(id: id, name: name, imageUrl:imageUrl)
                p.teamName = stat.teamName
                p.goals = 1
                playerDict[playerId] = p
            }
        }
        
        //extract player array from dictionary and return it
        var array = Array(playerDict.values)
        
        //order the player array by goals in descending order
        array.sort(by: {$0.goals > $1.goals})
        return array
    }
    
    private func setConstraints() {
        view.addSubview(leaguePicker)
        view.addSubview(goalsButton)
        view.addSubview(yellowsButton)
        view.addSubview(redsButton)
        view.addSubview(scorersTable)
        
        let width = view.bounds.width/3
        
        leaguePicker.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
        
        goalsButton.snp.makeConstraints { make in
            make.top.equalTo(leaguePicker.snp.bottom)
            make.leading.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(50)
        }
        
        yellowsButton.snp.makeConstraints { make in
            make.top.equalTo(goalsButton.snp.top)
            make.leading.equalTo(goalsButton.snp.trailing)
            make.width.equalTo(width)
            make.height.equalTo(goalsButton)
        }
        
        redsButton.snp.makeConstraints { make in
            make.top.equalTo(yellowsButton.snp.top)
            make.trailing.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(goalsButton)
        }
        
        scorersTable.snp.makeConstraints { make in
            make.top.equalTo(goalsButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

extension StatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalScorers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerStatCell.identifier) as! PlayerStatCell
        let row = indexPath.row
        let player = goalScorers[row]
        cell.loadPlayerStat(player: player)
        cell.posLabel.text = "\(row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = ViewMatchViewController()
//        vc.match = fixtures[indexPath.row]
//        vc.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

fileprivate enum Mode: String {
    case goals = "goal"
    case yellow = "yellow"
    case red = "red"
}
