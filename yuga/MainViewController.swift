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
 
 class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK: - Properties
    @IBOutlet weak var userOptions: UIButton!
    
    @IBOutlet weak var newsList: UICollectionView!
    var userModel: UserModel!
    let storyModel = StoryModel()
    let itemModel = ItemModel()
    
    
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
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items : [NSDictionary] = [["text":"test text", "title":"test title"]]

    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let currentItem = self.items[indexPath.item]
        
        if let storyItems = currentItem.value(forKey: "items") as? [NSDictionary] {
            let objectUrl = storyItems.first?.value(forKey: "source_url")
            if (objectUrl != nil) {itemModel.getImage(objectUrl as! String, cell.storyImage)}
        }
        
        cell.storyText.text = currentItem.value(forKey: "text") as? String
        cell.storyTitle.text = currentItem.value(forKey: "title") as? String
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
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

    }
    
    func populatedItems(getStoryResponse: [NSDictionary]) {
        self.items = getStoryResponse
        self.newsList.reloadData()
    }
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserOptionsDropDown()
        storyModel.getStory(populatedItems)
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
