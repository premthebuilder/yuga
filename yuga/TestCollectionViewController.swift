//
//  TestCollectionViewController.swift
//  yuga
//
//  Created by Koumudhi Cheruku on 3/17/18.
//  Copyright © 2018 PREMCHAND CHIDIPOTI. All rights reserved.
//

import Foundation
import UIKit

//class TestCollectionViewController : UICollectionViewController  {
//    
//    let customCellIdentifier = "customCellIdentifier"
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//        
//        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier : customCellIdentifier)
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath)
//        return customCell
//    }
//    
//}
//
//class CustomCell: UICollectionViewCell {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setUpViews()
//    }
//    
//    let nameLabel : UILabel = {
//        let label = UILabel()
//        label.text = "Custom Text"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    func setUpViews() {
//        addSubview(nameLabel)
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel]))
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("Init has not been implemented")
//    }
//    
//}

