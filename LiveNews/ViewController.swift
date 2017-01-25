//
//  ViewController.swift
//  LiveNews
//
//  Created by mac on 15/12/16.
//  Copyright © 2016 Benjamin Halilovic. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TableViewDataSource, TableViewDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var section = [String : [LNSourceTemporary]]()
    //var refreshControl : UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureApperance()
        // Do any additional setup after loading the view, typically from a nib.
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        getSources()
        
    }
    
    
    func configureApperance() {
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "Newspaper_background");
        bgImage.contentMode = .ScaleToFill
        
        self.collectionView?.backgroundView = bgImage
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
                    LNSection.sharedInstance.section = self.section
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
    
  
    //MARK: Create NSDictionary (key: category -> value: source)
    func createNSDictionary(sources: [LNSourceTemporary], onCompletion: (Bool) -> Void) {
        self.section.removeAll()
        for x in sources {
            let currentCategory = x.category
            if section[currentCategory] == nil {
                let array = [LNSourceTemporary]()
                section[currentCategory] = array
            }
            if var array = section[currentCategory] {
                array.append(x)
                //Looks like Apple considers this a "known issue" in Swift, implying it will work as expected eventually. From the Xcode 6 Beta 4 release notes:
                section[currentCategory] = array
            }
        }
        onCompletion(true)
    }


    
    //MARK: UICollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section.keys.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath) as! LNSourceCollectionViewCell
        cell.dataSource = self
        cell.delegate = self
        return cell.setupCell(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        //Expencive work
        let cell = cell as! LNSourceCollectionViewCell
        cell.tableView.reloadData()
    }
    
    //Table View data source
    func tableView(tableView: UITableView, cell: LNSourceCollectionViewCell, numberOfRowsInSection section: Int) -> Int {
        
        let array = self.section[cell.title.text!]!
        if array.count < 3 {
            return array.count
        }
        return 3
    }
    
    func tableView(table: UITableView, cell: LNSourceCollectionViewCell, cellForRowAtIndexPath index: NSIndexPath) -> LNSourceTableViewCell {
        let cellForTableView = table.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: index) as! LNSourceTableViewCell
        
        let category = cell.title.text
        let sourcesArray = self.section[category!]!
        cellForTableView.name.text = sourcesArray[index.row].name
        return cellForTableView

    }
    
    func tableView(tableView: UITableView, collCell: LNSourceCollectionViewCell, willDisplayCell cell: LNSourceTableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let category = collCell.title.text
        let sourcesArray = self.section[category!]!
        let source = sourcesArray[indexPath.row]
        LNAPICall.sharedInstance.fetchImageForSource(source, category: category!) {
            image, category in
            NSOperationQueue.mainQueue().addOperationWithBlock(){
                if let array = self.section[category] {
                    let photoIndex = array.indexOf(source)
                    let photoIndexPath = NSIndexPath(forRow: photoIndex!,  inSection: 0)
                    
                    if let cell = collCell.tableView.cellForRowAtIndexPath(photoIndexPath) as? LNSourceTableViewCell{
                        cell.img.image = image
                    }
                }
            }
        }
    }
    
    
    //MARK: Refresh Control
    /*
    func setupRefreshControl() {
        self.refreshControl.tintColor = UIColor.blueColor()
        self.refreshControl.addTarget(self, action: #selector(ViewController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView.addSubview(self.refreshControl)
    }
    
    func refreshData() {
        print("Refresh data")
        self.refreshControl.endRefreshing()
    }
    
    */
    //end
}

