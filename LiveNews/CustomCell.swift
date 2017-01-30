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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupNormalCell(_ category: String, indexPath: IndexPath) -> UITableViewCell {
        self.textNormalCell.text = category
        self.colorView.backgroundColor = UIColor.blue
        switch indexPath.section {
        case 0:
            self.colorView.backgroundColor = UIColor(red:65/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
            return self
        case 1:
            self.colorView.backgroundColor = UIColor(red:255/255.0, green: 198/255.0, blue: 81/255.0, alpha: 1.0)
            return self
        case 2:
            self.colorView.backgroundColor = UIColor(red:255/255.0, green: 221/255.0, blue: 117/255.0, alpha: 1.0)
            return self
        case 3:
            self.colorView.backgroundColor = UIColor(red:31/255.0, green: 225/255.0, blue: 133/255.0, alpha: 1.0)
            return self
        case 4:
            self.colorView.backgroundColor = UIColor(red:236/255.0, green: 135/255.0, blue: 255/255.0, alpha: 1.0)
            return self
        case 5:
            self.colorView.backgroundColor = UIColor(red:255/255.0, green: 128/255.0, blue: 127/255.0, alpha: 1.0)
            return self
        case 6:
            self.colorView.backgroundColor = UIColor(red:157/255.0, green: 148/255.0, blue: 255/255.0, alpha: 1.0)
            return self
        case 7:
            self.colorView.backgroundColor = UIColor(red:181/255.0, green: 198/255.0, blue: 225/255.0, alpha: 1.0)
            return self
        default:
            return self
        }
        //Safe!
    }
    
    func setupValuePickerCell (_ category: String, section: [String : [LNSourceTemporary]], indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            var array = section["general"]!
            self.textExpandCell.text = array[indexPath.row - 1].name
            self.colorExpandView.backgroundColor = UIColor(red:65/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
            return self
        case 1:
            var array = section["business"]!
            self.textExpandCell.text  = array[indexPath.row - 1].name
            self.colorExpandView.backgroundColor = UIColor(red:255/255.0, green: 198/255.0, blue: 81/255.0, alpha: 1.0)
            return self
        case 2:
            var array = section["science-and-nature"]!
            self.textExpandCell.text = array[indexPath.row - 1].name
            self.colorExpandView.backgroundColor = UIColor(red:255/255.0, green: 221/255.0, blue: 117/255.0, alpha: 1.0)
            return self
        case 3:
            var array = section["sport"]!
            self.textExpandCell.text = array[indexPath.row - 1].name
            self.colorExpandView.backgroundColor = UIColor(red:31/255.0, green: 225/255.0, blue: 133/255.0, alpha: 1.0)
            return self
        case 4:
            var array = section["technology"]!
            self.textExpandCell.text = array[indexPath.row - 1].name
            self.colorExpandView.backgroundColor = UIColor(red:236/255.0, green: 135/255.0, blue: 255/255.0, alpha: 1.0)
            return self
        case 5:
            var array = section["music"]!
            self.textExpandCell.text = array[indexPath.row - 1].name
            self.colorExpandView.backgroundColor = UIColor(red:255/255.0, green: 128/255.0, blue: 127/255.0, alpha: 1.0)
            return self
        case 6:
            var array = section["gaming"]!
            self.textExpandCell.text = array[indexPath.row - 1].name
            self.colorExpandView.backgroundColor = UIColor(red:157/255.0, green: 148/255.0, blue: 255/255.0, alpha: 1.0)
            return self
        case 7:
            var array = section["entertainment"]!
            self.textExpandCell.text = array[indexPath.row - 1].name
            self.colorExpandView.backgroundColor = UIColor(red:181/255.0, green: 198/255.0, blue: 225/255.0, alpha: 1.0)
            return self
        default:
            return self
        }
    }

    //end
    
}
