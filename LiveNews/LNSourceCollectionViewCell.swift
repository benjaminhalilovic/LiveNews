//
//  LNSourceCollectionViewCell.swift
//  LiveNews
//
//  Created by mac on 18/12/16.
//  Copyright © 2016 Benjamin Halilovic. All rights reserved.
//

import UIKit

protocol TableViewDataSource:class {
    func tableView(_ table: UITableView, cell:LNSourceCollectionViewCell, cellForRowAtIndexPath index: IndexPath) -> LNSourceTableViewCell
    func tableView(_ tableView: UITableView, cell:LNSourceCollectionViewCell, numberOfRowsInSection section: Int) -> Int
}

protocol TableViewDelegate:class{
    func tableView(_ tableView: UITableView, collCell: LNSourceCollectionViewCell, willDisplayCell cell: LNSourceTableViewCell, forRowAtIndexPath indexPath: IndexPath)
     func tableView(_ tableView: UITableView, collCell: LNSourceCollectionViewCell,didSelectRowAtIndexPath indexPath: IndexPath)
}

class LNSourceCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerview: UIView!
    
    weak var dataSource: TableViewDataSource?
    weak var delegate: TableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    func setupCell(_ index: IndexPath) -> LNSourceCollectionViewCell{
        let index = index.row
        switch index {
        case 0:
            self.title.text = "general"
            self.headerview.backgroundColor = UIColor(red:65/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
            return self
        case 1:
            self.title.text = "business"
            self.headerview.backgroundColor = UIColor(red:255/255.0, green: 198/255.0, blue: 81/255.0, alpha: 1.0)
            return self
        case 2:
            self.title.text = "science-and-nature"
            self.headerview.backgroundColor = UIColor(red:255/255.0, green: 221/255.0, blue: 117/255.0, alpha: 1.0)
            return self
        case 3:
            self.title.text = "sport"
            self.headerview.backgroundColor = UIColor(red:31/255.0, green: 225/255.0, blue: 133/255.0, alpha: 1.0)
            return self
        case 4:
            self.title.text = "technology"
            self.headerview.backgroundColor = UIColor(red:236/255.0, green: 135/255.0, blue: 255/255.0, alpha: 1.0)
            return self
        case 5:
            self.title.text = "music"
            self.headerview.backgroundColor = UIColor(red:255/255.0, green: 128/255.0, blue: 127/255.0, alpha: 1.0)
            return self
        case 6:
            self.title.text = "gaming"
            self.headerview.backgroundColor = UIColor(red:157/255.0, green: 148/255.0, blue: 255/255.0, alpha: 1.0)
            return self
        case 7:
            self.title.text = "entertainment"
            self.headerview.backgroundColor = UIColor(red:181/255.0, green: 198/255.0, blue: 225/255.0, alpha: 1.0)
            return self
        default:
            return self
        }

    }
    
    //Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = dataSource?.tableView(tableView, cell: self, numberOfRowsInSection: section)
        self.layoutIfNeeded()
        return numberOfRows!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // print("Require for table view")
        return (dataSource?.tableView(tableView, cell: self, cellForRowAtIndexPath: indexPath))!
        
    }
    
    //Delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            delegate?.tableView(tableView, collCell: self, willDisplayCell: cell as! LNSourceTableViewCell, forRowAtIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableView(tableView, collCell: self, didSelectRowAtIndexPath: indexPath)
    }
    
}
