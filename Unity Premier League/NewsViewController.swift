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
    @IBOutlet weak var newsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadNews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadNews() ->Void {
        let db = Firestore.firestore()
        
        db.collection("news")
            .addSnapshotListener {querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    print("Error: \(error)")
                    return
                }
                
                print("News collection has \(querySnapshot?.count) news items")
                
                self.newsArray = []
                
                for document in snapshots {
                    let id = document.data()["id"] as! String
                    let name = document.data()["title"] as! String
                    let imageUrl = document.data()["imageUrl"] as! String
                    
                    let news = News(id, name, imageUrl)
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
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

