//
//  VetendasViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/25/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit

class VetendasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let navBarColor = UIColor(red: 142/255, green: 63/255, blue: 175/255, alpha: 1)
    var xidmetler = ["Qəbula yazıl"]
    var menuBtn = UIButton(type: .custom)
    var menuBarItem = UIBarButtonItem()
    var revContr = CustomSWRevealController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    
    func initView(){
        setUpMenuButton()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = navBarColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.revContr = self.revealViewController() as! CustomSWRevealController
        
    }
    
    func setUpMenuButton(){
        
        menuBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuBtn.setImage(UIImage(named: "menuIcon.png"), for: UIControl.State.normal)
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        menuBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 30)
        
        
        menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        menuBarItem = UIBarButtonItem(customView: menuBtn)
        
        self.navigationItem.leftBarButtonItem = menuBarItem
        revealViewController()?.rearViewRevealWidth = UIScreen.main.bounds.size.width - 80
        
        view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  xidmetler.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let nib: [CustomElectronCell] = Bundle.main.loadNibNamed("CustomElectronCell", owner: self, options: nil) as! [CustomElectronCell]
        let cell = nib[0]
    
        cell.xidmetNameLbl.text = xidmetler[indexPath.row]
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = true
        cell.nameView.layer.cornerRadius = 4
        cell.nameView.layer.masksToBounds = true
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if(indexPath.row == 0)
        {
            performSegue(withIdentifier: "segueToQebul", sender: self)
        }
        
    }
    
  
    

}
