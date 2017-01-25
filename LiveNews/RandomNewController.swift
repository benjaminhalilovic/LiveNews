//
//  RandomNewController.swift
//  LiveNews
//
//  Created by mac on 12/01/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import UIKit

class RandomNewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var dataSource = [String : [LNNewsTemporary]]()
    var counter = 0
    var sources : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureApperance()
        if let selectedTabIndex = tabBarController?.selectedIndex {
            switch selectedTabIndex {
            case 1:
                self.sources = ["associated-press", "daily-mail", "sky-sports-news", "cnbc"]
                self.navigationItem.title = "Lastest news"
                getNews(sources[counter])
            case 2:
                self.sources = ["sky-news", "the-new-york-times", "new-york-magazine", "buzzfeed"]
                self.navigationItem.title = "Popular news"
                getNews(sources[counter])
            default:
                break
            }
        }
    }
    
    func configureApperance() {
        self.automaticallyAdjustsScrollViewInsets = false
        //Footer of tableView
        let footerView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 100))
        let pagingSpinner = UIActivityIndicatorView(frame: CGRectMake(footerView.frame.width/2, 40, 20.0, 20.0))
        pagingSpinner.startAnimating()
        pagingSpinner.color = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        pagingSpinner.transform = CGAffineTransformMakeScale(1.5, 1.5);
        pagingSpinner.hidesWhenStopped = true
        footerView.addSubview(pagingSpinner)
        self.tableView.tableFooterView = footerView

    }
    
    func getNews(source: String) {
        LNAPICall.sharedInstance.getNews(source) {
            news in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                if self.dataSource[source] == nil {
                    let array : [LNNewsTemporary] = news
                    self.dataSource[source] = array
                }
                for (key, value) in self.dataSource {
                    //print(key)
                   // print(value.count)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: TableView dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.dataSource.keys.count == 3 {
            tableView.tableFooterView = nil
        }
        return self.dataSource.keys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.dataSource[sources[section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as! LNRandomTabeViewCell
        let key = sources[indexPath.section]
        let array = dataSource[key]!
        cell.setupCell(array[indexPath.row], section: indexPath.section)
        return cell
    }
    
    //MARK: Table View Delegate
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let source = sources[indexPath.section]
        if let news = dataSource[source] {
            let article = news[indexPath.row]
            LNAPICall.sharedInstance.fetchImageForArticle(article, source: source) {
                image, source in
                NSOperationQueue.mainQueue().addOperationWithBlock(){
                    let news = self.dataSource[source]!
                    let photoIndexRow = news.indexOf(article)
                    let photoIndexSection = self.sources.indexOf(source)
                    let photoIndexPath = NSIndexPath(forRow: photoIndexRow!, inSection: photoIndexSection!)
                    
                    if let cell = tableView.cellForRowAtIndexPath(photoIndexPath) as? LNRandomTabeViewCell{
                        cell.updateWithImage(image)
                    }
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("NewsVCfromLastesNews", sender: self)
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sources[section]
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        switch section {
        case 0:
            view.tintColor = UIColor(red:210/255.0, green: 253/255.0, blue: 255/255.0, alpha: 1.0)
        case 1:
            view.tintColor = UIColor(red:255/255.0, green: 227/255.0, blue: 230/255.0, alpha: 1.0)
        case 2:
            view.tintColor = UIColor(red:191/255.0, green: 255/255.0, blue: 147/255.0, alpha: 1.0)
        case 3:
            view.tintColor = UIColor(red:255/255.0, green: 205/255.0, blue: 205/255.0, alpha: 1.0)
        default:
            view.tintColor = UIColor.whiteColor()
        }
    }
    
    
    //Better solution!
    //MARK: Scroll View Delegate
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if currentOffset - maximumOffset > -110{
            if counter < 3 {
                counter = counter + 1
                getNews(sources[counter])
            }
        }
    }
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NewsVCfromLastesNews" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let source = sources[selectedIndexPath.section]
                let news = self.dataSource[source]!
                let article = news[selectedIndexPath.row]
                
                let destinationVC = segue.destinationViewController as! NewsViewController
                destinationVC.article = article
            }
        }
    }

    
    //end
}
