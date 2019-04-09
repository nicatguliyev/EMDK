//
//  LogutViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/25/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit

class LogutViewController: UIViewController {

    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var popupView: UIView!
    
    var delegate: TableViewController?
    var dismiss:(() -> ())!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        
        noBtn.layer.cornerRadius = 8
        yesBtn.layer.cornerRadius = 8

    }
    

    @IBAction func yesClciked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.dismiss!()   
    }
    
    
    @IBAction func noClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
   
    
}
