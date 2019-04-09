//
//  NewsViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/20/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit
import SDWebImage


struct PostNewsModel: Decodable {
    let data: [PostNewsDataModel]
    let next_page_url: String?
    
}

struct PostNewsDataModel: Decodable {
    let id: Int
    let title: String
    let image: String
    let created_at: String
}

class NewsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var newsCollectionView: UICollectionView!
    var connView = UIView()
    var newImage = [String]()
    var postNews = [PostNewsDataModel]()
    var menuBtn = UIButton(type: .custom)
    var menuBarItem = UIBarButtonItem()
    var currentPage = 1
    var reachedLastPage = false
    var newsIsLoadin = false
    let navBarColor = UIColor(red: 142/255, green: 63/255, blue: 175/255, alpha: 1)
    var indicator = UIActivityIndicatorView();
    var selectedNewsId = 0
    
    var checkConnButtonView = UIView()
    var  tryAgainButton = UIButton()
    var checkConnIndicator = UIActivityIndicatorView()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
      
    }
    
    
    
    func initView(){
        
        setUpMenuButton()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = navBarColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        if let connectionView = Bundle.main.loadNibNamed("CheckConnection", owner: self, options: nil)?.first as? CheckConnection {
            self.view.addSubview(connectionView);
            connectionView.frame.size.height = UIScreen.main.bounds.height
            connectionView.frame.size.width = UIScreen.main.bounds.width
            connectionView.buttonView.clipsToBounds = true
            
            connView = connectionView
            checkConnButtonView = connectionView.buttonView
            checkConnIndicator = connectionView.loadingIndicator
            
            connectionView.tryButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        }
        
        getPostNews(page: currentPage);
        

    }
    
    
    @objc func tryAgain(){
        getPostNews(page: 1)
        checkConnIndicator.isHidden = false
        checkConnButtonView.isHidden = true
        
    }
    
    func setUpMenuButton(){
        
        menuBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuBtn.setImage(UIImage(named: "menuIcon.png"), for: UIControl.State.normal)
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        menuBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 30)
        
        
        menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        menuBarItem = UIBarButtonItem(customView: menuBtn)
        
        self.navigationItem.leftBarButtonItem = menuBarItem
        revealViewController()?.rearViewRevealWidth = UIScreen.main.bounds.size.width - 80
        
    view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postNews.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as! NewsCollectionCell
        
        cell.parentView.layer.cornerRadius = 5
        cell.parentView.layer.masksToBounds = true
        cell.parentView.layer.borderColor = UIColor.gray.cgColor
        cell.parentView.layer.borderWidth = 0.5
        
        cell.newsNameLbl.text = postNews[indexPath.row].title
        
        let urlImage = URL(string: newImage[indexPath.row])
        
        cell.newsImage.sd_setImage(with: urlImage)
        
        
        if(indexPath.row == postNews.count - 1){
            indicator = cell.loadIndicator
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let screenWidth =  screenSize.width
        if(indexPath.row == postNews.count - 1){
            if(reachedLastPage == false)
            {
                 return CGSize(width: screenWidth, height: 360)
            }
           else
            {
                 return CGSize(width: screenWidth, height: 320)
            }
        }
        else
        {
             return CGSize(width: screenWidth, height: 320)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedNewsId = postNews[indexPath.row].id
        performSegue(withIdentifier: "segueNewDetail", sender: self)
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            
            if(newsIsLoadin == false && reachedLastPage == false)
            {
                indicator.isHidden = false
                getPostNews(page: currentPage)
                indicator.startAnimating()
              
              
            }
         
            
        }
    }
    
    func getPostNews(page: Int) {
        let urlString = "http://142.93.186.89/api/v1/posts/index?page=" + "\(page)"
        
        newsIsLoadin = true
        
        guard let url = URL(string: urlString)
            else {return}
        
        URLSession.shared.dataTask(with: url){ (data, response, err) in
            
            
            if(err == nil){
            guard let data = data else { return }
            
            do{
                let slideNews = try JSONDecoder().decode(PostNewsModel.self, from: data)
                
                for i in 0..<slideNews.data.count{
                    let model = slideNews.data[i]
                    self.newImage.append(model.image)
                    self.postNews.append(model)
                }
                
                if(slideNews.next_page_url != nil)
                {
                    self.currentPage = self.currentPage + 1
                }
                else
                {
                    self.reachedLastPage = true
                }
                
                
            }
                
            catch let jsonError {
                print("Error bas verdi " , jsonError)
            }
            
            if (err == nil)
            {
                
                DispatchQueue.main.async {
                    
                    self.connView.isHidden = true
                    self.newsIsLoadin = false
                    self.indicator.isHidden = true
                    self.newsCollectionView.reloadData()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                  
                    })
                    
                }
                
            }
            }
            else
            {
                print("Xeta bas verdi")
                if let error = err as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost{
                        
                        
                        
                        DispatchQueue.main.async {
                            
                            self.connView.isHidden = false
                            self.checkConnIndicator.isHidden = true
                            self.checkConnButtonView.isHidden = false
                            
                        }
                    }
                }
                
            }
            
            }.resume()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueNewDetail")
        {
            let destinationVC = segue.destination as! NewsDetailController
            
            destinationVC.newsId = self.selectedNewsId
        }
    }



}
