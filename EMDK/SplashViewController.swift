//
//  SplashViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/18/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit
import LoginWithEgov

class SplashViewController: UIViewController {

    var count = 0
    @IBOutlet weak var splashImage: UIImageView!
    @IBOutlet weak var appName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    
        LoginController.shared.getFinalToken(){(token) in
           // print("token\(token)")
            if(token == "")
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.splashImage.isHidden = true
                    self.appName.isHidden = true
                    self.count = 1
                    self.dismiss(animated: true, completion: nil)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginId") as! LoginButtonController
                    self.present(vc, animated: true, completion: nil)
                })
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.splashImage.isHidden = true
                    self.appName.isHidden = true
                    self.count = 1
                    self.dismiss(animated: true, completion: nil)
                      UIView.setAnimationsEnabled(false)
                      self.performSegue(withIdentifier: "segueToMain", sender: self)
                })
            }
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToMain"){
            let destVC = segue.destination as! CustomSWRevealController
            destVC.vc  = self
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(count == 1)
        {
    
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginId") as! LoginButtonController
            self.present(vc, animated: true, completion: nil)
        }
    }

}
