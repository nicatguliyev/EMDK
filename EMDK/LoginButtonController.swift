//
//  LoginButtonController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 5/28/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import LoginWithEgov
class LoginButtonController: UIViewController {

    @IBOutlet weak var loginButton: AsanLoginDesign!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginTapped))
        loginButton.addGestureRecognizer(tapGesture)
        
     
    }
    
    @objc func loginTapped(){
        let controller = LoginController()
        controller.endpoint = "az.gov.emdk"
        self.present(controller, animated: true, completion: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! SWRevealViewController
        controller.controller = vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LoginController.shared.getFinalToken(){(token) in
            
            if(token == ""){
                print("TTTTTTYoxdur")
            }
            else
            {
                print("TTTTTTvar")
            }
            
        }
        
    }

}
