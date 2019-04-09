//
//  TenzimViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/22/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit

class TenzimViewController: UIViewController {
    
    
    @IBOutlet weak var engilshView: UIView!
    @IBOutlet weak var azerbaijanView: UIView!
    @IBOutlet weak var englishDone: UIImageView!
    @IBOutlet weak var azerbaijanDone: UIImageView!
    
let navBarColor = UIColor(red: 142/255, green: 63/255, blue: 175/255, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        engilshView.tag = 1
        azerbaijanView.tag = 2
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(languageTapped1))
             let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(languageTapped2))
        engilshView.addGestureRecognizer(tapGesture1)
        azerbaijanView.addGestureRecognizer(tapGesture2)
        
        engilshView.isUserInteractionEnabled = true
        azerbaijanView.isUserInteractionEnabled = true
        

    }
    
    @objc func languageTapped1(sender: UIView){
        englishDone.isHidden = false
        azerbaijanDone.isHidden = true
        
    }
    
    
    @objc func languageTapped2(sender: UIView){
        
        englishDone.isHidden = true
        azerbaijanDone.isHidden = false
        
    }
    

    func initView(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = navBarColor
        setupMenuButton()
        
    }
    
    
    func setupMenuButton(){
        let menuBtn = UIButton(type: .custom)
        var menuBarItem = UIBarButtonItem()
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
    



}
