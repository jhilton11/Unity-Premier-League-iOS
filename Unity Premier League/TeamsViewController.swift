//
//  SecondViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/6/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Firebase

class TeamsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    var teams: [Team] = []
    var leagues: [String] = []

    @IBOutlet weak var playersTable: UITableView!
    @IBOutlet weak var leaguePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Teams"
        loadLeagues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLeagues() ->Void {
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
                self.loadTeams(id: self.leagues[0])
        }
    }
    
    func loadTeams(id: String) ->Void {
        let db = Firestore.firestore()
        
        let leagueId = id
        db.collection("league_teams").whereField("currentLeague", isEqualTo: leagueId)
            //.order(by: "name")
            .addSnapshotListener {querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    return
                }
                
                print("There are \(querySnapshot?.count) teams in \(leagueId)")
                
                self.teams = []
                
                for document in snapshots {
                    let id = document.data()["id"] as! String
                    let name = document.data()["name"] as! String
                    let imageUrl = document.data()["imageUrl"] as! String
                    
                    let team = Team(id, name, imageUrl)
                    self.teams.append(team);
                }
                
                self.playersTable.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath)
        let team = teams[indexPath.row]
        cell.textLabel?.text = team.name
        
        //let url = URL(string: team.imageUrl)
        //let data = try? Data(contentsOf: url!)
        //cell.imageView?.image = UIImage(data: data!)
        DispatchQueue.global().async {
            let url = URL(string: team.imageUrl)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            
            DispatchQueue.main.async {
                print("Main thread stuffs")
                cell.imageView!.image = UIImage(data: data!)

                cell.setNeedsLayout() //invalidate current layout
                cell.layoutIfNeeded() //update immediately
            }
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Row: \(indexPath.row) and Section: \(indexPath.section) selected")
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
        loadTeams(id: leagues[row])
        print("Selected \(leagues[row])")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "teamDetail" {
            if let indexPath = self.playersTable.indexPathForSelectedRow {
                let vc = segue.destination as! ViewTeamViewController
                vc.team = teams[indexPath.row]
                vc.hidesBottomBarWhenPushed = true
            }
        }
    }

}

