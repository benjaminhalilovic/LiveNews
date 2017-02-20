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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        self.textView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    
    func textViewTapped(_ sender: UITapGestureRecognizer) {
     
    }
    
}




