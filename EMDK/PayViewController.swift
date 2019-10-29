//
//  PayViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 10/29/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import WebKit

class PayViewController: UIViewController {
    
    var url = ""
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.load(URLRequest(url: URL(string: url)!))

        // Do any additional setup after loading the view.
    }
    


}
