//
//  SecondViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/6/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Firebase

class TeamsViewController: UIViewController {
    var teams: [Team] = []
    var leagues: [String] = []
    var leagueNames: [String] = []
    
    lazy var width: CGFloat = {
        let width = (view.bounds.width/4)-10
//        print("cell width is \(width)")
        return width
    }()

    lazy var teamsTable: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let table = UICollectionView(frame: .zero, collectionViewLayout: layout)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(TeamCell.self, forCellWithReuseIdentifier: TeamCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var leaguePicker = Picker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Teams"
        loadLeagues()
        view.backgroundColor = .white
        setConstraints()
        
        leaguePicker.didSelect {  [weak self]
            selectedText, index, id in
            self?.loadTeams(id: self!.leagues[index])
            print("Selected \(selectedText)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setConstraints() {
        view.addSubview(leaguePicker)
        view.addSubview(teamsTable)
        
        NSLayoutConstraint.activate([
            leaguePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leaguePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            leaguePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            leaguePicker.heightAnchor.constraint(equalToConstant: 50),
            
            teamsTable.topAnchor.constraint(equalTo: leaguePicker.bottomAnchor, constant: 0),
            teamsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            teamsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            teamsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func loadLeagues() ->Void {
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
                    self?.loadTeams(id: self!.leagues[0])
                }
        }
    }
    
    func loadTeams(id: String) ->Void {
        let db = Firestore.firestore()
        
        let leagueId = id
        db.collection("league_teams").whereField("currentLeague", isEqualTo: leagueId)
            .order(by: "name")
            .addSnapshotListener {querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    return
                }
                
                print("There are \(querySnapshot!.count) teams in \(leagueId)")
                
                self.teams = []
                
                for document in snapshots {
                    let id = document.data()["id"] as? String ?? ""
                    let name = document.data()["name"] as! String
                    let imageUrl = document.data()["imageUrl"] as! String
                    let leagueId = document.data()["currentLeague"] as! String
                    
                    let team = Team(id, name, imageUrl)
                    team.currentLeague = leagueId
                    self.teams.append(team);
                }
                
                self.teamsTable.reloadData()
        }
    }

}

extension TeamsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamCell.identifier, for: indexPath) as! TeamCell
        let team = teams[indexPath.row]
        cell.configure(with: team)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ViewTeamViewController()
        vc.team = teams[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: width * 1.2)
    }
    
}

