//
//  LNSection.swift
//  LiveNews
//
//  Created by mac on 10/01/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import UIKit

class LNSection {
    static let sharedInstance = LNSection()
    var section = [String : [LNSourceTemporary]]()
}
