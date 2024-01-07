//
//  ViewMatchViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/16/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Firebase

class ViewMatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var match: Fixture?
    var stats: [MatchStat] = []
    
    @IBOutlet weak var leagueSeason: UILabel!
    @IBOutlet weak var homeLogo: UIImageView!
    @IBOutlet weak var awayLogo: UIImageView!
    @IBOutlet weak var scoresLabel: UILabel!
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var statsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let m = match {
            leagueSeason.text = m.leagueId
            homeTeam.text = m.homeTeam
            awayTeam.text = m.awayTeam
            scoresLabel.text = "\(m.homeScore) - \(m.awayScore)"
            
            Util.loadImage(view: homeLogo, imageUrl: m.homeTeamImgUrl)
            Util.loadImage(view: awayLogo, imageUrl: m.awayTeamImgUrl)
            loadStats(matchId: m.id)
        }
    }
    
    func loadImage(view: UIImageView, imageUrl: String) {
        DispatchQueue.global().async {
            let url = URL(string: imageUrl)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            
            DispatchQueue.main.async {
                //print("Main thread stuffs")
                view.image = UIImage(data: data!)
                
                //self.setNeedsLayout() //invalidate current layout
                //self.layoutIfNeeded() //update immediately
            }
        }
    }
    
    func loadStats(matchId: String) {
        let db = Firestore.firestore()
        
        db.collection("stats").whereField("matchId", isEqualTo: matchId)
            //.order(by: "name")
            .addSnapshotListener {querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    print("Error: \(error.debugDescription)")
                    return
                }
                
                print("Snapshot has \(querySnapshot?.count) items")
                
                self.stats = []
                
                for document in snapshots {
                    let id = document.data()["id"] as! String
                    let name = document.data()["name"] as! String
                    let playerId = document.data()["playerId"] as! String
                    let imageUrl = document.data()["playerImageUrl"] as! String
                    let matchId = document.data()["matchId"] as! String
                    let leagueId = document.data()["leagueId"] as! String
                    let type = document.data()["type"] as! String
                    let isHome = document.data()["home"] as! Bool
                    
                    let stat = MatchStat(id: id, name: name, playerId: playerId, url: imageUrl, matchId: matchId, type: type, league: leagueId)
                    stat.isHome = isHome
                    self.stats.append(stat);
                }
                
                self.statsTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchStatsCell") as! MatchStatCell
        let row = indexPath.row
        cell.loadStat(stat: stats[row])
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
