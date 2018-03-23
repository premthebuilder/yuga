//
//  ProfileViewController.swift
//  yuga
//
//  Created by Koumudhi Cheruku on 3/13/18.
//  Copyright © 2018 PREMCHAND CHIDIPOTI. All rights reserved.
//


import UIKit

class ProfileViewController: UIViewController {
    
    var userModel: UserModel!
    var profileModel = ProfileModel()
    var following_list = NSArray()
    var followers_list = NSArray()
    
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    
    override func viewDidLoad() {
        profileModel.getProfile(onGetProfile)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.addSubview(followersLabel)
        self.view.addSubview(followingLabel)
        
        let followingGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(followingTap))
        
        followingLabel.addGestureRecognizer(followingGestureRecognizer)
        
        let followersGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(followersTap))
        
        followersLabel.addGestureRecognizer(followersGestureRecognizer)
    }
    
    @objc func followingTap(gestureRecognizer: UIGestureRecognizer) {
        print("label clicked")
        
        let flowLayout = UICollectionViewFlowLayout()
        let profileCollectionViewController = ProfileFollowersListViewController(collectionViewLayout : flowLayout)
        
        //let profileFollowersListViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileFollowersListViewController") as! ProfileFollowersListViewController
        
        _ = UINavigationController(rootViewController: profileCollectionViewController)
        profileCollectionViewController.userList = self.following_list
        self.navigationController?.pushViewController(profileCollectionViewController, animated: true)
    }
    
    @objc func followersTap(gestureRecognizer: UIGestureRecognizer) {
        print("label clicked")
        
        let flowLayout = UICollectionViewFlowLayout()
        let profileCollectionViewController = ProfileFollowersListViewController(collectionViewLayout : flowLayout)
        
        //let profileFollowersListViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileFollowersListViewController") as! ProfileFollowersListViewController
        
        _ = UINavigationController(rootViewController: profileCollectionViewController)
        profileCollectionViewController.userList = self.followers_list
        self.navigationController?.pushViewController(profileCollectionViewController, animated: true)
    }
    
    func submitPost(){
        print("nothing")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftItemsSupplementBackButton = true
        
    }
    
    func onGetProfile(response : NSDictionary) {
        let profile = response.value(forKey: "profile") as! NSDictionary
        print(profile)
        let username = profile.value(forKey: "username") as! String
        
        self.profileLabel.text = username
        let objectUrl = profile.value(forKey: "image")
        
        self.following_list = profile.value(forKey: "following") as! NSArray
        self.followers_list = profile.value(forKey: "followers") as! NSArray
        
        self.followingLabel.text = String(self.following_list.count) + " Following"
        self.followersLabel.text = String(self.followers_list.count) + " Followers"
        
        if (objectUrl != nil ) {profileModel.downloadImage(objectUrl as! String, self.imageView)}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


