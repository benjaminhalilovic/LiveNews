//
//  LNSourceCollectionViewCell.swift
//  LiveNews
//
//  Created by mac on 18/12/16.
//  Copyright © 2016 Benjamin Halilovic. All rights reserved.
//

import UIKit

protocol TableViewDataSource:class {
    func tableView(table: UITableView, cell:LNSourceCollectionViewCell, cellForRowAtIndexPath index: NSIndexPath) -> LNSourceTableViewCell
    func tableView(tableView: UITableView, cell:LNSourceCollectionViewCell, numberOfRowsInSection section: Int) -> Int
}

class LNSourceCollectionViewCell: UICollectionViewCell, UITableViewDataSource {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var tableView: UITableView!
    weak var dataSource: TableViewDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource?.tableView(tableView, cell: self, numberOfRowsInSection: section))!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("Require for table view")
        if let dataSource = dataSource {
            return dataSource.tableView(tableView, cell: self, cellForRowAtIndexPath: indexPath)
        }
        return UITableViewCell()
    }
}
