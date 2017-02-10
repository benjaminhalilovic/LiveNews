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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navImage: UIImageView!
    
    var section = [String : [LNSourceTemporary]]()
    var newsDataSource = [LNNewsTemporary]()
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LilithProgressHUD.show(view: self.view)
        getSources()
        getNews("bbc-news")
        configureApperance()

    }
    
  
    //MARK: Configure Apperance
    func configureApperance() {
        self.automaticallyAdjustsScrollViewInsets = false
        //Background Image
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "Newspaper_background");
        bgImage.contentMode = .scaleToFill
        self.collectionView?.backgroundView = bgImage
        
        // Do any additional setup after loading the view, typically from a nib.
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Configure scrollView
        self.scrollView.contentSize = CGSize(width:self.view.frame.width * 4, height:self.scrollView.frame.height)
        self.scrollView.delegate = self

        
        //ImageView Action
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        scrollView.addGestureRecognizer(tap)
    }

    //MARK: Fetching data - done!
    func getSources() {
        LNAPICall.sharedInstance.getSources(){
            (sourceResult: SourceResult) in
            OperationQueue.main.addOperation() {
                switch sourceResult {
                case let .Success(sources):
                    self.createNSDictionary(sources){
                        bool in
                        closure_onmain { () -> () in
                            LilithProgressHUD.hide(view: self.view)
                        }
                        LNSection.sharedInstance.section = self.section
                        self.collectionView.reloadData()
                    }
                case let .Failure(error):
                    print("Error fetching recent source: \(error) ")
                    let alert = UIAlertController(title: "No Internet Connection or Server-side problem", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
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

    func getNews(_ source: String) {
        LNAPICall.sharedInstance.getNews(source) {
            (newsResult: NewsResult) in
            switch newsResult {
            case let .Success(news):
                print("Successfully found news \(news.count)")
                for article in news[0..<4] {
                    self.getImage(article: article)
                }
            case let .Failure(error):
                print("Error fetching recent sliding news: \(error) ")
            }
        }
    }
    
    func getImage(article: LNNewsTemporary) {
        LNAPICall.sharedInstance.fetchImageForArticle(article) {
            (imageResult: ImageResult) in
            switch imageResult {
            case let .Success(image):
                article.image = image
                self.newsDataSource.append(article)
                if self.newsDataSource.count == 4 {
                    OperationQueue.main.addOperation() {
                        self.imageView.image = self.newsDataSource[0].image
                        self.textLabel.text = self.newsDataSource[0].title
                        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.moveToNextPage), userInfo: nil, repeats: true)
                    }
                }
            case let .Failure(error):
                print("Error fetching recent images for sliding news: \(error) ")
            }
        }
    }

  
    //MARK: Create NSDictionary (key: category -> value: source)
    func createNSDictionary(_ sources: [LNSourceTemporary], onCompletion: (Bool) -> Void) {
        self.section.removeAll()
        for x in sources {
            if let currentCategory = x.category {
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
        }
        onCompletion(true)
    }


    
    //MARK: UICollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath) as! LNSourceCollectionViewCell
        cell.dataSource = self
        cell.delegate = self
        return cell.setupCell(indexPath)
    }
    
    //MARK: UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //Expencive work
        let cell = cell as! LNSourceCollectionViewCell
        cell.tableView.reloadData()
    }
    
    //MARK: Table View data source
    func tableView(_ tableView: UITableView, cell: LNSourceCollectionViewCell, numberOfRowsInSection section: Int) -> Int {
        if let array = self.section[cell.title.text!] {
            if array.count < 3 {
                return array.count
            }
            return 3
        }
        return 0
    }
    
    func tableView(_ table: UITableView, cell: LNSourceCollectionViewCell, cellForRowAtIndexPath index: IndexPath) -> LNSourceTableViewCell {
        let cellForTableView = table.dequeueReusableCell(withIdentifier: "UITableViewCell", for: index) as! LNSourceTableViewCell
        let category = cell.title.text
        if let sourcesArray = self.section[category!]{
            cellForTableView.name.text = sourcesArray[index.row].name
            return cellForTableView
        }
        return UITableViewCell() as! LNSourceTableViewCell
    }
    
    //MARK: Table View delegate
    func tableView(_ tableView: UITableView, collCell: LNSourceCollectionViewCell, willDisplayCell cell: LNSourceTableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        let category = collCell.title.text!
        if let sourceArray = self.section[category] {
            let source = sourceArray[indexPath.row]
            LNAPICall.sharedInstance.fetchImageForSource(source, category: category) {
                imageResult in
                OperationQueue.main.addOperation(){
                    if let array = self.section[category] {
                        let photoIndex = array.index(of: source)
                        let photoIndexPath = IndexPath(row: photoIndex!,  section: 0)
                        if let cell = collCell.tableView.cellForRow(at: photoIndexPath) as? LNSourceTableViewCell{
                            cell.img.image = source.image
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, collCell: LNSourceCollectionViewCell, didSelectRowAtIndexPath indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let navController = storyboard.instantiateViewController(withIdentifier: "NavConPresentNewsViewController") as? UINavigationController {
            let presentNewsVC = navController.viewControllers[0] as! PresentNewsViewController
            let category = collCell.title.text
            if let sourcesArray = self.section[category!] {
                let source = sourcesArray[indexPath.row]
                presentNewsVC.source = source.id
                self.show(navController, sender: self)
            }
        }
    }
    
    
    //MARK: Page Control
    func moveToNextPage (){
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * 4
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        var slideToX = contentOffset + pageWidth

        if  contentOffset + pageWidth == maxWidth {
            slideToX = 0
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
            if let image = newsDataSource[Int(pageNumber)].image {
                imageView.image = image
            }
            textLabel.text = newsDataSource[Int(pageNumber)].title
        }
    }
    
    //MARK:ImageView action
    func imageTapped(_ img: AnyObject)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let newsViewController = storyboard.instantiateViewController(withIdentifier: "NewsViewController") as? NewsViewController {
            newsViewController.article = newsDataSource[pageControl.currentPage]
            self.show(newsViewController, sender: self)
        }
    }
    
    //end
}

