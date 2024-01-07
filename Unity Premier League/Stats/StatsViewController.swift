//
//  StatsViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/7/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Firebase

class StatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var goalScorers: [Player] = []
    var stats: [MatchStat] = []
    var leagues: [String] = []

    @IBOutlet weak var leaguePicker: UIPickerView!
    @IBOutlet weak var scorersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Goal Scorers"
        loadLeagues();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.leaguePicker.reloadAllComponents()
                self.loadStats(leagueId: self.leagues[0])
        }
    }
    
    func loadStats(leagueId: String) {
        let db = Firestore.firestore()
        
        db.collection("stats").whereField("leagueId", isEqualTo: leagueId)
            .whereField("type", isEqualTo: "goal")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalScorers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scorersCell") as! PlayerStatCell
        let row = indexPath.row
        let player = goalScorers[row]
        cell.loadPlayerStat(player: player)
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return leagues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loadStats(leagueId: leagues[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return leagues[row]
    }
    
    func getScorers(stats: [MatchStat]) -> [Player] {
        //create an empty dictionary of players
        var playerDict: [String:Player] = [:]
        
        //for each stat, search for playerId in stat dictionary. If its there, increase the number of goals by one. Otherwise add it to the dictionary and set unmber of goals to one
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
