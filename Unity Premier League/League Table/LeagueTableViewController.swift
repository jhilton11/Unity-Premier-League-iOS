//
//  LeagueTableViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 11/9/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Firebase

class LeagueTableViewController: UIViewController {
    
    var leagueNames: [String] = []
    
    lazy var leagueTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(LeagueTableCell.self, forCellReuseIdentifier: LeagueTableCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var leaguePicker = Picker()
    
    var leagues: [String] = []
    var teams: [Team] = []
    var header: Team = Team()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "League Table"
        view.backgroundColor = .white
        loadLeagues()
        setConstraints()
        
        leaguePicker.didSelect {  [weak self]
            selectedText, index, id in
            self?.loadLeagueTable(leagueId: self!.leagues[index])
            print("Selected \(selectedText)")
        }
    }
    
    private func setConstraints() {
        view.addSubview(leaguePicker)
        view.addSubview(leagueTable)
        
        leaguePicker.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
        
        leagueTable.snp.makeConstraints { make in
            make.top.equalTo(leaguePicker.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func loadLeagues() {
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
                    
                    if (id.contains("Unity")) {
                        self?.leagues.append(id)
                        let name = id.replacingOccurrences(of: "_", with: "/")
                        self?.leagueNames.append(name)
                        print(name)
                    }
                }
                
                self?.leaguePicker.optionArray = self!.leagueNames
                
                if !self!.leagues.isEmpty {
                    self?.leaguePicker.text = self?.leagueNames[0] ?? ""
                    self?.loadLeagueTable(leagueId: self!.leagues[0])
                }
        }
    }
    
    func loadLeagueTable(leagueId: String) {
        let db = Firestore.firestore()
        
        db.collection("matches").whereField("leagueId", isEqualTo: leagueId)
            .addSnapshotListener {querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    return
                }
                var matches: [Fixture] = []
                print("There are \(querySnapshot!.count) matches in \(leagueId)")
                
                for document in snapshots {
                    let id = document.data()["id"] as! String
                    let homeTeam = document.data()["homeTeam"] as! String
                    let homeTeamId = document.data()["homeTeamId"] as! String
                    let homeTeamUrl = document.data()["homeTeamImageUrl"] as! String
                    let awayTeam = document.data()["awayTeam"] as! String
                    let awayTeamId = document.data()["awayTeamId"] as! String
                    let awayTeamUrl = document.data()["awayTeamImageUrl"] as! String
                    let leagueId = document.data()["leagueId"] as! String
                    let homeScore = document.data()["homeScore"] as! Int
                    let awayScore = document.data()["awayScore"] as! Int
                    let status = document.data()["status"] as! String
                    
                    let match = Fixture(id: id, homeTeam: homeTeam, homeTeamId: homeTeamId, homeTeamImgUrl: homeTeamUrl, awayTeam: awayTeam, awayTeamId: awayTeamId, awayTeamImgUrl: awayTeamUrl, leagueId: leagueId)
                    match.homeScore = homeScore
                    match.awayScore = awayScore
                    match.status = status
                    matches.append(match)
                }
                
                self.teams = self.computeLeagueTable(matches: matches)
                self.leagueTable.reloadData()
                
        }
    }
    
    func computeLeagueTable(matches: [Fixture]) -> [Team] {
        var result: [Team] = []
        var teamIds: [String] = []
        
        //Get teams from matches
        for match in matches {
            if (!teamIds.contains(match.homeTeamId)) {
                teamIds.append(match.homeTeamId)
                let t: Team = Team()
                t.id = match.homeTeamId
                t.name = match.homeTeam
                t.imageUrl = match.homeTeamImgUrl
                result.append(t)
            }
            
            if (!teamIds.contains(match.awayTeamId)) {
                teamIds.append(match.awayTeamId)
                let t: Team = Team()
                t.id = match.awayTeamId
                t.name = match.awayTeam
                t.imageUrl = match.awayTeamImgUrl
                result.append(t)
            }
        }
        print(teamIds)
        
        let playedMatches = matches.filter{$0.status=="played"}
        
        //compute league table
        for tm in result {
            print("Computing team \(tm.name)")
            for match in playedMatches {
                //check for home matches
                if (tm.id == match.homeTeamId) {
                    tm.gf += match.homeScore
                    tm.ga += match.awayScore
                    tm.played += 1
                    if (match.homeScore > match.awayScore) {
                        tm.win += 1
                        tm.points += 3
                    } else if (match.homeScore == match.awayScore) {
                        tm.draws += 1
                        tm.points += 1
                    } else if (match.homeScore < match.awayScore) {
                        tm.losses += 1
                    }
                }
                //check away matches and compute points
                if (tm.id == match.awayTeamId) {
                    tm.gf += match.awayScore
                    tm.ga += match.homeScore
                    tm.played += 1
                    if (match.awayScore > match.homeScore) {
                        tm.win += 1
                        tm.points += 3
                    } else if (match.homeScore == match.awayScore) {
                        tm.draws += 1
                        tm.points += 1
                    } else if (match.awayScore < match.homeScore) {
                        tm.losses += 1
                    }
                }
                tm.gd = tm.gf - tm.ga
            }
        }
        
        //sort the league table
        result.sort { (teamA, teamB) -> Bool in
            if (teamA.points != teamB.points) {
                return teamA.points > teamB.points
            } else if (teamA.gd != teamB.gd) {
                return teamA.gd > teamB.gd
            } else {
                return teamA.gf > teamB.gf
            }
        }
        
        //return sorted league table
        return result
    }
    
}

extension LeagueTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count == 0 ? 0 : teams.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeagueTableCell.identifier) as! LeagueTableCell
        if (indexPath.row == 0) {
            cell.loadHeader()
        } else {
            let row = indexPath.row
            cell.loadTeam(p: row, team: teams[row-1])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = ViewMatchViewController()
//        vc.match = fixtures[indexPath.row]
//        vc.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
