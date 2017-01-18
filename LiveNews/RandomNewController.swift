//
//  RandomNewController.swift
//  LiveNews
//
//  Created by mac on 12/01/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import UIKit

class RandomNewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedTabIndex = tabBarController?.selectedIndex {
            switch selectedTabIndex {
            case 1:
                print("First tab")
                print(self)
            case 2:
                print("Second tab")
                print(self)
            default:
                break
            }
        }
    }
}
