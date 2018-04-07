//
//  HomeViewController.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 3/16/18.
//  Copyright © 2018 PREMCHAND CHIDIPOTI. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var items = [AnyObject]()
    let itemModel = ItemModel()
    let storyModel = StoryModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "STREET"
        self.automaticallyAdjustsScrollViewInsets = false;
        
        setupCollectionView()
        setupNavBar()
    }
    
    func buildStreetLabel() -> UILabel {
        let frame  = CGRect(x: 0, y: 0, width: 200, height: 44)
        let label = UILabel();
        label.backgroundColor = UIColor.clear;
        label.font = UIFont(name: "Helvetica", size:8.0)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white;
        label.text = "STREET";
        return label;
    }
    
    func setupCollectionView(){
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(StoryCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.contentSize = CGSize(width: 1000, height: 1000)
        storyModel.getAllStories(self.populatedItems)
        collectionView?.reloadData()
    }
    
    func setupNavBar() {
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        navigationItem.rightBarButtonItems = [search]
    }
    
    @objc func searchTapped() {
        navigationController?.pushViewController(SearchVC(collectionViewLayout: UICollectionViewFlowLayout()), animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView?.reloadData()
    }
    
    func populatedItems(getStoryResponse: NSDictionary) {
        self.items = getStoryResponse.value(forKey: "results") as! [NSMutableDictionary]
        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! StoryCell
        let currentItem = self.items[indexPath.item]
        cell.articleTitleLabel.text = currentItem.value(forKey: "title") as? String
        let userInfo = currentItem.value(forKey: "author") as! NSDictionary
        cell.userInfoLabel.text = userInfo.value(forKey: "username") as! String
        let objectUrl = EditorUtil.parseImageUrlFromHtml((currentItem.value(forKey: "text") as? String)!)
        if (objectUrl != nil && !objectUrl.isEmpty) {self.itemModel.downloadImage(objectUrl as! String, cell.thumbnailImageView)}
        // make cell more visible in our example project
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyDict = self.items[indexPath.item] as! NSDictionary
        //        let controller = EditorController(storyDict.value(forKey: "text") as! String, storyDict.value(forKey: "title") as? String)
        let controller = EditorController(storyDict.value(forKey: "text") as! String, storyDict.value(forKey: "title") as! String)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  self.view.frame.size.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

class StoryCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let articleTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
//        label.backgroundColor = UIColor.yellow
        return label
    }()
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor.blue
        return imageView
    }()
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icons8-customer-30")
//        imageView.backgroundColor = UIColor.green
        return imageView
    }()
    let userInfoLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = UIColor.red
        return label
    }()
    let articleMetaLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = UIColor.red
        return label
    }()
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(userInfoLabel)
        addSubview(articleMetaLabel)
        addSubview(articleTitleLabel)
        //Horizontal Constraints
        addConstraintsWithFormat(format: "H:|-10-[v0(250)][v1]-10-|", views: articleTitleLabel, thumbnailImageView)
        addConstraintsWithFormat(format: "H:|-10-[v0(30)]-5-[v1]-10-|", views: userProfileImageView, userInfoLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: separatorView)
//        addConstraintsWithFormat(format: "H:|[v0]-10-|", views: userInfoLabel)
        //Vertical Constraints
        addConstraintsWithFormat(format: "V:|-5-[v0(30)]-8-[v1]-10-[v2(1)]|" , views: userProfileImageView, articleTitleLabel, separatorView)
        addConstraintsWithFormat(format: "V:|-5-[v0(30)]-[v1]-5-|", views: userInfoLabel, thumbnailImageView)
        //Relative Constraints
//        addConstraint(NSLayoutConstraint(item: userInfoLabel, attribute: .bottom, relatedBy: .equal, toItem: thumbnailImageView, attribute: .top, multiplier: 1, constant: 8))
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
}
