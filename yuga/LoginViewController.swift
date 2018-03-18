//
//  LoginViewController.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 5/11/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate,UINavigationControllerDelegate {

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
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainViewController") as! MainViewController
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let navigationController = UINavigationController(rootViewController: mainViewController)
        mainViewController.userModel = self.userModel
//        appDelegate.window?.rootViewController = mainViewController
        self.present(navigationController, animated:true, completion:nil)
        
    }
    
//    @IBAction func signUp(_ sender: UIButton) {
//
////        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "signUpViewController") as! SignUpViewController
////
////        let navigationController = UINavigationController(rootViewController: signUpViewController)
////
////          self.present(navigationController, animated:true, completion:nil)
////        self.navigationController?.pushViewController(signUpViewController, animated: true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("overriding viewwillappear")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.navigationItem.leftItemsSupplementBackButton = true
        
    }


}

