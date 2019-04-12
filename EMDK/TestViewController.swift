//
//  TestViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/24/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit
import LGButton

class TestViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var testBtn: LGButton!
    @IBOutlet weak var koko: UIButton!
    @IBOutlet weak var testScroll: UIScrollView!
    
    var step6 = Step6()
    var step7 = Step7()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testBtn.addTarget(self, action: #selector(haha), for: .touchUpInside)
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        testScroll.contentSize = CGSize(width: screenWidth * CGFloat(2), height: testScroll.frame.height)
        
        step6 = Bundle.main.loadNibNamed("Step6", owner: self, options: nil)?.first as! Step6
        
        step6.frame = CGRect(x: 0, y: 0, width: testScroll.frame.size.width, height: testScroll.frame.height)
        step6.headerView.layer.cornerRadius = 10
        step6.scrollView.layer.cornerRadius = 10
        // step6.fileCollectionView = fileCollectionView
        step6.addButton.layer.cornerRadius = 8
        
        let cellIdentifier = "cellIdentifier"
        step6.fileCollectionView.delegate = self
        step6.fileCollectionView.dataSource = self
        
        step6.fileCollectionView.register(UINib(nibName:"FileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        testScroll.addSubview(step6)
        
        
        
        step7 = Bundle.main.loadNibNamed("Step7", owner: self, options: nil)?.first as! Step7
        
        step7.frame = CGRect(x: view.frame.size.width, y: 0, width: testScroll.frame.size.width, height: testScroll.frame.height)
        step7.headerView.layer.cornerRadius = 10
        step7.scrollView.layer.cornerRadius = 10
        // step6.fileCollectionView = fileCollectionView
        //step6.addButton.layer.cornerRadius = 8
        
    
        
        testScroll.addSubview(step7)
        
    }


    @objc func haha(){
        print("Tata")
    }

    @IBAction func kokoClicked(_ sender: Any) {
        testScroll.setContentOffset(CGPoint(x: view.frame.width, y: 0), animated: true)
     //   getFavoriteServices()
    
        
    }
    
    override func viewDidLayoutSubviews() {
        print("KOKO")

    }
    
    
    func getFavoriteServices(){
        
        let urlString = "http://46.101.38.248/api/v1/user/favourites/list?type=1"
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("123123123", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, err) in
            
            
            if(err == nil){
               // guard let data = data else { return }
                print("Xeta yoxdur")
                
            }
            else
            {
                print("Xeta bas verdi")
                if let error = err as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost{
                        
                        DispatchQueue.main.async {
                            
                            
                        }
                    }
                }
                
            }
            
            }.resume()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! FileCollectionViewCell
        
        //in this example I added a label named "title" into the MyCollectionCell class
        // cell.title.text = self.objects[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 74)/2 , height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TOTOT")
        
    }
    
    
}
