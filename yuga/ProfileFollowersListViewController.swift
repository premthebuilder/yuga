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
    var profileModel = ProfileModel()
    var userList = NSArray()
    let customCellIdentifier = "customCellIdentifier"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("User list is ",self.userList)
        
        // Do any additional setup after loading the view.
        collectionView?.backgroundColor = UIColor(white : 0.95, alpha : 1)
        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier : customCellIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as! CustomCell
        
        let currentItem = self.userList[indexPath.item] as! NSDictionary
        customCell.nameLabel.text = (currentItem.value(forKey: "username") as! String)
        let imageUrl = currentItem.value(forKey: "image") as! String
        print("Image url is ", imageUrl)
        if(imageUrl != ""){ profileModel.downloadImage(imageUrl, customCell.profileImageView) }
        
        let isFollowing = currentItem.value(forKey: "is_following") as! Bool
        
        if(isFollowing == true){
            customCell.followLabel.text = "Following"
            customCell.followLabel.backgroundColor = UIColor.green
        }
        else{
            customCell.followLabel.text = "Follow"
            customCell.followLabel.backgroundColor = UIColor.gray
        }
        
        return customCell
    }
    
    @objc func followAction(sender : UIButton!){
        print("Hello Edit Button")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView!.frame.size.width - 20, height:70)
    }
    
}

class CustomCell: UICollectionViewCell {
    var profileModel = ProfileModel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    let profileImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Custom Text"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.green
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Following"
        return label
    }()
    
    func setUpViews() {
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(followLabel)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        followLabel.isUserInteractionEnabled = true
        followLabel.addGestureRecognizer(gestureRecognizer)
        
        addConstraintsWithFormat(format: "H:|-18-[v0(44)]-8-[v1(150)]-8-[v2]-18-|", views : profileImageView, nameLabel, followLabel)
        //addConstraintsWithFormat(format: "H:|-18-[v0(44)]-8-[v1(150)]|", views : profileImageView, nameLabel)
        addConstraintsWithFormat(format : "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format : "V:|-8-[v0(44)]|", views: profileImageView)
        addConstraintsWithFormat(format : "V:|-25-[v0(20)]|", views: followLabel)
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        
        if(followLabel.text == "Following"){
            followLabel.text = "Follow"
            followLabel.backgroundColor = UIColor.gray
            profileModel.unFollowUser(username: nameLabel.text!, onUnFollow)
        }
        else{
            followLabel.text = "Following"
            followLabel.backgroundColor = UIColor.green
            profileModel.followUser(username: nameLabel.text!, onFollow)
        }
        
    }
    
    func onUnFollow(serverResponse : NSDictionary){
        print("UnFollow done!!!")
    }
    
    func onFollow(serverResponse : NSDictionary){
        print("Follow done!!!")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init has not been implemented")
    }
    
}

extension UIView{
    
    func addConstraintsWithFormat(format : String, views : UIView...){
        var viewsDictionary = [String : UIView]()
        for(index,view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
