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
        
        if(warningType == "email"){
            
            warningMessage.text = "Email düzgün formatda deyil."
        }
        
        if(warningType == "Xeta")
        {
            warningMessage.text = "Xəta baş verdi."
        }
        if(warningType == "success"){
            warningMessage.text = "Əməliyyat uğurla tamamlandı."
        }
     
    }
    

    @IBAction func okClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
