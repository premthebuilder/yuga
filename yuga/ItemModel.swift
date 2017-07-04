//
//  ItemModel.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 7/4/17.
//  Copyright © 2017 PREMCHAND CHIDIPOTI. All rights reserved.
//

import Foundation
import UIKit

class ItemModel {
    
    let uploadSessionUrlEndPoint = "upload_session_url"
    
    func getSessionUrlToUploadItem(_ toStory: Int, _ image: UIImage, _ onComplete: @escaping ((UIImage, String)->Void)) {
        let postHeaders: NSDictionary = NSMutableDictionary()
        
        func onServerResponse(_ serverResponse : NSDictionary){
            print(serverResponse)
            onComplete(image, serverResponse.value(forKey: "upload_session_url") as! String)
        }
        
        HttpModel.shared.getRequest(postHeaders, uploadSessionUrlEndPoint, onServerResponse)
    }
    
    private func uploadImageUsingSessionUrl(_ image: UIImage, uploadSessionUrl: String) {
        var imageData = UIImageJPEGRepresentation(image, 0.9)
        let putHeaders: NSDictionary = NSMutableDictionary()
        func onServerResponse(_ serverResponse : NSDictionary){
            print(serverResponse)
        }
        HttpModel.shared.putRequest(imageData!, putHeaders, uploadSessionUrl, onServerResponse)
    }
    
    func uploadImage(_ image: UIImage) {
        getSessionUrlToUploadItem(1, image, uploadImageUsingSessionUrl)
    }
//    func uploadItem(_ toStory: Int) {
//        print(getSessionUrlToUploadItem(<#T##toStory: Int##Int#>))
//    }
}
