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
 
 class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK: - Properties
    @IBOutlet weak var userOptions: UIButton!
    
    var userModel: UserModel!
    
    var selectedImage: UIImage!
    
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
    
    @IBAction func useCamera(_ sender: Any) {
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let newStoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "newStoryViewController") as? NewStoryViewController
            topController.present(newStoryViewController!, animated:true, completion:nil)
            // topController should now be your topmost view controller
        }
        
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        
//        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                imagePickerController.sourceType = .camera
//                self.present(actionSheet, animated: true, completion: nil)
//            }
//            else {
//                print("Camera not available")
//            }
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
//            self.present(imagePickerController, animated: true, completion: nil)}))
//        
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(actionSheet, animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        picker.delegate = self
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            selectedImage = image
//            newStoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "newStoryViewController") as? NewStoryViewController
//            
//            newStoryViewController?.imageToAdd = image
//            
//            if var topController = UIApplication.shared.keyWindow?.rootViewController {
//                while let presentedViewController = topController.presentedViewController {
//                    topController = presentedViewController
//                }
//                topController.present(newStoryViewController!, animated:true, completion:nil)
//                // topController should now be your topmost view controller
//            }
//        } else{
//            print("Something went wrong")
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserOptionsDropDown()
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
