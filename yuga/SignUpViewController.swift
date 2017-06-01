//
//  SignUpViewController.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 5/29/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verifyPassword: UITextField!
    @IBOutlet weak var name: UITextField!
    
    let userModel = UserModel()
    
    @IBAction func signUp(_ sender: UIButton) {
        if(emailId != nil && password != nil &&
            verifyPassword != nil && password!.text! == verifyPassword!.text! && name != nil) {
            userModel.signUp(emailId!.text!, password!.text!, emailId!.text!, name!.text!, signUpDone)
        }
    }
    
    func signUpDone() {
        print("Yay! I am in.")
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainViewController") as! MainViewController
        self.present(mainViewController, animated:true, completion:nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
