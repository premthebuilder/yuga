//
//  MainTabBarController.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 3/24/18.
//  Copyright © 2018 PREMCHAND CHIDIPOTI. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
//        let homeViewController = HomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        let navigationController = UINavigationController(rootViewController: homeViewController)
//        navigationController.tabBarItem.image = UIImage(named: "icons8-home-page-26")
        
        let homeNVC = UINavigationController(rootViewController: HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        let bookmarksNVC = UINavigationController(rootViewController: UIViewController())
        let editorNVC = UINavigationController(rootViewController: EditorController())
        let profileNVC = UINavigationController(rootViewController: UIViewController())

        homeNVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icons8-home-page-26"), tag: 0)
        homeNVC.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -9, right: 0)
        bookmarksNVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icons8-bookmark-26"), tag: 1)
        bookmarksNVC.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -9, right: 0)
        editorNVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icons8-edit-file-26"), tag: 2)
        editorNVC.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -9, right: 0)
        profileNVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icons8-contacts-26"), tag: 3)
        profileNVC.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -9, right: 0)
        
        viewControllers = [homeNVC, bookmarksNVC, editorNVC, profileNVC]
        tabBar.isTranslucent = false
//        let topBorder = CALayer()
//        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
//        tabBar.layer.addSublayer(topBorder)
//        tabBar.clipsToBounds = true
    }
}
