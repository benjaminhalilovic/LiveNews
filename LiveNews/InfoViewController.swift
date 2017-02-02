//
//  InfoViewController.swift
//  LiveNews
//
//  Created by mac on 02/02/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        if let imageView = cell.viewWithTag(10) as? UIImageView {
            print("imageView.frame.width \(imageView.frame.width )")
            print("UIScreen.main.scale\(UIScreen.main.scale)")
            print("imageView.frame.height\(imageView.frame.height)")
            print("UIScreen.main.scale\(UIScreen.main.scale)")
            let widthInPixels = imageView.frame.width * UIScreen.main.scale
            let heightInPixels = imageView.frame.height * UIScreen.main.scale
            print(widthInPixels)
            print(heightInPixels)
            
        }
        return cell
    }
 
    //end
}

extension InfoViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
