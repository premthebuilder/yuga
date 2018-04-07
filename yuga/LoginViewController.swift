//
//  LoginViewController.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 5/11/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let userModel = UserModel()
    
    @IBAction func login(_ sender: UIButton) {
        print("In login")
        if(email != nil && password != nil) {
            userModel.login(email!.text!, password!.text!, loginDone)
        }
    }
    
    func loginDone() {
        print("Yay! I am in.")
//        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainViewController") as! MainViewController
//        let navigationController = UINavigationController(rootViewController: mainViewController)
//        mainViewController.userModel = self.userModel
        
//        let homeViewController = HomeViewController()
//        let layout = UICollectionViewFlowLayout()
//        self.view.window!.rootViewController = UINavigationController(rootViewController: HomeViewController(collectionViewLayout: layout))
//
//        self.view.window!.rootViewController = MainTabBarController()
//        UINavigationBar.appearance().tintColor = UIColor.red
        self.automaticallyAdjustsScrollViewInsets = false;
        UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
        UIApplication.shared.statusBarStyle = .lightContent

//        UITabBar.appearance().tintColor = UIColor(red: 70, green: 146, blue: 250, alpha: 1)
//        UINavigationBar.appearance().barTintColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
//        self.navigationController?.pushViewController(HomeViewController(), animated: true)
//        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
//        let navigationController = UINavigationController(rootViewController: homeViewController)
//        self.present(navigationController, animated:true, completion:nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userModel.login("talk2premchand@gmail.com", "welcome123", loginDone)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

