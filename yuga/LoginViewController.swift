//
//  LoginViewController.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 5/11/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let userModel = UserModel()
    
    @IBAction func login(_ sender: UIButton) {
        print("In login")
        if(userName != nil && password != nil) {
            userModel.login(userName!.text!, password!.text!, loginDone)
        }
    }
    
    func loginDone() {
        print("Yay! I am in.")
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainViewController") as! MainViewController
        mainViewController.userModel = self.userModel
        self.present(mainViewController, animated:true, completion:nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

