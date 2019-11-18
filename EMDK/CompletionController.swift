//
//  CompletionController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 6/23/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class CompletionController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    var number = ""
    var date = ""
    var VC = ErizeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

      mainView.layer.cornerRadius = 10
      okBtn.layer.cornerRadius = 7
        
     numberLbl.text  = number
        dateLbl.text = date
        
//        print(date)
//       let dateFormatter = DateFormatter()
//       dateFormatter.dateFormat = "MM/dd/yyyy"
//       let date1 = dateFormatter.date(from: String((date.prefix(10))))
//
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        let goodDate = dateFormatter.string(from: date1!)
//        dateLbl.text = goodDate
//
        //dateLbl.text = goodDate + " | " + (date.suffix(8))
    
    }
    


    @IBAction func okBtnClicked(_ sender: Any) {
        VC.navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
}
