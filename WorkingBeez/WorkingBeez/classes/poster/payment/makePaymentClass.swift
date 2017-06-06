//
//  makePaymentClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/10/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class makePaymentClass: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var lblExrendedHrs: UILabel!
    @IBOutlet weak var lblExtendedHrsStatic: UILabel!
    @IBOutlet weak var lblTimeSlot: UILabel!
    @IBOutlet weak var lblTimeslotStatik: UILabel!
    @IBOutlet weak var tblPaymentCardList: UITableView!
    @IBOutlet weak var lblTotalhrs: UILabel!
    @IBOutlet weak var lblTotalCharge: UILabel!
    @IBOutlet weak var viewPaymentInfo: cView!
    @IBOutlet weak var btnEditTime: cButton!
    
    var JobTimePeriod: CGFloat = 0.0
    var ExtendedFromTime: String = ""
    var StripeCardID: String = ""
    var selectedIndex: Int = 0
    var arrOfCardList: NSMutableArray = NSMutableArray()
    var totalHour: CGFloat = 0.0
    var totalExtendedHour: CGFloat = 0.0
    var totalEarning: CGFloat = 0.0
    var hourlyRate: CGFloat = 0.0
    var objPP: pendingPaymentClass!
    var dictFromPP: NSMutableDictionary = NSMutableDictionary()
    let custObj: customClassViewController = customClassViewController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tblPaymentCardList.dataSource = self
        self.tblPaymentCardList.delegate = self
        tblPaymentCardList.register(UINib(nibName: "posterPaymentCardListCell", bundle: nil), forCellReuseIdentifier: "posterPaymentCardList")
        
        view.backgroundColor = API.appBackgroundColor()
        
        tblPaymentCardList.layer.cornerRadius = 10.0
        tblPaymentCardList.clipsToBounds = true
        setPrice()
        getCardList()
        
        if dictFromPP.object(forKey: "ExFromTime") as! String == ""
        {
            dictFromPP.setValue(dictFromPP.object(forKey: "ToTime"), forKey: "ExtendedFromTimeToSend")
        }
        else
        {
            dictFromPP.setValue(dictFromPP.object(forKey: "ExFromTime"), forKey: "ExtendedFromTimeToSend")
        }
    }
    func back()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    func setPrice()
    {
        totalExtendedHour = dictFromPP.object(forKey: "NoOfHoursExtended") as! CGFloat
        
        let strJobTimePeriod: String = dictFromPP.object(forKey: "JobTimePeriod") as! String
        if let n = NumberFormatter().number(from: strJobTimePeriod) {
            JobTimePeriod = CGFloat(n)
        }
        
        
        let strTE: String = dictFromPP.object(forKey: "TotalAmount") as! String
        let strHR: String = dictFromPP.object(forKey: "HourlyRate") as! String
        if let n = NumberFormatter().number(from: strTE) {
            totalEarning = CGFloat(n)
        }
        if let n = NumberFormatter().number(from: strHR) {
            hourlyRate = CGFloat(n)
        }
        
        var TotalAmt: CGFloat = 0
        var totalTimeInmin: CGFloat = 0
        var totalAmtInmin: CGFloat = 0
        var totalTimeInHoure: CGFloat = 0
        
        var integer = 0.0
        totalTimeInmin = CGFloat(modf(Double(JobTimePeriod), &integer))
        totalTimeInHoure = JobTimePeriod - totalTimeInmin
        totalTimeInmin = totalTimeInmin * 100
        totalTimeInmin = totalTimeInmin + (totalTimeInHoure * 60)
        
        
        totalAmtInmin = hourlyRate / 60
        var tMin: CGFloat = 0
        var tHour: Int = 0
        var str2: String = ""
        if dictFromPP.object(forKey: "IsBreak") as! Bool == false
        {
            TotalAmt = totalTimeInmin * totalAmtInmin
            
            tMin = totalTimeInmin.truncatingRemainder(dividingBy: 60.0)
            tMin = tMin / 100
            tHour = Int(totalTimeInmin / 60)
        }
        else
        {
            if dictFromPP.object(forKey: "IsBreakPaid") as! Bool == false
            {
                let min: Int = dictFromPP.object(forKey: "BreakMin") as! Int
                TotalAmt = (totalTimeInmin - CGFloat(min)) * totalAmtInmin
                JobTimePeriod = JobTimePeriod - CGFloat(min)/100
                
                let tempJT: CGFloat = totalTimeInmin - CGFloat(min)
                
                tMin = tempJT.truncatingRemainder(dividingBy: 60.0)
                tMin = tMin / 100
                tHour = Int(tempJT / 60)
                
            }
            else
            {
                TotalAmt = totalTimeInmin * totalAmtInmin
                
                tMin = totalTimeInmin.truncatingRemainder(dividingBy: 60.0)
                tMin = tMin / 100
                tHour = Int(totalTimeInmin / 60)
            }
        }
        
        str2 = String(format: "%0.2f", CGFloat(tHour) + tMin)
        str2 = str2.replacingOccurrences(of: ".", with: ":")
        
        lblTotalhrs.text = String(format: "%@ hrs", str2)
        
        lblTotalCharge.text = String(format: "$ %0.2f", TotalAmt)
        
        if dictFromPP.object(forKey: "ExFromTime") as! String == ""
        {
            lblExtendedHrsStatic.isHidden = true
            lblExrendedHrs.isHidden = true
            ExtendedFromTime = dictFromPP.object(forKey: "ToTime") as! String
        }
        else
        {
            btnEditTime.frame = CGRect.init(x: btnEditTime.frame.origin.x, y: lblExrendedHrs.frame.origin.y - 5, width: btnEditTime.frame.size.width, height: btnEditTime.frame.size.height)
            lblExrendedHrs.text = String(format: "%@ - %@", dictFromPP.object(forKey: "ExFromTime") as! String,dictFromPP.object(forKey: "ExToTime") as! String )
            ExtendedFromTime = dictFromPP.object(forKey: "ExToTime") as! String
        }
        lblTimeSlot.text = String(format: "%@ - %@", dictFromPP.object(forKey: "FromTime") as! String,dictFromPP.object(forKey: "ToTime") as! String )
        
    }
    //MARK:- Action zone
    @IBAction func btnEditSlot(_ sender: Any)
    {
        let obj: editTimefromPayment = self.storyboard?.instantiateViewController(withIdentifier: "editTimefromPayment") as! editTimefromPayment
        obj.objMakePayment = self
        obj.dictFromMP = dictFromPP
        self.present(obj, animated: true, completion: nil)
    }
    @IBAction func btnPay(_ sender: Any)
    {
        let uiAlert = UIAlertController(title: ALERT_TITLE, message: "Are you sure want to pay?", preferredStyle: UIAlertControllerStyle.alert)
        uiAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            self.CompleteJob()
        }))
        
        uiAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
        }))
        self.present(uiAlert, animated: true, completion: nil)
        
    }
    @IBAction func btnselectCard(_ sender: Any)
    {
        selectedIndex = (sender as AnyObject).tag
        let arrTemp: NSMutableArray = NSMutableArray()
        for item in arrOfCardList
        {
            let dd: NSDictionary = item as! NSDictionary
            let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
            dictMutable.setValue(false, forKey: "isSelected")
            arrTemp.add(dictMutable)
        }
        arrOfCardList = NSMutableArray.init(array: arrTemp)
        let dd: NSDictionary = arrOfCardList.object(at: selectedIndex) as! NSDictionary
        let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        dictMutable.setValue(true, forKey: "isSelected")
        arrOfCardList.replaceObject(at: selectedIndex, with: dictMutable)
        tblPaymentCardList.reloadData()
        
        self.StripeCardID = dd.object(forKey: "CardID") as! String
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
        
        cell.btnDeleteOutlet.isHidden = true
        if dd.object(forKey: "isSelected") as! Bool == true
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
                    if dd.object(forKey: "Default") as! Bool == true
                    {
                        dictMutable.setValue(true, forKey: "isSelected")
                        self.StripeCardID = dd.object(forKey: "CardID") as! String
                    }
                    else
                    {
                        dictMutable.setValue(false, forKey: "isSelected")
                    }
                    self.arrOfCardList.add(dictMutable)
                }
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            
            self.tblPaymentCardList.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    func CompleteJob()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "PosterID")
        parameter.setValue(dictFromPP.object(forKey: "UserID"), forKey: "SeekerID")
        parameter.setValue(dictFromPP.object(forKey: "AcceptedID"), forKey: "JobAcceptedID")
        parameter.setValue(dictFromPP.object(forKey: "RosterDateID"), forKey: "RosterDateID")
        parameter.setValue(dictFromPP.object(forKey: "ExtendedFromTimeToSend"), forKey: "ExtendedFromTime")
//        if dictFromPP.object(forKey: "ExFromTime") as! String == ""
//        {
//            parameter.setValue(dictFromPP.object(forKey: "ToTime"), forKey: "ExtendedFromTime")
//        }
//        else
//        {
//            parameter.setValue(dictFromPP.object(forKey: "ExFromTime"), forKey: "ExtendedFromTime")
//        }
        parameter.setValue(dictFromPP.object(forKey: "NoOfHoursExtended"), forKey: "NoOfHoursExtended")
        parameter.setValue(StripeCardID, forKey: "CardID")
        print(parameter)
        API.callApiPOST(strUrl: API_CompleteJob,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let obj: feedbackClass = self.storyboard?.instantiateViewController(withIdentifier: "feedbackClass") as! feedbackClass
                obj.objPoster = self
                obj.fromWhere = "posterPayment"
                obj.dictFromMP = self.dictFromPP
                self.present(obj, animated: true, completion: nil)
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
