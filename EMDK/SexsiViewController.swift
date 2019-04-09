//
//  SexsiViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/21/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit
import LGButton

class SexsiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var muracieltler = ["Daşınmaz əmlaka dair çıxarışların verilməsi üçün müraciətin və sənədlərin qəbulu", "Mülkiyyətçinin arzusu ilə daşınmaz əmlakın dövlət reyestrində qeydiyyata alınmış daşınmaz əmlaka dair texniki sənədlərin (pasportun və plan ölçüsünün) tərtib edilməsi üçün müraciətin və sənədlərin qəbulu", "Məhv olmuş daşınmaz əmlakın və onun üzərindəki hüquqların dövlət qeydiyyatının ləğvi"]
    

    @IBOutlet weak var UserBtn: LGButton!
    @IBOutlet weak var muracietTable: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    var menuBtn = UIButton(type: .custom)
    var menuBarItem = UIBarButtonItem()
    let navBarColor = UIColor(red: 142/255, green: 63/255, blue: 175/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
      

    }
    
    func initView(){
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = navBarColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.tableHeight.constant = self.muracietTable.contentSize.height
        })
        
        UserBtn.addTarget(self, action: #selector(userClicked), for: .touchUpInside)
        
        setUpMenuButton()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return muracieltler.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let nib: [CustomFavCell] = Bundle.main.loadNibNamed("CustomFavCell", owner: self, options: nil) as! [CustomFavCell]
        let cell = nib[0]
        
        cell.nameView.layer.cornerRadius = 4
        cell.nameView.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = true
        
        cell.favBtn.setImage(UIImage(named: "greyStar.png"), for: .normal)
        
       cell.favBtn.addTarget(self, action: #selector(favClicked), for: .touchUpInside)
        cell.favBtn.tag = indexPath.row
      //  cell.favName.text = FavoritXidmetler[indexPath.row]
        cell.favName.font = cell.favName.font.withSize(16)
        cell.favName.text = muracieltler[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @objc func favClicked(sender: UIButton) {
        
        if(sender.imageView?.image == UIImage(named: "greyStar.png"))
        {
            sender.setImage(UIImage(named: "yellowStar.png"), for: .normal)
        }
        else
        {
            sender.setImage(UIImage(named: "greyStar.png"), for: .normal)
        }
        
    }
    
    @objc func userClicked(){
       
        performSegue(withIdentifier: "segueToUserDetail", sender: self)
    }
    
 
    
}
