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
    
    var times = ["1 Gün", "2 Gün", "3 Gün", "4 Gün", "5 Gün", "6 Gün", "7 Gün", "8 Gün", "9 Gün", "10 Gün", "11 Gün", "12 Gün", "13 Gün", "14 Gün", "15 Gün", "16 Gün", "17 Gün", "18 Gün", "19 Gün", "20 Gün", "21 Gün", "22 Gün", "23 Gün", "24 Gün", "25 Gün", "26 Gün", "27 Gün", "28 Gün", "29 Gün", "30 Gün", "31 Gün"]
    
    var receivers = [ReceiverDataModel]()
    var puposes = [PurposeDataModel]()
    var allRegions = [RegionDataModel]()
    var deadlines = [String]()

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    var setReceiverName:((Int) -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if(type == "erize")
        {
        
        if(CGFloat(puposes.count) * CGFloat(60) < UIScreen.main.bounds.size.height - CGFloat(100))
        {
         
             tableHeight.constant = CGFloat(puposes.count) * CGFloat(60)
        }
        else
        {
            tableHeight.constant = UIScreen.main.bounds.size.height - CGFloat(100)
        }
        }
        
       else if(type == "region"){
            if(CGFloat(allRegions.count) * CGFloat(60) < UIScreen.main.bounds.size.height - CGFloat(100))
            {
                tableHeight.constant = CGFloat(allRegions.count) * CGFloat(60)
            }
            else
            {
                tableHeight.constant = UIScreen.main.bounds.size.height - CGFloat(100)
            }
            
        }
       else if(type == "receiver")
        {
            if(CGFloat(receivers.count) * CGFloat(60) < UIScreen.main.bounds.size.height - CGFloat(100))
            {
                tableHeight.constant = CGFloat(receivers.count) * CGFloat(60)
            }
            else
            {
                tableHeight.constant = UIScreen.main.bounds.size.height - CGFloat(100)
            }
        }
        else{
            if(CGFloat(deadlines.count) * CGFloat(60) < UIScreen.main.bounds.size.height - CGFloat(100))
            {
                tableHeight.constant = CGFloat(deadlines.count) * CGFloat(60)
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
        if(type == "receiver")
        {
            return receivers.count
            
        }
        else if(type == "erize")
        {
            return puposes.count
        }
        else if(type == "region")
        {
            return allRegions.count
        }
        else
        {
            return deadlines.count
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "erizeCell")
        as! ErizeTypeCell
        
        if(type == "region")
        {
            cell.erizeTypeLbl.text = allRegions[indexPath.row].name
        }
        if(type == "erize")
        {
            cell.erizeTypeLbl.text = puposes[indexPath.row].title
        }
        
        if(type == "receiver")
        {
            cell.erizeTypeLbl.text = receivers[indexPath.row].name
        }
        if(type == "time"){
            
            cell.erizeTypeLbl.text = deadlines[indexPath.row] + " gün"
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
