//
//  LNNewsTableViewCell.swift
//  LiveNews
//
//  Created by mac on 24/01/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import UIKit

class LNNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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
    
    func setupCell(_ article: LNNewsTemporary) {
        titleLabel.text = article.title
        if  article.image == nil {
            self.img.image = UIImage(named: "Home")
            spinner.stopAnimating()
            spinner.hidesWhenStopped = true
        }
    }
}
