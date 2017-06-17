//
//  MainViewController.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 5/29/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import UIKit
import DropDown

typealias Proc = () -> ()

class MainViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var userOptions: UIButton!
    
    var userModel: UserModel!

    //MARK: - DropDowns
    let userOptionsDropDown = DropDown()
    
    //MARK: - Actions
    @IBAction func showUserOptionsDropDown(_ sender: UIButton) {
        userOptionsDropDown.show()
    }
    
    func logout() {
        userModel.logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUserOptionsDropDown() {
        userOptionsDropDown.anchorView = userOptions
        userOptionsDropDown.dataSource = ["Logout"]
        userOptionsDropDown.bottomOffset = CGPoint(x: 0, y: userOptions.bounds.height)
        userOptionsDropDown.selectionAction = { [unowned self] (index, item) in
            switch item {
            case "Logout":
                self.logout()
            default:
                print("No action defined for " + item)
            }
        }
    }
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserOptionsDropDown()
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
