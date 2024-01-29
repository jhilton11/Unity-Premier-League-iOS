//
//  NewsCell.swift
//  Unity Premier League
//
//  Created by APPLE on 10/6/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    static let identifier = "news-cell"
    
    lazy var imageIcon = ImageView(frame: .zero)
    
    lazy var titleLbl = Label(frame: .zero)
    
    lazy var bodyLbl: Label = {
        let label = Label(frame: .zero)
        
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        //imageIcon.image = nil
    }
    
    func configure(with news: News) {
        imageIcon.loadImage(imageUrl: news.imageUrl)
        titleLbl.text = news.title
        bodyLbl.attributedText = news.body?.htmlToAttributedString
    }
    
    private func setConstraints() {
        contentView.addSubview(imageIcon)
        contentView.addSubview(titleLbl)
        contentView.addSubview(bodyLbl)
        
        NSLayoutConstraint.activate([
            imageIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageIcon.widthAnchor.constraint(equalToConstant: 100),
            imageIcon.heightAnchor.constraint(equalToConstant: 100),
            
            titleLbl.topAnchor.constraint(equalTo: imageIcon.topAnchor, constant: 5),
            titleLbl.leadingAnchor.constraint(equalTo: imageIcon.trailingAnchor, constant: 10),
            titleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            bodyLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor),
            bodyLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            bodyLbl.trailingAnchor.constraint(equalTo: titleLbl.trailingAnchor),
            bodyLbl.bottomAnchor.constraint(equalTo: imageIcon.bottomAnchor, constant: -5),
        ])
    }

}
