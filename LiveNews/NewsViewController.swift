//
//  NewsViewController.swift
//  LiveNews
//
//  Created by mac on 23/01/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var article: LNNewsTemporary! {
        didSet {
            navigationItem.title = article.source
        }
    }
    
    let lastestSource = ["associated-press", "daily-mail", "sky-sports-news", "cnbc"]
    let popularSource = ["the-new-york-times", "new-york-magazine", "buzzfeed", "sky-news"]
    var dataSource: [LNNewsTemporary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppereance()
    }
    
    func configureAppereance() {
        //Table View
        let randomNumber = Int(arc4random_uniform(UInt32(lastestSource.count)))
        self.getNews(lastestSource[randomNumber])
        
        //Scroll View
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Label set up
        if let publishLabel = self.view.viewWithTag(10) as? UILabel {
            if let publishAt = article.publishedAt {
                publishLabel.text = publishAt
            }
            
        }
        
        if let authorLabel = self.view.viewWithTag(11) as? UILabel {
            if let author = article.author {
                authorLabel.text = author
            }
        }
        
        if let titleLabel = self.view.viewWithTag(12) as? UILabel {
            if let title = article.title {
                titleLabel.text = title
                self.heightForView(titleLabel)
            }
        }
        
        if let image = self.view.viewWithTag(13) as? UIImageView {
            if let img = article.image {
                image.image = img
            }
            
        }
        
        if let descriptionLabel = self.view.viewWithTag(14) as? UILabel {
            if let desc = article.desc {
                descriptionLabel.text = desc
                self.heightForView(descriptionLabel)
            }
        }
        
        if let urlButton = self.view.viewWithTag(15) as? UIButton {
            if let url = article.url {
                urlButton.setTitle(url, for: UIControlState())
                urlButton.sizeToFit()
            }
        }
    }
    
    //MARK: fetching data
    func getNews(_ source: String) {
        LNAPICall.sharedInstance.getNews(source) {
            (newsResult: NewsResult) in
            OperationQueue.main.addOperation() {
                switch newsResult {
                case let .Success(news):
                    self.dataSource.removeAll()
                    self.dataSource = news
                    LilithProgressHUD.hide(view: self.tableView)
                    self.tableView.reloadData()
                case let .Failure(error):
                    print("Error fetching recent photos: \(error) ")
                    let alert = UIAlertController(title: "No Internet Connection or Server-side problem", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                        
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)

                }
            }
        }
    }

    
  //MARK: Open Safari
    @IBAction func openUrl(_ sender: AnyObject) {
        if let url = article.url {
            if let url : URL = URL(string: url){
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = URL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    //MARK: Helper
    func heightForView(_ label: UILabel){
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
    }
    
    
    @IBAction func segmentControl(_ sender: AnyObject) {
        LilithProgressHUD.show(view: tableView)
        let segmentControl : UISegmentedControl = sender as! UISegmentedControl
        let index = segmentControl.selectedSegmentIndex
        if index == 0 {
            let randomNumber = Int(arc4random_uniform(UInt32(lastestSource.count)))
            self.getNews(lastestSource[randomNumber])
        } else if index == 1 {
            let randomNumber = Int(arc4random_uniform(UInt32(popularSource.count)))
            self.getNews(popularSource[randomNumber])
        }
    }
    
    //MARK: Table View datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath) as! LNNewsTableViewCell
        cell.setupCell(dataSource[indexPath.row])
        return cell        
    }
    
    //MARK: Table View delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let article = dataSource[indexPath.row]
        LNAPICall.sharedInstance.fetchImageForArticle(article) {
            (imageResult: ImageResult) in
            OperationQueue.main.addOperation(){
                if let photoIndexRow = self.dataSource.index(of: article) {
                    let photoIndexPath = IndexPath(row: photoIndexRow, section: 0)
                    if let cell = tableView.cellForRow(at: photoIndexPath) as? LNNewsTableViewCell{
                        cell.updateWithImage(article.image)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let newsViewController = storyboard.instantiateViewController(withIdentifier: "NewsViewController") as? NewsViewController {
                newsViewController.article = dataSource[indexPath.row]
                if var viewControllers = navigationController?.viewControllers {
                    viewControllers[viewControllers.count - 1] = newsViewController
                    navigationController?.setViewControllers(viewControllers, animated: true)
                }
            }
    }

    
    //end
}

