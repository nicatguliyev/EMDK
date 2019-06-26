//
//  UserDetailViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/21/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var berpaTextField: UITextField!
    @IBOutlet weak var unvanTextField: UITextField!
    @IBOutlet weak var elaqeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var finLbl: UILabel!
    @IBOutlet weak var surnameLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var fatherNameLbl: UILabel!
    
    
    
    var leftButton = UIButton()
    var rightButton = UIButton()
    var keyboardHeight = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
        }
    }
    
    func initView(){

        leftButton.setImage(UIImage(named: "backArrow.png"), for: UIControl.State.normal)
        
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: -5, bottom: 5, right: 25)
        leftButton.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = barButton
        
        rightButton.setImage(UIImage(named: "whiteDone.png"), for: UIControl.State.normal)
        
//        rightButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
//        rightButton.translatesAutoresizingMaskIntoConstraints = false
//        rightButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        rightButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        rightButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: -5)
//        rightButton.addTarget(self, action: #selector(doneClicked), for: .touchUpInside)
//        let barButton2 = UIBarButtonItem(customView: rightButton)
//        self.navigationItem.rightBarButtonItem = barButton2
        
        self.title = "Şəxsi məlumatları yenilə"
        
        scrollView.layer.cornerRadius = 10
        scrollView.layer.masksToBounds = true
        
        parentView.layer.cornerRadius = 10
        parentView.layer.masksToBounds = true
        
        let viewTappedGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(viewTappedGesture)
        view.isUserInteractionEnabled = true
        
        finLbl.text = ElectronViewController.model?.pin
        surnameLbl.text = ElectronViewController.model?.surname
        nameLbl.text = ElectronViewController.model?.name
        fatherNameLbl.text = ElectronViewController.model?.fatherName
        
    }
    
    @objc func hideKeyBoard(){
        emailTextField.resignFirstResponder()
        elaqeTextField.resignFirstResponder()
        unvanTextField.resignFirstResponder()
        berpaTextField.resignFirstResponder()
    }
    
    @objc func backClicked(){
        
        self.navigationController?.popViewController(animated: true)
    
    }
    
    @objc func doneClicked(){
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField == emailTextField)
        {
            elaqeTextField.becomeFirstResponder()
        }
        if(textField == elaqeTextField)
        {
            unvanTextField.becomeFirstResponder()
        }
        if(textField == unvanTextField ){
            berpaTextField.becomeFirstResponder()
        }
        if(textField == berpaTextField){
            textField.resignFirstResponder()
        }
        
     
        
        return true
    }
    
    
    /////////////// TextField edit olunmaga baslayir //////////////////
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            self.scrollViewBottomConstraint.constant = self.keyboardHeight + CGFloat(2)
        })
        
    }
    
    ////////////// Textfield edit olunub qutardi ////////////////////
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
       textField.resignFirstResponder()
        
       scrollViewBottomConstraint.constant = 16

    }
    



}
