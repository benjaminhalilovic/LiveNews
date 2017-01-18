//
//  LNAPICall+News.swift
//  LiveNews
//
//  Created by mac on 13/01/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import Foundation

let kLNNews_GET_Endpoint = "articles?source=%@&apiKey=3e22f2fcc1344975ae2b2e69379e2a6e"

extension LNAPICall {

    func getOneNews(source: String, onCompletion: (LNNewsTemporary) -> Void) {
        let fullURL = baseURL +  String(format: kLNNews_GET_Endpoint, source)
        makeHTTPGetRequest(fullURL, onCompletion: {
            data, err in
            let jsonObject: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
            
            guard let jsonDictionary = jsonObject as? [NSObject: AnyObject], sourcesArray = jsonDictionary["articles"] as? [[String: AnyObject]]  else {
                print("error")
                return
            }
            
            if let source = self.newsFromJSONObject(sourcesArray[0], source: source) {
                    onCompletion(source)
                }
        })
    }
    
    
    func newsFromJSONObject(json:[String: AnyObject], source: String) -> LNNewsTemporary? {
        guard let author = json["author"] as? String,
            let title = json["title"] as? String,
            let urlToImage = json["urlToImage"] as? String,
            let publishedAt = json["publishedAt"] as? String,
            let url = json["url"] as? String,
            let description = json["description"] as? String else {
                return nil
        }
        return LNNewsTemporary(source: source, author: author, title: title, urlToImage: urlToImage, publishedAt: publishedAt, url: url, description: description)
    }

    

}