//
//  FirstViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/6/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Firebase

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var newsArray: [News] = []
    lazy var newsTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        view.addSubview(table)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        title = "News"
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNews()
    }
    
    private func setConstraints() {
        view.addSubview(newsTable)
        
        NSLayoutConstraint.activate([
            newsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            newsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            newsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadNews() ->Void {
        let db = Firestore.firestore()
        
        db.collection("news")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener {querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    print("Error: \(error)")
                    return
                }
                
                //print("News collection has \(querySnapshot?.count) news items")
                
                self.newsArray = []
                
                for document in snapshots {
                    let id = document.data()["id"] as! String
                    let name = document.data()["title"] as! String
                    let imageUrl = document.data()["imgUrl"] as? String ?? ""
                    let body = document.data()["body"] as? String ?? ""
                    
                    let news = News(id: id, title: name, imageUrl: imageUrl, body: body)
                    print(news)
                    self.newsArray.append(news);
                }
                
                self.newsTable.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as! NewsCell
        let news = newsArray[indexPath.row]
        cell.configure(with: news)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newsArray[indexPath.row]
        let vc = ViewNewsViewController()
        vc.news = newsArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newsDetail" {
            if let indexPath = self.newsTable.indexPathForSelectedRow {
                let vc = segue.destination as! ViewNewsViewController
                vc.news = newsArray[indexPath.row]
                vc.hidesBottomBarWhenPushed = true
            }
        }
    }

}

