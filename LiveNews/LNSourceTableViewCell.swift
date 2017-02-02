//
//  LNSourceTableViewCell.swift
//  LiveNews
//
//  Created by mac on 16/12/16.
//  Copyright © 2016 Benjamin Halilovic. All rights reserved.
//

import UIKit

class LNSourceTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    fileprivate var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(_ indexPath: IndexPath, source: LNSourceTemporary) {
        self.indexPath = indexPath
        self.name.text = source.name
    }
}
