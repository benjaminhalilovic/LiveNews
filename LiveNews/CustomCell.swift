//
//  CustomCell.swift
//  Expandable
//
//  Created by Gabriel Theodoropoulos on 28/10/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit


class CustomCell: UITableViewCell {

    // MARK: IBOutlet Properties
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var textNormalCell: UILabel!
    @IBOutlet weak var textExpandCell: UILabel!
    @IBOutlet weak var colorExpandView: UIView!
    
    
   
    // MARK: Variables
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    
}
