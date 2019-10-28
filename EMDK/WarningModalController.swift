//
//  WarningModalController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 4/5/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class WarningModalController: UIViewController {
    
    var warningType = ""

    @IBOutlet weak var warningMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

            warningMessage.text = warningType
        
    }
    

    @IBAction func okClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
