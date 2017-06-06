//
//  posterPaymentCardListClass.swift
//  WorkingBeez
//
//  Created by Swami on 3/6/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class posterPaymentCardListClass: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet weak var tblPaymentCardList: UITableView!
    
    var selectedIndex: Int = 0
    var arrOfCardList: NSMutableArray = NSMutableArray()
    let custObj: customClassViewController = customClassViewController()
    var contentMsg: ContentMessageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        contentMsg = ContentMessageView.CreateView(self.view, strMessage: "No records found", strImageName: "WB_Font", color: UIColor.lightGray)
        contentMsg.isHidden = true
        self.tblPaymentCardList.dataSource = self
        self.tblPaymentCardList.delegate = self
        tblPaymentCardList.register(UINib(nibName: "posterPaymentCardListCell", bundle: nil), forCellReuseIdentifier: "posterPaymentCardList")
        
        view.backgroundColor = API.appBackgroundColor()
        
        tblPaymentCardList.layer.cornerRadius = 10.0
        tblPaymentCardList.clipsToBounds = true
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: API.blackColor(), NSFontAttributeName: UIFont(name: font_openSans_regular, size: 14)!]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = API.NavigationbarColor()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        getCardList()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnselectCard(_ sender: Any)
    {
        selectedIndex = (sender as AnyObject).tag
        
        let uiAlert = UIAlertController(title: ALERT_TITLE, message: "Are you sure want to make this card as default?", preferredStyle: UIAlertControllerStyle.alert)
        uiAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let dd: NSDictionary = self.arrOfCardList.object(at: self.selectedIndex) as! NSDictionary
            self.makeDefault(CardID: dd.object(forKey: "CardID") as! String)
        }))
        
        uiAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
        }))
        self.present(uiAlert, animated: true, completion: nil)
    }
    @IBAction func btnDeletCard(_ sender: Any)
    {
        selectedIndex = (sender as AnyObject).tag
        let uiAlert = UIAlertController(title: ALERT_TITLE, message: "Are you sure want to delete this card?", preferredStyle: UIAlertControllerStyle.alert)
        uiAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let dd: NSDictionary = self.arrOfCardList.object(at: self.selectedIndex) as! NSDictionary
            self.deleteCard(CardID: dd.object(forKey: "CardID") as! String)
        }))
        
        uiAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
        }))
        self.present(uiAlert, animated: true, completion: nil)
    }
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfCardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "posterPaymentCardList", for: indexPath as IndexPath) as! posterPaymentCardListCell
        cell.btnSelectCard.isHidden = true
        cell.imgCardType.backgroundColor = API.appBackgroundColor()
        let dd: NSDictionary = arrOfCardList.object(at: indexPath.row) as! NSDictionary
        
        cell.lblCardName.text = dd.object(forKey: "Name") as? String
        cell.lblCardNumber.text = String(format: "XXXX XXXX XXXX %@", dd.object(forKey: "Last4") as! String)
        
        
        if dd.object(forKey: "Default") as! Bool == true
        {
            cell.btnSelectCard.isSelected = true
        }
        else
        {
            cell.btnSelectCard.isSelected = false
        }
        cell.btnSelectCard.isHidden = false
        cell.btnSelectCard.tag = indexPath.row
        cell.btnDeleteOutlet.tag = indexPath.row
        cell.btnSelectCard.addTarget(self, action: #selector(self.btnselectCard(_:)), for: UIControlEvents.touchUpInside)
        cell.btnDeleteOutlet.addTarget(self, action: #selector(self.btnDeletCard(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }

    
    func addTapped(sender: UIBarButtonItem)
    {
        let obj: addCreditCardClass = self.storyboard?.instantiateViewController(withIdentifier: "addCreditCardClass") as! addCreditCardClass
        obj.objCardList = self
        obj.fromWhere = "cardList"
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    //MARK:- Call API
    func getCardList()
    {
        arrOfCardList = NSMutableArray()
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        print(parameter)
        API.callApiPOST(strUrl: API_GetCard,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                for item in arr
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    self.arrOfCardList.add(dictMutable)
                }
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            if self.arrOfCardList.count == 0
            {
                self.contentMsg.isHidden = false
            }
            else
            {
                self.contentMsg.isHidden = true
            }
            self.tblPaymentCardList.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.contentMsg.isHidden = false
        })
    }
    func makeDefault(CardID:String)
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(CardID, forKey: "CardID")
        print(parameter)
        API.callApiPOST(strUrl: API_SetCardDefault,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.getCardList()
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    func deleteCard(CardID:String)
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(CardID, forKey: "CardID")
        print(parameter)
        API.callApiPOST(strUrl: API_DeleteCard,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                //self.arrOfCardList.removeObject(at: self.selectedIndex)
                //self.tblPaymentCardList.reloadData()
                self.getCardList()
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
}
