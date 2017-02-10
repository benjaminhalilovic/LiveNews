//
//  InfoViewController.swift
//  LiveNews
//
//  Created by mac on 02/02/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import UIKit
import Foundation

class InfoViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "LiveNews is global independent news aggregation service. Fully-automated, and on a continuous basis, LiveNews displays breaking headlines linking to news websites all around the world. Our mission is to help provide people with links to the news they need to read, and publishers with people to read the news they write.                                                           LiveNews is very proud to be working closely with the NewsAPI.org, whice provide metadata for the headlines currently published on a range of news sources and blogs.                                   Do you have suggestions for LiveNews?                                                                                           Or want to report a problem?                                                                                               Feel free to contact on mail livenewscontact@gmail.com"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        self.textView.addGestureRecognizer(tapGesture)
    }
    
    
    func textViewTapped(_ sender: UITapGestureRecognizer) {
     
    }
    
}




