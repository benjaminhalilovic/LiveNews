//
//  LNSource.swift
//  LiveNews
//
//  Created by mac on 15/12/16.
//  Copyright © 2016 Benjamin Halilovic. All rights reserved.
//

import UIKit

class LNSourceTemporary: NSObject {
    let id: String
    let name: String
    let descriptionSource: String
    let url: String
    let category: String
    let country: String
    
    init(id: String, name: String, description: String, url: String, category: String, country: String) {
        self.id = id
        self.name = name
        self.descriptionSource = description
        self.url = url
        self.category = category
        self.country = country
    }
    /*
    required init(json: JSON) {
        id = json["id"].string
        name = json["name"].string
        descriptionSource = json["description"].string
        url = json["url"].string
        category = json["category"].string
        country = json["country"].string
    }*/
}
