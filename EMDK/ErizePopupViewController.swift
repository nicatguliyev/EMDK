//
//  ErizePopupViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/24/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit

class ErizePopupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var type = ""
    var countries = ["Agdam", "Agdas", "Agcabedi", "Baki", "Bilesuvar", "Beyleqab", "Sumqayit", "Lenkeran", "Quba", "Qusar", " Lerik"]

    var types = ["Şikayət", "Təklif", "İrad", "Şikayət", "Təklif", "İrad", "Şikayət", "Təklif", "İrad","Şikayət", "Təklif", "İrad", "Şikayət", "Təklif", "İrad", "Şikayət", "Təklif", "İrad"]
    
    var times = ["Gün", "Həftə", "Ay", "İl"]
    
    var receivers = [ReceiverDataModel]()

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    var setReceiverName:((Int) -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if(type == "erize")
        {
        
        if(CGFloat(types.count) * CGFloat(60) + CGFloat(50) < UIScreen.main.bounds.size.height - CGFloat(100))
        {
             tableHeight.constant = CGFloat(types.count) * CGFloat(60) + CGFloat(50)
        }
        else
        {
            tableHeight.constant = UIScreen.main.bounds.size.height - CGFloat(100)
        }
        }
        
        if(type == "region"){
            if(CGFloat(countries.count) * CGFloat(60) + CGFloat(50) < UIScreen.main.bounds.size.height - CGFloat(100))
            {
                tableHeight.constant = CGFloat(countries.count) * CGFloat(60) + CGFloat(50)
            }
            else
            {
                tableHeight.constant = UIScreen.main.bounds.size.height - CGFloat(100)
            }
            
        }
        if(type == "receiver")
        {
            if(CGFloat(receivers.count) * CGFloat(60) + CGFloat(50) < UIScreen.main.bounds.size.height - CGFloat(100))
            {
                tableHeight.constant = CGFloat(receivers.count) * CGFloat(60) + CGFloat(50)
            }
            else
            {
                tableHeight.constant = UIScreen.main.bounds.size.height - CGFloat(100)
            }
        }
        
       
        popupView.layer.cornerRadius = 10
        popupView.layer.borderColor = UIColor(red: 142/255, green: 63/255, blue: 175/255, alpha: 1).cgColor
        popupView.layer.borderWidth = 1
        popupView.layer.masksToBounds = true
      
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(type == "region")
//        {
//             return countries.count
//        }
//        if(type == "erize")
//        {
//            return types.count
//        }
        if(type == "receiver")
        {
            print()
            return receivers.count
            
        }
        else
        {
            print(receivers)
            return 1
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "erizeCell")
        as! ErizeTypeCell
        
        if(type == "region")
        {
            cell.erizeTypeLbl.text = countries[indexPath.row]
        }
        if(type == "erize")
        {
            cell.erizeTypeLbl.text = types[indexPath.row]
        }
        
        if(type == "receiver")
        {
            cell.erizeTypeLbl.text = receivers[indexPath.row].name
        }
        
        
        return cell
        
    }
    

    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setReceiverName(indexPath.row)
         dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    


}
