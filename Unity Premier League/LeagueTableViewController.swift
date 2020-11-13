//
//  LeagueTableViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 11/9/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Firebase

class LeagueTableViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var leagueTable: UITableView!
    var leagues: [String] = []
    var teams: [Team] = []
    var header: Team = Team()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "League Tables"
        loadLeagues()
    }
    
    func loadLeagues() {
        let db = Firestore.firestore()
        
        db.collection("leagues")
            .addSnapshotListener {querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    return
                }
                self.leagues = []
                
                for document in snapshots {
                    let id = document.data()["id"] as! String
                    
                    self.leagues.append(id)
                    print(id)
                }
                self.pickerView.reloadAllComponents()
                self.loadLeagueTable(leagueId: self.leagues[0])
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
                result.append(t)
            }
            
            if (!teamIds.contains(match.awayTeamId)) {
                teamIds.append(match.awayTeamId)
                let t: Team = Team()
                t.id = match.awayTeamId
                t.name = match.awayTeam
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return leagues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loadLeagueTable(leagueId: leagues[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return leagues[row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueTable") as! LeagueTableCell
        if (indexPath.row == 0) {
            cell.loadHeader()
        } else {
            let row = indexPath.row;
            cell.loadTeam(p:row, team: teams[row-1])
        }
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
