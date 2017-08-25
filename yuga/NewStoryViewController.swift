//
//  NewStoryViewController.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 6/18/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import UIKit

class NewStoryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let storyModel = StoryModel()
    let itemModel = ItemModel()
    
    @IBOutlet weak var storyTitle: UITextField!
    @IBOutlet weak var storyContent: UITextView!
    @IBAction func createStory(_ sender: UIButton) {
        storyModel.createStory(storyTitle.text!, storyContent.text, uploadImage)
    }
    func uploadImage(_ storyId: Int) {
        itemModel.uploadImage(storyId, imageView.image!)
    }
    @IBOutlet weak var imageView: UIImageView!
    var imageToAdd: UIImage?
    
    override func viewDidAppear(_ animated: Bool) {
        if (imageView.image == nil) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                // topController should now be your topmost view controller
                let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        imagePickerController.sourceType = .camera
                        topController.present(imagePickerController, animated: true, completion: nil)
                    }
                    else {
                        print("Camera not available")
                    }
                }))
                actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
                    topController.present(imagePickerController, animated: true, completion: nil)}))
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                //        self.view.addSubview(actionSheet.view!)        // Do any additional setup after loading the view.
                topController.present(actionSheet, animated: true, completion: nil)
            }
        }
        super.viewDidAppear(animated)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.delegate = self
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        } else{
            print("Something went wrong")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
