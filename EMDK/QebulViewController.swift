//
//  QebulViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/25/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit
import LoginWithEgov


struct Sexs: Decodable {
    let id: Int
    let name: String
    
}
struct ReceiverDataModel {
    var id = Int()
    var name = String()
}


class QebulViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var bootomConst: NSLayoutConstraint!
    var keyboardHeight = CGFloat()
    var leftButton = UIButton(type: .custom)
    var rightButton = UIButton(type: .custom)
    
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    var allReceivers = [ReceiverDataModel]()
    var warningType = ""
    var doneCicked = false
    var datePicker = UIDatePicker()
    
    let borderColor = UIColor(red: 233/255, green: 239/255, blue: 244/255, alpha: 1)
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var qebulView: UIView!
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var qebulBtn: UIButton!
    @IBOutlet weak var receiverName: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollBottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    var selectedReceiverId = 0
    @IBOutlet weak var unvanTextField: UITextField!
    var userToken = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.init(identifier: "az")
        datePicker.minimumDate = Date()
        
        let tapGesure = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesure)
        view.isUserInteractionEnabled = true
        
        let tapGesure2 = UITapGestureRecognizer(target: self, action: #selector(dateTapped))
        dateView.addGestureRecognizer(tapGesure2)
        dateView.isUserInteractionEnabled = true
        dateTxtField.inputView = datePicker
        
        LoginController.shared.getFinalToken{(token) in
            self.userToken = token
        }
        
        
        
        getReceiverList()
        initView()
        
        
    }
    
    func initView(){
        
        
        textArea.layer.borderColor = borderColor.cgColor
        textArea.layer.borderWidth = 1
        textArea.backgroundColor = UIColor.white
        textArea.layer.cornerRadius = 5
        
        nameTextField.layer.borderColor = borderColor.cgColor
        surnameTextField.layer.borderColor = borderColor.cgColor
        emailTextField.layer.borderColor = borderColor.cgColor
        numberTextField.layer.borderColor = borderColor.cgColor
        unvanTextField.layer.borderColor = borderColor.cgColor
        dateView.layer.borderColor = borderColor.cgColor
        dateView.layer.borderWidth = 1
        dateView.layer.cornerRadius = 5
        
        qebulBtn.layer.cornerRadius = 10
        qebulBtn.layer.borderColor = borderColor.cgColor
        qebulBtn.layer.borderWidth = 1
        
        qebulView.layer.cornerRadius = 10
        qebulView.layer.masksToBounds = true
        
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
        
        rightButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: -5)
        rightButton.addTarget(self, action: #selector(doneClicked), for: .touchUpInside)
        let barButton2 = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = barButton2
        
        
        qebulBtn.backgroundColorForStates(normal: UIColor.clear, highlighted: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))
        
        if let connectionView = Bundle.main.loadNibNamed("CheckConnection", owner: self, options: nil)?.first as? CheckConnection {
            self.view.addSubview(connectionView);
            connectionView.frame.size.height = UIScreen.main.bounds.height
            connectionView.frame.size.width = UIScreen.main.bounds.width
            connectionView.buttonView.clipsToBounds = true
            
            connView = connectionView
            checkConnButtonView = connectionView.buttonView
            checkConnIndicator = connectionView.loadingIndicator
            
            connectionView.tryButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
            
            qebulBtn.addTarget(self, action: #selector(openReceivers), for: .touchUpInside)
            
        }
        
        self.title = "Qəbula yazıl"
        
    }
    
    @objc func dateTapped(){
        dateTxtField.becomeFirstResponder()
    }
    
    @objc func tryAgain(){
        addToAppeal(receiverId: selectedReceiverId, name: nameTextField.text!, surname: surnameTextField.text!, email: emailTextField.text!, phone: numberTextField.text!, adress: unvanTextField.text!, theme: textArea.text)
    }
    
    @objc func openReceivers(){
        performSegue(withIdentifier: "segueToReceivers", sender: self)
    }
    
    @objc func backClicked(){
        // self.navigationController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneClicked(){
        addToAppeal(receiverId: selectedReceiverId, name: nameTextField.text!, surname: surnameTextField.text!, email: emailTextField.text!, phone: numberTextField.text!, adress: unvanTextField.text!, theme: textArea.text)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    
    @objc func viewTapped(){
        nameTextField.resignFirstResponder()
        surnameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        numberTextField.resignFirstResponder()
        unvanTextField.resignFirstResponder()
        textArea.resignFirstResponder()
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        //        self.bootomConst.constant = self.keyboardHeight + 16
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
        //
        //            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
        //            self.scrollView.setContentOffset(bottomOffset, animated: true)
        //
        //        })
        
        
        
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.purple.cgColor
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        bootomConst.constant = 16
        
        textView.layer.borderWidth = 1.5
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor(red: 233/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //       DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
        //
        //          //  self.bootomConst.constant = self.keyboardHeight + 16
        //        })
        //       self.bootomConst.constant = self.keyboardHeight + 16
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.purple.cgColor
        
        if(textField == dateTxtField){
            dateView.layer.borderWidth = 1
            dateView.layer.cornerRadius = 5
            dateView.layer.borderColor = UIColor.purple.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //  bootomConst.constant = 16
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor(red: 233/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        if(textField == dateTxtField){
            dateView.layer.borderWidth = 1.5
            dateView.layer.cornerRadius = 5
            dateView.layer.borderColor = UIColor(red: 233/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
            
           //let dateString =
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateLbl.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //        if (text == "\n") {
    //            textView.resignFirstResponder()
    //        }
    //        return true
    //    }
    //
    
    func getReceiverList(){
        
        let urlString = "http://31.170.236.6:81/api/v1/receiver/list"
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue(self.userToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, err) in
            
            
            if(err == nil){
                guard let data = data else { return }
                
                do{
                    let receiverList = try JSONDecoder().decode([Sexs].self, from: data)
                    
                    for i in 0..<receiverList.count{
                        var model = ReceiverDataModel()
                        model.id = receiverList[i].id
                        model.name = receiverList[i].name
                        
                        self.allReceivers.append(model)
                        
                    }
                    
                }
                    
                catch let jsonError {
                    print("Error bas verdi " , jsonError)
                }
                
                if (err == nil)
                {
                    DispatchQueue.main.async {
                        
                        self.connView.isHidden = true
                        self.receiverName.text = self.allReceivers[0].name
                        self.selectedReceiverId = self.allReceivers[0].id
                        //    self.elektronTable.reloadData()
                        
                    }
                    
                }
            }
            else
            {
                print("Xeta bas verdi")
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
    
    
    func addToAppeal(receiverId: Int, name: String, surname: String, email: String, phone: String, adress: String, theme: String){
        
        let selectedDate = datePicker.date
        let timeInterval = selectedDate.timeIntervalSince1970
        let intDate = Int(timeInterval)
        
        let urlString = "http://31.170.236.6:81/api/v1/receiver/appeals/add"
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(self.userToken, forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = [
            "receiver_id": receiverId,
            "name": name,
            "surname": surname,
            "email": email,
            "phone": phone,
            "address": adress,
            "theme": theme,
            "date":  "\(intDate)"
        ]
        urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        connView.isHidden = false
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, err) in
            
            let output = String(bytes: data!, encoding: .utf8)
            print(output)
            DispatchQueue.main.async {
                self.connView.isHidden = true
                
            }
            if(err == nil){
                
                
                if let httpResponse = response as? HTTPURLResponse {
                    let code = httpResponse.statusCode
                    
                    if(code == 200){
                        DispatchQueue.main.async {
                            
                            self.warningType = "Əməliyyat uğurla tamamlandı"
                            self.performSegue(withIdentifier: "segueToWarningModal", sender: self)
                            
                            self.receiverName.text = self.allReceivers[0].name
                            self.selectedReceiverId = self.allReceivers[0].id
                            self.nameTextField.text = ""
                            self.surnameTextField.text = ""
                            self.emailTextField.text = ""
                            self.unvanTextField.text = ""
                            self.textArea.text = ""
                            self.numberTextField.text = ""
                            self.dateLbl.text = ""
                            self.datePicker.date = Date()
                        }
                        
                    }
                    if(code == 422){
                        
                        guard let data = data else { return }
                        do{
                            let errorList = try JSONDecoder().decode([[String : String]].self, from: data)
                            
                            DispatchQueue.main.async {
                                self.warningType = errorList[0]["message"]!
                                
                                self.performSegue(withIdentifier: "segueToWarningModal", sender: self)
                            }
                            
                        }
                        catch _{
                            DispatchQueue.main.async {
                                self.view.makeToast("Xəta baş verdi")
                            }
                            
                        }
                        
                    }
                    if(code == 500){
                        DispatchQueue.main.async {
                            self.view.makeToast("Xəta baş verdi")
                        }
                    }
                }
                
            }
            else
            {
                
                DispatchQueue.main.async {
                    self.connView.isHidden = true
                    
                }
                if let error = err as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost{
                        
                        DispatchQueue.main.async {
                            
                            self.view.makeToast("Xəta: İnternet bağlantısını yoxlayın")
                            
                        }
                    }
                    
                }
                
            }
            
        }.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToReceivers")
        {
            let vc = segue.destination as! ErizePopupViewController
            vc.type = "receiver"
            vc.receivers  = self.allReceivers
            vc.setReceiverName = self.setReceiverName
        }
        
        if(segue.identifier == "segueToWarningModal"){
            
            let vc = segue.destination as! WarningModalController
            vc.warningType = warningType
            
        }
    }
    
    func setReceiverName(selectedReceiver: Int) -> () {
        receiverName.text = allReceivers[selectedReceiver].name
        selectedReceiverId = allReceivers[selectedReceiver].id
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
