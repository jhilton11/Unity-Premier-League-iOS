//
//  FixturesViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/7/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class FixturesViewController: UIViewController {

    var matches: [Fixture] = []
    var selectedMatches = [Fixture]()
    var leagues: [String] = []
    var leagueNames: [String] = []
    fileprivate var mode: Mode = .fixtures
    var leagueId = ""

    lazy var fixturesTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(FixturesCell.self, forCellReuseIdentifier: FixturesCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var leaguePicker = Picker()
    
    lazy var fixturesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("Fixtures", for: .normal)
        button.setTitleColor(Theme.primaryColour, for: .normal)
        button.addTarget(self, action: #selector(didTapFixtures), for: .touchUpInside)
        return button
    }()
    
    lazy var resultsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("Results", for: .normal)
        button.backgroundColor = Theme.primaryColour
        button.addTarget(self, action: #selector(didTapResults), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.title = "Fixtures"
        loadLeagues()
        setConstraints()
        mode = .results
        
        leaguePicker.didSelect {  [weak self]
            selectedText, index, id in
            if let self = self {
                self.leagueId = self.leagues[index]
                self.load(id: self.leagueId)
            } else {
                print("self is nil")
            }
        }
    }
    
    private func setFixtures() {
        mode = .fixtures
        selectedMatches = matches.filter{ $0.status == "not played" }
        fixturesTable.reloadData()
    }
    
    private func setResults() {
        mode = .results
        selectedMatches = matches.filter{ $0.status == "played" || $0.status == "live" }.sorted{$0.matchNo ?? 0 > $1.matchNo ?? 0}
        fixturesTable.reloadData()
    }
    
    @objc private func didTapFixtures() {
        toggleButtonStates(fixturesButton, resultsButton)
        setFixtures()
    }
    
    @objc private func didTapResults() {
        toggleButtonStates(resultsButton, fixturesButton)
        setResults()
    }
    
    private func toggleButtonStates(_ first: UIButton, _ second: UIButton) {
        first.backgroundColor = Theme.primaryColour
        first.setTitleColor(.white, for: .normal)
        
        second.backgroundColor = .white
        second.setTitleColor(Theme.primaryColour, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setConstraints() {
        view.addSubview(leaguePicker)
        view.addSubview(fixturesButton)
        view.addSubview(resultsButton)
        view.addSubview(fixturesTable)
        
        NSLayoutConstraint.activate([
            leaguePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leaguePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -10),
            leaguePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            leaguePicker.heightAnchor.constraint(equalToConstant: 50),
            
            fixturesTable.topAnchor.constraint(equalTo: fixturesButton.bottomAnchor),
            fixturesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fixturesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fixturesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        resultsButton.snp.makeConstraints { make in
            let width = (view.bounds.width-20)/2
            make.top.equalTo(leaguePicker.snp.bottom)//.offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(width)
            make.height.equalTo(40)
        }
        
        fixturesButton.snp.makeConstraints { make in
            make.top.equalTo(resultsButton.snp.top)
            make.trailing.equalToSuperview().offset(-10)
            make.width.height.equalTo(resultsButton)
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
                    
                    self?.leagues.append(id)
                    let name = id.replacingOccurrences(of: "_", with: "/")
                    self?.leagueNames.append(name)
                }
                
                self?.leaguePicker.optionArray = self!.leagueNames
                
                if let self = self, !self.leagues.isEmpty {
                    self.leaguePicker.text = self.leagueNames[0]
                    self.leagueId = self.leagues[0]
                    self.load(id: self.leagueId)
                }
        }
    }
    
    func loadMatches(id: String, descending: Bool = true) {
        let db = Firestore.firestore()
        
        let leagueId = id
        db.collection("matches")
            .whereField("leagueId", isEqualTo: leagueId)
            .order(by: "matchNo")
            .addSnapshotListener {querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    return
                }
                
                self.matches = []
                
                for document in snapshots {
                    let id = document.data()["id"] as! String
                    let homeTeam = document.data()["homeTeam"] as? String ?? ""
                    let homeTeamId = document.data()["homeTeamId"] as? String ?? ""
                    let homeTeamUrl = document.data()["homeTeamImageUrl"] as? String ?? ""
                    let awayTeam = document.data()["awayTeam"] as? String ?? ""
                    let awayTeamId = document.data()["awayTeamId"] as? String ?? ""
                    let awayTeamUrl = document.data()["awayTeamImageUrl"] as? String ?? ""
                    let leagueId = document.data()["leagueId"] as? String ?? ""
                    let homeScore = document.data()["homeScore"] as? Int ?? 0
                    let awayScore = document.data()["awayScore"] as? Int ?? 0
                    let status = document.data()["status"] as? String ?? ""
                    let matchNo = document.data()["matchNo"] as? Int ?? 0
                    let date = document.data()["date"] as? Timestamp
                    let venue = document.data()["venue"] as? String ?? ""
                    _ = document.data()["referee"] as? String ?? ""
                    
                    let match = Fixture(id: id, homeTeam: homeTeam, homeTeamId: homeTeamId, homeTeamImgUrl: homeTeamUrl, awayTeam: awayTeam, awayTeamId: awayTeamId, awayTeamImgUrl: awayTeamUrl, leagueId: leagueId)
                    match.homeScore = homeScore
                    match.awayScore = awayScore
                    match.matchNo = matchNo
                    match.cellNo = matchNo
                    match.status = status
                    match.date = date?.dateValue() 
                    match.venue = venue
                    
                    self.matches.append(match)
                }
                
                if self.mode == .fixtures {
                    self.setFixtures()
                } else {
                    self.setResults()
                }
        }
    }
    
    private func load(id: String) {
        loadMatches(id: id, descending: false)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "matchDetail" {
            if let indexPath = self.fixturesTable.indexPathForSelectedRow {
                let vc = segue.destination as! ViewMatchViewController
                vc.match = matches[indexPath.row]
//                vc.hidesBottomBarWhenPushed = true
            }
        }
    }

}

extension FixturesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedMatches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let match = selectedMatches[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FixturesCell.identifier) as! FixturesCell
        cell.setMatch(match: match)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewMatchViewController()
        vc.match = selectedMatches[indexPath.row]
        Util.pushToNavigationController(navC: navigationController, vc: vc)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
}

fileprivate enum Mode: String {
    case fixtures = "fixtures"
    case results = "results"
}
