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
    var source : String?
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
        self.navigationController?.title = source
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
                    print("Successfully found news \(news.count)")
                    self.dataSource += news
                    self.tableView.reloadData()
                case let .Failure(error):
                    print("Error fetching recent photos: \(error) ")
                }
            }
        }
    }

    @IBAction func backToMenu(_ sender: AnyObject) {
        print("back ")
        self.navigationController!.dismiss(animated: true, completion: nil)
    }
}
