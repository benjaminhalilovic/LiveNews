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
    
    private var indexPath: NSIndexPath?
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setupCell(indexPath: NSIndexPath, source: LNSourceTemporary) {
        self.indexPath = indexPath
        //print("label value \(source.name)")
        self.name.text = source.name
    }
}
