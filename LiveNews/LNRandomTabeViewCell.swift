//
//  LNRandomTabeViewCell.swift
//  LiveNews
//
//  Created by mac on 20/01/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import UIKit

class LNRandomTabeViewCell: UITableViewCell {
    
    @IBOutlet weak var descript: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateWithImage(nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateWithImage(nil)
    }
    
    func updateWithImage(_ image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            spinner.hidesWhenStopped = true
            img.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView?.image = nil
        }
    }
    
    func setupCell(_ article: LNNewsTemporary, section: Int) {
        self.descript.text = article.desc
        switch section {
        case 0:
            self.backgroundColor = UIColor(red:210/255.0, green: 253/255.0, blue: 255/255.0, alpha: 0.35)
        case 1:
            self.backgroundColor = UIColor(red:255/255.0, green: 227/255.0, blue: 230/255.0, alpha: 0.35)
        case 2:
            self.backgroundColor = UIColor(red:191/255.0, green: 255/255.0, blue: 147/255.0, alpha: 0.35)
        case 3:
            self.backgroundColor = UIColor(red:255/255.0, green: 205/255.0, blue: 205/255.0, alpha: 0.35)
        default:
            self.backgroundView?.tintColor = UIColor.white
        }
        if  article.image == nil {
            self.img.image = UIImage(named: "Home")
            spinner.stopAnimating()
            spinner.hidesWhenStopped = true
        }
    }
    
}
