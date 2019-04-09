//
//  SplashViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/18/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            
            self.performSegue(withIdentifier: "segueToLogin", sender: self)
        })
    }
    

    


}
