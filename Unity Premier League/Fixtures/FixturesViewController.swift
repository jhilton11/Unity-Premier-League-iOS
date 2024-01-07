//
//  FixturesViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/7/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Firebase

class FixturesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    var fixtures: [Fixture] = []
    var leagues: [String] = []

    @IBOutlet weak var fixturesTable: UITableView!
    @IBOutlet weak var leaguePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadLeagues()
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
                self.loadMatches(id: self.leagues[0])
        }
    }
    
    func loadMatches(id: String) {
        let db = Firestore.firestore()
        
        let leagueId = id
        db.collection("matches").whereField("leagueId", isEqualTo: leagueId)
            .order(by: "matchNo")
            .addSnapshotListener {querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    return
                }
                
                print("There are \(querySnapshot!.count) matches in \(leagueId)")
                
                self.fixtures = []
                var matno: Int = 0;
                
                for document in snapshots {
                    matno = matno + 1
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
                    match.cellNo = matno
                    match.status = status
                    
                    self.fixtures.append(match);
                }
                
                self.fixturesTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fixtures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let match = fixtures[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "fixturesCell") as! FixturesCell
        cell.setMatch(match: match)
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return leagues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let id = leagues[row]
        return id;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loadMatches(id: leagues[row])
        print("Selected \(leagues[row])")
    }

    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "matchDetail" {
            if let indexPath = self.fixturesTable.indexPathForSelectedRow {
                let vc = segue.destination as! ViewMatchViewController
                vc.match = fixtures[indexPath.row]
                vc.hidesBottomBarWhenPushed = true
            }
        }
    }

}
