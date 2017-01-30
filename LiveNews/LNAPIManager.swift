//
//  LNAPIManager.swift
//  LiveNews
//
//  Created by mac on 15/12/16.
//  Copyright © 2016 Benjamin Halilovic. All rights reserved.
//

import UIKit


class LNAPIManager: NSObject {
    let baseURL = "https://newsapi.org/v1/"
    
    // MARK: Perform a GET Request
    func makeHTTPGetRequest(_ path: String, onCompletion: @escaping (_ data: Data?, _ error: NSError?) -> Void) {
        let request = URLRequest(url:URL(string: path)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if data != nil {
                onCompletion(data, nil)
            } else {
                onCompletion(nil, error as NSError?)
            }
        })
        task.resume()
    }

}
