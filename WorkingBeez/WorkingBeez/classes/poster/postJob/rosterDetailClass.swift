//
//  rosterDetailClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/24/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class rosterDetailClass: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    //MARK:- Outlet
    @IBOutlet weak var tblRoster: UITableView!
    @IBOutlet weak var btnAddMore: UIButton!
    @IBOutlet weak var viewFeeInfo: UIView!
    @IBOutlet weak var lblTotalCharge: UILabel!
    @IBOutlet weak var viewStep: UIView!
    
    var dictUserData: NSMutableDictionary = NSMutableDictionary()
    var TotalWorkingBeezCharge: CGFloat = 0.0
    let custObj: customClassViewController = customClassViewController()
    var deleObj: AppDelegate!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dictUserData = NSMutableDictionary.init(dictionary: API.getLoggedUserData())
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        view.backgroundColor = API.appBackgroundColor()
        self.tblRoster.dataSource = self
        self.tblRoster.delegate = self
        tblRoster.register(UINib(nibName: "cellNoRepeat", bundle: nil), forCellReuseIdentifier: "cellNoRepeat")
        tblRoster.register(UINib(nibName: "cellWithRepeat", bundle: nil), forCellReuseIdentifier: "cellWithRepeat")
        self.navigationItem.title = "Roster Summary"
        btnAddMore.tintColor = API.themeColorPink()
        
        print(deleObj.dictPosJob)
        calculatePrice()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetRoster"), object: nil)
    }
    func calculatePrice()
    {
        TotalWorkingBeezCharge = 0
        for item in deleObj.arrOfRoster
        {
            let dd: NSDictionary = item as! NSDictionary
            let total: CGFloat = dd.object(forKey: "totalCharge") as! CGFloat
            if dd.object(forKey: "IsRepete") as! Bool == true
            {
                let totalDay: CGFloat = dd.object(forKey: "totalDays") as! CGFloat
                TotalWorkingBeezCharge = TotalWorkingBeezCharge + (total * totalDay)
            }
            else
            {
                TotalWorkingBeezCharge = TotalWorkingBeezCharge + total
            }
        }
        lblTotalCharge.text = String(format: "$ %0.2f", TotalWorkingBeezCharge)
    }
    //MARK:- Action Zone
    @IBAction func btnAddMore(_ sender: Any)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetRoster"), object: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnPost(_ sender: Any)
    {
        if dictUserData.object(forKey: "IsPaymentVerify") as! Bool == true
        {
            postJob()
        }
        else
        {
            custObj.alertMessage(Payment_Message)
            let obj: addCreditCardClass = self.storyboard?.instantiateViewController(withIdentifier: "addCreditCardClass") as! addCreditCardClass
            obj.objPostJob = self
            obj.fromWhere = "postJob"
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    @IBAction func btnCancel(_ sender: Any)
    {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnDeleteSlot(_ sender: Any)
    {
        let tag: Int = (sender as AnyObject).tag
        deleObj.arrOfRoster.removeObject(at: tag)
        tblRoster.reloadData()
        calculatePrice()
    }
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return deleObj.arrOfRoster.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dd: NSDictionary = deleObj.arrOfRoster.object(at: indexPath.row) as! NSDictionary
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNoRepeat", for: indexPath as IndexPath) as! cellNoRepeat
        if dd.object(forKey: "IsRepete") as! Bool == false
        {
            cell.lblRosterDate.text = API.convertDateToString(strDate: dd.object(forKey: "Date") as! String, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy")
            
            cell.lblRosterRepeatStatus.isHidden = false
            cell.viewDays.isHidden = true
        }
        else
        {
            cell.lblRosterRepeatStatus.isHidden = true
            cell.viewDays.isHidden = false
            cell.lblRosterDate.text = String(format: "%@ to %@", API.convertDateToString(strDate: dd.object(forKey: "FromDate") as! String, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy"),API.convertDateToString(strDate: dd.object(forKey: "ToDate") as! String, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy"))
            
            let strDays: String = dd.object(forKey: "DayOfWeek") as! String
            if strDays.contains("1")
            {
                cell.btnMon.backgroundColor = API.themeColorBlue()
                cell.btnMon.isSelected = true
            }
            else
            {
                cell.btnMon.backgroundColor = UIColor.white
                cell.btnMon.isSelected = false
            }
            if strDays.contains("2")
            {
                cell.btnTue.backgroundColor = API.themeColorBlue()
                cell.btnTue.isSelected = true
            }
            else
            {
                cell.btnTue.backgroundColor = UIColor.white
                cell.btnTue.isSelected = false
            }
            if strDays.contains("3")
            {
                cell.btnWed.backgroundColor = API.themeColorBlue()
                cell.btnWed.isSelected = true
            }
            else
            {
                cell.btnWed.backgroundColor = UIColor.white
                cell.btnWed.isSelected = false
            }
            if strDays.contains("4")
            {
                cell.btnThu.backgroundColor = API.themeColorBlue()
                cell.btnThu.isSelected = true
            }
            else
            {
                cell.btnThu.backgroundColor = UIColor.white
                cell.btnThu.isSelected = false
            }
            if strDays.contains("5")
            {
                cell.btnFri.backgroundColor = API.themeColorBlue()
                cell.btnFri.isSelected = true
            }
            else
            {
                cell.btnFri.backgroundColor = UIColor.white
                cell.btnFri.isSelected = false
            }
            if strDays.contains("6")
            {
                cell.btnSat.backgroundColor = API.themeColorBlue()
                cell.btnSat.isSelected = true
            }
            else
            {
                cell.btnSat.backgroundColor = UIColor.white
                cell.btnSat.isSelected = false
            }
            if strDays.contains("0")
            {
                cell.btnSun.backgroundColor = API.themeColorBlue()
                cell.btnSun.isSelected = true
            }
            else
            {
                cell.btnSun.backgroundColor = UIColor.white
                cell.btnSun.isSelected = false
            }
        }
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "hh:mm a"
        var hour: CGFloat = dd.object(forKey: "Hours") as! CGFloat
        var str: String = String(format: "%0.2f", hour)
        str = str.replacingOccurrences(of: ".15", with: ".25")
        str = str.replacingOccurrences(of: ".30", with: ".50")
        str = str.replacingOccurrences(of: ".45", with: ".75")
        if let n = NumberFormatter().number(from: str) {
            hour = CGFloat(n)
        }
        let min: CGFloat = 60
        let toTime = df.date(from: dd.object(forKey: "StartTime") as! String)?.add(minutes: Int(hour * min)) as Date!
//        var strTime: String = df.string(from: toTime!)
//        if !strTime.lowercased().contains("A".lowercased())
//        {
//            strTime = API.convertDateToString(strDate: df.string(from: toTime!), fromFormat: "HH:mm", toFormat: "hh:mm a")
//        }
//        else
//        {
//            strTime = df.string(from: toTime!)
//        }
        
        cell.lblRosterTime.text = String(format: "%@ - %@", dd.object(forKey: "StartTime") as! String,df.string(from: toTime!))
        cell.lblRosterRepeatStatus.text = "No Repeat"
        cell.lblRosterTotalPayment.text = String(format: "%0.2f", dd.object(forKey: "totalCharge") as! CGFloat)
        cell.lblRosterTotalHire.text = String(format: "%d Hire", dd.object(forKey: "NoOfHire") as! Int)
        if dd.object(forKey: "BreakTimeInMin") as! Int == 0
        {
            cell.lblRosterBreak.text = "No Break"
            cell.lblRosterBreakPaid.isHidden = true
        }
        else
        {
            cell.lblRosterBreakPaid.isHidden = false
            cell.lblRosterBreak.text = "Break"
            if dd.object(forKey: "IsPaid") as! Bool == false
            {
                cell.lblRosterBreakPaid.text = String(format: "(%dmin - Unpaid)", dd.object(forKey: "BreakTimeInMin") as! Int)
            }
            else
            {
                
                cell.lblRosterBreakPaid.text = String(format: "(%dmin - Paid)", dd.object(forKey: "BreakTimeInMin") as! Int)
            }
        }
        cell.imgHireIcon.tintColor = API.themeColorBlue()
        if deleObj.arrOfRoster.count == 1
        {
            cell.btnDelete.isHidden = true
        }
        else
        {
            cell.btnDelete.isHidden = false
        }
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.btnDeleteSlot(_:)), for: UIControlEvents.touchUpInside)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        deleObj.arrIndexForRosterEdit = indexPath.row
        let dd: NSDictionary = deleObj.arrOfRoster.object(at: indexPath.row) as! NSDictionary
        print(dd)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "prefillRoster"), object: dd)
        _ = self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let dd: NSDictionary = deleObj.arrOfRoster.object(at: indexPath.row) as! NSDictionary
        if dd.object(forKey: "BreakTimeInMin") as! Int == 0
        {
            return 83
        }
        else
        {
            return 93
        }
    }
    //MARK:- Call API
    func postJob()
    {
        print(deleObj.dictPosJob)
        //let dictTemp: NSMutableDictionary = NSMutableDictionary.init(dictionary: deleObj.dictPosJob)
        
        custObj.showSVHud("Loading")
        
        API.callApiPOST(strUrl: API_CreateJobPost,parameter: deleObj.dictPosJob, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                _ = self.navigationController?.popToRootViewController(animated: true)
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.sendMatching(postId: response.object(forKey: "ReturnValue") as! String)
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
    func sendMatching(postId: String)
    {
        let patameter: NSMutableDictionary = NSMutableDictionary()
        patameter.setValue(API.getToken(), forKey: "Token")
        patameter.setValue(API.getUserId(), forKey: "UserID")
        patameter.setValue(postId, forKey: "JobPostID")
        //custObj.showSVHud("Loading")
        
        API.callApiPOST(strUrl: API_MatchSeeker,parameter: patameter, success: { (response) in
            
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
            }
            else
            {
            }
        }, error: { (error) in
            print(error)
        })
    }
}
