//
//  PlayerViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/8/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    var player: Player?

    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var teamName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let p = player {
            self.title = p.name;
            playerName.text = p.name
            teamName.text = p.teamName
            
            DispatchQueue.global().async {
                let url = URL(string: p.imageUrl)
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                
                DispatchQueue.main.async {
                    print("Main thread stuffs")
                    self.playerImage.image = UIImage(data: data!)
                    
                    self.playerImage.setNeedsLayout() //invalidate current layout
                    self.playerImage.layoutIfNeeded() //update immediately
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
