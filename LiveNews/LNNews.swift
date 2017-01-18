//
//  LNNews.swift
//  LiveNews
//
//  Created by mac on 14/01/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import UIKit
import CoreData

class LNNewsTemporary {
    let source: String
    let author: String
    let title: String
    let urlToImage: String
    let publishedAt: String
    let url: String
    let desc: String
    
    init(source:String, author: String, title: String, urlToImage: String, publishedAt: String, url: String, description: String) {
        self.source = source
        self.author = author
        self.title = title
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.url = url
        self.desc = description
    }

}


