//
//  ViewNewsViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/9/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit

class ViewNewsViewController: UIViewController {
    var news: News?
    
    lazy var image: ImageView = {
        let image = ImageView(frame: .zero)
        image.loadImage(imageUrl: news?.imageUrl ?? "")
        //image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var bodyLbl: Label = {
        let label = Label(frame: .zero)
        label.text = "This text"
        //label.numberOfLines = 0
        label.attributedText = (news?.body ?? "").htmlToAttributedString
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setConstraints() {
        view.addSubview(image)
        view.addSubview(bodyLbl)
        let imageHeight = view.bounds.width * 0.75
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            image.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            image.heightAnchor.constraint(equalToConstant: imageHeight),
            
            bodyLbl.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 0),
            bodyLbl.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            bodyLbl.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            bodyLbl.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
