//
//  WebSiteResponse.swift
//  Vaccess
//
//  Created by Emil Ryd on 2020-06-20.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import Foundation
import SwiftSoup
enum HTMLError: Error {
    case badInnerHTML
    
}

struct WebSiteResponse {
    
    init(innerHTML: String) throws  {
        //guard let htmlString = innerHTML as? String else {
       //     throw HTMLError.badInnerHTML
       // }
        let doc = try SwiftSoup.parse(innerHTML)
        //let mainText = try doc.getElementsByClass("content-3-1 rs-listen").text()
        let mainText = try doc.getElementsByTag("p").text()

        let ingress = try doc.getElementsByClass("intro").text()
        //let title = try doc.getElementsByClass("content-2 rs-listen ").text()
        let title = try doc.getElementsByTag("h1").text()
        print(title)
        print(ingress)
        print(mainText)
        
    }
}
