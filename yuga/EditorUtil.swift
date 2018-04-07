//
//  EditorUtil.swift
//  yuga
//
//  Created by PREMCHAND CHIDIPOTI on 3/21/18.
//  Copyright © 2018 PREMCHAND CHIDIPOTI. All rights reserved.
//

import Foundation
import SwiftSoup

class EditorUtil {
    static func parseImageUrlFromHtml(_ html: String) -> String{
        do {
            let doc: Document = try SwiftSoup.parse(html)
            if(try! doc.select("a").size() > 0) {
                let link: Element = try! doc.select("a").first()!
                
                let text: String = try! doc.body()!.text(); // "An example link"
                let linkHref: String = try! link.attr("href");
                return linkHref}
            return("")
        } catch Exception.Error(let type, let message) {
            return("")
        } catch {
            return("")
        }
    }
}
