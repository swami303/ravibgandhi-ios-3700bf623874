//
//  completedJobPoster.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/8/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit
import MessageUI
class completedJobPoster: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate
{
    //MARK:- Outlet
    @IBOutlet weak var tblCompleted: UITableView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var btnTotalHour: UIButton!
    @IBOutlet weak var btnTotalHire: UIButton!
    @IBOutlet weak var btnTotalSpent: UIButton!
    
    var dictSendInvoice: NSDictionary!
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
        let dd: NSDictionary = API.getLoggedUserData()
        dictUserData = NSMutableDictionary.init(dictionary: dd)
        super.viewDidLoad()
        btnTotalHire.tintColor = API.themeColorPink()
        dictTopParameter.setValue("0", forKey: "CompleteAmount")
        dictTopParameter.setValue("0", forKey: "PendingAmout")
        dictTopParameter.setValue("0", forKey: "TotalHire")
        setTopData()
        
        contentMsg = ContentMessageView.CreateView(self.view, strMessage: "No records found", strImageName: "WB_Font", color: UIColor.lightGray)
        contentMsg.isHidden = true
        view.backgroundColor = API.appBackgroundColor()
        self.tblCompleted.dataSource = self
        self.tblCompleted.delegate = self
        tblCompleted.register(UINib(nibName: "cellCompletedJobNoRepeat", bundle: nil), forCellReuseIdentifier: "cellCompletedJobNoRepeat")
        
