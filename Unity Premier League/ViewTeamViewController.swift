//
//  ViewTeamViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/8/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Firebase

class ViewTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var team: Team?
    var players: [Player] = []

    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var playerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let myTeam = team {
            self.title = "\(myTeam.name)"
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
        teamName.text = team.name
        DispatchQueue.global().async {
            let url = URL(string: (self.team?.imageUrl)!)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                print("Main thread stuffs")
                self.teamLogo.image = UIImage(data: data!)
            }
        }
        
        let db = Firestore.firestore()
        
        let leagueId = team.currentLeague
        db.collection("players")//("league_players").whereField("currentLeague", isEqualTo: leagueId)
            .whereField("teamId", isEqualTo: team.id)
            //.order(by: "name")
            .addSnapshotListener {querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    print("Error: \(error.debugDescription)")
                    return
                }
                
                print("Snapshot has \(querySnapshot?.count) players")
                
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
                
                self.playerTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let player = players[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell")
        cell?.textLabel?.text = player.name
        
        DispatchQueue.global().async {
            let url = URL(string: player.imageUrl)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            
            DispatchQueue.main.async {
                print("Main thread stuffs")
                cell?.imageView!.image = UIImage(data: data!)
                
                cell?.setNeedsLayout() //invalidate current layout
                cell?.layoutIfNeeded() //update immediately
            }
        }
        
        return cell!
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "playerDetail" {
            if let indexPath = self.playerTable.indexPathForSelectedRow {
                let vc = segue.destination as! PlayerViewController
                vc.player = players[indexPath.row]
                vc.hidesBottomBarWhenPushed = true
            }
        }
    }
    

}
