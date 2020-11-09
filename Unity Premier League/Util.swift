//
//  Util.swift
//  Unity Premier League
//
//  Created by APPLE on 11/9/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//
import UIKit

class Util {
    
    static func loadImage(view: UIImageView, imageUrl: String) {
        DispatchQueue.global().async {
            let url = URL(string: imageUrl)
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    view.image = UIImage(data: data)
                }
            } else {
                print("Unable to load image probably due to network")
            } //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            
        }
    }
}