        getAllCompletedPost()
        
        
        deleObj = UIApplication.shared.delegate as! AppDelegate!
    }
    override func viewWillAppear(_ animated: Bool) {
        deleObj.isInCompleted = true
    }
    override func viewWillDisappear(_ animated: Bool) {
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
        obj.objCompletedJobPoster = self
        obj.fromWhere = "completedJobPoster"
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
    @IBAction func btnInvite(_ sender: Any)
    {
        let tag: Int = (sender as AnyObject).tag
        let dd: NSDictionary = arrOfPost.object(at: tag) as! NSDictionary
        let obj: completedJobDetailPoster = self.storyboard?.instantiateViewController(withIdentifier: "completedJobDetailPoster") as! completedJobDetailPoster
        obj.dictPost = NSMutableDictionary.init(dictionary: dd)
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnInvoice(_ sender: Any)
    {
        dictSendInvoice = arrOfPost.object(at: (sender as AnyObject).tag) as! NSDictionary
        sendInvoice(isAll: false)
    }
    @IBAction func btnFeedback(_ sender: Any)
    {
        let dd: NSDictionary = arrOfPost.object(at: (sender as AnyObject).tag) as! NSDictionary
        let obj: feedbackClass = self.storyboard?.instantiateViewController(withIdentifier: "feedbackClass") as! feedbackClass
        obj.objPosterCompleted = self
        obj.fromWhere = "posterCompleted"
        obj.dictFromPC = NSMutableDictionary.init(dictionary: dd)
        self.present(obj, animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCompletedJobNoRepeat", for: indexPath as IndexPath) as! cellCompletedJobNoRepeat
        let dd: NSDictionary = arrOfPost.object(at: indexPath.row) as! NSDictionary
        
        cell.btnFeedback.tintColor = API.themeColorPink()
        
        cell.lblJobTitle.text = dd.object(forKey: "JobPostTitle")as? String
        cell.lblSeekerName.text = dd.object(forKey: "Name")as? String
        cell.lblJobCompleted.text = String(format: "Job Completed %d", dd.object(forKey: "TotalCompletedJobs") as! Int)
        cell.viewSeekerRating.value = dd.object(forKey: "Rating") as! CGFloat
        cell.imgSeekerPhoto.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
        cell.imgSeekerPhoto.tag = indexPath.row
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGestureRecognizer:)))
        cell.imgSeekerPhoto.isUserInteractionEnabled = true
        cell.imgSeekerPhoto.addGestureRecognizer(tapGestureRecognizer)
        cell.lblJobID.text = String(format: "Job ID: %d", dd.object(forKey: "JobPostID") as! Int)
        
        let strFromLat: String = dd.object(forKey: "Latitude") as! String
        let strFromLong: String = dd.object(forKey: "Longitude") as! String
        
        let strLatitude: String = dd.object(forKey: "Latitude1") as! String
        let strLongitude: String = dd.object(forKey: "Longitude1") as! String
        let strDistance: String = API.getDistance(strToLate: strLatitude, strToLong: strLongitude, strFromLat: strFromLat, strFromLong: strFromLong)
        
        cell.btnSeekerKm.setTitle(String(format:"%@",strDistance), for: UIControlState.normal)
        
        
        //cell.btnSeekerKm.setTitle(String(format:"%@",dd.object(forKey: "Distance") as! String), for: UIControlState.normal)
        cell.btnSeekerExp.setTitle(String(format:"%0.2f Yr",dd.object(forKey: "TotalExperienced") as! CGFloat), for: UIControlState.normal)
        cell.lblJobStatus.text = dd.object(forKey: "Status") as? String
        if dd.object(forKey: "IsAvailable") as! Bool == true
        {
            cell.lblSeekerStatus.backgroundColor = API.onlineColor()
        }
        else
        {
            cell.lblSeekerStatus.backgroundColor = API.offline()
        }
        if dd.object(forKey: "IsVehicle") as! Bool == true
        {
            cell.btnSeekerHaveVehicle.isSelected = false
        }
        else
        {
            cell.btnSeekerHaveVehicle.isSelected = true
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
            //cell.lblRosterDate.text = String(format: "%@ - %@", dd.object(forKey: "FromDate") as! String,dd.object(forKey: "ToDate") as! String)
            cell.lblRosterDate.text = String(format: "%@", dd.object(forKey: "FromDate") as! String)
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
            cell.lblRosterPayment.text = "-"
        }
        else
        {
            cell.lblRosterPayment.text = String(format: "%@", dd.object(forKey: "TotalAmount") as! String)
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
            cell.btnFeedback.isHidden = true
        }
        else
        {
            cell.btnFeedback.isHidden = false
        }
        
        cell.btnHelp.tag = indexPath.row
        cell.btnIvite.tag = indexPath.row
        cell.btnInvoice.tag = indexPath.row
        cell.btnFeedback.tag = indexPath.row
        
        cell.btnHelp.addTarget(self, action: #selector(self.btnHelp(_:)), for: UIControlEvents.touchUpInside)
        cell.btnIvite.addTarget(self, action: #selector(self.btnInvite(_:)), for: UIControlEvents.touchUpInside)
        cell.btnInvoice.addTarget(self, action: #selector(self.btnInvoice(_:)), for: UIControlEvents.touchUpInside)
        
        
        cell.btnFeedback.addTarget(self, action: #selector(self.btnFeedback(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let tag: Int = indexPath.row
//        let dd: NSDictionary = arrOfPost.object(at: tag) as! NSDictionary
//        let obj: completedJobDetailPoster = self.storyboard?.instantiateViewController(withIdentifier: "completedJobDetailPoster") as! completedJobDetailPoster
//        obj.dictPost = NSMutableDictionary.init(dictionary: dd)
//        self.navigationController!.pushViewController(obj, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 270
    }
    //MARK:- GO TO SEEKER PROFILE
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tag: Int = (tapGestureRecognizer.view?.tag)!
        var dd: NSDictionary = NSDictionary()
        dd = arrOfPost.object(at: tag) as! NSDictionary
        let obj: seekerProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "seekerProfileClass") as! seekerProfileClass
        obj.userId = dd.object(forKey: "UserID") as! String
        self.navigationController!.pushViewController(obj, animated: true)
    }
    func setTopData()
    {
        btnTotalHour.setTitle(String(format:"%@",dictTopParameter.object(forKey: "PendingAmout") as! String), for: UIControlState.normal)
        btnTotalHire.setTitle(String(format:"%@",dictTopParameter.object(forKey: "TotalHire") as! String), for: UIControlState.normal)
        btnTotalSpent.setTitle(String(format:"%@",dictTopParameter.object(forKey: "CompleteAmount") as! String), for: UIControlState.normal)
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
        API.callApiPOST(strUrl: API_GetPosterCompletedJobs,parameter: parameter, success: { (response) in
            
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
            parameter.setValue(dictSendInvoice.object(forKey: "RosterDateID"), forKey: "JobID")
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
