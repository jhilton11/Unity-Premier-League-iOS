//
//  FirstViewController.swift
//  Unity Premier League
//
//  Created by APPLE on 10/6/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Firebase

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var currentPage = 0
    private var carouselPages = [Carousel]()
    
    let timingInterval = 10.0
    
    var height: CGFloat {
        return view.bounds.width * 0.7
    }
    
    private var carouselIndexPath: IndexPath?
    
    var timer = Timer()
    
    lazy var carouselView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let table = UICollectionView(frame: .zero, collectionViewLayout: layout)
        table.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.isPagingEnabled = true
        table.backgroundColor = .clear
        table.showsHorizontalScrollIndicator = false
        return table
    }()
    
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
        control.pageIndicatorTintColor = .gray
        control.currentPageIndicatorTintColor = .blue
        control.backgroundColor = .white.withAlphaComponent(0.5)
        return control
    }()

    var newsArray: [News] = []
    lazy var newsTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        view.addSubview(table)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        title = "News"
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNews()
        loadCarousels()
    }
    
    private func setConstraints() {
        view.addSubview(carouselView)
        view.addSubview(pageControl)
        view.addSubview(newsTable)
        
        carouselView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(height)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(carouselView.snp.bottom)
            make.centerX.equalToSuperview()
//            make.height.equalTo(30)
        }
        
        newsTable.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func pageChanged() {
        
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: timingInterval, target: self, selector: #selector(updatePage), userInfo: nil, repeats: true)
    }

    private func loadNews() ->Void {
        let db = Firestore.firestore()
        
        db.collection("news")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener {querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    print("Error: \(error)")
                    return
                }
                
                //print("News collection has \(querySnapshot?.count) news items")
                
                self.newsArray = []
                
                for document in snapshots {
                    let id = document.data()["id"] as! String
                    let name = document.data()["title"] as! String
                    let imageUrl = document.data()["imgUrl"] as? String ?? ""
                    let body = document.data()["body"] as? String ?? ""
                    
                    let news = News(id: id, title: name, imageUrl: imageUrl, body: body)
                    print(news)
                    self.newsArray.append(news);
                }
                
                self.newsTable.reloadData()
        }
    }
    
    private func loadCarousels() ->Void {
        let db = Firestore.firestore()
        
        db.collection("carousel")
//            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self]
                querySnapshot, error in
                guard let snapshots = querySnapshot?.documents else {
                    print("Error: \(error)")
                    return
                }
                
                //print("News collection has \(querySnapshot?.count) news items")
                
                self?.carouselPages = []
                
                for document in snapshots {
                    let id = document.data()["id"] as! String
                    let imgUrl = document.data()["imgUrl"] as! String
                    let message = document.data()["message"] as! String
                    
                    let carousel = Carousel(imgUrl: imgUrl, message: message)
                    print(carousel)
                    self?.carouselPages.append(carousel);
                }
                
                self?.pageControl.numberOfPages = self!.carouselPages.count
                self?.carouselView.reloadData()
                self?.startTimer()
        }
    }
    
    @objc private func updatePage() {
        currentPage += 1
        currentPage = currentPage >= carouselPages.count ? 0 : currentPage
        let i = IndexPath(item: currentPage, section: 0)
        carouselView.scrollToItem(at: i, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentPage
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as! NewsCell
        let news = newsArray[indexPath.row]
        cell.configure(with: news)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewNewsViewController()
        vc.news = newsArray[indexPath.row]
        Util.pushToNavigationController(navC: navigationController, vc: vc)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}

extension NewsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselPages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.identifier, for: indexPath) as! CarouselCell
        carouselIndexPath = indexPath
        let carousel = carouselPages[indexPath.row]
        cell.configure(with: carousel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width - 20
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        currentPage = Int(scrollView.contentOffset.x/width)
        
        if (currentPage >= carouselPages.count) {
            currentPage = 0
            let i = IndexPath(item: 0, section: 0)
            carouselView.scrollToItem(at: i, at: .centeredHorizontally, animated: true)
        }
        pageControl.currentPage = currentPage
    }
}
