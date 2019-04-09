//
//  TestViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/24/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit
import LGButton

class TestViewController: UIViewController {

    @IBOutlet weak var testBtn: LGButton!
    @IBOutlet weak var koko: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testBtn.addTarget(self, action: #selector(haha), for: .touchUpInside)
        
    
    }


    @objc func haha(){
        print("Tata")
    }

    @IBAction func kokoClicked(_ sender: Any) {
        
        getFavoriteServices()
        
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
}
