//
//  NewsDetailController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/20/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit
import WebKit
import SDWebImage



struct NewsDetail: Decodable {
    
    let id: Int
    let title: String
    let image: String
    let body: String
    let created_at: String
    
}

class NewsDetailController: UIViewController, WKNavigationDelegate {
    
    var leftButton = UIButton()
    var rightButton = UIButton()
    
    var connView = UIView()
    var checkConnButtonView = UIView()
    var  tryAgainButton = UIButton()
    var checkConnIndicator = UIActivityIndicatorView()
    var newsId = 0
    var detailModel: NewsDetail?
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    leftButton.setImage(UIImage(named: "backArrow.png"), for: UIControl.State.normal)
 
    leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    leftButton.translatesAutoresizingMaskIntoConstraints = false
    leftButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    leftButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    leftButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: -10, bottom: 5, right: 25)
    leftButton.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
    let barButton = UIBarButtonItem(customView: leftButton)
    self.navigationItem.leftBarButtonItem = barButton
        
    rightButton.setImage(UIImage(named: "share.png"), for: UIControl.State.normal)

    rightButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
    rightButton.translatesAutoresizingMaskIntoConstraints = false
    rightButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    rightButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    rightButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 8, right: 0)
    rightButton.addTarget(self, action: #selector(shareClicked), for: .touchUpInside)
    let barButton2 = UIBarButtonItem(customView: rightButton)
    self.navigationItem.rightBarButtonItem = barButton2
        
    self.title = "Xəbərlər"
        
        
        webView.navigationDelegate = self
        self.webView.scrollView.isScrollEnabled = false
        
        
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
        
        getNewsDetail(newsId: newsId)

       
    }
    
    func getNewsDetail(newsId: Int){
        
        let urlString = "http://142.93.186.89/api/v1/posts/show/" + "\(newsId)"
       // let urlString = "http://142.93.186.89/api/v1/content/detail/117"
        
       // newsIsLoadin = true
        
        guard let url = URL(string: urlString)
            else {return}
        
        URLSession.shared.dataTask(with: url){ (data, response, err) in
            
            
            if(err == nil){
                guard let data = data else { return }
                
                do{
                 self.detailModel = try JSONDecoder().decode(NewsDetail.self, from: data)
                
                }
                    
                catch let jsonError {
                    print("Error bas verdi " , jsonError)
                }
                
                if (err == nil)
                {
                    DispatchQueue.main.async {
                        if let x = self.detailModel?.image{
                            let urlImage = URL(string: x)
                            self.newsImage.sd_setImage(with: urlImage)
                        

                        }
                        self.newsTitle.text = self.detailModel?.title
                        self.newsDate.text = self.detailModel?.created_at
                        self.webView.loadHTMLString("<meta name=\"viewport\" content=\"initial-scale=1.0\" />" + (self.detailModel?.body)!, baseURL: nil)
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
    
    @objc func tryAgain(){
        checkConnIndicator.isHidden = false
        checkConnButtonView.isHidden = true
        getNewsDetail(newsId: newsId)
    }
    
    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true)
    }

    @objc func shareClicked(){
       
    }
    
//    private func webViewDidFinishLoad(_ webView: WKWebView) {
//        webViewHeight.constant = webView.scrollView.contentSize.height
//        print("MMMMMMMMMMM")
//        connView.isHidden = true
//    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
             self.webViewHeight.constant = webView.scrollView.contentSize.height
            
        })
          // webViewHeight.constant = webView.scrollView.contentSize.height
           connView.isHidden = true
    }


}
