//
//  ElectronViewController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/19/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit
import Toast_Swift
// deyisiklik edildi 2jjjj
struct cellData {
    var id  = Int()
    var opened = Bool()
    var title = String()
    var sectionData = [SubServiceModel]()
    
}
// Test
struct SubServiceModel: Decodable {
    let id: Int
    let title: String
    let electronic_service_id: Int
    let created_at: String
    var isFavourite: Bool
}

struct ServiceModel: Decodable {
    let id: Int
    let title: String
    let sub_services: [SubServiceModel]
    let created_at: String
}

struct FavoritModel:Decodable {
    let id: Int
    let user_id: Int
    let electronic_sub_service_id: Int
}

struct FavoritDataModel:Decodable {
    let data: [FavoritModel]
}

struct FavCellData {
    var electronic_sub_service_id = Int()
    var title = String()

}

class ElectronViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
 
    @IBOutlet weak var favoritBtn: UIButton!
    @IBOutlet weak var electronBtn: UIButton!
    @IBOutlet weak var elektronBtn: UIView!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var segmentView: UIView!
    
    @IBOutlet weak var favoritTable: UITableView!
    @IBOutlet weak var elektronTable: UITableView!
    
    @IBOutlet weak var electronTableBottomConstr: NSLayoutConstraint!
    
    
    @IBOutlet weak var bottomIndicatorView: UIView!
    
    let navBarColor = UIColor(red: 142/255, green: 63/255, blue: 175/255, alpha: 1)
    let testColor = UIColor(red: 142/255, green: 63/255, blue: 175/255, alpha: 1)
    
    let menuBtn = UIButton(type: .custom)
    var menuBarItem = UIBarButtonItem()
    
    var xidmetler = [cellData]()    //  butun servisler
    var FavoritXidmetler = [FavCellData]() // Favorit servisler
    var someControl = [[Int : Int] : Bool]() // hansi sectionda ve hansi rowda ulduzun rengi saridi onu yaddasda saxlamaq ucun dictionary
    var subServiceDict = [Int: String]()
    
    var connView = UIView()
    var checkConnButtonView =  UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    
    var addfavoriteIndicatorView = UIView()
    
    var task1: URLSessionDataTask?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        segmentView.backgroundColor = testColor     
    }
    
    
    func initView(){
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = navBarColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        tabView.layer.cornerRadius = 8
        tabView.layer.borderColor = UIColor.white.cgColor
        tabView.layer.borderWidth = 2
        
        if let connectionView = Bundle.main.loadNibNamed("CheckConnection", owner: self, options: nil)?.first as? CheckConnection {
            self.view.addSubview(connectionView); // Internet olmayanda vey zeif olanda CheckConection adli view-nu goturur ve onu ekrana elve edir
            connectionView.frame.size.height = UIScreen.main.bounds.height
            connectionView.frame.size.width = UIScreen.main.bounds.width
            
            connectionView.buttonView.clipsToBounds = true
            
            connView = connectionView
            checkConnButtonView = connectionView.buttonView
            checkConnIndicator = connectionView.loadingIndicator
        }
        
        
        
        if let indicatorView = Bundle.main.loadNibNamed("IndicatorView", owner: self, options: nil)?.first as? IndicatorView {
            self.view.addSubview(indicatorView);
            indicatorView.frame.size.height = UIScreen.main.bounds.height
            indicatorView.frame.size.width = UIScreen.main.bounds.width
            indicatorView.isHidden = true
            self.addfavoriteIndicatorView = indicatorView
            indicatorView.indicatorParentView.layer.cornerRadius = 10
        }
        
        getServices()
        
        setUpMenuButton()
    }
    
    @objc func tryAgain(){
        getServices()
        checkConnIndicator.isHidden = false
        checkConnButtonView.isHidden = true
        
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
    
    
    @IBAction func electronClicked(_ sender: Any) {  // electron xidmeetler tabi cliclenende
        
       segmentView.clipsToBounds = true
        
       electronBtn.backgroundColor = UIColor.clear
       electronBtn.setTitleColor(navBarColor, for: .normal)
        
       favoritBtn.backgroundColor = navBarColor
       favoritBtn.setTitleColor(UIColor.white, for: .normal)
        
       elektronTable.isHidden = false
       favoritTable.isHidden = true
    
        
    }
    
    @IBAction func favoritClicked(_ sender: Any) { //Favoritler tabi clicklenende
        
        segmentView.clipsToBounds = true
        
        electronBtn.backgroundColor = navBarColor
        electronBtn.setTitleColor(UIColor.white, for: .normal)
        
        favoritBtn.backgroundColor = UIColor.clear
        favoritBtn.setTitleColor(navBarColor, for: .normal)
        
        elektronTable.isHidden = true
        favoritTable.isHidden = false
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == elektronTable){
            return xidmetler.count
            
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == elektronTable){
        if(xidmetler[section].opened == true)
        {
           
            return xidmetler[section].sectionData.count + 1
        }
        else
        {
            
            return 1
        }
        }
        else
        {
            return FavoritXidmetler.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // electron table-nin setiri 2 curdur: servisler ve subservisler. Eger indexpath.row = 0 olarsa demeli bu servisdir. eger indexpath.row !=0  olarsa demeli bu subservisdir. Ilk olaraq servisin cell -ni yaradiriq.
        if(tableView == elektronTable){
        if(indexPath.row == 0)
        {
          // Burada CustomElectroncell UiTableViewCell classindan torenmis bir classdir. CustomElectronCell adli xib faylinda 2 dene View var.
            // asagidaki kod vasitesile biz hemin Viewlarin arrayini aliriq. Bizim servisimizin cell - i nib[0] olacaq
        let nib: [CustomElectronCell] = Bundle.main.loadNibNamed("CustomElectronCell", owner: self, options: nil) as! [CustomElectronCell]
          let cell1 = nib[0]
            
            if(xidmetler[indexPath.section].opened == true && xidmetler[indexPath.section].sectionData.count != 0){
                let seperatorColor = UIColor(red: 119/255, green: 119/255, blue: 118/255, alpha: 0.4)
                cell1.bottomView.backgroundColor = seperatorColor
                cell1.bottomViewHeight.constant = 1
            }
        
        cell1.layer.cornerRadius = 4
        cell1.layer.masksToBounds = true
        cell1.nameView.layer.cornerRadius = 4
        cell1.nameView.layer.masksToBounds = true
        
            
        cell1.xidmetNameLbl.text = xidmetler[indexPath.section].title
        
        
        return cell1
        }
        
        else  // Burda ise artiq subservicler ucun cell - i  hazirliyariq arrayin ikinci elementi subservice ucun cell olacaq: nib[1]
        {
            let nib: [CustomElectronCell] = Bundle.main.loadNibNamed("CustomElectronCell", owner: self, options: nil) as! [CustomElectronCell]
            let cell2 = nib[1]
            
            cell2.subItemLbl.text = xidmetler[indexPath.section].sectionData[indexPath.row - 1].title

            if(xidmetler[indexPath.section].sectionData[indexPath.row-1].isFavourite){
                
                cell2.favImage.setImage(UIImage(named: "yellowStar.png"), for: .normal)
                
            }
            else
            {
                cell2.favImage.setImage(UIImage(named: "greyStar.png"), for: .normal)
            }
            
            
            for(e, value) in someControl{ // somecontrol subservislerde ulduzun sari veya boz rengde olmasini yadda saxlamaq ucun lazim olan bir distionarydi. Burada e -> [Int:Int] value ise Bool - dur
                
                for(x, val) in e {
                    
                    if(x == indexPath.section && val == indexPath.row)
                    {
                        if(value == true)
                        {
                            cell2.favImage.setImage(UIImage(named: "yellowStar.png"), for: .normal)
                        }
                        else
                        {
                            cell2.favImage.setImage(UIImage(named: "greyStar.png"), for: .normal)
                        }
                    }
                }
                
            }
            
            // Ulduzlardan sonra istifade etmek ucun onlari taglayiriq
            cell2.favImage.tag = indexPath.section
            cell2.contentView.tag = indexPath.row
            
            cell2.favImage.addTarget(self, action: #selector(favClicked), for: .touchUpInside)
            return cell2
            
        }
        }
        else // Bu ise Favoritlerin table- di
        {
            let nib: [CustomFavCell] = Bundle.main.loadNibNamed("CustomFavCell", owner: self, options: nil) as! [CustomFavCell]
            let cell = nib[0]
            
            cell.nameView.layer.cornerRadius = 4
            cell.nameView.layer.masksToBounds = true
            cell.layer.cornerRadius = 4
            cell.layer.masksToBounds = true
            
            cell.favBtn.addTarget(self, action: #selector(favClicked2), for: .touchUpInside)
            cell.favBtn.tag = indexPath.row
            cell.favBtn.superview?.tag = FavoritXidmetler[indexPath.row].electronic_sub_service_id
            cell.favName.text = FavoritXidmetler[indexPath.row].title
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if(tableView == elektronTable){
        if(xidmetler[indexPath.section].opened == false){
            xidmetler[indexPath.section].opened = true // eger servis baglidirsa onu acir(Subservisleri gosterir)
            for i in 0..<xidmetler.count{ // Bu for dongusu o ise yarayirki bir servis acilanda avtomatik qalan servisler baglansin
                if(i != indexPath.section)
                {
                    xidmetler[i].opened = false
                }
            }
            
           tableView.reloadData() // Table reload olmasa olunan prosesler icra olunmayacaq
         
        }
        else
        {   // eger servis aciqdirsa(Subservisleri gorsenirse ....)
          
            if(indexPath.row == 0){ // servisin ozune tiklayanda
                xidmetler[indexPath.section].opened = false // servisi bagliyir
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
                
            }
            else // subservise tiklayanda..
            {
                performSegue(withIdentifier: "segueToErize", sender: self)
               
            }
            
        }
        }
        else
        {
            
        }
        
    }
    
    @objc func favClicked(sender: UIButton){ // elektron tableda hansisa ulduza tiklayanda ....
        
        if(sender.imageView?.image == UIImage(named: "greyStar.png")){ // eger bozdursa

            sender.setImage(UIImage(named: "yellowStar.png"), for: .normal) // sari ele
            let section = sender.tag // hemin ulduzun sectionunu alir
            let row = sender.superview?.tag // hemin ulduzun row - sunu alir
        
            addfavoriteIndicatorView.isHidden = false
            
            someControl[[section : row!]]  = true // somecontrolda hemin sectionu ve setirin uluduzunu sari edir

            addToFavorites(serviceId: xidmetler[section].sectionData[row! - 1].id, section: section, row: row!, sender: sender) // favoritlere elave edir
            
        }
        else
        {
            sender.setImage(UIImage(named: "greyStar.png"), for: .normal)
            
            let section = sender.tag
            let row = sender.superview?.tag
            
            addfavoriteIndicatorView.isHidden = false
            
            someControl[[section : row!]]  = false
            
            unFavorite(serviceId: xidmetler[section].sectionData[row! - 1].id, section: section, row: row!, sender: sender) // favoritlerden silir..

        }
        
    }
    
    @objc func favClicked2(sender: UIButton){ // favorit table-inda favoritlerden silmek ucun
        sender.setImage(UIImage(named: "greyStar.png"), for: .normal)
        self.addfavoriteIndicatorView.isHidden = false
        unFavoriteFromFavTab(serviceId: (sender.superview?.tag)!, sender: sender) // favoritlerden silir

    }
    
    
    func getServices(){
        
        let urlString = "http://46.101.38.248/api/v1/electronic/services/list"
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("123123123", forHTTPHeaderField: "Authorization") // headerde parameter gonderir
        

        URLSession.shared.dataTask(with: urlRequest){ (data, response, err) in
            
            
            if(err == nil){ // eger hec bir error yoxdursa
                guard let data = data else { return }
                
                do{
                    let serviceDataModel = try JSONDecoder().decode([ServiceModel].self, from: data)
                    
                   for i in 0..<serviceDataModel.count{
                    var x = cellData()
                    x.id = serviceDataModel[i].id
                    x.opened = false
                    x.title = serviceDataModel[i].title
                    x.sectionData = [SubServiceModel]()
                    
                    
                    if(serviceDataModel[i].sub_services.count != 0){
                        
                        for j in 0..<serviceDataModel[i].sub_services.count{
                            x.sectionData.append(serviceDataModel[i].sub_services[j])
                            
                            self.subServiceDict[serviceDataModel[i].sub_services[j].id] = serviceDataModel[i].sub_services[j].title
                        }
                    }
                    self.xidmetler.append(x) // gelen cavabi xidmetlere doldurur
                    
                   }
                    
                }
                    
                catch let jsonError {
                    print("Error bas verdi " , jsonError)
                }
                
                if (err == nil)
                { // eger hec bir error olmasa Xidmetleri yukledikden sonra Favoritleri yukleyir
                    DispatchQueue.main.async {
                          self.getFavoriteServices()
                    }

                }
            }
            else
            { // Eger error olarsa Bglanti olmayan vienu gosterir ki baglanti yoxdu veya zeifdir
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
    
    
    func addToFavorites(serviceId: Int, section: Int, row: Int, sender: UIButton){
        
       
        let urlString = "http://46.101.38.248/api/v1/services/favourites/add"
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("123123123", forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = [ // reuqest ile gonderilecek parameterler
            "service_id": serviceId
        ]
       urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8) // percenEscape extensiondu asagida  Internetden copy elemisem(Bilmirem nedise)
        
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 3 // gonderilecek requestde 3 saniyeye cvb vgelmese TimeOut error verecek
        urlconfig.timeoutIntervalForResource = 60 // bilmirem nedise
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue.main)
        
        self.task1 =  session.dataTask(with: urlRequest){ (data, response, err) in
        
            self.addfavoriteIndicatorView.isHidden = true
            if(err == nil){ //eger error yoxdursa demeli Table - larda deyisiklik ede bilerik(Elave edilmis servisin ulduzunu sari edirik ve hemin servisi Favoritlerin en basina insert edirik)
              var x = FavCellData()
              x.electronic_sub_service_id =  self.xidmetler[section].sectionData[row - 1].id
              x.title = self.xidmetler[section].sectionData[row - 1].title
                
                DispatchQueue.main.async {
                    self.FavoritXidmetler.insert(x, at: 0)
                    self.favoritTable.reloadData()
                }
                
                
            }
            else
            { // Eger faoritlere elave edilmeyibse Tablelarda deyisiklik etmirik
                if let error = err as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost {
                     
                        DispatchQueue.main.async {
                             self.someControl[[section : row]]  = false // bunu yeniden false edirik cunki ulduza basanda tru elemisdik emeliyyat ugurszuz olduguna gore yeniden false edirik ve tableni reload edirik
                             self.elektronTable.reloadData()
                             self.view.makeToast("Əlavə edilmədi. İnternet bağlantısını yoxlayın.")

                        }
                        
                    }
                    
                    if  error.code == NSURLErrorTimedOut // 3 saniyeden sonra ugursuz olarsa bu error cixir
                    {
                        self.someControl[[section : row]]  = false
                        self.elektronTable.reloadData()
                        self.view.makeToast("Əlavə edilmədi. İnternet bağlantısı zəifdir.")
                    }
                }
                
            }
            
            }
        
           self.task1?.resume()
        
    }
    
    func getFavoriteServices(){

        let urlString = "http://46.101.38.248/api/v1/user/favourites/list?type=1"

        guard let url = URL(string: urlString)
            else {return}

        var urlRequest = URLRequest(url: url)

        urlRequest.setValue("123123123", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: urlRequest){ (data, response, err) in


            if(err == nil){
                guard let data = data else { return }

                do{
                    let favoritDataModel = try JSONDecoder().decode(FavoritDataModel.self, from: data)

                    for i in 0..<favoritDataModel.data.count{
                        var x = FavCellData()
                        x.electronic_sub_service_id = favoritDataModel.data[i].electronic_sub_service_id
                        x.title = self.subServiceDict[favoritDataModel.data[i].electronic_sub_service_id]!

                        self.FavoritXidmetler.append(x)

                    }
                }

                catch let jsonError {
                    print("Error bas verdi " , jsonError)
                }

                if (err == nil)
                {
                DispatchQueue.main.async {

                self.connView.isHidden = true
                self.elektronTable.reloadData()
                self.favoritTable.reloadData()

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
    
    func unFavorite(serviceId: Int, section: Int, row: Int, sender: UIButton){
        
        print(FavoritXidmetler)
        
        let urlString = "http://46.101.38.248/api/v1/services/unFavourite"
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("123123123", forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = [
            "service_id": serviceId
        ]
        urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 3
        urlconfig.timeoutIntervalForResource = 60
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue.main)
        
        let task =  session.dataTask(with: urlRequest){ (data, response, err) in
            
            self.addfavoriteIndicatorView.isHidden = true
            
            if(err == nil){
              
                for i in 0..<self.FavoritXidmetler.count{
                    if(self.FavoritXidmetler[i].electronic_sub_service_id == self.xidmetler[section].sectionData[row - 1].id){
                        self.FavoritXidmetler.remove(at: i)
                        break
                    }
                }

                DispatchQueue.main.async {
                    self.favoritTable.reloadData()
                }
                
                
            }
            else
            {
                if let error = err as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost{
                        
                        DispatchQueue.main.async {
                            self.someControl[[section : row]]  = true
                            self.elektronTable.reloadData()
                            self.view.makeToast("Xəta: İnternet bağlantısını yoxlayın.")

                        }
                        
                    }
                    if(error.code == NSURLErrorTimedOut){
                        self.someControl[[section : row]]  = true
                        self.elektronTable.reloadData()
                        self.view.makeToast("Xəta: İnternet bağlantısı zəifdir.")
                        
                    }
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
    
    
    func unFavoriteFromFavTab(serviceId: Int, sender: UIButton){
        
        let urlString = "http://46.101.38.248/api/v1/services/unFavourite"
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("123123123", forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = [
            "service_id": serviceId
        ]
        urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 3
        urlconfig.timeoutIntervalForResource = 60
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue.main)
        
        let task =  session.dataTask(with: urlRequest){ (data, response, err) in
            
        self.addfavoriteIndicatorView.isHidden = true
            
        var row = 0
        var section = 0
            
            
            for j in 0..<self.xidmetler.count{
                var secData = self.xidmetler[j].sectionData
                for i in 0..<secData.count{
                    
                    if(secData[i].id == self.FavoritXidmetler[sender.tag].electronic_sub_service_id)
                    {
                        row = i + 1
                        section = j
                        break
                    }
                }
                
            }
            
            if(err == nil){

                DispatchQueue.main.async {
                    self.someControl[[section:row]] = false
                    self.FavoritXidmetler.remove(at: sender.tag)
                    self.favoritTable.reloadData()
                    self.elektronTable.reloadData()
                }
                
                
            }
            else
            {
                if let error = err as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost{
                        
                        DispatchQueue.main.async {
                            sender.setImage(UIImage(named: "yellowStar.png"), for: .normal)
                            self.someControl[[section:row]] = true
                            self.view.makeToast("Xəta: İnternet bağlantısını yoxlayın.")
                            
                        }
                        
                    }
                    if(error.code == NSURLErrorTimedOut){
                        sender.setImage(UIImage(named: "yellowStar.png"), for: .normal)
                        self.someControl[[section:row]] = true
                        self.view.makeToast("Xəta: İnternet bağlantısı zəifdir.")
                        
                    }
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
    
    
    
    func showToast(controller: UIViewController, message:String, seconds:Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.blue
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute:{
            
            alert.dismiss(animated: true, completion: nil)
        })
        
        
    }

}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
