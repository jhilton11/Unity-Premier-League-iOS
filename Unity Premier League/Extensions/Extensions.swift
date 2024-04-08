//
//  Extensions.swift
//  Unity Premier League
//
//  Created by student on 2024-01-07.
//  Copyright © 2024 Appify Mobile Apps. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup

let cache: NSCache<NSString, UIImage> = NSCache()

extension UIImageView {
    
    func loadImage(imageUrl: String) {
        guard let img = cache.object(forKey: imageUrl as NSString) else {
            DispatchQueue.global().async { [weak self] in
                guard let url = URL(string: imageUrl) else {
                    print("Image url is nil")
                    return
                }
                
                guard let data = try? Data(contentsOf: url) else {
                    print("data is nil")
                    return
                }
                
                if let img = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = img
                        cache.setObject(img, forKey: imageUrl as NSString)
                    }
                } else {
                    print("Unable to display image")
                }
                
            }
            
            return
        }
                
        image = img
    }
    
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        let htmlTemplate = """
            <!doctype html>
            <html>
              <head>
                <style>
                  body {
                    font-family: -apple-system;
                    font-size: 16px;
                  }
                </style>
              </head>
              <body>
                \(self)
              </body>
            </html>
            """

            guard let data = htmlTemplate.data(using: .utf8) else {
                return nil
            }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func parseHTMLString() -> String {
        do {
            let doc = try SwiftSoup.parse(self)
            return try doc.text()
        } catch Exception.Error(let type, let message) {
            return ""
        } catch {
            return ""
        }
    }
}

var dateFormatter: DateFormatter  {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE, dd MMM YYYY"
    return dateFormatter
}

extension Date {
    func formatDateToString(dateFormat: DateFormatter = dateFormatter) -> String {
        return dateFormatter.string(from: self)
    }
}
