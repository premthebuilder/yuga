//
//  ProfileModel.swift
//  yuga
//
//  Created by Koumudhi Cheruku on 3/14/18.
//  Copyright © 2018 PREMCHAND CHIDIPOTI. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

class ProfileModel {
    let profileEndPoint = "api/profile/"
    let downloadSessionUrlEndPoint = "api/download_session_url/"
    
    func getProfile(_ onComplete:@escaping ((_ getAllProfilesResponse: NSDictionary)->Void)) {
        let postHeaders: NSDictionary = NSMutableDictionary()
        let authHeaderValue = "Token " + UserDefaults.standard.string(forKey: "session")!
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        
        func onServerResponse(_ serverResponse : Data){
            print("getting profile")
            let decodedResponse: Any?
            do {
                decodedResponse = try JSONSerialization.jsonObject(with: serverResponse, options: [])
                onComplete(decodedResponse as! NSDictionary)
            }
            catch {
                return
            }
        }
        HttpModel.shared.getRequest(postHeaders, profileEndPoint, "", NSMutableDictionary(), onServerResponse)
    }
    
    func downloadImageUsingSessionUrl(_ imageMeta: NSDictionary) {
        print(imageMeta)
        let postHeaders: NSDictionary = NSMutableDictionary()
        let downloadSessionUrl: NSDictionary = imageMeta.value(forKey: "download_session_url") as! NSDictionary
        let getUrl = downloadSessionUrl.value(forKey: "baseUrl")
        let queryParams = downloadSessionUrl.value(forKey: "queryParams")
        var imageView: UIImageView? = nil
        if (imageMeta.value(forKey: "imageView") != nil){
            imageView = imageMeta.value(forKey: "imageView") as! UIImageView
        }
        func onServerResponse(_ serverResponse : Any?){
            if imageView != nil {
                print("imageview is not nil")
                imageView?.image = UIImage(data: serverResponse as! Data)!
            }
        }
        HttpModel.shared.getRequest(postHeaders, "", getUrl as! String, queryParams as! NSDictionary, onServerResponse)
    }
    
    func getSessionUrlToDownloadItem(_ objectName: String, _ imageView: UIImageView, _ onComplete: @escaping ((NSDictionary)->Void))  {
        let postHeaders: NSDictionary = NSMutableDictionary()
        let postData: NSDictionary = NSMutableDictionary()
        postData.setValue(objectName, forKey: "objectName")
        func onServerResponse(_ serverResponse : Any?){
            let decodedResponse = serverResponse as! NSDictionary
            onComplete(decodedResponse)
        }
        let callbackParams = NSMutableDictionary()
        callbackParams.setValue(imageView, forKey: "imageView")
        HttpModel.shared.postRequest(postData: postData, postHeaders: postHeaders, endPoint: downloadSessionUrlEndPoint, onComplete: onServerResponse, callbackParams: callbackParams)
    }
    
    func getImage(_ objectName: String, _ imageView: UIImageView){
        if !objectName.isEmpty{
            print(objectName)
            getSessionUrlToDownloadItem(objectName, imageView, downloadImageUsingSessionUrl)}
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(_ urlStr: String, _ imageView: UIImageView) {
        let url = URL(string: urlStr)
        getDataFromUrl(url: url!) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url?.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    
}
