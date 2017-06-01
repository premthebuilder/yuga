//
//  UserModel.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 5/14/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import Foundation

class UserModel {
    
    let baseUrl = "http://127.0.0.1:8000/"
    let loginEndPoint = "api-token-auth/login/"
    let registerEndPoint = "register/"
    var loginSession:String = ""
    
    func postRequest(_ postData: NSDictionary, _ endPoint: String,
                     _ onComplete: @escaping ((NSDictionary)->Void)) {
        
        let url:URL = URL(string: baseUrl + endPoint)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        var paramString = ""
        for (key, value) in postData
        {
            paramString = paramString + (key as! String) + "=" + (value as! String) + "&"
        }
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        print(request)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            let json: Any?
            
            do
            {
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch
            {
                return
            }
            
            guard let serverResponse = json as? NSDictionary else
            {
                return
            }
            
            DispatchQueue.main.async{
                onComplete(serverResponse)
            }
        })
        
        task.resume()
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
        postRequest(postData, loginEndPoint, onServerResponse)
        
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
        postRequest(postData, registerEndPoint, onServerResponse)
        
    }
    
    
}
