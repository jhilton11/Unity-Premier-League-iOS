//
//  CarouselCell.swift
//  Unity Premier League
//
//  Created by student on 2024-03-31.
//  Copyright © 2024 Appify Mobile Apps. All rights reserved.
//

import UIKit
import SnapKit

class CarouselCell: UICollectionViewCell {
    
    static var identifier = "carousel-cell"
    
    lazy var carouselImage: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    lazy var messageLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with carousel: Carousel) {
        carouselImage.loadImage(imageUrl: carousel.imgUrl)
        messageLbl.text = carousel.message
    }
    
    private func setConstraints() {
        contentView.addSubview(carouselImage)
        contentView.addSubview(messageLbl)
        
        carouselImage.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
//            make.trailing.equalToSuperview()
        }
        
        messageLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
}

struct Carousel: Codable {
    let imgUrl: String
    let message: String
}
