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
    func makeHTTPGetRequest(path: String, onCompletion: (data: NSData?, error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if data != nil {
                onCompletion(data:data, error: nil)
            } else {
                onCompletion(data:nil, error: error)
            }
        })
        task.resume()
    }
}
