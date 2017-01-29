//
//  PresentNewsViewController.swift
//  LiveNews
//
//  Created by mac on 28/01/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import UIKit

class PresentNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    private var dataSource = [LNNewsTemporary]()
    var source : String?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureApperance()
        getNews("cnbc")
    }
    
    func configureApperance() {
        self.automaticallyAdjustsScrollViewInsets = false
    }

    
    
    //MARK: data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as! LNRandomTabeViewCell
        cell.setupCell(dataSource[indexPath.row], section: indexPath.section)
        return cell
    }
    
    //MARK: Table View delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let article = dataSource[indexPath.row]
        LNAPICall.sharedInstance.fetchImageForArticle(article, source: article.source) {
            image, source in
            NSOperationQueue.mainQueue().addOperationWithBlock(){
                let photoIndexRow = self.dataSource.indexOf(article)
                let photoIndexPath = NSIndexPath(forRow: photoIndexRow!, inSection: 0)
                
                if let cell = tableView.cellForRowAtIndexPath(photoIndexPath) as? LNRandomTabeViewCell{
                    cell.updateWithImage(image)
                }
            }
        }
    }
    
    
    //MARK: Fetching data
    func getNews(source: String) {
        LNAPICall.sharedInstance.getNews(source) {
            news in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.dataSource += news
                self.tableView.reloadData()

            }
        }
    }

    @IBAction func backToMenu(sender: AnyObject) {
        print("back ")
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
