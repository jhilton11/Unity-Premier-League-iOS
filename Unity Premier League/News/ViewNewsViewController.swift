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
    
    lazy var authorLbl: Label = {
        let label = Label()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.text = news?.author ?? ""
        return label
    }()
    
    lazy var dateLbl: Label = {
        let label = Label()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.text = news?.date?.formatDateToString() ?? ""
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
        view.addSubview(authorLbl)
        view.addSubview(dateLbl)
        let imageHeight = view.bounds.width * 0.75
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        image.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(0)
            make.leading.trailing.equalTo(titleLbl)
            make.height.equalTo(imageHeight)
        }
        
        authorLbl.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(5)
            make.leading.equalTo(image.snp.leading)
        }
        
        dateLbl.snp.makeConstraints { make in
            make.top.equalTo(authorLbl)
            make.trailing.equalTo(image)
        }
        
        bodyLbl.snp.makeConstraints { make in
            make.top.equalTo(authorLbl.snp.bottom).offset(10)
            make.leading.trailing.equalTo(titleLbl)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }

}
