//
//  LNAPICall+Source.swift
//  LiveNews
//
//  Created by mac on 15/12/16.
//  Copyright © 2016 Benjamin Halilovic. All rights reserved.
//

import Foundation

let kLNSource_GET_Endpoint = "sources"

//Data Source Result
enum SourceResult {
    case Success([LNSourceTemporary])
    case Failure(Error)
}

enum NewsApiError: Error {
    case InvalidJSONData
}


//Image Result
enum ImageResult {
    case Success(UIImage)
    case Failure(Error)
}

enum PhotoError: Error {
    case ImageCreationError
}


extension LNAPICall {
    
    func getSources(onCompletion: @escaping (_ result: SourceResult) -> Void){
        let fullURL = baseURL + kLNSource_GET_Endpoint
        makeHTTPGetRequest(fullURL, onCompletion: {
            data, err in
            let result = self.processSourceRequest(data, error: err)
            onCompletion(result)
        })
    }
    
    func processSourceRequest(_ data: Data?, error: Error?) -> SourceResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return LNAPICall.sourcesFromJSONData(data: jsonData)
    }

    
    
     static func sourcesFromJSONData(data: Data) -> SourceResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let jsonDictionary = jsonObject as? [AnyHashable: Any], let sourcesArray = jsonDictionary["sources"] as? [[String: AnyObject]] else {
                print("error")
                return .Failure(NewsApiError.InvalidJSONData)
            }
            var finalSources = [LNSourceTemporary]()
            for sourceJSON in sourcesArray {
                if let source = sourceFromJSONObject(sourceJSON) {
                    finalSources.append(source)
                }
            }
            
            if finalSources.count == 0 && sourcesArray.count > 0 {
                //Json format is changed or cannt parse
                return .Failure(NewsApiError.InvalidJSONData)
            }
            return .Success(finalSources)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    private static func sourceFromJSONObject(_ json:[String: AnyObject]) -> LNSourceTemporary? {
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
    func fetchImageForSource(_ source: LNSourceTemporary, category: String, completion: @escaping (ImageResult) -> Void) {
        if let image = source.image {
            completion(.Success(image))
            return
        }
        if let fullURL = source.smallUrl {
            makeHTTPGetRequest(fullURL) {
                data, err in
               
                let result = self.processImageRequest(data, error: err)
                if case let .Success(image) = result {
                    source.image = image
                }
                completion(result)
            }
        }
    }
   
    
    //end
}
