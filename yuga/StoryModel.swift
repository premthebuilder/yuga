//
//  StoryModel.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 7/4/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import Foundation

class StoryModel {
    
    let createStoryEndPoint = ""
    let itemModel = ItemModel()
    
    func createStory(_ title: String, _ content: String, _ onComplete:@escaping (()->Void) )  {
        let postData: NSDictionary = NSMutableDictionary()
        let postHeaders: NSDictionary = NSMutableDictionary()
        
        postData.setValue(title, forKey: "title")
        postData.setValue(content, forKey: "text")
        let authHeaderValue = "JWT " + UserDefaults.standard.string(forKey: "session")!
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        
        func onServerResponse(_ serverResponse : NSDictionary){
            print("Congrats, you just posted a story!")
            onComplete()
        }
        HttpModel.shared.postRequest(postData, postHeaders, createStoryEndPoint, onServerResponse)
    }
}
