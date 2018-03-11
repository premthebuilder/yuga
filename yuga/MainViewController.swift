 //
 //  MainViewController.swift
 //  yuga
 //
 //  Created by PREMCHAND CHIDIPOTI on 5/29/17.
 //  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
 //
 
 import UIKit
 import DropDown
 import CoreLocation
 import SwiftSoup
 
 typealias Proc = () -> ()
 
 class MainViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{
    
    //MARK: - Properties

    var location : CLLocation? = nil
    let locationManager = CLLocationManager()
    @IBOutlet weak var newsList: UICollectionView!
    var userModel: UserModel!
    let storyModel = StoryModel()
    let itemModel = ItemModel()
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController:  nil)

    func setupUserOptionsDropDown(anchorView: UIBarButtonItem) {
        userOptionsDropDown.anchorView = anchorView
        userOptionsDropDown.dataSource = ["Logout"]
        userOptionsDropDown.bottomOffset = CGPoint(x: 0, y:(userOptionsDropDown.anchorView?.plainView.bounds.height)!)
        userOptionsDropDown.selectionAction = { [unowned self] (index, item) in
            switch item {
            case "Logout":
                self.logout()
            default:
                print("No action defined for " + item)
            }
        }
    }
    
    func setupNavBar(){
        let userOptionsIcon = UIImage(named: "icons8-User-30")
        let userOptions = UIBarButtonItem(image: userOptionsIcon, style: UIBarButtonItemStyle.plain, target: self, action: #selector(onUserOptions))
//        userOptions.customView = UIView()
        let toolbarItems = [userOptions]
        self.navigationItem.rightBarButtonItems = toolbarItems
//        setupUserOptionsDropDown(anchorView: userOptions)
    }
    
    @objc func onUserOptions(_ sender: Any) {
        userOptionsDropDown.show()
    }
    
    //MARK: - DropDowns
    let userOptionsDropDown = DropDown()
    
    //MARK: - Actions
    @IBAction func showUserOptionsDropDown(_ sender: UIButton) {
        userOptionsDropDown.show()
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
    }

    func logout() {
        userModel.logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [AnyObject]()

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
        
//        if let storyItems = currentItem.value(forKey: "items") as? [NSDictionary] {
//            let objectUrl = parseImageUrlFromHtml((currentItem.value(forKey: "text") as? String)!)
//            if (objectUrl != nil) {itemModel.downloadImage(objectUrl as! String, cell.storyImage)}
//        }

        cell.storyText.text = currentItem.value(forKey: "text") as? String
        cell.storyTitle.text = currentItem.value(forKey: "title") as? String
        let objectUrl = parseImageUrlFromHtml((currentItem.value(forKey: "text") as? String)!)
        if (objectUrl != nil && !objectUrl.isEmpty) {itemModel.downloadImage(objectUrl as! String, cell.storyImage)}
        // make cell more visible in our example project
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let storyDict = self.items[indexPath.item] as! NSDictionary
//        let controller = EditorController(storyDict.value(forKey: "text") as! String, storyDict.value(forKey: "title") as? String)
        let controller = EditorController(storyDict.value(forKey: "text") as! String, storyDict.value(forKey: "title") as! String)
        self.navigationController?.pushViewController(controller, animated: true)
        
//        let newStoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "newStoryViewController") as? NewStoryViewController
//        newStoryViewController?.storyDict = (self.items[indexPath.item] as! NSDictionary).mutableCopy() as! NSMutableDictionary
//        self.navigationController?.pushViewController(newStoryViewController!, animated: true)
    }
    
    func parseImageUrlFromHtml(_ html: String) -> String{
        do {
            let doc: Document = try SwiftSoup.parse(html)
            if(try! doc.select("a").size() > 0) {
            let link: Element = try! doc.select("a").first()!
            
            let text: String = try! doc.body()!.text(); // "An example link"
            let linkHref: String = try! link.attr("href");
                return linkHref}
            return("")
        } catch Exception.Error(let type, let message) {
            return("")
        } catch {
            return("")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            print(searchText)
            storyModel.searchStories(searchString: searchText, populatedItems)
        }
        else {
            storyModel.getAllStories(populatedItems)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            print(searchText)
            }
         else {}
    }

    
    @IBAction func useCamera(_ sender: Any) {
        
//        let newStoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "newStoryViewController") as? NewStoryViewController
//        if (self.location != nil){
//            let locationList = [["latitude" : self.location?.coordinate.latitude, "longitude" : self.location?.coordinate.longitude]]
//            newStoryViewController?.storyDict.setValue(locationList, forKey: "locationList")
//        }
//        self.navigationController?.pushViewController(newStoryViewController!, animated: true)
        
        let controller: EditorController
        controller = EditorController()
        self.navigationController?.pushViewController(controller, animated: true)
//        if var topController = UIApplication.shared.keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//            let newStoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "newStoryViewController") as? NewStoryViewController
//            topController.present(newStoryViewController!, animated:true, completion:nil)
//            // topController should now be your topmost view controller
//        }

    }
    
    func populatedItems(getStoryResponse: NSDictionary) {
        self.items = getStoryResponse.value(forKey: "results") as! [NSMutableDictionary]
        self.newsList.reloadData()
    }
    
    func setupSearchBar() {
        
//        // Set search bar position and dimensions
//        var searchBarFrame: CGRect = self.searchController.searchBar.frame
//        var viewFrame = self.view.frame
//        self.searchController.searchBar.frame =  CGRect(origin: CGPoint(x:searchBarFrame.origin.x, y:searchBarFrame.origin.y + 4),size: viewFrame.size)
//        
//        
//        // Add search controller's search bar to our view and bring it to forefront
        self.view.addSubview(self.searchController.searchBar)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations[0]
    }
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
//        storyModel.getAllStories(self.populatedItems)
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
    
        self.navigationItem.titleView = searchController.searchBar
        
//        self.setupSearchBar()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.storyModel.getAllStories(self.populatedItems)
        super.viewWillAppear(animated)
        setupUserOptionsDropDown(anchorView: self.navigationItem.rightBarButtonItems![0])
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigationid
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
 }
