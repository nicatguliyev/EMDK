//
//  TableViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/19/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var menuImages = ["electronImg.png", "userImg.png", "notificationImg.png", "vetendasImg.png", "newsImg.png", "logoutImg.png"]
    
    var menuNames = ["Elektron xidmətlər", "Şəxsi kabinet", "Bildirişlər", "Vətəndaşlar üçün", "Xəbərlər", "Təhlükəsiz çıxış"]

    @IBOutlet weak var menuTable: UITableView!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var index = NSIndexPath(row: 0, section: 0)
        menuTable.selectRow(at: index as IndexPath, animated: true, scrollPosition: UITableView.ScrollPosition.middle)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableCell
        
        cell.menuImg.image = UIImage(named: menuImages[indexPath.row])
        cell.menuNameLbl.text = menuNames[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // tableView.deselectRow(at: indexPath, animated: true)
        
        if(indexPath.row == 4){
            performSegue(withIdentifier: "segueToNews", sender: self)
            
        }
        if(indexPath.row == 0){
            performSegue(withIdentifier: "segueToXidmet", sender: self)
        }
        if(indexPath.row == 1){
            performSegue(withIdentifier: "segueToSexsi", sender: self)
        }
        if(indexPath.row == 2)
        {
            performSegue(withIdentifier: "segueToTenzim", sender: self)
        }
        if(indexPath.row == 3){
            
            performSegue(withIdentifier: "segueToVetendas", sender: self)
        }
        if(indexPath.row == 5)
        {
              self.revealViewController()?.revealToggle(animated: true)
              performSegue(withIdentifier: "segueToExit", sender: self)
    
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToExit"){
            
            let vc  = segue.destination as! LogutViewController
            vc.dismiss = self.dismiss2
        }
    }
    
    func dismiss2() -> () {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.dismiss(animated: true, completion: nil)
        })
       
        
    }

    
   

}
