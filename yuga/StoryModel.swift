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
    let getStoryEndPoint = "view/story/all/"
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
    
    func getStory(_ onComplete:@escaping ((_ getStoryResponse: [NSDictionary])->Void)) {
        let postHeaders: NSDictionary = NSMutableDictionary()
        let authHeaderValue = "JWT " + UserDefaults.standard.string(forKey: "session")!
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        
        func onServerResponse(_ serverResponse : Any?){
            let decodedResponse = serverResponse as! [NSDictionary]
            print(decodedResponse)
            
            print("Congrats, you got all the stories")
            //onComplete(serverResponse.value(forKey: "id") as! Int)
        }
        HttpModel.shared.getRequest(postHeaders, getStoryEndPoint, onServerResponse)
    }
}
