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
import Photos
import BSImagePicker
import LoginWithEgov


struct PurposeModel: Decodable {
    let id: Int
    let title: String
    let deadline: String
    let is_plan: Int
}

struct PurposeDataModel{
    var id = Int()
    var title = String()
    var deadline = String()
    var is_plan = Int()
}

struct PurposeModel2: Decodable {
    let code: String
    let title: String
    let deadline: String
    let is_plan: Int
}


struct RegionModel: Decodable {
    let code: Int32
    let name: String
}

struct RegionDataModel{
    var code = Int32()
    var name = String()
}

struct AppealResponseModel: Decodable {
    let responseEgov: ResponseEgovModel
}

struct ResponseEgovModel:Decodable {
        let Sened_Nomresi: String
        let Son_Icra_Tarixi: String
        let Error: String
}

struct EgovErrorModel:Decodable {
    let message: String
}

class ErizeViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource{

    var phoneTextField = UITextField()
    var mailTextField = UITextField()
    var nameTextField = UITextField()
    var voenTextFiled = UITextField()
    var fileCollectionView: UICollectionView?
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
    var images = [Int]()
    var fileCollectionViewHeight  = NSLayoutConstraint()
    var selectedAssats = [PHAsset]()
    var photoArray = [UIImage]()
    var selectedImage = UIImage()
    
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    
    var userToken = ""
    var allPusrposes = [PurposeDataModel]()
    var allRegions = [RegionDataModel]()
    
    var deadlineString = ""
    var deadlineArray = [String]()
    
    var selectedPurpose = ""
    var selectedRegion = ""
    var selectedDeadline = ""
    
    var base64Array = [String]()
    var errorList = [EgovErrorModel]()
    
    var rightButton = UIButton()
    var senedNumber = ""
    var date = ""
    
    var closeInformation = 0
    var selectedPurposeId = 0
    var selectedPusrposeIndex = 0
    var subServiceId = 0

    
    @IBOutlet weak var stepIndicator: StepIndicatorView!
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       initView()
       addPages()
        
        stepIndicator.layer.shadowOffset = CGSize(width: 0, height: 1)
        stepIndicator.layer.shadowColor = UIColor.lightGray.cgColor
        stepIndicator.layer.shadowOpacity = 1
        stepIndicator.layer.shadowRadius = 5
        stepIndicator.layer.masksToBounds = false
        stepIndicator.circleStrokeWidth = 1.0
        stepIndicator.circleRadius = 10

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
        
      LoginController.shared.getFinalToken{(token) in
        self.userToken = token
        }
        
        if(subServiceId == 0){
            getAppealPurposes()
        }
        else{
            getAppealPurposes2()
        }
        
        print("SelectedPurpose \(selectedPurposeId)")
        
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
        
        rightButton = UIButton(type: .custom)
        rightButton.setImage(UIImage(named: "rightArrow.png"), for: UIControl.State.normal)
        
        rightButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 25, bottom: 5, right: -10)
        rightButton.addTarget(self, action: #selector(nextClicked), for: .touchUpInside)
        let barButton2 = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = barButton2
        
        self.title = "Onlayn müraciət"
        
        if let connectionView = Bundle.main.loadNibNamed("CheckConnection", owner: self, options: nil)?.first as? CheckConnection {
            self.view.addSubview(connectionView);
            connectionView.frame.size.height = UIScreen.main.bounds.height
            connectionView.frame.size.width = UIScreen.main.bounds.width
            connectionView.buttonView.clipsToBounds = true
            
            connView = connectionView
            checkConnButtonView = connectionView.buttonView
            checkConnIndicator = connectionView.loadingIndicator
            
            connectionView.tryButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        }
        
    }
    
    @objc func tryAgain(){
        getAppealPurposes()
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
            self.rightButton.isHidden = false

        }
     
        
    }
    
    @objc func nextClicked(){
      resignAllTextFields()
        
        if(stepIndicator.currentStep == 5)
        {
            
           stepIndicator.currentStep = 6
            self.rightButton.isHidden = true
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
         print(UIScreen.main.bounds.height)

        if(UIScreen.main.bounds.height < 600){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {

                self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - self.keyboardHeight, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
        }
        if(UIScreen.main.bounds.height > 650 && UIScreen.main.bounds.height < 700){
            
             self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 110, width:self.view.frame.size.width, height:self.view.frame.size.height);
        }
        
        if(UIScreen.main.bounds.height > 700 && UIScreen.main.bounds.height < 750){
            
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 75, width:self.view.frame.size.width, height:self.view.frame.size.height);
        }
        
        
        if(textField != step4.reystrTextField){
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.purple.cgColor
        }
        
        else
        {
            step4.textFieldView.layer.borderWidth = 1
             step4.textFieldView.layer.cornerRadius = 5
             step4.textFieldView.layer.borderColor = UIColor.purple.cgColor
        }

    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(UIScreen.main.bounds.height < 600){
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + self.keyboardHeight, width:self.view.frame.size.width, height:self.view.frame.size.height);
        }
        
        if(UIScreen.main.bounds.height > 650 && UIScreen.main.bounds.height < 700){
            
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 110, width:self.view.frame.size.width, height:self.view.frame.size.height);
        }
        
        if(UIScreen.main.bounds.height > 700 && UIScreen.main.bounds.height < 750){
            
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 75, width:self.view.frame.size.width, height:self.view.frame.size.height);
        }
        
        
        if(textField != step4.reystrTextField){
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor(red: 233/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        }
        else
        {
            step4.textFieldView.layer.borderWidth = 1.5
           step4.textFieldView.layer.cornerRadius = 5
            step4.textFieldView.layer.borderColor = UIColor(red: 233/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        }
       
    }
    

    @objc func huquqiClicked(){
        
        huquqiBtn.backgroundColor = purpleColor
        huquqiBtn.setTitleColor(UIColor.white, for: .normal)
        
        fizikiBtn.backgroundColor = UIColor.white
        fizikiBtn.setTitleColor(purpleColor, for: .normal)
        
        step2.infLbl.text = "Adından etibarnamə ilə çıxış etdiyiniz hüquqi şəxsin məlumatlarını dəqiq doldurun"
        step2.nameTextField.isHidden = false
        step2.nameLbl.isHidden = false
        step2.nameFieldHeight.constant = 45
        step2.const1.constant = 12
        step2.const2.constant = 16
        
        if(UIScreen.main.bounds.height < 600){
            step2.frame = CGRect(x: view.frame.size.width * CGFloat(1), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        }
        else{
            step2.frame = CGRect(x: view.frame.size.width * CGFloat(1), y: 0, width: view.frame.size.width, height: 460)
        }
        
        step2.const3.constant = 16
        step2.voenTextField.isHidden = false
        step2.voenLbl.text = "HÜQUQI ŞƏXSIN VÖEN-I:"
        step2.seriaTextfield.isHidden = true
        step2.seriaTextfield.resignFirstResponder()
        
    }
    
    @objc func fizikiClicked(){
        huquqiBtn.backgroundColor = UIColor.white
        huquqiBtn.setTitleColor(purpleColor, for: .normal)
        
        fizikiBtn.backgroundColor = purpleColor
        fizikiBtn.setTitleColor(UIColor.white, for: .normal)
        
        step2.infLbl.text = "Adından etibarnamə ilə çıxış etdiyiniz fiziki şəxsin məlumatlarını dəqiq doldurun"
        step2.nameTextField.isHidden = true
        step2.voenTextField.isHidden = true
        step2.voenLbl.text = "SƏNƏDİN SERİYA VƏ NÖMRƏSİ"
        step2.seriaTextfield.isHidden = false
        step2.nameFieldHeight.constant = 0
        step2.const1.constant = 0
        step2.const2.constant = 0
        step2.const3.constant = 0
        step2.nameLbl.isHidden = true
        step2.frame = CGRect(x: view.frame.size.width * CGFloat(1), y: 0, width: view.frame.size.width, height: 360)
        
        print(deadlineString)
        
    }
    
    func resignAllTextFields(){
        phoneTextField.resignFirstResponder()
        mailTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        voenTextFiled.resignFirstResponder()
        step4.reystrTextField.resignFirstResponder()
        step2.seriaTextfield.resignFirstResponder()
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
        
        
        if(UIScreen.main.bounds.height < 600){
             step1.frame = CGRect(x: view.frame.size.width * CGFloat(0), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        }
        else{
            step1.frame = CGRect(x: view.frame.size.width * CGFloat(0), y: 0, width: view.frame.size.width, height: 430)
        }
        step1.headerView.layer.cornerRadius = 10
        step1.scrollView.layer.cornerRadius = 10
        
        let nameSurname = ElectronViewController.model!.name + " " + ElectronViewController.model!.surname
        let fatherName = ElectronViewController.model!.fatherName
        
        step1.nameLbl.text = nameSurname + " " + fatherName
        phoneTextField = step1.phoneTextField
        mailTextField = step1.mailTextField
        step1ScrollBottomConst = step1.bottomConst
        phoneTextField.delegate = self
        mailTextField.delegate = self
        horizontalScrollView.addSubview(step1)
        
    }
    
    
    func configureStep2(){
        
        // step2 - nin detallari
        if(UIScreen.main.bounds.height < 600){
            step2.frame = CGRect(x: view.frame.size.width * CGFloat(1), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        }
        else{
            step2.frame = CGRect(x: view.frame.size.width * CGFloat(1), y: 0, width: view.frame.size.width, height: 460)
        }
        
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
        step2.seriaTextfield.delegate = self
        
        horizontalScrollView.addSubview(step2)
    }
    
    func configureStep3(){
        
        // step3 -un detallari
        step3.frame = CGRect(x: view.frame.size.width * CGFloat(2), y: 0, width: view.frame.size.width, height: 310)
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
        
        if(UIScreen.main.bounds.height < 600){
            step4.frame = CGRect(x: view.frame.size.width * CGFloat(3), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        }
        else{
            step4.frame = CGRect(x: view.frame.size.width * CGFloat(3), y: 0, width: view.frame.size.width, height: 410)
        }

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
        
        if(UIScreen.main.bounds.height < 600){
            step5.frame = CGRect(x: view.frame.size.width * CGFloat(4), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        }
        else{
            step5.frame = CGRect(x: view.frame.size.width * CGFloat(4), y: 0, width: view.frame.size.width, height: 400)
        }

        step5.headerView.layer.cornerRadius = 10
        step5.scrollView.layer.cornerRadius = 10
        step5.muddetLbl.text = "1 Gün"
        
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
        
        if(UIScreen.main.bounds.height < 600){
            step6.frame = CGRect(x: view.frame.size.width * CGFloat(5), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        }
        else{
            step6.frame = CGRect(x: view.frame.size.width * CGFloat(5), y: 0, width: view.frame.size.width, height: 340)
        }
        
        step6.headerView.layer.cornerRadius = 10
        step6.scrollView.layer.cornerRadius = 10
        step6.addButton.layer.cornerRadius = 8
        
        step6.addButton.addTarget(self, action: #selector(addNewImage), for: .touchUpInside)
        
        
        let cellIdentifier = "cellIdentifier"
        step6.fileCollectionView.delegate = self
        step6.fileCollectionView.dataSource = self
        
        step6.fileCollectionView.register(UINib(nibName:"FileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.fileCollectionView = step6.fileCollectionView
        self.fileCollectionViewHeight = step6.collectionHeightConst
  
        horizontalScrollView.addSubview(step6)
      
    }
    
    func configureStep7(){
        
        step7.frame = CGRect(x: view.frame.size.width * CGFloat(6), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        step7.headerView.layer.cornerRadius = 10
        step7.scrollView.layer.cornerRadius = 10
        
        step7.odeBtn.layer.cornerRadius = 8
        step7.odeBtn.addTarget(self, action: #selector(sendAppeal), for: .touchUpInside)
        step7.imtinaBtn.layer.borderWidth = 1
        step7.imtinaBtn.layer.cornerRadius = 8
        step7.imtinaBtn.layer.borderColor = UIColor(red: 233/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        step7.warningTableView.layer.cornerRadius = 10
        
      //  step7.warningView.layer.cornerRadius = 8
        let cellId = "WarningCellId"
        step7.warningTableView.register(UINib(nibName: "WarningTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        step7.warningTableView.delegate = self
        step7.warningTableView.dataSource = self
        step7.warningTableView.isHidden  = true
        
        horizontalScrollView.addSubview(step7)
        
    }
    
    
    @objc func sendAppeal(){
      addToAppeal()
    }
    
    @objc func addNewImage(){
       
        if(photoArray.count == 6){
            self.view.makeToast("Maksimum 6 ədəd fayl seçə bilərsiniz")
        }
        else{
            let vc = BSImagePickerViewController()
            vc.maxNumberOfSelections = 6 - photoArray.count
            self.bs_presentImagePickerController(vc, animated: true,
                                                 select: { (asset: PHAsset) -> Void in
                                                    // User selected an asset.
                                                    // Do something with it, start upload perhaps?
            }, deselect: { (asset: PHAsset) -> Void in
                // User deselected an assets.
                // Do something, cancel upload?
            }, cancel: { (assets: [PHAsset]) -> Void in
                // User cancelled. And this where the assets currently selected.
            }, finish: { (assets: [PHAsset]) -> Void in
                // User finished with these assets
                for i in 0..<assets.count{
                    print(assets.count)
                    self.selectedAssats.append(assets[i])
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.reloadCollectionView()
                })
                
            }, completion: nil)
        }
       
    }
    
    func reloadCollectionView(){
        
        if(selectedAssats.count != 0){
            self.photoArray = []
            for i in 0..<selectedAssats.count{
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbNail = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: selectedAssats[i], targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill, options: option, resultHandler: {(result, info) -> Void in
                    thumbNail = result!
                })
                self.base64Array.append(self.convertImageToBase64(image: resizeImage(image: thumbNail, targetSize: CGSize(width: 300, height: 300))))
                self.photoArray.append(thumbNail)
                
            }
        }
        
     
        if(photoArray.count % 2 == 1)
        {
            self.fileCollectionViewHeight.constant  = CGFloat((photoArray.count/2 + 1)*85)
            
            if(horizontalScrollView.frame.size.height > 340.0 + fileCollectionViewHeight.constant)
            {
                step6.frame.size.height = 340.0 + fileCollectionViewHeight.constant
            }
            
            else

            {
               
                step6.frame.size.height = horizontalScrollView.frame.height
            }
            
        }
        else
        {
            self.fileCollectionViewHeight.constant  = CGFloat((photoArray.count/2)*85)
            
            if(horizontalScrollView.frame.size.height > 340.0 + fileCollectionViewHeight.constant)
            {
                step6.frame.size.height = 340.0 + fileCollectionViewHeight.constant
            }
                
            else
                
            {
                
                step6.frame.size.height = horizontalScrollView.frame.height
            }
            
            
        }
                self.fileCollectionView?.reloadData()
        
    }
    
    
    
    @objc func chooseRegion(){
        sendParameterToPopup = "region"
        performSegue(withIdentifier: "segueToPopup", sender: self)
   
        
    }
    
    @objc func chooseTime(){
        sendParameterToPopup = "time"
        performSegue(withIdentifier: "segueToPopup", sender: self)
    
    }
    
    @objc func removeImage(sender: UIButton){
        photoArray.remove(at: sender.tag)
        base64Array.remove(at: sender.tag)
        selectedAssats.remove(at: sender.tag)
        fileCollectionView?.reloadData()
        
        if(photoArray.count % 2 == 1)
        {
            self.fileCollectionViewHeight.constant  = CGFloat((photoArray.count/2 + 1)*85)
        }
        else
        {
            self.fileCollectionViewHeight.constant  = CGFloat((photoArray.count/2)*85)
        }
        
        if(horizontalScrollView.frame.size.height > 340.0 + fileCollectionViewHeight.constant)
        {
            step6.frame.size.height = 340.0 + fileCollectionViewHeight.constant
        }
            
        else
            
        {
            
            step6.frame.size.height = horizontalScrollView.frame.height
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if(segue.identifier == "segueToPopup")
     {
        let vc = segue.destination as! ErizePopupViewController
        vc.type = self.sendParameterToPopup
        vc.puposes = self.allPusrposes
        vc.setReceiverName = self.setName
        vc.allRegions = self.allRegions
        vc.deadlines = self.deadlineArray
        }
        if(segue.identifier == "segueToImageController"){
            
            let vc = segue.destination as! FullScreenImageController
            vc.selectedImage = self.selectedImage
        }
        if(segue.identifier == "segueToCompletionModal")
        {
             let vc = segue.destination as! CompletionController
            vc.date = self.date
            vc.number = self.senedNumber
            vc.VC = self
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! FileCollectionViewCell
        
        //in this example I added a label named "title" into the MyCollectionCell class
       // cell.title.text = self.objects[indexPath.item]
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.clipsToBounds = true
        
        cell.imageView.image = self.photoArray[indexPath.row]
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(removeImage), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 74)/2 , height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = self.photoArray[indexPath.row]
        performSegue(withIdentifier: "segueToImageController", sender: self)
        
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return errorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WarningCellId", for: indexPath) as! WarningTableViewCell
        
        cell.errorName.text = "• " + errorList[indexPath.row].message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func getAppealPurposes(){
        
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
        
        let urlString = "http://46.101.38.248/api/v1/appeals/purposes/list"
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue(self.userToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, err) in
            
            
            if(err == nil){
                guard let data = data else { return }
                
                do{
                    let purposeList = try JSONDecoder().decode([PurposeModel2].self, from: data)
                    
                    for i in 0..<purposeList.count{
                        var model = PurposeDataModel()
                        model.id = Int(purposeList[i].code)!
                        model.title = purposeList[i].title
                        model.deadline = purposeList[i].deadline
                        model.is_plan = purposeList[i].is_plan
                        
                        self.allPusrposes.append(model)
                        
                    
                        self.deadlineString = self.allPusrposes[0].deadline
                        self.deadlineArray = self.deadlineString.components(separatedBy: ",")
                        self.selectedPurpose = "\(self.allPusrposes[0].id)"
                        self.selectedDeadline = "\(self.deadlineArray[0])"
                        
                    }
                    
                }
                    
                catch let jsonError {
                    print("Error bas verdi " , jsonError)
                }
                
                if (err == nil)
                {
                    DispatchQueue.main.async {
                        
                       self.meqsedLbl.text = self.allPusrposes[0].title
                       self.step5.muddetLbl.text = self.deadlineArray[0] + " gün"
                        
                       self.getAllRegions()
                  
                        if(self.allPusrposes[0].is_plan == 0){
                            self.step3.passportLbl.isHidden = true
                            self.step3.switch.isHidden = true
                        }
                        else
                        {
                            self.step3.passportLbl.isHidden = false
                            self.step3.switch.isHidden = false
                        }
                        
                    }
                    
                }
            }
            else
            {
                if let error = err as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        
                        DispatchQueue.main.async {
                            
                            self.connView.isHidden = false
                            self.checkConnIndicator.isHidden = true
                            self.checkConnButtonView.isHidden = false
                            
                        }
                    }
                }
                
            }
            
            }.resume()
        
    }
    
    func getAppealPurposes2(){
        
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
        
        let urlString = "http://46.101.38.248/api/v1/electronic/subservice/purposes/" + "\(subServiceId)"
        print(urlString)
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue(self.userToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, err) in
            
            
            if(err == nil){
                guard let data = data else { return }
                
                do{
                    let purposeList = try JSONDecoder().decode([PurposeModel2].self, from: data)
                    
                    for i in 0..<purposeList.count{
                        var model = PurposeDataModel()
                        model.id = Int(purposeList[i].code)!
                        model.title = purposeList[i].title
                        model.deadline = purposeList[i].deadline
                        model.is_plan = purposeList[i].is_plan
                        
                        self.allPusrposes.append(model)
                        
                        
                        self.deadlineString = self.allPusrposes[0].deadline
                        self.deadlineArray = self.deadlineString.components(separatedBy: ",")
                        self.selectedPurpose = "\(self.allPusrposes[0].id)"
                        self.selectedDeadline = "\(self.deadlineArray[0])"
                        
                    }
                    
                    print("YYY")
                    print(self.allPusrposes)
                    
                }
                    
                catch let jsonError {
                    print("Error bas verdi " , jsonError)
                }
                
                if (err == nil)
                {
                    DispatchQueue.main.async {

                        self.meqsedLbl.text = self.allPusrposes[0].title
                        self.step5.muddetLbl.text = self.deadlineArray[0] + " gün"

                        self.getAllRegions()

                        if(self.allPusrposes[0].is_plan == 0){
                            self.step3.passportLbl.isHidden = true
                            self.step3.switch.isHidden = true
                        }
                        else
                        {
                            self.step3.passportLbl.isHidden = false
                            self.step3.switch.isHidden = false
                        }

                    }
                    
                }
            }
            else
            {
                if let error = err as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        
                        DispatchQueue.main.async {
                            
                            self.connView.isHidden = false
                            self.checkConnIndicator.isHidden = true
                            self.checkConnButtonView.isHidden = false
                            
                        }
                    }
                }
                
            }
            
            }.resume()
        
    }
    
    func getAllRegions(){
        
        let urlString = "http://46.101.38.248/api/v1/cities/list"
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue(self.userToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, err) in
            
            
            if(err == nil){
                guard let data = data else { return }
                
                do{
                    let regionList = try JSONDecoder().decode([RegionModel].self, from: data)
                    print(regionList)
                    for i in 0..<regionList.count{
                        var model = RegionDataModel()
                        model.code = regionList[i].code
                        model.name = regionList[i].name
                        
                        self.allRegions.append(model)
                        self.selectedRegion = "\(self.allRegions[0].code)"
                        
                    }
                    
                }
                    
                catch let jsonError {
                    self.view.makeToast("Xeta bas verdi: \(jsonError)")
                }
                
                if (err == nil)
                {
                    DispatchQueue.main.async {
                        
                        self.connView.isHidden = true
                        self.step4.regionLbl.text =  self.allRegions[0].name
                    }
                    
                }
            }
            else
            {
                if let error = err as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost{
                        
                        DispatchQueue.main.async {
                            
                            self.connView.isHidden = false
                            self.checkConnIndicator.isHidden = true
                            self.checkConnButtonView.isHidden = false
                            
                        }
                    }
                }
                
            }
            
            }.resume()
        
    }
    
    func addToAppeal(){
        
        // parameters...
        let nameSurname = ElectronViewController.model!.name + " " + ElectronViewController.model!.surname
        let fatherName = ElectronViewController.model!.fatherName
        let nameParameter = nameSurname + " " + fatherName // 1-ci parameter
        let pinParameter = ElectronViewController.model?.pin // 2 ci parameter
        let passportParamater = step2.seriaTextfield.text // 3 cu parameter
        let phoneParameter = step1.phoneTextField.text // 4 cu parameter
        let emailParazmeter = step1.mailTextField.text // 5 ci parameter
        var personTypeParameter = "" // 6 ci parameter
        if(step2.seriaTextfield.isHidden){
            personTypeParameter = "1"
        }
        else{
            personTypeParameter = "2"
        }
        let voenparameter = step2.voenTextField.text // 7 ci parameter
        let personNameparameter = step2.nameTextField.text // 8 ci parameter
        var isPlanParameter = "" // 9 cu parameter
        if(!step3.switch.isHidden)
        {
            if(step3.switch.isOn){
                isPlanParameter = "1"
            }
            else
            {
                isPlanParameter = "0"
            }
        }
        else{
            isPlanParameter = "0"
        }
        let reysterParameter = step4.reystrTextField.text // 10cu parameter
        var fayl1Parameter = ""
        if(base64Array.count == 1)
        {
            fayl1Parameter = base64Array[0]
        }
        var fayl2Parameter = ""
        if(base64Array.count == 2)
        {
            fayl1Parameter = base64Array[0]
            fayl2Parameter = base64Array[1]
        }
        var fayl3Parameter = ""
        if(base64Array.count == 3)
        {
            fayl1Parameter = base64Array[0]
            fayl2Parameter = base64Array[1]
            fayl3Parameter = base64Array[2]
        }
        var fayl4Parameter = ""
        if(base64Array.count == 4)
        {
            fayl1Parameter = base64Array[0]
            fayl2Parameter = base64Array[1]
            fayl3Parameter = base64Array[2]
            fayl4Parameter = base64Array[3]
        }
        var fayl5Parameter = ""
        if(base64Array.count == 5)
        {
            fayl1Parameter = base64Array[0]
            fayl2Parameter = base64Array[1]
            fayl3Parameter = base64Array[2]
            fayl4Parameter = base64Array[3]
            fayl5Parameter = base64Array[4]
        }
        var fayl6Parameter = ""
        if(base64Array.count == 6)
        {
            fayl1Parameter = base64Array[0]
            fayl2Parameter = base64Array[1]
            fayl3Parameter = base64Array[2]
            fayl4Parameter = base64Array[3]
            fayl5Parameter = base64Array[4]
            fayl6Parameter = base64Array[5]
        }
        
      

        
      //  let urlString = "https://ticket.ady.az/test.php"
        let urlString = "http://46.101.38.248/api/v1/appeals/add"
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(self.userToken, forHTTPHeaderField: "Authorization")
        
        
        let parameters: [String: Any] = [
            "name": nameParameter,
            "pin": pinParameter!,
            "passport_number": passportParamater!,
            "phone": phoneParameter!,
            "email": emailParazmeter!,
            "person_type": personTypeParameter,
            "person_voen": voenparameter!,
            "person_name": personNameparameter!,
            "purpose": selectedPurpose,
            "is_plan": isPlanParameter,
            "city": selectedRegion,
            "reyestr_no": reysterParameter!,
            "deadline": selectedDeadline,
            "file_1": fayl1Parameter,
            "file_2": fayl2Parameter,
            "file_3": fayl3Parameter,
            "file_4": fayl4Parameter,
            "file_5": fayl5Parameter,
            "file_6": fayl6Parameter
        ]
        
        //print(fayl1Parameter)
        urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        connView.isHidden = false
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, err) in
            
            if(err == nil){
                guard let data = data else { return }
                do{
                    if (try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary) != nil {
                        let fullResponse = try  JSONDecoder().decode(AppealResponseModel.self, from: data)
                        self.date = fullResponse.responseEgov.Son_Icra_Tarixi
                        self.senedNumber = fullResponse.responseEgov.Sened_Nomresi
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "segueToCompletionModal", sender: self)
                            self.step7.warningTableView.isHidden = true
                        }
                    } else if (try JSONSerialization.jsonObject(with: data, options: []) as? NSArray) != nil {
                       self.errorList = try JSONDecoder().decode([EgovErrorModel].self, from: data)
                        DispatchQueue.main.async {
                              self.step7.warningTableView.reloadData()
                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                    self.step7.warningTableView.isHidden = false
                                     self.step7.warningTableHeight.constant = self.step7.warningTableView.contentSize.height
                             })
                        
                        }
                    } else {
                        print("dataVal is not valid JSON data")
                    }
                    
                }
                catch _{
                    DispatchQueue.main.async {
                        self.view.makeToast("Xəta baş verdi")
                    }
                }
            
                DispatchQueue.main.async {
                    self.connView.isHidden = true
              
                }
                
            }
            else
            {
                if let error = err as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        
                        DispatchQueue.main.async {
                            
                            self.connView.isHidden = true
                            self.view.makeToast("Xəta baş verdi. İnternet bağlantısını yoxlayın")
                            self.step7.warningTableView.isHidden = true
                            
                        }
                    }
                }
                
            }
            
            }.resume()
        
    }
    
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    
    func setName(selectedIndex: Int) -> () {
        if(self.sendParameterToPopup == "erize"){
            meqsedLbl.text = allPusrposes[selectedIndex].title
            deadlineString = allPusrposes[selectedIndex].deadline
            deadlineArray = deadlineString.components(separatedBy: ",")
            step5.muddetLbl.text = deadlineArray[0] + " gün"
            
            if(allPusrposes[selectedIndex].is_plan == 0){
                step3.passportLbl.isHidden = true
                step3.switch.isHidden = true
            }
            else{
                step3.passportLbl.isHidden = false
                step3.switch.isHidden = false
            }
            
            selectedPurpose = "\(allPusrposes[selectedIndex].id)"
            
        }
        if(sendParameterToPopup == "region"){
            step4.regionLbl.text = allRegions[selectedIndex].name
            selectedRegion = "\(allRegions[selectedIndex].code)"
        }
        if(sendParameterToPopup == "time"){
            step5.muddetLbl.text = deadlineArray[selectedIndex] + " gün"
            selectedDeadline = "\(deadlineArray[selectedIndex])"
        }
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("KOKOKOKOKOKOK")
        if(closeInformation == 1)
        {
            self.navigationController?.popViewController(animated: true)

        }
    }
    
    
    
    
    
}
