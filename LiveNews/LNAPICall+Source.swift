//
//  LNAPICall+Source.swift
//  LiveNews
//
//  Created by mac on 15/12/16.
//  Copyright © 2016 Benjamin Halilovic. All rights reserved.
//

import Foundation

let kLNSource_GET_Endpoint = "sources"

extension LNAPICall {
    
    func getSources(onCompletion: ([LNSourceTemporary]) -> Void) {
        let fullURL = baseURL + kLNSource_GET_Endpoint
        makeHTTPGetRequest(fullURL, onCompletion: {
            data, err in
            let jsonObject: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
           
            guard let jsonDictionary = jsonObject as? [NSObject: AnyObject], sourcesArray = jsonDictionary["sources"] as? [[String: AnyObject]] else {
                print("error")
                return
            }
            var finalSources = [LNSourceTemporary]()
            for sourceJSON in sourcesArray {
                if let source = self.sourceFromJSONObject(sourceJSON) {
                    finalSources.append(source)
                }
            }
            onCompletion(finalSources)
        })
    }
    
    func sourceFromJSONObject(json:[String: AnyObject]) -> LNSourceTemporary? {
        guard let category = json["category"] as? String,
            let country = json["country"] as? String,
            let description = json["description"] as? String,
            let id = json["id"] as? String,
            let name = json["name"] as? String,
            let url = json["url"] as? String,
            let urlToLogos = json["urlsToLogos"] as? [String: AnyObject],
            let smallUrl = urlToLogos["small"] as? String
        else {
                return nil
        }
        return LNSourceTemporary(id: id, name: name, description: description, url: url, category: category, country: country, smallURL: smallUrl)
    }
    
    //MARK: Image Data
    func fetchImageForSource(source: LNSourceTemporary, category: String, completion: (UIImage, category: String) -> Void) {
        if let image = source.image {
            completion(image, category: category)
            return
        }
        let fullURL = source.smallUrl
        makeHTTPGetRequest(fullURL) {
            data, err in
            if let imageData = data, image = UIImage(data: imageData)
            {
                source.image = image
                completion(image, category: category)
            }
           
        }
        
    }
   
    
    //end
}