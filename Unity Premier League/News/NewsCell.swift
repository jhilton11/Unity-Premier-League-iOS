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
    
    lazy var authorLbl: Label = {
        let label = Label(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = Theme.primaryColour
        return label
    }()
    
    lazy var titleLbl: Label = {
        let label = Label(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var dateLbl: Label = {
        let label = Label(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
//        label.textColor = .lightGray
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
        imageIcon.image = nil
    }
    
    func configure(with news: News) {
        imageIcon.loadImage(imageUrl: news.imageUrl)
        authorLbl.text = news.author
        titleLbl.text = news.title
        dateLbl.text = news.date?.formatDateToString()
    }
    
    private func setConstraints() {
        contentView.addSubview(imageIcon)
        contentView.addSubview(authorLbl)
        contentView.addSubview(titleLbl)
        contentView.addSubview(dateLbl)
        
        NSLayoutConstraint.activate([
            imageIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageIcon.widthAnchor.constraint(equalToConstant: 100),
            imageIcon.heightAnchor.constraint(equalToConstant: 100),
            
            authorLbl.topAnchor.constraint(equalTo: imageIcon.topAnchor, constant: 5),
            authorLbl.leadingAnchor.constraint(equalTo: imageIcon.trailingAnchor, constant: 10),
            authorLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            titleLbl.topAnchor.constraint(equalTo: authorLbl.bottomAnchor, constant: 5),
            titleLbl.leadingAnchor.constraint(equalTo: authorLbl.leadingAnchor),
            titleLbl.trailingAnchor.constraint(equalTo: authorLbl.trailingAnchor),
            
//            dateLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 0),
            dateLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            dateLbl.trailingAnchor.constraint(equalTo: titleLbl.trailingAnchor),
            dateLbl.bottomAnchor.constraint(equalTo: imageIcon.bottomAnchor, constant: 0),
        ])
    }

}
