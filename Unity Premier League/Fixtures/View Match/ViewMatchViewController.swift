//
//  ViewMatchViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/16/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Firebase

class ViewMatchViewController: UIViewController {
    var match: Fixture?
    var stats: [MatchStat] = []
    
    lazy var backgroundImage: ImageView = {
        let imgView = ImageView(frame: .zero)
        imgView.image = UIImage(named: "fixtures_background_1")
        return imgView
    }()
    
    lazy var leagueSeason: Label = {
        let label = Label()
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var homeLogo: ImageView = {
        let imgView = ImageView(frame: .zero)
        return imgView
    }()
    
    lazy var awayLogo: ImageView = {
        let imgView = ImageView(frame: .zero)
        return imgView
    }()
    
    lazy var scoresLabel: Label = {
        let label = Label()
        label.font = .boldSystemFont(ofSize: 60)
        return label
    }()
    
    lazy var homeTeamLabel: Label = {
        let label = Label()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    lazy var awayTeamLabel: Label = {
        let label = Label()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    lazy var venueLabel: Label = {
        let label = Label()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    lazy var refereeLabel: Label = {
        let label = Label()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    lazy var dateLabel: Label = {
        let label = Label()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    lazy var matchStatLabel: Label = {
        let label = Label()
        label.text = "Match Stats"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    lazy var statsTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(MatchStatCell.self, forCellReuseIdentifier: MatchStatCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let m = match {
            leagueSeason.text = m.leagueId.replacingOccurrences(of: "_", with: "/")
            homeTeamLabel.text = m.homeTeam
            awayTeamLabel.text = m.awayTeam
            scoresLabel.text = "\(m.homeScore) - \(m.awayScore)"
            venueLabel.text = m.venue
            refereeLabel.text = "Referee: \(m.referee ?? "")"
            dateLabel.text = m.date?.formatDateToString() ?? ""
            homeLogo.loadImage(imageUrl: m.homeTeamImgUrl)
            awayLogo.loadImage(imageUrl: m.awayTeamImgUrl)
            loadStats(matchId: m.id)
        }
        
        view.backgroundColor = .white
        setConstraints()
    }
    
    private func setConstraints() {
//        view.addSubview(backgroundImage)
        view.addSubview(leagueSeason)
        view.addSubview(homeLogo)
        view.addSubview(awayLogo)
        view.addSubview(scoresLabel)
        view.addSubview(homeTeamLabel)
        view.addSubview(awayTeamLabel)
        view.addSubview(venueLabel)
        view.addSubview(refereeLabel)
        view.addSubview(dateLabel)
        view.addSubview(matchStatLabel)
        view.addSubview(statsTable)
        
//        backgroundImage.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(matchStatLabel.snp.top)
//        }
        
        leagueSeason.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        homeLogo.snp.makeConstraints { make in
            make.top.equalTo(leagueSeason.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(100)
        }
        
        awayLogo.snp.makeConstraints { make in
            make.top.width.height.equalTo(homeLogo)
            make.trailing.equalTo(-20)
        }
        
        scoresLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(homeLogo)
        }
        
        homeTeamLabel.snp.makeConstraints { make in
            make.top.equalTo(homeLogo.snp.bottom).offset(5)
            make.centerX.equalTo(homeLogo)
        }
        
        awayTeamLabel.snp.makeConstraints { make in
            make.top.equalTo(awayLogo.snp.bottom).offset(5)
            make.centerX.equalTo(awayLogo)
        }
        
        venueLabel.snp.makeConstraints { make in
            make.top.equalTo(homeTeamLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        refereeLabel.snp.makeConstraints { make in
            make.top.equalTo(venueLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(refereeLabel.snp.bottom)//.offset(10)
            make.centerX.equalToSuperview()
        }
        
        matchStatLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        statsTable.snp.makeConstraints { make in
            make.top.equalTo(matchStatLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func loadStats(matchId: String) {
        let db = Firestore.firestore()
        
        db.collection("stats").whereField("matchId", isEqualTo: matchId)
            .order(by: "minute", descending: false)
            .addSnapshotListener { [weak self]
                querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    print("Error: \(error.debugDescription)")
                    return
                }
                
                print("Snapshot has \(querySnapshot?.count) items")
                
                self?.stats = []
                
                for document in snapshots {
                    let id = document.data()["id"] as! String
                    let name = document.data()["name"] as! String
                    let playerId = document.data()["playerId"] as! String
                    let imageUrl = document.data()["playerImageUrl"] as! String
                    let matchId = document.data()["matchId"] as! String
                    let leagueId = document.data()["leagueId"] as! String
                    let type = document.data()["type"] as! String
                    let isHome = document.data()["home"] as! Bool
                    let minute = document.data()["minute"] as! String
                    
                    let stat = MatchStat(id: id, name: name, playerId: playerId, url: imageUrl, matchId: matchId, type: type, league: leagueId)
                    stat.isHome = isHome
                    stat.minute = minute
                    self?.stats.append(stat)
                }
                
                self?.statsTable.reloadData()
        }
    }

}

extension ViewMatchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchStatCell.identifier) as! MatchStatCell
        let row = indexPath.row
        cell.loadStat(stat: stats[row])
        return cell
    }
}
