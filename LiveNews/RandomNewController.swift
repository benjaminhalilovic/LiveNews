//
//  RandomNewController.swift
//  LiveNews
//
//  Created by mac on 12/01/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import UIKit

class RandomNewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var dataSource = [String : [LNNewsTemporary]]()
    var counter = 0
    var sources : [String] = []
    var fetchingData = false
    var refreshControl : UIRefreshControl = UIRefreshControl()
    
    let lastestSource = ["associated-press", "daily-mail", "sky-sports-news", "cnbc", "bbc-news", "daily-mail", "cnn", "bbc-sport", "google-news"  ]
    let popularSource = ["sky-news", "the-new-york-times", "new-york-magazine", "buzzfeed", "cnbc", "bbc-news", "daily-mail"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureApperance()
        setupRefreshControl()
        if let selectedTabIndex = tabBarController?.selectedIndex {
            switch selectedTabIndex {
            case 1:
                self.sources = lastestSource.choose(4)
                getNews(sources[counter])
            case 2:
                self.sources = popularSource.choose(3)
                getNews(sources[counter])
            default:
                break
            }
        }
    }
    
    func configureApperance() {
        self.automaticallyAdjustsScrollViewInsets = false
        //Menu button
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Footer of tableView
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        let pagingSpinner = UIActivityIndicatorView(frame: CGRect(x: footerView.frame.width/2, y: 40, width: 20.0, height: 20.0))
        pagingSpinner.startAnimating()
        pagingSpinner.color = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        pagingSpinner.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
        pagingSpinner.hidesWhenStopped = true
        footerView.addSubview(pagingSpinner)
        self.tableView.tableFooterView = footerView

    }
    
    func getNews(_ source: String) {
        LNAPICall.sharedInstance.getNews(source) {
            (newsResult: NewsResult) in
            OperationQueue.main.addOperation() {
                switch newsResult {
                case let .Success(news):
                    if self.dataSource[source] == nil {
                        let array : [LNNewsTemporary] = news
                        self.dataSource[source] = array
                    }
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                    self.tableView.reloadData()
                    self.fetchingData = false
                case let .Failure(error):
                    print("Error fetching recent photos: \(error) ")
                    self.tableView.tableFooterView = nil
                }
            }
        }
    }
    
    //MARK: TableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.dataSource.keys.count == 3 {
            tableView.tableFooterView = nil
        }
        return self.dataSource.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let news = self.dataSource[sources[section]] {
            return news.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath) as! LNRandomTabeViewCell
        let key = sources[indexPath.section]
        let array = dataSource[key]!
        cell.setupCell(array[indexPath.row], section: indexPath.section)
        return cell
    }
    
    //MARK: Table View Delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let source = sources[indexPath.section]
        if let news = dataSource[source] {
            let article = news[indexPath.row]
            LNAPICall.sharedInstance.fetchImageForArticle(article) {
                (imageResult: ImageResult) in
                OperationQueue.main.addOperation(){
                    let news = self.dataSource[source]!
                    let photoIndexRow = news.index(of: article)
                    let photoIndexSection = self.sources.index(of: source)
                    let photoIndexPath = IndexPath(row: photoIndexRow!, section: photoIndexSection!)
                    if let cell = tableView.cellForRow(at: photoIndexPath) as? LNRandomTabeViewCell{
                        cell.updateWithImage(article.image)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toNewsViewController", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sources[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
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
            view.tintColor = UIColor.white
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if currentOffset - maximumOffset > -20 {
            //find better solution
            if !fetchingData {
                fetchingData = true
                if counter < sources.count - 1 {
                    counter = counter + 1
                    getNews(sources[counter])
                }
            }
        }
    }

    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewsViewController" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let source = sources[selectedIndexPath.section]
                let news = self.dataSource[source]!
                let article = news[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! NewsViewController
                destinationVC.article = article
            }
        }
    }

    //MARK: Refresh Control
     func setupRefreshControl() {
        self.refreshControl.tintColor = UIColor.blue
        self.refreshControl.addTarget(self, action: #selector(RandomNewController.refreshData), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl)
     }
     
     func refreshData() {
        print("Refreshing")
        self.refreshControl.endRefreshing()
        counter = 0
        tableView.dataSource = nil
        tableView.delegate = nil
        dataSource.removeAll()
        getNews(sources[counter])
     }
    
    //end
}
