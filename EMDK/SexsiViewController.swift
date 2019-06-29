//
//  SexsiViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/21/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit
import LGButton
import LoginWithEgov


struct muracietModel: Decodable {
    let id: Int
    let name: String
    let purpose: String
    let created_at: String
}

class SexsiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var muracieltler = [muracietModel]()
    

    @IBOutlet weak var finLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var UserBtn: LGButton!
   
    @IBOutlet weak var muracietTable: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    var menuBtn = UIButton(type: .custom)
    var menuBarItem = UIBarButtonItem()
    let navBarColor = UIColor(red: 142/255, green: 63/255, blue: 175/255, alpha: 1)
    var userToken = ""
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    var selectedAppealId = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        LoginController.shared.getFinalToken{(token) in
            self.userToken = token
        }
        getAllAppeals()

        initView()
      

    }
    
    func initView(){
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = navBarColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
          //  self.tableHeight.constant = self.muracietTable.contentSize.height
        })
        
        UserBtn.addTarget(self, action: #selector(userClicked), for: .touchUpInside)
        
        let nameSurname = ElectronViewController.model!.name + " " + ElectronViewController.model!.surname
        let fatherName = ElectronViewController.model!.fatherName
        
        nameLbl.text = nameSurname + " " + fatherName
        finLbl.text = ElectronViewController.model?.pin
        
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
        
        
        
        setUpMenuButton()
    }
    
    @objc func tryAgain(){
        getAllAppeals()
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
 
        let nib: [MuracietCell] = Bundle.main.loadNibNamed("MuracietCell", owner: self, options: nil) as! [MuracietCell]
        let cell = nib[0]
        
        cell.muracietView.layer.cornerRadius = 4
        cell.muracietView.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = true
        
        cell.muracietName.text = muracieltler[indexPath.row].name
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.date(from: String(muracieltler[indexPath.row].created_at.prefix(10)))
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let goodDate = dateFormatter.string(from: date!)
        cell.muracietDate.text = goodDate
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedAppealId = muracieltler[indexPath.row].id
        performSegue(withIdentifier: "segueToAppealDetail", sender: self)
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
    
    
    func getAllAppeals(){
        
        self.connView.isHidden = false
        self.checkConnButtonView.isHidden = true
        self.checkConnIndicator.isHidden = false
        
        let urlString = "http://46.101.38.248/api/v1/appeals/list"
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue(self.userToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, err) in
            
            
            if(err == nil){
                guard let data = data else { return }
                
                do{
                    let muracietList = try JSONDecoder().decode([muracietModel].self, from: data)
                    for i in 0..<muracietList.count{
                        let model = muracietModel(id: muracietList[i].id, name: muracietList[i].name, purpose: muracietList[i].purpose, created_at: muracietList[i].created_at)
                        self.muracieltler.append(model)
                    }
                    
                }
                    
                catch let jsonError {
                    self.view.makeToast("Xeta bas verdi: \(jsonError)")
                }
                
                if (err == nil)
                {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                        self.connView.isHidden = true
                        self.muracietTable.reloadData()
                    })
                    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToAppealDetail")
        {
            let vc = segue.destination as! AppealDetailController
            vc.selectedAppealId = self.selectedAppealId
        }
    }
    
}


