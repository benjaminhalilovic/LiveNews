//
//  ViewController.swift
//  LiveNews
//
//  Created by mac on 15/12/16.
//  Copyright © 2016 Benjamin Halilovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TableViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var section = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getSources()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getSources() {
        LNAPICall.sharedInstance.getSources(){
            (sources: [LNSourceTemporary]) in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.createNSDictionary(sources){
                    bool in
                    for(key, value) in self.section {
                        print("Key: \(key as! String)")
                        let sources = value as! [LNSourceTemporary]
                        for x in sources {
                            print("Value: \(x.name)")
                        }
                    }
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
    
    //MARK: Create NSDictionary for sections
    func createNSDictionary(sources: [LNSourceTemporary], onCompletion: (Bool) -> Void) {
        for x in sources {
            let currentCategory = x.category
            if section[currentCategory] == nil {
                let array = NSMutableArray()
                section[currentCategory] = array
            }
            if let array = section[currentCategory] as? NSMutableArray{
                array.addObject(x)
            }
        }
        onCompletion(true)
    }
    
    //MARK: UICollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section.allKeys.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath) as! LNSourceCollectionViewCell
        print("Require for collection view")
        cell.dataSource = self
        switch indexPath.row {
        case 0:
            cell.title.text = "general"
            return cell
        case 1:
            cell.title.text = "business"
            return cell
        case 2:
            cell.title.text = "science-and-nature"
            return cell
        case 3:
            cell.title.text = "sport"
            return cell
        case 4:
            cell.title.text = "technology"
            return cell
        case 5:
            cell.title.text = "music"
            return cell
        case 6:
            cell.title.text = "gaming"
            return cell
        case 7:
            cell.title.text = "entertainment"
            return cell
        default:
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        //Expencive work
        let cell = cell as! LNSourceCollectionViewCell
        cell.tableView.reloadData()
    }
    
    //Table View data source
    func tableView(tableView: UITableView, cell: LNSourceCollectionViewCell, numberOfRowsInSection section: Int) -> Int {
        let array = self.section[cell.title.text!] as! [LNSourceTemporary]
        if array.count < 3 {
            return array.count
        }
        return 3
    }
    
    func tableView(table: UITableView, cell: LNSourceCollectionViewCell, cellForRowAtIndexPath index: NSIndexPath) -> LNSourceTableViewCell {
        let cellForTableView = table.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: index) as! LNSourceTableViewCell
        let category = cell.title.text
        print("Category \(category)")
        let sourcesArray = self.section[category!] as! [LNSourceTemporary]
        cellForTableView.name.text = sourcesArray[index.row].name
        return cellForTableView

    }
    //end
}

