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
    let createStoryTagsEndPoint = "create_storytags/"
    let createTagsEndPoint = "create/tags/"
    let getAllStoryEndPoint = "view/story/all/"
    let getStoryEndPoint = "view/story/"
    let updateStoryBaseEndPoint = "update/story/"
    let searchStoryEndPoint = "storys/?search="
    let approveStoryEndPoint = "approve_story/"
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
    
    func createStoryWithTags(_ title: String, _ content: String, _ tags: String, _ onComplete:@escaping ((_ storyId: Int)->Void) )  {
        let postData: NSDictionary = NSMutableDictionary()
        let postHeaders: NSDictionary = NSMutableDictionary()
        postData.setValue(title, forKey: "title")
        postData.setValue(content, forKey: "text")
        postData.setValue(tags, forKey: "tags")
        let authHeaderValue = "JWT " + UserDefaults.standard.string(forKey: "session")!
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        
        func onServerResponse(_ serverResponse : NSDictionary){
            print(serverResponse)
            print("Congrats, you just posted a story!")
            onComplete(serverResponse.value(forKey: "id") as! Int)
        }
        HttpModel.shared.postRequest(postData: postData, postHeaders: postHeaders, endPoint: createStoryTagsEndPoint, onComplete: onServerResponse)
    }
    
    func updateStory(updateParams: NSDictionary, storyId: Int, onComplete:@escaping ((_ updateStoryResponse: NSDictionary)->Void)) {
        let updateStoryUrl = updateStoryBaseEndPoint + String(storyId) + "/"
        let postHeaders: NSDictionary = NSMutableDictionary()
        let authHeaderValue = "JWT " + UserDefaults.standard.string(forKey: "session")!
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")

        func onGetStory(getStoryResponse: NSDictionary){
            let mergedParams: NSDictionary = NSMutableDictionary()
            for (key, value) in updateParams {
                switch key as! String{
                case "approvedBy":
                    let approvals = getStoryResponse.value(forKey: "approvals") as! NSArray
                    approvals.adding(value as! Int)
                    mergedParams.setValue(approvals, forKey: "approvals")
                default:
                    print("No matching key Story parameter found for: " + (key as! String))
                }
            }
            HttpModel.shared.postRequest(postData: mergedParams, postHeaders: postHeaders, endPoint: updateStoryUrl, onComplete: onComplete)
        }
    }
    
    func createTags(tagsArray: NSArray, _ onComplete:@escaping ((_ tagNames: NSArray)->Void) ){
        let postData: NSDictionary = NSMutableDictionary()
        let postHeaders: NSDictionary = NSMutableDictionary()
        let authHeaderValue = "JWT " + UserDefaults.standard.string(forKey: "session")!
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        
        func onServerResponse(_ serverResponse : NSDictionary){
            print(serverResponse)
            print("Congrats, you have created tags!")
//            onComplete(serverResponse.value(forKey: "id") as! Int)
        }
        HttpModel.shared.postRequest(postData: postData, postHeaders: postHeaders, endPoint: createTagsEndPoint, onComplete: onServerResponse)
    }
    
    func approveStory(storyId: Int, onComplete:@escaping ((_ approveStoryResponse: NSDictionary)->Void)){
        let postData: NSDictionary = NSMutableDictionary()
        let postHeaders: NSDictionary = NSMutableDictionary()
        let authHeaderValue = "JWT " + UserDefaults.standard.string(forKey: "session")!
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        postData.setValue(storyId, forKey: "story_id")
        HttpModel.shared.postRequest(postData: postData, postHeaders: postHeaders, endPoint: approveStoryEndPoint, onComplete: onComplete)
    }
    
    func getAllStories(_ onComplete:@escaping ((_ getAllStoriesResponse: [NSMutableDictionary])->Void)) {
        let postHeaders: NSDictionary = NSMutableDictionary()
        let authHeaderValue = "JWT " + UserDefaults.standard.string(forKey: "session")!
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        
        func onServerResponse(_ serverResponse : Data){
            let decodedResponse: Any?
            do {
                decodedResponse = try JSONSerialization.jsonObject(with: serverResponse, options: [])
                onComplete(decodedResponse as! [NSMutableDictionary])
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
    
    func searchStories(searchString:String, _ onComplete:@escaping ((_ getAllStoriesResponse: [NSMutableDictionary])->Void)) {
        let postHeaders: NSDictionary = NSMutableDictionary()
        let queryParams: NSDictionary = NSMutableDictionary()
        queryParams.setValue(searchString, forKey: "search")
        let authHeaderValue = "JWT " + UserDefaults.standard.string(forKey: "session")!
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        
        func onServerResponse(_ serverResponse : Data){
            let decodedResponse: Any?
            do {
                decodedResponse = try JSONSerialization.jsonObject(with: serverResponse, options: [])
                onComplete(decodedResponse as! [NSMutableDictionary])
            }
            catch {
                return
            }
        }
        HttpModel.shared.getRequest(postHeaders, getAllStoryEndPoint, "", queryParams, onServerResponse)
    }
}
