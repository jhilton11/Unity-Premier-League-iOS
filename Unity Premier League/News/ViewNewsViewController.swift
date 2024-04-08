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
        return image
    }()
    
    lazy var titleLbl: Label = {
        let label = Label()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = news?.title ?? ""
        return label
    }()
    
    lazy var bodyLbl: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This text"
        label.isEditable = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .justified
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
        view.addSubview(titleLbl)
        view.addSubview(bodyLbl)
        let imageHeight = view.bounds.width * 0.75
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            image.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            image.heightAnchor.constraint(equalToConstant: imageHeight),
        ])
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.leading.trailing.equalTo(image)
        }
        
        bodyLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(10)
            make.leading.trailing.equalTo(image)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}
