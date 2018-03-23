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
    let profileFollowEndPoint = "api/profiles/"
    
    
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
    
    func unFollowUser(username : String, _ onComplete:@escaping ((_ getAllProfilesResponse: NSDictionary)->Void)) {
        //let postData: NSDictionary = NSMutableDictionary()
        let postHeaders: NSDictionary = NSMutableDictionary()
        let authHeaderValue = "Token " + UserDefaults.standard.string(forKey: "session")!
        //postData.setValue(username, forKey: "username")
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        let profileUnFollowEndPoint = self.profileFollowEndPoint+username+"/follow/"
        print(profileUnFollowEndPoint)
        func onServerResponse(_ serverResponse : NSDictionary){
            print("Unfollowed profile")
            print(serverResponse)
            onComplete(serverResponse)
        }
        HttpModel.shared.deleteRequest(postHeaders: postHeaders, endPoint: profileUnFollowEndPoint, onComplete: onServerResponse)
        
    }
    
    func followUser(username : String, _ onComplete:@escaping ((_ getAllProfilesResponse: NSDictionary)->Void)) {
        let postData: NSDictionary = NSMutableDictionary()
        let postHeaders: NSDictionary = NSMutableDictionary()
        let authHeaderValue = "Token " + UserDefaults.standard.string(forKey: "session")!
        //postData.setValue(username, forKey: "username")
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        let profileFollowEndPoint = self.profileFollowEndPoint+username+"/follow/"
        print(profileFollowEndPoint)
        func onServerResponse(_ serverResponse : NSDictionary){
            print("Followed profile")
            print(serverResponse)
            onComplete(serverResponse)
        }
        HttpModel.shared.postRequest(postData: postData, postHeaders: postHeaders, endPoint: profileFollowEndPoint, onComplete: onServerResponse)
        
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
