//
//  FixturesViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/7/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
//import Firebase
import FirebaseCore
import FirebaseFirestore

class FixturesViewController: UIViewController {

    var fixtures: [Fixture] = []
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
        button.backgroundColor = .purple
        button.addTarget(self, action: #selector(didTapFixtures), for: .touchUpInside)
        return button
    }()
    
    lazy var resultsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("Results", for: .normal)
        button.setTitleColor(.purple, for: .normal)
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
        
        leaguePicker.didSelect {  [weak self]
            selectedText, index, id in
            self?.leagueId = self!.leagues[index]
            self?.load(id: self!.leagueId)
            print("Selected \(selectedText)")
        }
    }
    
    @objc private func didTapFixtures() {
        mode = .fixtures
        toggleButtonStates(fixturesButton, resultsButton)
        load(id: leagueId)
    }
    
    @objc private func didTapResults() {
        mode = .results
        toggleButtonStates(resultsButton, fixturesButton)
        load(id: leagueId)
    }
    
    private func toggleButtonStates(_ first: UIButton, _ second: UIButton) {
        first.backgroundColor = .purple
        first.setTitleColor(.white, for: .normal)
        
        second.backgroundColor = .white
        second.setTitleColor(.purple, for: .normal)
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
            leaguePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            leaguePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            leaguePicker.heightAnchor.constraint(equalToConstant: 50),
            
            fixturesTable.topAnchor.constraint(equalTo: fixturesButton.bottomAnchor),
            fixturesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fixturesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fixturesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        fixturesButton.snp.makeConstraints { make in
            let width = (view.bounds.width-30)/2
            make.top.equalTo(leaguePicker.snp.bottom)//.offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(width)
            make.height.equalTo(40)
        }
        
        resultsButton.snp.makeConstraints { make in
            make.top.equalTo(fixturesButton.snp.top)
            make.trailing.equalToSuperview().offset(-10)
            make.width.height.equalTo(fixturesButton)
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
                    print(name)
                }
                
                self?.leaguePicker.optionArray = self!.leagueNames
                
                if !self!.leagues.isEmpty {
                    self?.leaguePicker.text = self?.leagueNames[0] ?? ""
                    self?.leagueId = self!.leagues[0]
                    self?.load(id: self!.leagueId)
                }
        }
    }
    
    func loadMatches(id: String, status: String = "played", descending: Bool = true) {
        let db = Firestore.firestore()
        
        let leagueId = id
        db.collection("matches")
            .whereField("leagueId", isEqualTo: leagueId)
            .whereField("status", isEqualTo: status)
            .order(by: "matchNo", descending: descending)
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
                    let date = document.data()["date"] as? Date ?? Date()
                    let venue = document.data()["venue"] as? String ?? ""
                    let referee = document.data()["referee"] as? String ?? ""
                    
                    let match = Fixture(id: id, homeTeam: homeTeam, homeTeamId: homeTeamId, homeTeamImgUrl: homeTeamUrl, awayTeam: awayTeam, awayTeamId: awayTeamId, awayTeamImgUrl: awayTeamUrl, leagueId: leagueId)
                    match.homeScore = homeScore
                    match.awayScore = awayScore
                    match.matchNo = matchNo
                    match.cellNo = matno
                    match.status = status
                    match.date = date
                    match.venue = venue
                    
                    self.fixtures.append(match);
                }
                
                self.fixturesTable.reloadData()
        }
    }
    
    private func load(id: String) {
        switch (mode) {
        case .fixtures:
            loadMatches(id: id, status: "not-played", descending: false)
        case .results:
            loadMatches(id: id, status: "played", descending: true)
        }
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

extension FixturesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fixtures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let match = fixtures[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FixturesCell.identifier) as! FixturesCell
        cell.setMatch(match: match)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewMatchViewController()
        vc.match = fixtures[indexPath.row]
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
