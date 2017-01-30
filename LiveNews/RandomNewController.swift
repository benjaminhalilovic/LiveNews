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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureApperance()
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        if let selectedTabIndex = tabBarController?.selectedIndex {
            switch selectedTabIndex {
            case 0:
                self.navigationItem.title = sources[counter]
                fetchingData = true
                tableView.tableFooterView = nil
                getNews(sources[counter])
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
        } else {
            self.tableView.tableFooterView = nil
            getNews(sources[counter])
        }
    }
    
    func configureApperance() {
        self.automaticallyAdjustsScrollViewInsets = false
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
            news in
            OperationQueue.main.addOperation() {
                if self.dataSource[source] == nil {
                    let array : [LNNewsTemporary] = news
                    self.dataSource[source] = array
                }
                for (key, value) in self.dataSource {
                    //print(key)
                   // print(value.count)
                }
                self.tableView.reloadData()
                self.fetchingData = false
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
       
        return self.dataSource[sources[section]]!.count
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
            
            LNAPICall.sharedInstance.fetchImageForArticle(article, source: source) {
                image, source in
                OperationQueue.main.addOperation(){
                    let news = self.dataSource[source]!
                    let photoIndexRow = news.index(of: article)
                    let photoIndexSection = self.sources.index(of: source)
                    let photoIndexPath = IndexPath(row: photoIndexRow!, section: photoIndexSection!)
                    
                    if let cell = tableView.cellForRow(at: photoIndexPath) as? LNRandomTabeViewCell{
                        cell.updateWithImage(image)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "NewsVCfromLastesNews", sender: self)
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
        if segue.identifier == "NewsVCfromLastesNews" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let source = sources[selectedIndexPath.section]
                let news = self.dataSource[source]!
                let article = news[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! NewsViewController
                destinationVC.article = article
            }
        }
    }

 
    
    //end
}
