//
//  HttpModel.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 6/15/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import Foundation

class HttpModel {
    
//    static let shared = HttpModel(baseUrl: URL(string: "http://192.168.86.224:8000/")!)
    static let shared = HttpModel(baseUrl: URL(string: "http://localhost:8000/")!)
//    static let shared = HttpModel(baseUrl: URL(string: "https://yuga-171020.appspot.com/")!)
    
    private init(baseUrl: URL){
        self.baseUrl = baseUrl;
    }
    
    let baseUrl: URL;
    
    func postRequest(postData: NSDictionary, postHeaders: NSDictionary, endPoint: String,
                     onComplete: @escaping ((NSDictionary)->Void), callbackParams: NSDictionary = NSMutableDictionary()) {
        let url:URL = baseUrl.appendingPathComponent(endPoint)
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let postBody = try? JSONSerialization.data(withJSONObject: postData, options: [])
        postHeaders.setValue("application/json", forKey: "Content-Type")
        request.allHTTPHeaderFields = postHeaders as? [String : String]
//        request.httpBody = paramString.data(using: String.Encoding.utf8)
        request.httpBody = postBody
        
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
            var serverResponse = json as? NSDictionary
            DispatchQueue.main.async{
                for (key, value) in serverResponse!{
                    callbackParams.setValue(value, forKey: key as! String)
                }
                onComplete(callbackParams)
            }
        })
        task.resume()
    }
    
    func postByteRequest(_ fileData: Data, _ putHeaders: NSDictionary, _ queryParams:NSDictionary, _ uploadUrl: String,
                    _ onComplete: @escaping ((NSDictionary)->Void)) {
        if let urlComponents = NSURLComponents(string: uploadUrl),
            var queryItems = (urlComponents.queryItems ?? []) as? [URLQueryItem] {
            for qp in queryParams {
                var s = NSCharacterSet.urlQueryAllowed
                s.remove(charactersIn: "+&")
                let paramVal = qp.value as? String
                //                let escapedParamVal = paramVal?.replacingOccurrences(of: "+", with: "%2B")
                //                let escapedParamVal = paramVal?.addingPercentEncoding(withAllowedCharacters: s)
                queryItems.append(URLQueryItem(name: qp.key as! String, value: paramVal))
            }
            let cs = CharacterSet(charactersIn: "+").inverted
            urlComponents.queryItems = queryItems
            let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            let q =  urlComponents.percentEncodedQuery?.addingPercentEncoding(withAllowedCharacters: cs)
            urlComponents.percentEncodedQuery = q
            let url = urlComponents.url
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = "POST"
            //        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            //            let body = NSMutableData()
            //            body.append(fileData)
            let putData = NSData(data: "Hello World!".data(using: String.Encoding.utf8)!)
            request.httpBody = fileData
            request.allHTTPHeaderFields = putHeaders as? [String : String]
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, errorResponse) in
                guard let _:Data = data, let _:URLResponse = response, errorResponse == nil else {
                    return}
                let httpResponse = response as! HTTPURLResponse
                let responseUrlComponents = NSURLComponents(string: (httpResponse.url?.absoluteString)!)
                let httpResponseDict: NSDictionary = NSMutableDictionary()
                httpResponseDict.setValue(httpResponse.url, forKey: "url")
                httpResponseDict.setValue(httpResponse.allHeaderFields, forKey: "headers")
                httpResponseDict.setValue(httpResponse.statusCode, forKey: "status")
                do{
                let dataDict = try JSONSerialization.jsonObject(with: data!, options: [])
                httpResponseDict.setValue(dataDict as! NSDictionary, forKey: "data")
                }
                catch{}
                DispatchQueue.main.async{
                    onComplete(httpResponseDict)
                }
            })
            task.resume()
        }
    }
    
    func patchRequest(patchData: NSDictionary, patchHeaders: NSDictionary, endPoint: String,
                     onComplete: @escaping ((NSDictionary)->Void), callbackParams: NSDictionary = NSMutableDictionary()) {
        let url:URL = baseUrl.appendingPathComponent(endPoint)
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        var paramString = ""
        for (key, value) in patchData{
            paramString = paramString + (key as! String) + "=" + (value as! String) + "&"
        }
        
        request.allHTTPHeaderFields = patchHeaders as? [String : String]
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
            var serverResponse = json as? NSDictionary
            DispatchQueue.main.async{
                for (key, value) in serverResponse!{
                    callbackParams.setValue(value, forKey: key as! String)
                }
                onComplete(callbackParams)
            }
        })
        task.resume()
    }
    
    func getRequest(_ postHeaders: NSDictionary, _ endPoint: String, _ getUrl: String, _ queryParams:NSDictionary,
                    _ onComplete: @escaping ((Data)->Void)) {
        var url:URL;
        if endPoint.isEmpty {
            url = URL(string: getUrl)!
        }
        else {
            url = baseUrl.appendingPathComponent(endPoint)
        }
        if let urlComponents = NSURLComponents(string: url.absoluteString),
            var queryItems = (urlComponents.queryItems ?? []) as? [URLQueryItem] {
            for qp in queryParams {
                var s = NSCharacterSet.urlQueryAllowed
                s.remove(charactersIn: "+&")
                let paramVal = qp.value as? String
                //                let escapedParamVal = paramVal?.replacingOccurrences(of: "+", with: "%2B")
                //                let escapedParamVal = paramVal?.addingPercentEncoding(withAllowedCharacters: s)
                queryItems.append(URLQueryItem(name: qp.key as! String, value: paramVal))
            }
            let cs = CharacterSet(charactersIn: "+").inverted
            urlComponents.queryItems = queryItems
            let q =  urlComponents.percentEncodedQuery?.addingPercentEncoding(withAllowedCharacters: cs)
            urlComponents.percentEncodedQuery = q
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            request.allHTTPHeaderFields = postHeaders as? [String : String]
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                    return}
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode < 300{
                    DispatchQueue.main.async{
                        onComplete(data!)
                    }
                }
            })
            task.resume()
            
        }
    }
    
    func putRequest(_ fileData: Data, _ putHeaders: NSDictionary, _ queryParams:NSDictionary, _ uploadUrl: String,
                    _ onComplete: @escaping ((NSDictionary)->Void)) {
        if let urlComponents = NSURLComponents(string: uploadUrl),
            var queryItems = (urlComponents.queryItems ?? []) as? [URLQueryItem] {
            for qp in queryParams {
                var s = NSCharacterSet.urlQueryAllowed
                s.remove(charactersIn: "+&")
                let paramVal = qp.value as? String
                //                let escapedParamVal = paramVal?.replacingOccurrences(of: "+", with: "%2B")
                //                let escapedParamVal = paramVal?.addingPercentEncoding(withAllowedCharacters: s)
                queryItems.append(URLQueryItem(name: qp.key as! String, value: paramVal))
            }
            let cs = CharacterSet(charactersIn: "+").inverted
            urlComponents.queryItems = queryItems
            let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            let q =  urlComponents.percentEncodedQuery?.addingPercentEncoding(withAllowedCharacters: cs)
            urlComponents.percentEncodedQuery = q
            let url = urlComponents.url
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = "PUT"
            //        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            //            let body = NSMutableData()
            //            body.append(fileData)
            let putData = NSData(data: "Hello World!".data(using: String.Encoding.utf8)!)
            request.httpBody = fileData
            request.allHTTPHeaderFields = putHeaders as? [String : String]
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, errorResponse) in
                guard let _:Data = data, let _:URLResponse = response, errorResponse == nil else {
                    return}
                let httpResponse = response as! HTTPURLResponse
                let responseUrlComponents = NSURLComponents(string: (httpResponse.url?.absoluteString)!)
                let httpResponseDict: NSDictionary = NSMutableDictionary()
                httpResponseDict.setValue(httpResponse.url, forKey: "url")
                httpResponseDict.setValue(httpResponse.allHeaderFields, forKey: "headers")
                httpResponseDict.setValue(httpResponse.statusCode, forKey: "status")
                DispatchQueue.main.async{
                    onComplete(httpResponseDict)
                }
            })
            task.resume()
        }
    }
}
