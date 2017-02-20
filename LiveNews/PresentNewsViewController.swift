//
//  PresentNewsViewController.swift
//  LiveNews
//
//  Created by mac on 28/01/17.
//  Copyright © 2017 Benjamin Halilovic. All rights reserved.
//

import UIKit

class PresentNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    fileprivate var dataSource = [LNNewsTemporary]()
    var sourceObject  : LNSourceTemporary?
    var source : String? {
        didSet {
           
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureApperance()
        if let source = source {
            getNews(source)
        }
    }
    
    func configureApperance() {
        self.automaticallyAdjustsScrollViewInsets = false
        if let title = sourceObject?.name {
            self.navigationItem.title = title
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Verdana", size: 20)!]
        }
        
    }

    //MARK: data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath) as! LNRandomTabeViewCell
        cell.setupCell(dataSource[indexPath.row], section: indexPath.section)
        return cell
    }
    
    //MARK: Table View delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
        newsViewController.article = dataSource[indexPath.row]
        self.show(newsViewController, sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let article = dataSource[indexPath.row]
        LNAPICall.sharedInstance.fetchImageForArticle(article) {
            (imageResult: ImageResult) in
            OperationQueue.main.addOperation(){
                let photoIndexRow = self.dataSource.index(of: article)
                let photoIndexPath = IndexPath(row: photoIndexRow!, section: 0)
                
                if let cell = tableView.cellForRow(at: photoIndexPath) as? LNRandomTabeViewCell{
                    cell.updateWithImage(article.image)
                }
            }
        }
    }
    
    
    //MARK: Fetching data
    func getNews(_ source: String) {
        LNAPICall.sharedInstance.getNews(source) {
            (newsResult: NewsResult) in
            OperationQueue.main.addOperation() {
                switch newsResult {
                case let .Success(news):
                    self.dataSource += news
                    self.tableView.reloadData()
                case let .Failure(error):
                    print("Error fetching recent source: \(error) ")
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

    @IBAction func backToMenu(_ sender: AnyObject) {
        print("back ")
        self.navigationController!.dismiss(animated: true, completion: nil)
    }
}
