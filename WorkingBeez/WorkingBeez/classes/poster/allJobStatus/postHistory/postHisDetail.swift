//
//  postHisDetail.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/7/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class postHisDetail: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    @IBOutlet weak var viewAddress: cView!
    @IBOutlet weak var lblJobRoster: cLable!
    @IBOutlet weak var tblRoster: UITableView!
    @IBOutlet weak var tblAddSlot: cButton!
    @IBOutlet weak var scrCoreSkill: UIScrollView!
    @IBOutlet weak var scrCerti: UIScrollView!
    @IBOutlet weak var scrMain: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var btnRepost: UIButton!
    
    var dictUserData: NSMutableDictionary = NSMutableDictionary()
    var selectedIndex:Int = 0
    var isAdd: Bool = false
    var dictRoster: NSMutableDictionary = NSMutableDictionary()
    var strLat: String = ""
    var strLong: String = ""
    var arrOfCerti: NSMutableArray = NSMutableArray()
    var arrOfSkill: NSMutableArray = NSMutableArray()
    var arrOfRoster: NSMutableArray = NSMutableArray()
    var dictPost: NSMutableDictionary = NSMutableDictionary()
    var yOffset: CGFloat = 0.0
    var deleObj: AppDelegate!
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        deleObj = UIApplication.shared.delegate as! AppDelegate!

        dictUserData = NSMutableDictionary.init(dictionary: API.getLoggedUserData())
        view.backgroundColor = API.appBackgroundColor()
        tblRoster.register(UINib(nibName: "cellWithRepeat", bundle: nil), forCellReuseIdentifier: "cellWithRepeat")
        tblRoster.register(UINib(nibName: "cellNoRepeat", bundle: nil), forCellReuseIdentifier: "cellNoRepeat")
        tblRoster.delegate = self
        tblRoster.dataSource = self
        scrMain.isHidden = true
        getPostDetail()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnRepost(_ sender: Any)
    {
        if arrOfRoster.count == 0
        {
            custObj.alertMessage("Please add job roster before reposting.")
            return
        }
        if dictUserData.object(forKey: "IsPaymentVerify") as! Bool == true
        {
            repost()
        }
        else
        {
            custObj.alertMessage(Payment_Message)
            let obj: addCreditCardClass = self.storyboard?.instantiateViewController(withIdentifier: "addCreditCardClass") as! addCreditCardClass
            obj.fromWhere = "postJob"
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    @IBAction func btnAddress(_ sender: Any)
    {
    }
    @IBAction func btnEditAddress(_ sender: Any)
    {
        let obj: addLocationClass = self.storyboard?.instantiateViewController(withIdentifier: "addLocationClass") as! addLocationClass
        obj.dictFromSetting = dictPost
        obj.fromWhere = "objPostHisEdit"
        obj.objPostHisEdit = self
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnNewSlot(_ sender: Any)
    {
        isAdd = true
        let obj: setRosterClass = self.storyboard?.instantiateViewController(withIdentifier: "setRosterClass") as! setRosterClass
        obj.fromWhere = "objPostHisEdit"
        obj.objHisEdit = self
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnEditCoreSkill(_ sender: Any)
    {
        deleObj.dictPosJob.setValue(dictPost.object(forKey: "CategoryID"), forKey: "CategoryID")
        let obj: chooseCoreSkillToPost = self.storyboard?.instantiateViewController(withIdentifier: "chooseCoreSkillToPost") as! chooseCoreSkillToPost
        obj.fromWhere = "objPostHisEdit"
        obj.objHistoryEdit = self
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnEditCertificates(_ sender: Any)
    {
        deleObj.dictPosJob.setValue(dictPost.object(forKey: "CategoryID"), forKey: "CategoryID")
        let obj: chooseCertiToPost = self.storyboard?.instantiateViewController(withIdentifier: "chooseCertiToPost") as! chooseCertiToPost
        obj.fromWhere = "objPostHisEdit"
        obj.objHistoryEdit = self
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btndeleteRoster(_ sender: Any)
    {
        arrOfRoster.removeObject(at: (sender as AnyObject).tag)
        tblRoster.reloadData()
        arrangeView()
    }
    //MARK:- set Data
    func setData()
    {
        scrMain.isHidden = false
        lblJobTitle.text = dictPost.object(forKey: "Title") as? String
        strLat = dictPost.object(forKey: "Latitude") as! String
        strLong = dictPost.object(forKey: "Longitude") as! String
        btnAddress.setTitle(dictPost.object(forKey: "LocationName") as? String, for: UIControlState.normal)
        manageTag(arrTag: arrOfSkill, scr: scrCoreSkill)
        manageTag(arrTag: arrOfCerti, scr: scrCerti)
        tblRoster.reloadData()
        arrangeView()
    }
    //MARK:- TagList Method
    func manageTag(arrTag: NSMutableArray, scr:UIScrollView)
    {
        print(arrTag)
        for case let vv as CustomViewWithoutButton in scr.subviews
        {
            vv.removeFromSuperview()
        }
        
        if arrTag.count == 0
        {
            return
        }
        for i in 0..<arrTag.count
        {
            let dd: NSDictionary = arrTag.object(at: i) as! NSDictionary
            let view1 : CustomViewWithoutButton = CustomViewWithoutButton.init(s: dd.object(forKey: "Name") as! String, viewBorderColor: API.themeColorBlue(), viewBackColor: API.lightBlueColor())
            print(view1.frame)
            // view1.viewBackColor = UIColor.lightGray
            // view1.frame = CGRect.init(x: 0, y: 20, width: view1.btnSecondOutlet.frame.origin.x + view1.btnSecondOutlet.frame.size.width + 3, height: view1.lblText.frame.size.height + 6)
            view1.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width - 40, height: view1.lblText.frame.size.height + 6)
            view1.tag = 2000 + i
            view1.clipsToBounds = true
            //            view1.btnFirstOutlet.setImage(UIImage.init(named: ""), for: UIControlState.normal)
            //            view1.btnSecondOutlet.setImage(UIImage.init(named: ""), for: UIControlState.normal)
            
            view1.backgroundColor = API.lightBlueColor()
            view1.layer.borderColor = API.themeColorBlue().cgColor
            view1.layer.borderWidth = 1
            view1.clipsToBounds = true
            scr.addSubview(view1)
            self.view.layoutIfNeeded()
        }
        arrangeTags(scrToArrange: scr, arrTag: arrTag)
    }
    func arrangeTags(scrToArrange: UIScrollView,arrTag: NSMutableArray)
    {
        var prevViewWidth : CGFloat = 20
        var prevViewY : CGFloat = 35
        var lastViewFrame : CGFloat = 0
        
        for v in scrToArrange.subviews
        {
            if(v.tag >= 2000 && v.tag < 99999)
            {
                if(v is CustomViewWithoutButton)
                {
                    let cv : CustomViewWithoutButton = v as! CustomViewWithoutButton
                    
                    if(((prevViewWidth + cv.lblText.frame.origin.x + cv.lblText.frame.size.width + 9) <= 280))
                    {
                        cv.frame = CGRect.init(x: prevViewWidth, y: prevViewY, width: cv.lblText.frame.origin.x + cv.lblText.frame.size.width + 9, height: cv.lblText.frame.size.height + 6)
                    }
                    else
                    {
                        prevViewWidth = 20
                        cv.frame = CGRect.init(x: prevViewWidth, y: prevViewY, width: cv.lblText.frame.origin.x + cv.lblText.frame.size.width + 9, height: cv.lblText.frame.size.height + 6)
                    }
                    
                    if(self.view.viewWithTag(v.tag + 1) != nil)
                    {
                        let nextView : CustomViewWithoutButton = self.view.viewWithTag(v.tag + 1) as! CustomViewWithoutButton
                        
                        if(!((prevViewWidth + (cv.lblText.frame.origin.x + cv.lblText.frame.size.width + 9) + 9 + nextView.lblText.frame.origin.x + nextView.lblText.frame.size.width + 9) <= 280))
                        {
                            prevViewY = cv.frame.origin.y + cv.frame.size.height + 5
                        }
                    }
                    
                    lastViewFrame = cv.frame.size.height
                    //cv.layer.borderColor = UIColor.init(red: 20/255.0, green: 164/255.0, blue: 245/255.0, alpha: 1.0).cgColor
                    cv.layer.cornerRadius = 13//cv.frame.size.height / 2
                    //cv.layer.borderWidth = 0.5
                    cv.clipsToBounds = true
                    prevViewWidth = cv.frame.size.width + cv.frame.origin.x + 9
                }
            }
        }
        scrToArrange.frame = CGRect.init(x: scrToArrange.frame.origin.x, y: scrToArrange.frame.origin.y, width: scrToArrange.frame.size.width, height: prevViewY + lastViewFrame + 10)
        arrangeView()
    }
    
    //MARK:- Arrange Views
    func arrangeView()
    {
        yOffset = viewAddress.frame.size.height + viewAddress.frame.origin.y + 8
        
        lblJobRoster.frame = CGRect.init(x: lblJobRoster.frame.origin.x, y: yOffset, width: lblJobRoster.frame.size.width, height: lblJobRoster.frame.size.height)
        yOffset = lblJobRoster.frame.size.height + lblJobRoster.frame.origin.y + 8
        var tblRosterHieght: CGFloat = 0
        for item in arrOfRoster
        {
            let dd: NSDictionary = item as! NSDictionary
            if dd.object(forKey: "IsBreak") as! Bool == false
            {
                tblRosterHieght = tblRosterHieght + 80
            }
            else
            {
                tblRosterHieght = tblRosterHieght + 93
            }
        }
        
        tblRoster.frame = CGRect.init(x: tblRoster.frame.origin.x, y: yOffset, width: tblRoster.frame.size.width, height: tblRosterHieght)
        yOffset = tblRoster.frame.size.height + tblRoster.frame.origin.y + 3
        
        tblAddSlot.frame = CGRect.init(x: tblAddSlot.frame.origin.x, y: yOffset, width: tblAddSlot.frame.size.width, height: tblAddSlot.frame.size.height)
        yOffset = tblAddSlot.frame.size.height + tblAddSlot.frame.origin.y + 8
        
        scrCoreSkill.frame = CGRect.init(x: scrCoreSkill.frame.origin.x, y: yOffset, width: scrCoreSkill.frame.size.width, height: scrCoreSkill.frame.size.height)
        yOffset = scrCoreSkill.frame.size.height + scrCoreSkill.frame.origin.y + 8
        
        scrCerti.frame = CGRect.init(x: scrCerti.frame.origin.x, y: yOffset, width: scrCerti.frame.size.width, height: scrCerti.frame.size.height)
        yOffset = scrCerti.frame.size.height + scrCerti.frame.origin.y + 8
        
        
        scrMain.contentSizeToFit()
    }
    
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfRoster.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dd: NSDictionary = arrOfRoster.object(at: indexPath.row) as! NSDictionary
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNoRepeat", for: indexPath as IndexPath) as! cellNoRepeat
        if dd.object(forKey: "IsRepete") as! Bool == false
        {
            cell.lblRosterDate.text = dd.object(forKey: "FromDate") as? String
            
            cell.lblRosterRepeatStatus.isHidden = false
            cell.viewDays.isHidden = true
        }
        else
        {
            cell.lblRosterRepeatStatus.isHidden = true
            cell.viewDays.isHidden = false
            cell.lblRosterDate.text = String(format: "%@ to %@", dd.object(forKey: "FromDate") as! String, dd.object(forKey: "ToDate") as! String)
            
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
        
        cell.lblRosterTime.text = String(format: "%@ - %@", dd.object(forKey: "FromTime") as! String,dd.object(forKey: "ToTime") as! String)
        cell.lblRosterRepeatStatus.text = "No Repeat"
        cell.lblRosterTotalPayment.text = String(format: "%@/hr", dd.object(forKey: "Rate") as! String)
        cell.lblRosterTotalHire.text = String(format: "%d Hire", dd.object(forKey: "NoOfHire") as! Int)
        if dd.object(forKey: "IsBreak") as! Bool == false
        {
            cell.lblRosterBreak.text = "No Break"
            cell.lblRosterBreakPaid.isHidden = true
        }
        else
        {
            cell.lblRosterBreakPaid.isHidden = false
            cell.lblRosterBreak.text = "Break"
            if dd.object(forKey: "IsBreakPaid") as! Bool == false
            {
                cell.lblRosterBreakPaid.text = String(format: "(%dmin - Unpaid)", dd.object(forKey: "BreakMin") as! Int)
            }
            else
            {
                
                cell.lblRosterBreakPaid.text = String(format: "(%dmin - Paid)", dd.object(forKey: "BreakMin") as! Int)
            }
        }
        cell.imgHireIcon.tintColor = API.themeColorBlue()
        if arrOfRoster.count == 1
        {
            cell.btnDelete.isHidden = true
        }
        else
        {
            cell.btnDelete.isHidden = false
        }
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.btndeleteRoster(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedIndex = indexPath.row
        let dd: NSDictionary = arrOfRoster.object(at: indexPath.row) as! NSDictionary
        let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        
        dictRoster = NSMutableDictionary()
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        dictRoster.setValue(df.string(from: Date()), forKey: "Date")
        dictRoster.setValue(df.string(from: Date()), forKey: "FromDate")
        dictRoster.setValue("", forKey: "ToDate")
        df.dateFormat = "hh:mm a"
        dictRoster.setValue(df.string(from: Date().add(minutes: 105)), forKey: "StartTime")
        
        dictRoster.setValue(dictMutable.object(forKey: "BreakMin"), forKey: "BreakTimeInMin")
        dictRoster.setValue(dictMutable.object(forKey: "IsBreakPaid"), forKey: "IsPaid")
        
        dictRoster.setValue(dictMutable.object(forKey: "NoOfHire"), forKey: "NoOfHire")
        dictRoster.setValue(dictMutable.object(forKey: "IsRepete"), forKey: "IsRepete")
        dictRoster.setValue(dictMutable.object(forKey: "DayOfWeekIDs"), forKey: "DayOfWeek")
        
        if let n = NumberFormatter().number(from: dictMutable.object(forKey: "Rate") as! String) {
            let f = CGFloat(n)
            dictRoster.setValue(f, forKey: "Rate")
            dictRoster.setValue(f, forKey: "totalCharge")
        }
        let td: CGFloat = 0.0
        dictRoster.setValue(dictMutable.object(forKey: "Hours"), forKey: "Hours")
        dictRoster.setValue(td, forKey: "totalDays")
        print(dictRoster)
        isAdd = false
        let obj: setRosterClass = self.storyboard?.instantiateViewController(withIdentifier: "setRosterClass") as! setRosterClass
        obj.fromWhere = "objPostHisEdit"
        obj.objHisEdit = self
        self.navigationController?.pushViewController(obj, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let dd: NSDictionary = arrOfRoster.object(at: indexPath.row) as! NSDictionary
        if dd.object(forKey: "IsBreak") as! Bool == false
        {
            return 80
        }
        else
        {
            return 93
        }
//        if dd.object(forKey: "IsRepete") as! Bool == false
//        {
//            if dd.object(forKey: "BreakMin") as! Int == 0
//            {
//                return 75
//            }
//            else
//            {
//                return 88
//            }
//        }
//        else
//        {
//            return 100
//        }
        
//        let dd: NSDictionary = deleObj.arrOfRoster.object(at: indexPath.row) as! NSDictionary
//        if dd.object(forKey: "IsRepete") as! Bool == false
//        {
//            if dd.object(forKey: "BreakTimeInMin") as! Int == 0
//            {
//                return 75
//            }
//            else
//            {
//                return 88
//            }
//        }
//        else
//        {
//            return 100
//        }
    }
    
    //MARK:- Call API
    func getPostDetail()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(dictPost.object(forKey: "PostID"), forKey: "PostID")
        print(parameter)
        API.callApiPOST(strUrl: API_JobProfileForPoster,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1" || response.object(forKey: "ReturnCode") as! String == ""
            {
                let result: NSArray = response.object(forKey: "Data") as! NSArray
                if result.count != 0
                {
                    let dd: NSDictionary = result.object(at: 0) as! NSDictionary
                    
                    self.dictPost = NSMutableDictionary.init(dictionary: dd)
                    
                    let arrCert: NSArray = dd.object(forKey: "Certificate") as! NSArray
                    self.arrOfCerti = NSMutableArray.init(array: arrCert)
                    
                    let arrSkill: NSArray = dd.object(forKey: "CoreSkill") as! NSArray
                    self.arrOfSkill = NSMutableArray.init(array: arrSkill)
                    
                    self.arrOfRoster = NSMutableArray()
                    let arrRoster: NSArray = dd.object(forKey: "Roster") as! NSArray
                    for item in arrRoster
                    {
                        let dd: NSDictionary = item as! NSDictionary
                        let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                        if let n = NumberFormatter().number(from: dictMutable.object(forKey: "JobTimePeriod") as! String) {
                            let f = CGFloat(n)
                            dictMutable.setValue(f, forKey: "Hours")
                        }
                        self.arrOfRoster.add(dictMutable)
                    }
                    
                }
                
                self.setData()
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
    func repost()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(dictPost.object(forKey: "PostID"), forKey: "PostID")
        parameter.setValue(strLat, forKey: "Latitude")
        parameter.setValue(strLong, forKey: "Longitude")
        parameter.setValue(btnAddress.currentTitle, forKey: "LocationName")
        
        let aR: NSMutableArray = NSMutableArray()
        for item in arrOfRoster
        {
            let dd: NSDictionary = item as! NSDictionary
            let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
            dictMutable.setValue(dd.object(forKey: "FromDate"), forKey: "Date")
            dictMutable.setValue(dd.object(forKey: "FromTime"), forKey: "StartTime")
            dictMutable.setValue(dd.object(forKey: "BreakMin"), forKey: "BreakTimeInMin")
            dictMutable.setValue(dd.object(forKey: "IsBreakPaid"), forKey: "IsPaid")
            dictMutable.setValue(dd.object(forKey: "DayOfWeekIDs"), forKey: "DayOfWeek")
            aR.add(dictMutable)
        }
        
        let aCerti: NSMutableArray = NSMutableArray()
        for item in arrOfCerti
        {
            let dd: NSDictionary = item as! NSDictionary
            let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
            dictMutable.setValue(dd.object(forKey: "ID"), forKey: "CertificateID")
            aCerti.add(dictMutable)
        }
        
        let aSkillID: NSMutableArray = NSMutableArray()
        let aSkillName: NSMutableArray = NSMutableArray()
        for item in arrOfSkill
        {
             let dd: NSDictionary = item as! NSDictionary
            if dd.object(forKey: "ID") as! Int == 0
            {
                aSkillName.add(dd.object(forKey: "Name") ?? 0)
            }
            aSkillID.add(dd.object(forKey: "ID") ?? 0)
        }
        
        parameter.setValue(aR, forKey: "Roster")
        parameter.setValue(aCerti, forKey: "CertificateIDs")
        
        let strJobIDs = aSkillID.componentsJoined(by: ",")
        let strJobNames = aSkillName.componentsJoined(by: ",")
        
        parameter.setValue(strJobIDs, forKey: "SkillIDs")
        parameter.setValue(strJobNames, forKey: "SkillNames")
        
        print(parameter)
        API.callApiPOST(strUrl: API_CreateJobPostUsingOlderJob,parameter: parameter, success: { (response) in
            
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
