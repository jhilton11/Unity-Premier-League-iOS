//
//  UILabel+Extension.swift
//  Unity Premier League
//
//  Created by student on 2024-03-14.
//  Copyright © 2024 Appify Mobile Apps. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func addTrailing(image: UIImage) {
        let attachment = NSTextAttachment()
        attachment.image = image

        let attachmentString = NSAttributedString(attachment: attachment)
        let string = NSMutableAttributedString(string: self.text!, attributes: [:])

        string.append(attachmentString)
        self.attributedText = string
    }
}
