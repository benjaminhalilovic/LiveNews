//
//  LNAPICall+News.swift
//  LiveNews
//
//  Created by mac on 13/01/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import Foundation

let kLNNews_GET_Endpoint = "articles?source=%@&apiKey=3e22f2fcc1344975ae2b2e69379e2a6e"

//Data News Result
enum NewsResult {
    case Success([LNNewsTemporary])
    case Failure(Error)
}


extension LNAPICall {

    func getNews(_ source: String, onCompletion: @escaping (_ result: NewsResult) -> Void) {
        let fullURL = baseURL +  String(format: kLNNews_GET_Endpoint, source)
        makeHTTPGetRequest(fullURL, onCompletion: {
            data, err in
            let result = self.processNewsRequestRequest(data, error: err, source: source)
            onCompletion(result)
        })
    }
    
    func processNewsRequestRequest(_ data: Data?, error: Error?, source: String) -> NewsResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return LNAPICall.newsFromJSONData(data: jsonData, source: source)
    }
    
    static func newsFromJSONData(data: Data, source: String) -> NewsResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
           
            guard let jsonDictionary = jsonObject as? [AnyHashable: Any], let sourcesArray = jsonDictionary["articles"] as? [[String: AnyObject]]  else {
                return .Failure(NewsApiError.InvalidJSONData)
            }

            var finalNews = [LNNewsTemporary]()
            for article in sourcesArray {
                if let articleObject = self.newsFromJSONObject(article, source: source) {
                    finalNews.append(articleObject)
                }
            }
            
            if finalNews.count == 0 && sourcesArray.count > 0 {
                //Json format is changed or cannt parse
                return .Failure(NewsApiError.InvalidJSONData)
            }
            return .Success(finalNews)
        }
        catch let error {
            return .Failure(error)
        }
    }


    
    //Find better solution
    private static func newsFromJSONObject(_ json:[String: AnyObject], source: String) -> LNNewsTemporary? {
        let author = json["author"] as? String
        let title = json["title"] as? String
        let urlToImage = json["urlToImage"] as? String
        let publishedAt = json["publishedAt"] as? String
        let url = json["url"] as? String
        let description = json["description"] as? String
        
        return LNNewsTemporary(source: source, author: author, title: title, urlToImage: urlToImage, publishedAt: publishedAt, url: url, description: description)
    }
    
    
    
    func fetchImageForArticle(_ news: LNNewsTemporary, completion: @escaping (ImageResult) -> Void) {
        if let image = news.image {
            completion(.Success(image))
            return
        }
        
        if let fullURL = news.urlToImage{
            makeHTTPGetRequest(fullURL) {
                data, err in
                let result = self.processImageRequest(data, error: err)
                if case let .Success(image) = result {
                    news.image = image
                }
                completion(result)
            }
        }
    }
    
    func processImageRequest(_ data: Data?, error: Error?) -> ImageResult {
        guard let imageData = data,
            let image = UIImage(data: imageData) else {
                // Couldn' t create an image
                if data == nil {
                    return .Failure(error!)
                }else {
                    return .Failure(PhotoError.ImageCreationError)
                }
        }
        return .Success(image)
    }
    //end
}
