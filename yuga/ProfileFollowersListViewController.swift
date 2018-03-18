//
//  ProfileFollowersListViewController.swift
//  yuga
//
//  Created by Koumudhi Cheruku on 3/17/18.
//  Copyright © 2018 PREMCHAND CHIDIPOTI. All rights reserved.
//

import Foundation
import UIKit

class ProfileFollowersListViewController :  UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    
    let customCellIdentifier = "customCellIdentifier"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier : customCellIdentifier)
    }
    let names = ["test1","test2","test3"]
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as! CustomCell
        customCell.nameLabel.text = names[indexPath.item]
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 100)
    }
    
}

class CustomCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Custom Text"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setUpViews() {
        backgroundColor = UIColor.red
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init has not been implemented")
    }
    
}
