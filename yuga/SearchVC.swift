//
//  SearchVC.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 3/13/18.
//  Copyright © 2018 PREMCHAND CHIDIPOTI. All rights reserved.
//

import Foundation
import UIKit

class SearchVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var items = [AnyObject]()
    let itemModel = ItemModel()
    let storyModel = StoryModel()
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configureSearchController()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        self.searchController.searchBar.sizeToFit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        self.navigationItem.titleView = self.searchController.searchBar;
        
//        searchController.searchBar.scopeButtonTitles = ["Articles", "Location", "Users"]
        searchController.searchBar.delegate = self
//        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.sizeToFit()
        searchController.definesPresentationContext = true
    }
    
    
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        searchController.searchBar.showsScopeBar = true
//        searchController.searchBar.sizeToFit()
//        return true
//    }
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchController.searchBar.showsScopeBar = false
//        searchController.searchBar.sizeToFit()
//    }
    
    
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
////        navigationController?.setNavigationBarHidden(false, animated: true)
////        searchController.searchBar.sizeToFit()
//        searchController.searchBar.showsScopeBar = false
//        searchController.searchBar.sizeToFit()
//        return true
//    }
    
    func filterSearchController(_ searchBar: UISearchBar) {
        if(!(searchBar.text?.trimmingCharacters(in: .whitespaces).isEmpty)!) {
            storyModel.searchStories(searchString: searchBar.text!, populatedItems)
            collectionView?.reloadData()
        } else {
            self.items = [AnyObject]()
            collectionView?.reloadData()
        }
    }
    
    func setupCollectionView(){
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(StoryCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.contentSize = CGSize(width: 1000, height: 1000)
//        storyModel.getAllStories(self.populatedItems)
//        collectionView?.reloadData()
    }
    
    func populatedItems(getStoryResponse: NSDictionary) {
        self.items = getStoryResponse.value(forKey: "results") as! [NSMutableDictionary]
        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! StoryCell
        let currentItem = self.items[indexPath.item]
        cell.articleTitleLabel.text = currentItem.value(forKey: "title") as? String
        let userInfo = currentItem.value(forKey: "author") as! NSDictionary
        cell.userInfoLabel.text = userInfo.value(forKey: "username") as? String
        let objectUrl = EditorUtil.parseImageUrlFromHtml((currentItem.value(forKey: "text") as? String)!)
        if (!objectUrl.isEmpty) {self.itemModel.downloadImage(objectUrl , cell.thumbnailImageView)}
        // make cell more visible in our example project
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyDict = self.items[indexPath.item] as! NSDictionary
        //        let controller = EditorController(storyDict.value(forKey: "text") as! String, storyDict.value(forKey: "title") as? String)
        let controller = EditorController(storyDict.value(forKey: "text") as! String, storyDict.value(forKey: "title") as? String)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  self.view.frame.size.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

//extension SearchVC : UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath)
//        let pokemon = searchController.isActive ? filteredPokemonList[indexPath.row] : pokemonList[indexPath.row]
//        cell.textLabel!.text = pokemon.name
//        cell.detailTextLabel?.text = pokemon.element.rawValue
//        cell.imageView!.image = pokemon.image
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchController.isActive ? filteredPokemonList.count : pokemonList.count
//    }
//
//}

extension SearchVC : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterSearchController(searchController.searchBar)
    }
    
}

extension SearchVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterSearchController(searchBar)
    }
    
}
