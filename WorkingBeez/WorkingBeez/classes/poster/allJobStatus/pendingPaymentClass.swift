//
//  pendingPaymentClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/26/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class pendingPaymentClass: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    //MARK:- Outlet
    @IBOutlet weak var tblPendingPayment: UITableView!
    
    var selectedIndex: Int = 0
    var arrOfPP: NSMutableArray = NSMutableArray()
    var contentMsg: ContentMessageView!
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        contentMsg = ContentMessageView.CreateView(self.view, strMessage: "No records found", strImageName: "WB_Font", color: UIColor.lightGray)
        contentMsg.isHidden = true
        view.backgroundColor = API.appBackgroundColor()
        self.tblPendingPayment.dataSource = self
        self.tblPendingPayment.delegate = self
        tblPendingPayment.register(UINib(nibName: "pendingPaymentCell", bundle: nil), forCellReuseIdentifier: "pendingPaymentCell")
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        getAllPT()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnPay(_ sender: Any)
    {
        selectedIndex = (sender as AnyObject).tag
        let dd: NSDictionary = arrOfPP.object(at: selectedIndex) as! NSDictionary
        if dd.object(forKey: "IsPay") as! Bool == false
        {
            custObj.alertMessage("WorkingBeez has not submitted the timesheet yet.")
            return
        }
        let obj: makePaymentClass = self.storyboard?.instantiateViewController(withIdentifier: "makePaymentClass") as! makePaymentClass
        obj.dictFromPP = NSMutableDictionary.init(dictionary: dd)
        obj.objPP = self
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfPP.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingPaymentCell", for: indexPath as IndexPath) as! pendingPaymentCell
        
        let dd: NSDictionary = arrOfPP.object(at: indexPath.row) as! NSDictionary
        cell.lblSeekerName.text = dd.object(forKey: "Name") as? String
        cell.lblJobTitle.text = dd.object(forKey: "JobPostTitle") as? String
        cell.btnSeekerLocation.setTitle(dd.object(forKey: "Location") as? String, for: UIControlState.normal)
        cell.btnSeekerLocation.titleLabel?.adjustsFontSizeToFitWidth = true
        cell.lblPendingTotalPayment.text = dd.object(forKey: "TotalAmount") as? String
        cell.lblHourlyRate.text = String(format: "%@/hr", dd.object(forKey: "HourlyRate") as! String)
        cell.lblPendingDate.text = String(format: "%@", dd.object(forKey: "FromDate") as! String)
        cell.lblPostNadJobId.text = String(format: "Job ID: %d", dd.object(forKey: "JobPostID") as! Int)
        
        if dd.object(forKey: "ExToTime") as! String == ""
        {
            cell.lblPendingTime.text = String(format: "%@ - %@", dd.object(forKey: "FromTime") as! String,dd.object(forKey: "ToTime") as! String)
        }
        else
        {
            cell.lblPendingTime.text = String(format: "%@ - %@", dd.object(forKey: "FromTime") as! String,dd.object(forKey: "ExToTime") as! String)
        }
        
        
        cell.imgSeekerPhoto.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
        cell.imgSeekerPhoto.tag = indexPath.row
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGestureRecognizer:)))
        cell.imgSeekerPhoto.isUserInteractionEnabled = true
        cell.imgSeekerPhoto.addGestureRecognizer(tapGestureRecognizer)
        
        cell.lblSeekerStatus.isHidden = false
        if dd.object(forKey: "IsAvailable") as! Bool == false
        {
            cell.lblSeekerStatus.backgroundColor = API.offline()
        }
        else
        {
            cell.lblSeekerStatus.backgroundColor = API.onlineColor()
        }
        
        if dd.object(forKey: "IsBreak") as! Bool == false
        {
            cell.lblPendingBreak.text = "No Break"
            cell.lblPendingBreakPaid.isHidden = true
        }
        else
        {
            cell.lblPendingBreak.text = "Break"
            cell.lblPendingBreakPaid.isHidden = false
            
            if dd.object(forKey: "IsBreakPaid") as! Bool == true
            {
                cell.lblPendingBreakPaid.text = String(format: "(%d min - Paid)", dd.object(forKey: "BreakMin") as! Int)
            }
            else
            {
                cell.lblPendingBreakPaid.text = String(format: "(%d min - Unpaid)", dd.object(forKey: "BreakMin") as! Int)
            }
        }
        cell.lblPendingDate.text = String(format: "%@", dd.object(forKey: "FromDate") as! String)
        if dd.object(forKey: "IsRepete") as! Bool == true
        {
            cell.viewDays.isHidden = false
            cell.lblPendingRepeatStatus.isHidden = true
            
            //cell.lblPendingDate.text = String(format: "%@ to %@", dd.object(forKey: "FromDate") as! String,dd.object(forKey: "ToDate") as! String)
            
            let strDays: String = dd.object(forKey: "DayOfWeekIDs") as! String
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
        else
        {
            cell.viewDays.isHidden = true
            cell.lblPendingRepeatStatus.isHidden = false
        }
        cell.btnFillTimesheet.isHidden = true
        if dd.object(forKey: "IsPay") as! Bool == true
        {
            cell.btnPay.tintColor = API.themeColorPink()
            cell.btnPay.setTitleColor(API.themeColorPink(), for: UIControlState.normal)
        }
        else
        {
            cell.btnPay.tintColor = UIColor.lightGray
            cell.btnPay.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        }
        
        
        cell.btnPayInfo.isHidden = true
        cell.btnPay.tag = indexPath.row
        cell.btnPay.addTarget(self, action: #selector(self.btnPay(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 190
    }
    //MARK:- GO TO SEEKER PROFILE
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tag: Int = (tapGestureRecognizer.view?.tag)!
        var dd: NSDictionary = NSDictionary()
        dd = arrOfPP.object(at: tag) as! NSDictionary
        
        let obj: seekerProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "seekerProfileClass") as! seekerProfileClass
        obj.userId = dd.object(forKey: "UserID") as! String
        self.navigationController!.pushViewController(obj, animated: true)
    }
    //MARK:- Call API
    func getAllPT()
    {
        arrOfPP = NSMutableArray()
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(false, forKey: "IsGetOnlyTotalCounts")
        print(parameter)
        API.callApiPOST(strUrl: API_GetPosterPendingPayments,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                for item in arr
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    self.arrOfPP.add(dictMutable)
                }
                self.contentMsg.isHidden = true
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.contentMsg.isHidden = false
            }
            self.tblPendingPayment.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.contentMsg.isHidden = false
        })
    }
}
