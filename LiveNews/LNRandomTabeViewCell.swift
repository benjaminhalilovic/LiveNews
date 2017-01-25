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
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            spinner.hidesWhenStopped = true
            img.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView?.image = nil
        }
    }
    
    func setupCell(article: LNNewsTemporary, section: Int) {
        self.descript.text = article.desc
    }
    
}
