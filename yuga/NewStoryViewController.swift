//
//  NewStoryViewController.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 6/18/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import UIKit

class NewStoryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var storyDict: NSMutableDictionary = [:]
    let storyModel = StoryModel()
    let itemModel = ItemModel()
    
    // Nav bar Items
    func setupNavBar() {
        let addMoreIcon = UIImage(named: "icons8-Plus Math-30")
        let addMore = UIBarButtonItem(image: addMoreIcon, style: UIBarButtonItemStyle.plain, target: self, action: #selector(onAddMore))
        let toolbarItems = [addMore]
        self.navigationItem.rightBarButtonItems = toolbarItems
    }
    
    
    @IBOutlet weak var storyTitle: UITextField!
    @IBOutlet weak var storyContent: UITextView!
    @IBOutlet weak var storyTags: UITextField!
    @IBOutlet weak var post: UIButton!
    
    @IBAction func createStory(_ sender: UIButton) {
        storyDict.setValue(storyTitle.text!, forKey: "title")
        storyDict.setValue(storyContent.text!, forKey: "text")
        storyDict.setValue(storyTags.text!, forKey: "tags")
        storyModel.createStoryWithTags(storyDict, uploadImage)
        _ = navigationController?.popViewController(animated: true)
    }
    func uploadImage(_ storyId: Int) {
        itemModel.uploadImage(storyId, imageView.image!)
    }
    @IBOutlet weak var imageView: UIImageView!
    var imageToAdd: UIImage?
    
    @IBOutlet weak var approveButton: UIButton!
    
    @IBAction func onApproveButton(_ sender: UIButton) {
        func onApproveStoryReponse(story: NSDictionary){
            storyDict.setValue(story.value(forKey: "approvals") as! NSArray, forKey: "approvals")
        }
        storyModel.approveStory(storyId: self.storyDict.value(forKey: "id") as! Int, onComplete: onApproveStoryReponse)
    }
    
    @IBOutlet weak var flagButton: UIButton!
    
    @IBAction func onFlagButton(_ sender: UIButton) {
    }
    
    func onAddMore(_ sender: UIBarButtonItem!) {
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func pickImage() {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false 
        
        view.addGestureRecognizer(tap)
        let storyIdStr = self.storyDict.value(forKey: "id")
        if ((storyIdStr) != nil) {
            storyModel.getStory(storyId: String(storyIdStr as! Int), onGetStory)
            self.setupNavBar()
            self.post.isHidden = true
        }
        else{
            pickImage()
        }
    }
    
    func onGetStory(response: NSDictionary) {
        self.storyTitle.text = response.value(forKey: "title") as! String
        self.storyContent.text = response.value(forKey: "text") as! String
        self.storyTags.text = (response.value(forKey: "tags") as! NSArray).componentsJoined(by: ",")
        if let storyItems = response.value(forKey: "items") as? [NSDictionary] {
            let objectUrl = storyItems.first?.value(forKey: "source_url")
            if (objectUrl != nil) {itemModel.getImage(objectUrl as! String, self.imageView)}
        }
        self.approveButton.setTitle(String((response.value(forKey: "approvals") as! NSArray).count), for: .normal)
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
