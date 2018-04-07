//
//  ArticleListVC.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 3/13/18.
//  Copyright © 2018 PREMCHAND CHIDIPOTI. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup

class ArticleListVC: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var items: [AnyObject] = [{} as AnyObject]
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    let storyModel = StoryModel()
    let itemModel = ItemModel()
    var navigationController : UINavigationController? = nil;
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
}
