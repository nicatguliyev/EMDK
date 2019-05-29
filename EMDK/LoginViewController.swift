//
//  LoginViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/18/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit
import LoginWithEgov

class LoginViewController: UIViewController, UITextFieldDelegate {
    let navBarColor = UIColor(red: 142/255, green: 63/255, blue: 175/255, alpha: 1)
    let borderColor = UIColor(red: 228/255, green: 227/255, blue: 229/255, alpha: 1)
    
    @IBOutlet weak var asanShadowView: UIView!
    @IBOutlet weak var eGovShadowView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var asanParentView: UIView!
    @IBOutlet weak var eGovView: UIView!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var eGovDoneBackground: UIView!
    @IBOutlet weak var asanDoneBackground: UIView!
    @IBOutlet weak var asanDoneImg: UIImageView!
    @IBOutlet weak var asanView: UIView!
    @IBOutlet weak var bottomImage: UIImageView!
    @IBOutlet weak var passwordView2: UIView!
    @IBOutlet weak var fromToConst: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMainView()
    
    }
    
    @objc func asanTapped(){
        
        asanShadowView.isHidden = true
        asanView.layer.borderColor = navBarColor.cgColor
        asanDoneBackground.isHidden = false
        
        eGovShadowView.isHidden = false
        eGovView.layer.borderColor = borderColor.cgColor
        eGovDoneBackground.isHidden = true
        

        
    }
    
    @objc func eGovTapped(){
        asanShadowView.isHidden = false
        asanView.layer.borderColor = borderColor.cgColor
        asanDoneBackground.isHidden = true
        
        eGovShadowView.isHidden = true
        eGovView.layer.borderColor = navBarColor.cgColor
        eGovDoneBackground.isHidden = false
        
    }
    
    @objc func mainTapped(){
        
        userNameTxtField.resignFirstResponder()
        passwordTxtField.resignFirstResponder()
    }
    
    @objc func userViewtapped(){
        userNameTxtField.becomeFirstResponder()
        
    }
    
    @objc func passwordViewTapped(){
        passwordTxtField.becomeFirstResponder()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == userNameTxtField)
        {
            userNameTxtField.resignFirstResponder()
            passwordTxtField.becomeFirstResponder()
        }
        else
        {
            passwordTxtField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
           let screenSize = UIScreen.main.bounds.size.height
           if(screenSize < 600)
           {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
                
            })
        }
        else
           {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 160, width:self.view.frame.size.width, height:self.view.frame.size.height);
                
            })
        }
        
    
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(UIScreen.main.bounds.size.height < 600){
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
                
            })
        }
        
        else{
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 160, width:self.view.frame.size.width, height:self.view.frame.size.height);
                
            })
        }
    }
    
    func initMainView(){
        
        self.navigationController?.navigationBar.barTintColor = navBarColor
        
        
        let asanTapGesture = UITapGestureRecognizer(target: self, action: #selector(asanTapped))
        asanView.addGestureRecognizer(asanTapGesture)
        asanView.isUserInteractionEnabled = true
        
        let eGovTapGesture = UITapGestureRecognizer(target: self, action: #selector(eGovTapped))
        eGovView.addGestureRecognizer(eGovTapGesture)
        eGovView.isUserInteractionEnabled = true
        
        let mainViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(mainTapped))
        self.view.addGestureRecognizer(mainViewTapGesture)
        
        let userNameGesture = UITapGestureRecognizer(target: self, action: #selector(userViewtapped))
        userNameView.addGestureRecognizer(userNameGesture)
        userNameView.isUserInteractionEnabled = true
        
        let passwordViewGesture = UITapGestureRecognizer(target: self, action: #selector(passwordViewTapped))
        passwordView2.addGestureRecognizer(passwordViewGesture)
        passwordView2.isUserInteractionEnabled = true
        
        asanView.layer.cornerRadius = 8
        asanView.layer.borderColor = navBarColor.cgColor
        asanView.layer.borderWidth = 1
        
        eGovView.layer.cornerRadius = 8
        eGovView.layer.borderColor = borderColor.cgColor
        eGovView.layer.borderWidth = 1
        
        asanParentView.bringSubviewToFront(asanDoneBackground)
        asanParentView.bringSubviewToFront(eGovDoneBackground)
        
        userNameView.layer.borderColor = borderColor.cgColor
        userNameView.layer.borderWidth = 1
        userNameView.layer.cornerRadius = 8
        
        passwordView.layer.borderColor = borderColor.cgColor
        passwordView.layer.borderWidth = 1
        passwordView.layer.cornerRadius = 8
        
        dividerView.backgroundColor = borderColor
        
        loginBtn.backgroundColor = navBarColor
        loginBtn.layer.cornerRadius = 8
        
        bottomImage.image = UIImage(named: "bottomImg.png")
        print(UIScreen.main.bounds.size.height)
        
        if(UIScreen.main.bounds.size.height > 700)
        {
            fromToConst.constant = 100
        }
        if(UIScreen.main.bounds.size.height > 600 && UIScreen.main.bounds.size.height < 700)
            
        {
            fromToConst.constant = 60
        }
        
    }
    
    
    @IBAction func loginClicked(_ sender: Any) {
        
        LoginController.shared.getFinalToken(){
            (token) in
            if(token == ""){
                let controller = LoginController()
                controller.endpoint = "com.nicatguliyev.EMDK"
                self.present(controller, animated: true, completion: nil)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! SWRevealViewController
                controller.controller = vc
            }
            else{                
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! SWRevealViewController
                 self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    
    
}
