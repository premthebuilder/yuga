//
//  UserModel.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 5/14/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import Foundation

class UserModel {
    
    let loginEndPoint = "api-token-auth/login/"
    let registerEndPoint = "register/"
    var loginSession:String = ""
    
    func clearLoginSession() {
        self.loginSession = ""
    }
    
    func login(_ userName: String, _ password: String, _ loginDone:@escaping (()->Void) ) {
        let postData: NSDictionary = NSMutableDictionary()
        
        postData.setValue(userName, forKey: "username")
        postData.setValue(password, forKey: "password")
        
        func onServerResponse(_ serverResponse : NSDictionary){
            if let sessionData = serverResponse["token"] as? String
            {
                self.loginSession = sessionData

                let preferences = UserDefaults.standard
                preferences.set(sessionData, forKey: "session")
                
                DispatchQueue.main.async(execute: loginDone)
            }
        }
        HttpModel.shared.postRequest(postData, loginEndPoint, onServerResponse)
        
    }
    
    func signUp(_ userName: String, _ password: String,
                _ emailId: String, _ name:String, _ signUpDone:@escaping (()->Void) ) {
        let postData: NSDictionary = NSMutableDictionary()
        
        postData.setValue(userName, forKey: "username")
        postData.setValue(password, forKey: "password")
        postData.setValue(emailId, forKey: "email")
        postData.setValue(name, forKey: "first_name")
        
        func onServerResponse(_ serverResponse : NSDictionary){
            login(userName, password, signUpDone)
        }
        HttpModel.shared.postRequest(postData, registerEndPoint, onServerResponse)
        
    }
    
    func logout() {
        self.clearLoginSession()
        UserDefaults.standard.removeObject(forKey: "session")
    }
    
    
}
