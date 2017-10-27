//
//  StoryModel.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 7/4/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import Foundation

class StoryModel {
    
    let createStoryEndPoint = "create/story/"
    let getAllStoryEndPoint = "view/story/all/"
    let getStoryEndPoint = "view/story/"
    let updateStoryEndPoint = "update/story/"
    let searchStoryEndPoint = "storys/?search="
    let itemModel = ItemModel()
    
    func createStory(_ title: String, _ content: String, _ onComplete:@escaping ((_ storyId: Int)->Void) )  {
        let postData: NSDictionary = NSMutableDictionary()
        let postHeaders: NSDictionary = NSMutableDictionary()
        
        postData.setValue(title, forKey: "title")
        postData.setValue(content, forKey: "text")
        let authHeaderValue = "JWT " + UserDefaults.standard.string(forKey: "session")!
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        
        func onServerResponse(_ serverResponse : NSDictionary){
            print(serverResponse)
            print("Congrats, you just posted a story!")
            onComplete(serverResponse.value(forKey: "id") as! Int)
        }
        HttpModel.shared.postRequest(postData: postData, postHeaders: postHeaders, endPoint: createStoryEndPoint, onComplete: onServerResponse)
    }
    
    func updateStory(updateParams: NSDictionary, storyId: Int) {
        
    }
    
    func getAllStories(_ onComplete:@escaping ((_ getAllStoriesResponse: [NSDictionary])->Void)) {
        let postHeaders: NSDictionary = NSMutableDictionary()
        let authHeaderValue = "JWT " + UserDefaults.standard.string(forKey: "session")!
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        
        func onServerResponse(_ serverResponse : Data){
            let decodedResponse: Any?
            do {
                decodedResponse = try JSONSerialization.jsonObject(with: serverResponse, options: [])
                onComplete(decodedResponse as! [NSDictionary])
            }
            catch {
                return
            }
        }
        HttpModel.shared.getRequest(postHeaders, getAllStoryEndPoint, "", NSMutableDictionary(), onServerResponse)
    }
    
    func getStory(storyId: String, _ onComplete:@escaping ((_ getStoryResponse: NSDictionary)-> Void)) {
        var url = getStoryEndPoint + storyId + "/"
        let postHeaders: NSDictionary = NSMutableDictionary()
        let authHeaderValue = "JWT " + UserDefaults.standard.string(forKey: "session")!
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        
        func onServerResponse(_ serverResponse : Data){
            let decodedResponse: Any?
            do {
                decodedResponse = try JSONSerialization.jsonObject(with: serverResponse, options: [])
                onComplete(decodedResponse as! NSDictionary)
            }
            catch {
                return
            }
        }
        HttpModel.shared.getRequest(postHeaders, url, "", NSMutableDictionary(), onServerResponse)
    }
    
    func searchStories(searchString:String, _ onComplete:@escaping ((_ getAllStoriesResponse: [NSDictionary])->Void)) {
        let postHeaders: NSDictionary = NSMutableDictionary()
        let queryParams: NSDictionary = NSMutableDictionary()
        queryParams.setValue(searchString, forKey: "search")
        let authHeaderValue = "JWT " + UserDefaults.standard.string(forKey: "session")!
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        
        func onServerResponse(_ serverResponse : Data){
            let decodedResponse: Any?
            do {
                decodedResponse = try JSONSerialization.jsonObject(with: serverResponse, options: [])
                onComplete(decodedResponse as! [NSDictionary])
            }
            catch {
                return
            }
        }
        HttpModel.shared.getRequest(postHeaders, getAllStoryEndPoint, "", queryParams, onServerResponse)
    }
}
