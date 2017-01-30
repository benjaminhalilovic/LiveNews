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

    func getNews(_ source: String, onCompletion: @escaping ([LNNewsTemporary]) -> Void) {
        let fullURL = baseURL +  String(format: kLNNews_GET_Endpoint, source)
        makeHTTPGetRequest(fullURL, onCompletion: {
            data, err in
            let jsonObject: AnyObject = try! JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
            
            guard let jsonDictionary = jsonObject as? [AnyHashable: Any], let sourcesArray = jsonDictionary["articles"] as? [[String: AnyObject]]  else {
                print("error")
                return
            }
            var finalArray = [LNNewsTemporary]()
            for article in sourcesArray {
                if let articleObject = self.newsFromJSONObject(article, source: source) {
                    finalArray.append(articleObject)
                }
            }
            onCompletion(finalArray)
        })
    }
    
    //Find better solution
    func newsFromJSONObject(_ json:[String: AnyObject], source: String) -> LNNewsTemporary? {
        let author = json["author"] as? String
        let title = json["title"] as? String
        let urlToImage = json["urlToImage"] as? String
        let publishedAt = json["publishedAt"] as? String
        let url = json["url"] as? String
        let description = json["description"] as? String
        
        return LNNewsTemporary(source: source, author: author, title: title, urlToImage: urlToImage, publishedAt: publishedAt, url: url, description: description)
    }
    
    func fetchImageForArticle(_ news: LNNewsTemporary, source: String, completion: @escaping (UIImage, _ src: String) -> Void) {
        if let image = news.image {
            completion(image, source)
            return
        }
        if let fullURL = news.urlToImage{
            makeHTTPGetRequest(fullURL) {
                data, err in
                if let imageData = data, let image = UIImage(data: imageData)
                {
                    news.image = image
                    completion(image, source)
                }
            }
        }
    }
    //end
}
