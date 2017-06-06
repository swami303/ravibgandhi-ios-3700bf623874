//
//  completedJobSeeker.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/12/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit
import MessageUI
class completedJobSeeker: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate
{
    //MARK:- Outlet
    @IBOutlet weak var tblCompleted: UITableView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var btnTotalJobsCompleted: UIButton!
    @IBOutlet weak var btnTotalPendingEarned: UIButton!
    @IBOutlet weak var btnTotalEarned: UIButton!
    
    var dictUserData: NSMutableDictionary = NSMutableDictionary()
    var dictTopParameter: NSMutableDictionary = NSMutableDictionary()
    var strFromDate: String = ""
    var strToDate: String = ""
    var arrOfPost: NSMutableArray = NSMutableArray()
    var contentMsg: ContentMessageView!
    let custObj: customClassViewController = customClassViewController()
    var deleObj: AppDelegate!
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        let dd: NSDictionary = API.getLoggedUserData()
        dictUserData = NSMutableDictionary.init(dictionary: dd)
        
        dictTopParameter.setValue("0", forKey: "CompleteAmount")
        dictTopParameter.setValue("0", forKey: "CompletedJobs")
        dictTopParameter.setValue("0", forKey: "PendingAmout")
        setTopData()
        
        contentMsg = ContentMessageView.CreateView(self.view, strMessage: "No records found", strImageName: "WB_Font", color: UIColor.lightGray)
        contentMsg.isHidden = true
        view.backgroundColor = API.appBackgroundColor()
        self.tblCompleted.dataSource = self
        self.tblCompleted.delegate = self
        tblCompleted.register(UINib(nibName: "cellCompletedJobSeeker", bundle: nil), forCellReuseIdentifier: "cellCompletedJobSeeker")
        getAllCompletedPost()
        btnTotalJobsCompleted.tintColor = API.themeColorPink()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        deleObj.isInCompleted = true
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        deleObj.isInCompleted = false
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnSelectPeriod(_ sender: Any)
    {
        let obj: timePeriodClass = self.storyboard?.instantiateViewController(withIdentifier: "timePeriodClass") as! timePeriodClass
        obj.objCompletedJobSeeker = self
        obj.fromWhere = "completedJobSeeker"
        self.present(obj, animated: true, completion: nil)
    }
    @IBAction func btnEmail(_ sender: Any)
    {
        sendInvoice(isAll: true)
    }
    @IBAction func btnTotalSpent(_ sender: Any)
    {
    }
    @IBAction func btnTotalHire(_ sender: Any)
    {
    }
    @IBAction func btnTotalHour(_ sender: Any)
    {
    }
    @IBAction func btnAddress(_ sender: Any)
    {
        let dd: NSDictionary = arrOfPost.object(at: (sender as AnyObject).tag) as! NSDictionary
        let lati: Double = Double(dd.object(forKey: "Latitude") as! String)!
        let longi: Double = Double(dd.object(forKey: "Longitude") as! String)!
        API.openMapForPlace(lat: lati, longi: longi, dd: dd)
    }
    @IBAction func btnHelp(_ sender: Any)
    {
        let obj: webViewClass = self.storyboard?.instantiateViewController(withIdentifier: "webViewClass") as! webViewClass
        obj.strNavTitle = "HELP & SUPPORT"
        self.navigationController!.pushViewController(obj, animated: true)
//        let mailComposeViewController = configuredMailComposeViewController()
//        if MFMailComposeViewController.canSendMail()
//        {
//            self.present(mailComposeViewController, animated: true, completion: nil)
//        }
//        else
//        {
//            //custObj.alertMessage("Your device can not send email.  Please check email configuration in your phone setting and try again")
//        }
    }
    @IBAction func btnFeedback(_ sender: Any)
    {
        let dd: NSDictionary = arrOfPost.object(at: (sender as AnyObject).tag) as! NSDictionary
        let obj: feedbackClass = self.storyboard?.instantiateViewController(withIdentifier: "feedbackClass") as! feedbackClass
        obj.objCompletedSeeker = self
        obj.fromWhere = "seekerCompleted"
        obj.dictFromSC = NSMutableDictionary.init(dictionary: dd)
        self.present(obj, animated: true, completion: nil)
    }
    @IBAction func btnInfo(_ sender: Any)
    {
        custObj.alertMessage(SEEKER_PAY_INOF)
    }
    //MARK:- MAIL
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([BEEZ_EMAIL])
        mailComposerVC.setSubject("")
        return mailComposerVC
    }
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        if (error == nil)
        {
            //custObj.alertMessage(error?.localizedDescription)
        }
        controller.dismiss(animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCompletedJobSeeker", for: indexPath as IndexPath) as! cellCompletedJobSeeker
        let dd: NSDictionary = arrOfPost.object(at: indexPath.row) as! NSDictionary
        
        cell.lblJobTitle.text = dd.object(forKey: "JobPostTitle")as? String
        cell.lblCompanyName.text = dd.object(forKey: "CompanyName")as? String
        cell.lblHiredTillDate.text = String(format: "Hired till date %d", dd.object(forKey: "TotalHiredJobs") as! Int)
        cell.viewRating.value = dd.object(forKey: "Rating") as! CGFloat
        cell.imgCompanyPhoto.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
        cell.imgCompanyPhoto.tag = indexPath.row
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGestureRecognizer:)))
        cell.imgCompanyPhoto.isUserInteractionEnabled = true
        cell.imgCompanyPhoto.addGestureRecognizer(tapGestureRecognizer)
        cell.lblJobStatus.text = dd.object(forKey: "Status") as? String
        
        cell.lblJobId.text = String(format: "Job ID: %d", dd.object(forKey: "JobPostID") as! Int)
        
        if dd.object(forKey: "Status") as! String == "Completed"
        {
            cell.lblPaid.isHidden = false
            if dd.object(forKey: "IsPay") as! Bool == true
            {
                cell.lblPaid.text = "PAID"
                cell.lblPaid.textColor = UIColor.red
            }
            else
            {
                cell.lblPaid.text = "UNPAID"
                cell.lblPaid.textColor = UIColor.red
            }
        }
        else
        {
            cell.lblPaid.isHidden = true
        }
        
        if dd.object(forKey: "IsRepete") as! Bool == false
        {
            cell.viewDays.isHidden = true
            cell.lblRosterRepeat.isHidden = false
            cell.lblRosterDate.text = dd.object(forKey: "FromDate") as? String
        }
        else
        {
            cell.lblRosterRepeat.isHidden = true
            cell.viewDays.isHidden = false
            cell.lblRosterDate.text = String(format: "%@", dd.object(forKey: "FromDate") as! String)
            //cell.lblRosterDate.text = String(format: "%@ - %@", dd.object(forKey: "FromDate") as! String,dd.object(forKey: "ToDate") as! String)
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
        cell.btnAddress.setTitle(dd.object(forKey: "Location") as? String, for: UIControlState.normal)
        cell.btnAddress.titleLabel?.adjustsFontSizeToFitWidth = true
        cell.lblRosterTime.text = String(format: "%@ - %@", dd.object(forKey: "FromTime") as! String,dd.object(forKey: "ToTime") as! String)
        if dd.object(forKey: "TotalAmount") as! String == ""
        {
            cell.lblTotalPayment.text = "-"
        }
        else
        {
            cell.lblTotalPayment.text = String(format: "%@", dd.object(forKey: "TotalAmount") as! String)
        }
        if dd.object(forKey: "HourlyRate") as! String == ""
        {
            cell.lblHourlyRate.text = "-"
        }
        else
        {
            cell.lblHourlyRate.text = String(format: "%@/hr", dd.object(forKey: "HourlyRate") as! String)
        }
        if dd.object(forKey: "IsBreak") as! Bool == false
        {
            cell.lblRosterBreakPaid.isHidden = true
            cell.lblRosterBreak.text = "No Break"
        }
        else
        {
            cell.lblRosterBreakPaid.isHidden = false
            cell.lblRosterBreak.text = "Break"
            if dd.object(forKey: "IsBreakPaid") as! Bool == true
            {
                cell.lblRosterBreakPaid.text = String(format: "(%d min - Paid)", dd.object(forKey: "BreakMin") as! Int)
            }
            else
            {
                cell.lblRosterBreakPaid.text = String(format: "(%d min - Unpaid)", dd.object(forKey: "BreakMin") as! Int)
            }
        }
        if dd.object(forKey: "IsFeedback") as! Bool == false
        {
            cell.btnfeedback.isHidden = true
        }
        else
        {
            cell.btnfeedback.isHidden = false
        }
        cell.btnfeedback.tintColor = API.themeColorPink()
        cell.btnfeedback.tag = indexPath.row
        cell.btnfeedback.addTarget(self, action: #selector(self.btnFeedback(_:)), for: UIControlEvents.touchUpInside)
        cell.btnAddress.tag = indexPath.row
        cell.btnAddress.addTarget(self, action: #selector(self.btnAddress(_:)), for: UIControlEvents.touchUpInside)
        cell.btnHelp.addTarget(self, action: #selector(self.btnHelp(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 198
    }
    //MARK:- GO TO SEEKER PROFILE
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tag: Int = (tapGestureRecognizer.view?.tag)!
        var dd: NSDictionary = NSDictionary()
        dd = arrOfPost.object(at: tag) as! NSDictionary
        let obj: posterProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "posterProfileClass") as! posterProfileClass
        obj.userId = dd.object(forKey: "UserID") as! String
        self.navigationController!.pushViewController(obj, animated: true)
    }
    func setTopData()
    {
        btnTotalEarned.setTitle(String(format:"%@",dictTopParameter.object(forKey: "CompleteAmount") as! String), for: UIControlState.normal)
        btnTotalJobsCompleted.setTitle(String(format:"%@",dictTopParameter.object(forKey: "CompletedJobs") as! String), for: UIControlState.normal)
        btnTotalPendingEarned.setTitle(String(format:"%@",dictTopParameter.object(forKey: "PendingAmout") as! String), for: UIControlState.normal)
    }
    //MARK:- BACK
    override func navigationShouldPopOnBackButton() -> Bool
    {
        var flag: Bool = true
        for item in arrOfPost
        {
            let dd: NSDictionary = item as! NSDictionary
            if dd.object(forKey: "IsFeedback") as! Bool == true
            {
                flag = false
                break
            }
        }
        if flag == false
        {
            custObj.alertMessage("Please give pending rating(s).")
            return false
        }
        else
        {
            return true
        }
    }
    //MARK:- Call API
    func getAllCompletedPost()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(strFromDate, forKey: "FromDate")
        parameter.setValue(strToDate, forKey: "ToDate")
        parameter.setValue(false, forKey: "IsGetOnlyTotalCounts")
        print(parameter)
        API.callApiPOST(strUrl: API_GetSeekerCompletedJobs,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            let arr: NSArray = response.object(forKey: "Data") as! NSArray
            var dd: NSDictionary!
            if arr.count != 0
            {
                dd = arr.object(at: 0) as! NSDictionary
            }
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                if arr.count != 0
                {
                    let arrPost: NSArray = dd.object(forKey: "ObjComplete") as! NSArray
                    self.arrOfPost = NSMutableArray.init(array: arrPost)
                    
                    self.contentMsg.isHidden = true
                }
                else
                {
                    self.contentMsg.isHidden = false
                }
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.arrOfPost = NSMutableArray()
                self.contentMsg.isHidden = false
            }
            let arrTop: NSArray = dd.object(forKey: "ObjExtraParameters") as! NSArray
            if arrTop.count != 0
            {
                let dd: NSDictionary = arrTop.object(at: 0) as! NSDictionary
                self.dictTopParameter = NSMutableDictionary.init(dictionary: dd)
            }
            self.tblCompleted.reloadData()
            self.setTopData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.contentMsg.isHidden = false
        })
    }
    func sendInvoice(isAll: Bool)
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        
        if isAll == false
        {
            parameter.setValue("-1", forKey: "FromDate")
            parameter.setValue("-1", forKey: "ToDate")
            //parameter.setValue(dictSendInvoice.object(forKey: "RosterDateID"), forKey: "JobID")
        }
        else
        {
            parameter.setValue(strFromDate, forKey: "FromDate")
            parameter.setValue(strToDate, forKey: "ToDate")
            parameter.setValue("0", forKey: "JobID")
        }
        
        parameter.setValue(dictUserData.object(forKey: "EmailID"), forKey: "Email")
        print(parameter)
        API.callApiPOST(strUrl: API_GetInvoice,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
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
