//
//  StatsViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/7/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Firebase

class StatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var goalScorers: [Player] = []
    var leagues: [String] = []

    @IBOutlet weak var leaguePicker: UIPickerView!
    @IBOutlet weak var scorersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Goal Scorers"
        loadLeagues();
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
                self.loadScorers(id: self.leagues[0])
        }
    }
    
    func loadScorers(id: String) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalScorers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scorersCell")
        return cell!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return leagues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loadScorers(id: leagues[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return leagues[row]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
