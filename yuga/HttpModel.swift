//
//  HttpModel.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 6/15/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import Foundation

class HttpModel {
    
    static let shared = HttpModel(baseUrl: URL(string: "http://127.0.0.1:8000/")!)
    
    private init(baseUrl: URL){
        self.baseUrl = baseUrl;
    }
    
    let baseUrl: URL;
    
    func postRequest(_ postData: NSDictionary, _ postHeaders: NSDictionary, _ endPoint: String,
                     _ onComplete: @escaping ((NSDictionary)->Void)) {
        let url:URL = baseUrl.appendingPathComponent(endPoint)
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        var paramString = ""
        for (key, value) in postData{
            paramString = paramString + (key as! String) + "=" + (value as! String) + "&"
        }
        
        request.allHTTPHeaderFields = postHeaders as? [String : String]
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                return}
            let json: Any?
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch {
                return
            }
            guard let serverResponse = json as? NSDictionary else{
                return
            }
            DispatchQueue.main.async{
                onComplete(serverResponse)
            }
        })
        task.resume()
    }
    
    func getRequest(_ postHeaders: NSDictionary, _ endPoint: String,
                     _ onComplete: @escaping ((NSDictionary)->Void)) {
        let url:URL = baseUrl.appendingPathComponent(endPoint)
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.allHTTPHeaderFields = postHeaders as? [String : String]
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                return}
            let json: Any?
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch {
                return
            }
            guard let serverResponse = json as? NSDictionary else{
                return
            }
            DispatchQueue.main.async{
                onComplete(serverResponse)
            }
        })
        task.resume()
    }
    
    func putRequest(_ fileData: Data, _ putHeaders: NSDictionary, _ uploadUrl: String,
                     _ onComplete: @escaping ((NSDictionary)->Void)) {
        let url:URL = URL(string: uploadUrl)!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let body = NSMutableData()
        body.append(fileData)
        request.httpBody = body as Data
        
        
        request.allHTTPHeaderFields = putHeaders as? [String : String]
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                return}
            let json: Any?
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch {
                return
            }
            guard let serverResponse = json as? NSDictionary else{
                return
            }
            DispatchQueue.main.async{
                onComplete(serverResponse)
            }
        })
        task.resume()
    }
}
