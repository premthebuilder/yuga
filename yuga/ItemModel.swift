//
//  ItemModel.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 7/4/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

class ItemModel {
    
    let uploadSessionUrlEndPoint = "upload_session_url/"
    let downloadSessionUrlEndPoint = "download_session_url/"
    let createitemEndPoint = "create/item/"
    
    private func getSessionUrlToUploadItem(_ toStory: Int, _ image: UIImage,_ someData:Data, _ checksumHex: String, _ onComplete: @escaping ((UIImage, Data, NSDictionary, Int)->Void)) {
        let postHeaders: NSDictionary = NSMutableDictionary()
        let postData: NSDictionary = NSMutableDictionary()
        postData.setValue(checksumHex, forKey: "md5")
        func onServerResponse(_ serverResponse : Any?){
            let decodedResponse = serverResponse as! NSDictionary
            onComplete(image, someData, decodedResponse.value(forKey: "upload_session_url") as! NSDictionary, toStory)
        }
        HttpModel.shared.postRequest(postData: postData, postHeaders: postHeaders, endPoint: uploadSessionUrlEndPoint, onComplete: onServerResponse)
    }
    
    private func uploadImageUsingSessionUrl(_ image: UIImage, _ someData: Data, uploadSessionUrl: NSDictionary, toStory: Int) {
        let putUrl = uploadSessionUrl.value(forKey: "baseUrl")
        let queryParams = uploadSessionUrl.value(forKey: "queryParams")
        let putHeaders = uploadSessionUrl.value(forKey: "headers")
        var imageData = UIImageJPEGRepresentation(image, 0.9)
        func onServerResponse(_ serverResponse : NSDictionary){
            print(serverResponse)
            createItem(imageUploadResponse: serverResponse, storyId: toStory)
        }
        HttpModel.shared.putRequest(someData, putHeaders as! NSDictionary, queryParams as! NSDictionary, putUrl as! String, onServerResponse)
    }
    
    func uploadImage(_ storyId: Int, _ image: UIImage) {
        if let jpegData = UIImageJPEGRepresentation(image, 0.9) {
            //            let someText = "Hello World!"
            //            let someData = someText.data(using: .utf8)
            let checksum = jpegData.md5().bytes.toBase64()
            //            let checksumHex = checksum?.toHexString()
            //            let checksumHex = someText.md5()
            getSessionUrlToUploadItem(storyId, image, jpegData, checksum!, uploadImageUsingSessionUrl)
        }
        
    }
    
    func downloadImageUsingSessionUrl(_ imageMeta: NSDictionary) {
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
    
    private func createItem(imageUploadResponse: NSDictionary, storyId: Int) {
        func onServerResponse(_ serverResponse : NSDictionary){
            print(serverResponse)
        }
        let responseUrl: NSURL = imageUploadResponse.value(forKey: "url") as! NSURL
        let postData: NSDictionary = NSMutableDictionary()
        let postHeaders: NSDictionary = NSMutableDictionary()
        postData.setValue(String(storyId), forKey: "story")
        postData.setValue("test", forKey: "name")
        postData.setValue("test", forKey: "description")
        postData.setValue(responseUrl.lastPathComponent!, forKey: "source_url")
        let authHeaderValue = "JWT " + UserDefaults.standard.string(forKey: "session")!
        postHeaders.setValue(authHeaderValue, forKey: "Authorization")
        HttpModel.shared.postRequest(postData: postData, postHeaders: postHeaders, endPoint: createitemEndPoint, onComplete: onServerResponse)
    }
    //func uploadItem(_ toStory: Int) {
    //    print(getSessionUrlToUploadItem(<#T##toStory: Int##Int#>))
    //}
}
