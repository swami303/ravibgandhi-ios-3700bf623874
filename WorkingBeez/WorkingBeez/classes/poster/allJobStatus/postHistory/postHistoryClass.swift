//
//  postHistoryClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/5/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class postHistoryClass: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    @IBOutlet weak var tblHistory: UITableView!
    
    var contentMsg: ContentMessageView!
    var arrOfPost: NSMutableArray = NSMutableArray()
    var strFromDate: String = ""
    var strToDate: String = ""
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        contentMsg = ContentMessageView.CreateView(self.view, strMessage: "No records found", strImageName: "WB_Font", color: UIColor.lightGray)
        contentMsg.isHidden = true
        view.backgroundColor = API.appBackgroundColor()
        tblHistory.delegate = self
        tblHistory.dataSource = self
        tblHistory.register(UINib(nibName: "cellHistoryNoRepeat", bundle: nil), forCellReuseIdentifier: "cellHistoryNoRepeat")

        view.backgroundColor = API.appBackgroundColor()
        getAllPost()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnSelectperiod(_ sender: Any)
    {
        let obj: timePeriodClass = self.storyboard?.instantiateViewController(withIdentifier: "timePeriodClass") as! timePeriodClass
        obj.objPostHistory = self
        obj.fromWhere = "postHistory"
        self.present(obj, animated: true, completion: nil)
    }
    @IBAction func btnEditPost(_ sender: Any)
    {
        let tag: Int = (sender as AnyObject).tag
        let dd: NSDictionary = arrOfPost.object(at: tag) as! NSDictionary
        let obj: postHisDetail = self.storyboard?.instantiateViewController(withIdentifier: "postHisDetail") as! postHisDetail
        obj.dictPost = NSMutableDictionary.init(dictionary: dd)
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnAddress(_ sender: Any)
    {
    }
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfPost.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellHistoryNoRepeat", for: indexPath as IndexPath) as! cellHistoryNoRepeat
        let dd: NSDictionary = arrOfPost.object(at: indexPath.row) as! NSDictionary
        if dd.object(forKey: "IsRepete") as! Bool == false
        {
            cell.lblRosterDate.text = API.convertDateToString(strDate: dd.object(forKey: "FromDate") as! String, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy")
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
        
        cell.imgHireIcon.tintColor = API.themeColorBlue()
        if dd.object(forKey: "IsBreak") as! Bool == false
        {
            cell.lblRosterBreakPaid.isHidden = true
            cell.lblRosterBreak.text = "No Break"
        }
        else
        {
            cell.lblRosterBreakPaid.isHidden = false
            cell.lblRosterBreak.text = "Break"
            if dd.object(forKey: "IsPaid") as! Bool == true
            {
                cell.lblRosterBreakPaid.text = String(format: "(%d min - Paid)", dd.object(forKey: "BreakTimeInMin") as! Int)
            }
            else
            {
                cell.lblRosterBreakPaid.text = String(format: "(%d min - Unpaid)", dd.object(forKey: "BreakTimeInMin") as! Int)
            }
        }
        cell.lblJobTitle.text = dd.object(forKey: "Title") as? String
        
        cell.lblRosterTime.text = String(format: "%@ - %@", dd.object(forKey: "FromTime") as! String,dd.object(forKey: "ToTime") as! String)
        cell.lblRosterTotalPayment.text = String(format: "%0.2f/hr", dd.object(forKey: "Rate") as! CGFloat)
        cell.lblTotalHire.text = String(format: "%d Hire", dd.object(forKey: "NoOfHire") as! Int)
        cell.lblJobId.text = String(format: "Job ID: %d", dd.object(forKey: "PostID") as! Int)
        cell.btnAddress.setTitle(dd.object(forKey: "Location") as? String, for: UIControlState.normal)
        cell.btnAddress.titleLabel?.adjustsFontSizeToFitWidth = true
        cell.btnEditPost.tag = indexPath.row
        cell.btnAddress.tag = indexPath.row
        cell.btnEditPost.addTarget(self, action: #selector(self.btnEditPost(_:)), for: UIControlEvents.touchUpInside)
        cell.btnAddress.addTarget(self, action: #selector(self.btnAddress(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let dd: NSDictionary = arrOfPost.object(at: indexPath.row) as! NSDictionary
        if dd.object(forKey: "IsBreak") as! Bool == false
        {
            return 135
        }
        else
        {
            return 147
        }
    }
    
    //MARK:- Call API
    func getAllPost()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(strFromDate, forKey: "FromDate")
        parameter.setValue(strToDate, forKey: "ToDate")
        print(parameter)
        API.callApiPOST(strUrl: API_GetPostHistory,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                self.arrOfPost = NSMutableArray.init(array: arr)
                self.contentMsg.isHidden = true
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.arrOfPost = NSMutableArray()
                self.contentMsg.isHidden = false
            }
            self.tblHistory.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.contentMsg.isHidden = false
        })
    }
}
