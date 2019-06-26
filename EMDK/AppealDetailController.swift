//
//  AppealDetailController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 6/25/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import LoginWithEgov

struct AppealDetailModel:Decodable {
    var id: Int
    var user_id: Int
    var name: String
    var pin: String
    var phone: String
    var email: String
    var purpose: String
    var city: String
    var reyestr_no: String
    var deadline: Int
    var created_at: String
    var emdk_document_no: String?
    var emdk_end_time: String?
}

class AppealDetailController: UIViewController {
    
    var leftButton = UIButton()
    var userToken = ""
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    var selectedAppealId = 0
    
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var reyestrField: UITextField!
    @IBOutlet weak var purposeField: UITextField!
    @IBOutlet weak var phoneFiled: UITextField!
    @IBOutlet weak var pinField: UITextField!
    @IBOutlet weak var deadlineField: UITextField!
    @IBOutlet weak var endField: UITextField!
    @IBOutlet weak var documentField: UITextField!
    @IBOutlet weak var regionField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftButton.setImage(UIImage(named: "backArrow.png"), for: UIControl.State.normal)
        
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: -5, bottom: 5, right: 25)
        leftButton.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = barButton
        
         self.title = "Müraciət haqqında məlumat"
        
        
        if let connectionView = Bundle.main.loadNibNamed("CheckConnection", owner: self, options: nil)?.first as? CheckConnection {
            self.view.addSubview(connectionView); // Internet olmayanda vey zeif olanda CheckConection adli view-nu goturur ve onu ekrana elve edir
            connectionView.frame.size.height = UIScreen.main.bounds.height
            connectionView.frame.size.width = UIScreen.main.bounds.width
            
            connectionView.buttonView.clipsToBounds = true
            
            connView = connectionView
            checkConnButtonView = connectionView.buttonView
            checkConnIndicator = connectionView.loadingIndicator
            
            connectionView.tryButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
            
        }
        
        LoginController.shared.getFinalToken{(token) in
            self.userToken = token
        }
        
        getAppealDetail()

    }
    

    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tryAgain(){
      
    }
    
    
    func getAppealDetail() {
    
        let urlString = "http://46.101.38.248/api/v1/appeals/show/" + "\(selectedAppealId)"
        
        print(urlString)
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue(self.userToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, err) in
            
            
            if(err == nil){
                guard let data = data else { return }
                
                do{
                    let model = try JSONDecoder().decode(AppealDetailModel.self, from: data)
                    
                    DispatchQueue.main.async {
                        
                          self.connView.isHidden = true
                          self.checkConnIndicator.isHidden = true
                        
                          self.nameField.text = model.name
                          self.deadlineField.text = "\(model.deadline)"
                          self.documentField.text = model.emdk_document_no
                          self.emailField.text = model.email
                          self.endField.text = model.emdk_end_time
                          self.phoneFiled.text = model.phone
                          self.pinField.text = model.pin
                          self.purposeField.text = model.purpose
                          self.regionField.text = model.city
                          self.reyestrField.text = model.reyestr_no
                    }
                    
                }
                    
                catch let jsonError {
                    print("Error bas verdi " , jsonError)
                }
                
            }
            else
            {
                print("Xeta bas verdi")
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

}
