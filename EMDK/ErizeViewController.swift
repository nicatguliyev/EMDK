//
//  ErizeViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/22/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit
import LGButton
import ButtonBackgroundColor
import StepIndicator

class ErizeViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var phoneTextField = UITextField()
    var mailTextField = UITextField()
    var nameTextField = UITextField()
    var voenTextFiled = UITextField()
  //  var fileCollectionView: UICollectionView?
    var meqsedBtn = LGButton()
    var x = UIButton()
    var meqsedLbl = UILabel()
    var step1ScrollBottomConst = NSLayoutConstraint()
    var keyboardHeight = CGFloat()
    var focused = false
    var step1 = Step1()
    var step2 = Step2()
    var step3 = Step3()
    var step4 = Step4()
    var step5 = Step5()
    var step6 = Step6()
    var step7 = Step7()
    let purpleColor = UIColor(red: 142/255, green: 63/255, blue: 175/255, alpha: 1)
    var fizikiBtn = UIButton()
    var huquqiBtn = UIButton()
    var sendParameterToPopup = ""
    

    
    @IBOutlet weak var stepIndicator: StepIndicatorView!
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       initView()
       addPages()

    NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideKeyboardGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(hideKeyboardGesture)
        view.isUserInteractionEnabled = true
        
        stepIndicator.frame.size.width = UIScreen.main.bounds.width - 32
        stepIndicator.layer.cornerRadius = 5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.configureStep1()
            self.configureStep2()
            self.configureStep3()
            self.configureStep4()
            self.configureStep5()
            self.configureStep6()
            self.configureStep7()
        })
        
    }
    
    @objc func hideKeyboard(){
        resignAllTextFields()
        focused = false
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            keyboardHeight = keyboardRectangle.height
         
        }
    }
    
    
    
    func initView(){
        
        let leftButton = UIButton(type: .custom)
        leftButton.setImage(UIImage(named: "backArrow.png"), for: UIControl.State.normal)
        
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: -10, bottom: 5, right: 25)
        leftButton.addTarget(self, action: #selector(backClicked), for: .touchDown)
        let barButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = barButton
        
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(UIImage(named: "rightArrow.png"), for: UIControl.State.normal)
        
        rightButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 25, bottom: 5, right: -10)
        rightButton.addTarget(self, action: #selector(nextClicked), for: .touchUpInside)
        let barButton2 = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = barButton2
        
        self.title = "Elektron xidmətlər"
   
        
    }
    
    
    @objc func backClicked(){
        
        resignAllTextFields()
        if(stepIndicator.currentStep == 0)
        {
            self.navigationController?.popViewController(animated: true)
        }
        if(stepIndicator.currentStep == 1){
            horizontalScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            stepIndicator.currentStep = 0
        }
        if(stepIndicator.currentStep == 2){
            horizontalScrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
           stepIndicator.currentStep = 1
        }
        if(stepIndicator.currentStep == 3){
            horizontalScrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(2), y: 0), animated: true)
            stepIndicator.currentStep = 2
        }
        if(stepIndicator.currentStep == 4){
            horizontalScrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(3), y: 0), animated: true)
           stepIndicator.currentStep = 3
        }
        if(stepIndicator.currentStep == 5){
            horizontalScrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(4), y: 0), animated: true)
            stepIndicator.currentStep = 4
        }
        if(stepIndicator.currentStep == 6){
            horizontalScrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(5), y: 0), animated: true)
           stepIndicator.currentStep = 5
        }
     
        
    }
    
    @objc func nextClicked(){

      resignAllTextFields()
        
        if(stepIndicator.currentStep == 5)
        {
            
           stepIndicator.currentStep = 6
            horizontalScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(6), y: 0), animated: true)
        }
        
        if(stepIndicator.currentStep == 4)
        {
            
            stepIndicator.currentStep = 5
            horizontalScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(5), y: 0), animated: true)
        }
        
        if(stepIndicator.currentStep == 3)
        {
            
            stepIndicator.currentStep = 4
            horizontalScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(4), y: 0), animated: true)
        }
        
        if(stepIndicator.currentStep == 2)
        {
            
            stepIndicator.currentStep = 3
            horizontalScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(3), y: 0), animated: true)
        }
        
        if(stepIndicator.currentStep == 1)
        {
            
            stepIndicator.currentStep = 2
            horizontalScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(2), y: 0), animated: true)
        }
        
        if(stepIndicator.currentStep == 0)
        {
            
            stepIndicator.currentStep = 1
            horizontalScrollView.setContentOffset(CGPoint(x: view.frame.width, y: 0), animated: true)
        }
     
 
    }
    
    
    func addPages(){
        
           let screenWidth = UIScreen.main.bounds.size.width
        
         horizontalScrollView.contentSize = CGSize(width: screenWidth * CGFloat(7), height: horizontalScrollView.frame.height)
        
         step1 = Bundle.main.loadNibNamed("Step1", owner: self, options: nil)?.first as! Step1
        
         step2 = Bundle.main.loadNibNamed("Step2", owner: self, options: nil)?.first as! Step2
        
         step3 = Bundle.main.loadNibNamed("Step3", owner: self, options: nil)?.first as! Step3
        
         step4 = Bundle.main.loadNibNamed("Step4", owner: self, options: nil)?.first as! Step4
        
         step5 = Bundle.main.loadNibNamed("Step5", owner: self, options: nil)?.first as! Step5
        
         step6 = Bundle.main.loadNibNamed("Step6", owner: self, options: nil)?.first as! Step6
        
        step7 = Bundle.main.loadNibNamed("Step7", owner: self, options: nil)?.first as! Step7
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField == phoneTextField)
        {
            mailTextField.becomeFirstResponder()
        }
        else
        {
            mailTextField.resignFirstResponder()
            focused = false
        }
     
        return true
       
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        focused = true
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {

                self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - self.keyboardHeight, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
      
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + self.keyboardHeight, width:self.view.frame.size.width, height:self.view.frame.size.height);
       
    }
    

    @objc func huquqiClicked(){
        
        huquqiBtn.backgroundColor = purpleColor
        huquqiBtn.setTitleColor(UIColor.white, for: .normal)
        
        fizikiBtn.backgroundColor = UIColor.white
        fizikiBtn.setTitleColor(purpleColor, for: .normal)
        
    }
    
    @objc func fizikiClicked(){
        huquqiBtn.backgroundColor = UIColor.white
        huquqiBtn.setTitleColor(purpleColor, for: .normal)
        
        fizikiBtn.backgroundColor = purpleColor
        fizikiBtn.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    func resignAllTextFields(){
        phoneTextField.resignFirstResponder()
        mailTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        voenTextFiled.resignFirstResponder()
        step4.reystrTextField.resignFirstResponder()
    }
    

    @objc func test(){
        sendParameterToPopup = "erize"
        step3.meqsedBtn2.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
         performSegue(withIdentifier: "segueToPopup", sender: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.step3.meqsedBtn2.backgroundColor = UIColor.clear
        })
        
    }
    
    func configureStep1(){
        
        step1.frame = CGRect(x: view.frame.size.width * CGFloat(0), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        step1.headerView.layer.cornerRadius = 10
        step1.scrollView.layer.cornerRadius = 10
        phoneTextField = step1.phoneTextField
        mailTextField = step1.mailTextField
        step1ScrollBottomConst = step1.bottomConst
        phoneTextField.delegate = self
        mailTextField.delegate = self
        horizontalScrollView.addSubview(step1)
        
    }
    
    
    func configureStep2(){
        
        // step2 - nin detallari
        step2.frame = CGRect(x: view.frame.size.width * CGFloat(1), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        step2.segmentView.layer.cornerRadius = 10
        step2.segmentView.layer.borderColor = purpleColor.cgColor
        step2.segmentView.layer.borderWidth = 1
        step2.segmentView.layer.masksToBounds = true
        step2.step2HeaderView.layer.cornerRadius = 10
        step2.step2ScrollView.layer.cornerRadius = 10
        fizikiBtn = step2.fizikiBtn
        huquqiBtn = step2.huquqiBtn
        nameTextField = step2.nameTextField
        voenTextFiled = step2.voenTextField
        nameTextField.delegate = self
        voenTextFiled.delegate = self
        huquqiBtn.addTarget(self, action: #selector(huquqiClicked), for: .touchUpInside)
        fizikiBtn.addTarget(self, action: #selector(fizikiClicked), for: .touchUpInside)
        
        horizontalScrollView.addSubview(step2)
    }
    
    func configureStep3(){
        
        // step3 -un detallari
        step3.frame = CGRect(x: view.frame.size.width * CGFloat(2), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        step3.headerView.layer.cornerRadius = 10
        step3.scrollView.layer.cornerRadius = 10
        meqsedLbl = step3.meqsedLbl
        meqsedBtn = step3.meqsedBtn
        step3.meqsedBtn.layer.cornerRadius = 8
        step3.meqsedBtn.layer.borderColor = UIColor(red: 233/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        step3.meqsedBtn.layer.borderWidth = 1
        step3.meqsedBtn.layer.masksToBounds = true
        step3.meqsedBtn2.backgroundColorForStates(normal: UIColor.clear, highlighted: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))
        step3.meqsedBtn2.addTarget(self, action: #selector(test), for: .touchUpInside)
        
        
        horizontalScrollView.addSubview(step3)
        
    }
    
    
    func configureStep4(){
        
        step4.frame = CGRect(x: view.frame.size.width * CGFloat(3), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        step4.headerView.layer.cornerRadius = 10
        step4.scrollView.layer.cornerRadius = 10
       
        step4.rayonBtn.layer.cornerRadius = 8
        step4.rayonBtn.layer.borderColor = UIColor(red: 233/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        step4.rayonBtn.layer.borderWidth = 1
        step4.rayonBtn.layer.masksToBounds = true
        step4.rayonBtn.backgroundColorForStates(normal: UIColor.clear, highlighted: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))
        step4.rayonBtn.addTarget(self, action: #selector(chooseRegion), for: .touchUpInside)
        
        step4.reystrTextField.delegate = self
        step4.textFieldView.layer.cornerRadius = 8
        step4.textFieldView.layer.masksToBounds = true
        step4.textFieldView.layer.borderColor = UIColor(red: 233/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        step4.textFieldView.layer.borderWidth = 1
        
        
        horizontalScrollView.addSubview(step4)
        
    }
    
    
    func configureStep5(){
        
        step5.frame = CGRect(x: view.frame.size.width * CGFloat(4), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        step5.headerView.layer.cornerRadius = 10
        step5.scrollView.layer.cornerRadius = 10
        
        step5.muddetBtn.layer.cornerRadius = 8
        step5.muddetBtn.layer.borderColor = UIColor(red: 233/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        step5.muddetBtn.layer.borderWidth = 1
        step5.muddetBtn.layer.masksToBounds = true
        step5.muddetBtn.backgroundColorForStates(normal: UIColor.clear, highlighted: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))
        step5.muddetBtn.addTarget(self, action: #selector(chooseTime), for: .touchUpInside)
        step5.muddetView.layer.cornerRadius = 8
        step5.muddetView.layer.masksToBounds = true
        
        
        horizontalScrollView.addSubview(step5)
        
    }
    
    func configureStep6(){
        
        step6.frame = CGRect(x: view.frame.size.width * CGFloat(5), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        step6.headerView.layer.cornerRadius = 10
        step6.scrollView.layer.cornerRadius = 10
       // step6.fileCollectionView = fileCollectionView
        step6.addButton.layer.cornerRadius = 8
        
        let cellIdentifier = "cellIdentifier"
       // step6.fileCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
      //  let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
      //  step6.fileCollectionView.setCollectionViewLayout(layout, animated: true)
        step6.fileCollectionView.delegate = self
        step6.fileCollectionView.dataSource = self
        
        step6.fileCollectionView.register(UINib(nibName:"FileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
       // self.fileCollectionView = step6.fileCollectionView
        
       // print(step6.scrollView.touchesShouldCancel(in: step6.fil))
        //step6.fileCollectionView = self.fileCollectionView
        //or if you use class:
       // self.collectionView.register(MyCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        //self.fileCollectionView!.delegate = self
     //   self.fileCollectionView!.dataSource = self
        //self.fileCollectionView?.allowsSelection = true
        
        print("added")
        horizontalScrollView.addSubview(step6)
      
    }
    
    func configureStep7(){
        
        step7.frame = CGRect(x: view.frame.size.width * CGFloat(6), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        step7.headerView.layer.cornerRadius = 10
        step7.scrollView.layer.cornerRadius = 10
        
        step7.odeBtn.layer.cornerRadius = 8
        step7.imtinaBtn.layer.borderWidth = 1
        step7.imtinaBtn.layer.cornerRadius = 8
        step7.imtinaBtn.layer.borderColor = UIColor(red: 233/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        
        step7.warningView.layer.cornerRadius = 8
        
        
        horizontalScrollView.addSubview(step7)
        
    }
    
    
    
    @objc func chooseRegion(){
        sendParameterToPopup = "region"
     //   step4.rayonBtn.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        performSegue(withIdentifier: "segueToPopup", sender: self)
      //  DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
      //      self.step4.rayonBtn.backgroundColor = UIColor.clear
       // })
        
    }
    
    @objc func chooseTime(){
        sendParameterToPopup = "time"
       // step4.rayonBtn.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        performSegue(withIdentifier: "segueToPopup", sender: self)
     //   DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
      //      self.step4.rayonBtn.backgroundColor = UIColor.clear
     //   })
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if(segue.identifier == "segueToPopup")
     {
        let vc = segue.destination as! ErizePopupViewController
        vc.type = self.sendParameterToPopup
        
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! FileCollectionViewCell
        
        //in this example I added a label named "title" into the MyCollectionCell class
       // cell.title.text = self.objects[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 74)/2 , height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TOTOT")
            
       
    }
    
    
}
