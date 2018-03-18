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
    
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    override func viewDidLoad() {
        profileModel.getProfile(onGetProfile)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.addSubview(followersLabel)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        followersLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        print("label clicked")
        
        let flowLayout = UICollectionViewFlowLayout()
        let profileCollectionViewController = ProfileFollowersListViewController(collectionViewLayout : flowLayout)
        
        //let profileFollowersListViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileFollowersListViewController") as! ProfileFollowersListViewController
        
        _ = UINavigationController(rootViewController: profileCollectionViewController)
        
        //self.present(navigationController, animated:true, completion:nil)
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
        self.followersLabel.text = String(profile.value(forKey: "followers") as! Int) + " Following"
        self.followingLabel.text = String(profile.value(forKey: "following") as! Int) + " Followers"
        //if (object_url != nil) {profileModel.getImage(object_url as! String, self.imageView)}
        if (objectUrl != nil ) {profileModel.downloadImage(objectUrl as! String, self.imageView)}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


