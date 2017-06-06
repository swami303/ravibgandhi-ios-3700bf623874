//
//  appliedDetailSeeker.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/5/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class appliedDetailSeeker: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    @IBOutlet weak var viewRating: HCSStarRatingView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblHireTillDate: UILabel!
    @IBOutlet weak var imgCompanyPhoto: cImageView!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var btnTotalJobs: UIButton!
    @IBOutlet weak var btnKm: UIButton!
    
    @IBOutlet weak var viewCompanyInfo: UIView!
    
    @IBOutlet weak var scrCoreSkills: UIScrollView!
    @IBOutlet weak var scrCertifiactes: UIScrollView!
    @IBOutlet weak var lblRatingAndReview: UILabel!
    @IBOutlet weak var tblRating: UITableView!
    @IBOutlet weak var scrMain: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var viewTblRosterHeader: UIView!
    @IBOutlet weak var tblRoster: UITableView!
    @IBOutlet weak var lblJobRoster: UILabel!
    @IBOutlet weak var btnSeekerAddress: UIButton!
    @IBOutlet weak var viewButtonInvited: UIView!
    @IBOutlet weak var btnSave: cButton!
    @IBOutlet weak var btnApply: cButton!
    @IBOutlet weak var btnNotApply: cButton!
    @IBOutlet weak var btnSave1: cButton!
    @IBOutlet weak var btnAccept: cButton!
    @IBOutlet weak var viewLable: UIView!
    @IBOutlet weak var lblAddThisCat: UILabel!
    @IBOutlet weak var btnPass: cButton!
    
    var dictUserData: NSMutableDictionary = NSMutableDictionary()
    var IsApplied: Bool = false
    var arrOfSelectedCerti: NSMutableArray = NSMutableArray()
    var arrOfSelectedSkill: NSMutableArray = NSMutableArray()
    var arrOfSelectedRoster: NSMutableArray = NSMutableArray()
    var objMatching: allJobStatusSeeker!
    var objSaved: savedJobClass!
    var arrOfCerti: NSMutableArray = NSMutableArray()
    var arrOfSkill: NSMutableArray = NSMutableArray()
    var arrofRating: NSMutableArray = NSMutableArray()
    var arrOfRoster: NSMutableArray = NSMutableArray()
    var DictPostDetail: NSMutableDictionary = NSMutableDictionary()
    var dictPost: NSMutableDictionary = NSMutableDictionary()
    var strFrom: String = ""
    var yOffset: CGFloat = 0.0
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = API.appBackgroundColor()
        
        self.tblRating.dataSource = self
        self.tblRating.delegate = self
        
        self.tblRoster.dataSource = self
        self.tblRoster.delegate = self
        
        tblRoster.register(UINib(nibName: "cellNoRepeatApplied", bundle: nil), forCellReuseIdentifier: "cellNoRepeatApplied")
        tblRoster.register(UINib(nibName: "cellRepeatApplied", bundle: nil), forCellReuseIdentifier: "cellRepeatApplied")
        
        tblRating.register(UINib(nibName: "rateAndReviewCell", bundle: nil), forCellReuseIdentifier: "rateAndReviewCell")
        viewTblRosterHeader.isHidden = true
        
        tblRoster.layer.cornerRadius = 10
        tblRoster.clipsToBounds = true
        
        tblRoster.layer.borderColor = API.dividerColor().cgColor
        tblRoster.layer.borderWidth = 1
        viewButtons.isHidden = true
        viewButtonInvited.isHidden = true
        scrMain.isHidden = true
        if strFrom == "savedJob"
        {
            btnSave.isHidden = true
            btnApply.frame = btnSave1.frame
            btnNotApply.frame = btnAccept.frame
        }
        viewLable.isHidden = true
        lblAddThisCat.text = "Add this category from >My Profile> Add Category to start getting matching jobs in future."
        getMatchingDetail()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnSave(_ sender: Any)
    {
//        if btnSave.currentTitle == "Remove"
//        {
//            saveProfile(status: false)
//        }
//        else
//        {
//            saveProfile(status: true)
//        }
        if strFrom == "otherJob"
        {
            custObj.alertMessage("You have to add this category in order to save")
            return
        }
        saveProfile(status: true)
    }
    @IBAction func btnApplied(_ sender: Any)
    {
        if strFrom == "otherJob"
        {
            custObj.alertMessage("You have to add this category in order to apply")
            return
        }
        let dd: NSDictionary = API.getLoggedUserData()
        dictUserData = NSMutableDictionary.init(dictionary: dd)
        if dictUserData.object(forKey: "IsPaymentVerify") as! Bool == false
        {
            custObj.alertMessage(Payment_Message)
            let obj: seekerPaymentDetailClass = self.storyboard?.instantiateViewController(withIdentifier: "seekerPaymentDetailClass") as! seekerPaymentDetailClass
            self.navigationController!.pushViewController(obj, animated: true)
            return
        }
        if arrOfSelectedRoster.count == 0
        {
            custObj.alertMessage("Please select atleast one job in order to apply")
            return
        }
        if arrOfSelectedSkill.count == 0
        {
            custObj.alertMessage("Please tick on applicable skills to apply for the work")
            return
        }
        if arrOfSelectedCerti.count == 0
        {
            custObj.alertMessage("Please tick on applicable certificate you have to apply for the work")
            return
        }
        apply(status: true)
    }
    @IBAction func btnRejectInvitation(_ sender: Any)
    {
        if strFrom == "otherJob"
        {
            custObj.alertMessage("You have to add this category in order to pass")
            return
        }
        accept(status: false)
    }
    
    @IBAction func btnAccept(_ sender: Any)
    {
        if strFrom == "otherJob"
        {
            custObj.alertMessage("You have to add this category in order to accept")
            return
        }
        let dd: NSDictionary = API.getLoggedUserData()
        dictUserData = NSMutableDictionary.init(dictionary: dd)
        if dictUserData.object(forKey: "IsPaymentVerify") as! Bool == false
        {
            custObj.alertMessage(Payment_Message)
            let obj: seekerPaymentDetailClass = self.storyboard?.instantiateViewController(withIdentifier: "seekerPaymentDetailClass") as! seekerPaymentDetailClass
            self.navigationController!.pushViewController(obj, animated: true)
            return
        }
        if arrOfSelectedRoster.count == 0
        {
            custObj.alertMessage("Please select atleast one job in order to apply")
            return
        }
        if arrOfSelectedSkill.count == 0
        {
            custObj.alertMessage("Please select atleast one skill in order to apply")
            return
        }
        if arrOfSelectedCerti.count == 0
        {
            custObj.alertMessage("Please select atleast one certifiactes in order to apply")
            return
        }
        accept(status: true)
    }
    @IBAction func btnPass(_ sender: Any)
    {
        if strFrom == "otherJob"
        {
            custObj.alertMessage("You have to add this category in order to not apply")
            return
        }
        apply(status: false)
    }
    
    @IBAction func btnInfo(_ sender: Any)
    {
        custObj.alertMessage(SEEKER_PAY_INOF)
    }
    @IBAction func btnSelectRoster(_ sender: Any)
    {
    }
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblRating
        {
            return arrofRating.count
        }
        if tableView == tblRoster
        {
            return arrOfRoster.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblRating
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rateAndReviewCell", for: indexPath as IndexPath) as! rateAndReviewCell
            let dd: NSDictionary = arrofRating.object(at: indexPath.row) as! NSDictionary
            cell.lblReView.text = dd.object(forKey: "Review") as? String
            cell.viewRating.value = dd.object(forKey: "Rate") as! CGFloat
            cell.imgUserPic.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePic") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
            cell.lblReView.frame = CGRect(x: cell.lblReView.frame.origin.x, y: cell.lblReView.frame.origin.y, width: cell.lblReView.frame.size.width, height: CGFloat(API.HieghtForText(text: cell.lblReView.text!, font: cell.lblReView.font, maxSize: CGSize(width: cell.lblReView.frame.size.width, height: 90000))))
            return cell
        }
        if tableView == tblRoster
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellNoRepeatApplied", for: indexPath as IndexPath) as! cellNoRepeatApplied
            let dd: NSDictionary = arrOfRoster.object(at: indexPath.row) as! NSDictionary
            cell.imgHireIcon.tintColor = API.themeColorBlue()
           
            
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
                cell.lblRosterDate.text = String(format: "%@ to %@", dd.object(forKey: "FromDate") as! String,dd.object(forKey: "ToDate") as! String)
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
                if dd.object(forKey: "IsBreakPaid") as! Bool == true
                {
                    cell.lblRosterBreakPaid.text = String(format: "(%d min - Paid)", dd.object(forKey: "BreakMin") as! Int)
                }
                else
                {
                    cell.lblRosterBreakPaid.text = String(format: "(%d min - Unpaid)", dd.object(forKey: "BreakMin") as! Int)
                }
            }
            
            cell.lblRosterTime.text = String(format: "%@ - %@", dd.object(forKey: "FromTime") as! String,dd.object(forKey: "ToTime") as! String)
            cell.lblRosterTotalPayment.text = String(format: "%@/hr", dd.object(forKey: "Rate") as! String)
            cell.lblRosterTotalHire.text = String(format: "%d applied", dd.object(forKey: "TotalApplied") as! Int)
            if dd.object(forKey: "IsSelected") as! Bool == true
            {
                cell.btnSelectedSlot.isSelected = true
            }
            else
            {
                cell.btnSelectedSlot.isSelected = false
            }
            
            cell.btnSelectedSlot.isUserInteractionEnabled = false
            //cell.btnSelectedSlot.tag = indexPath.row
            //cell.btnSelectedSlot.addTarget(self, action: #selector(self.btnSelectRoster(_:)), for: UIControlEvents.touchUpInside)
            cell.btnInfo.addTarget(self, action: #selector(self.btnInfo(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchingCellPoster", for: indexPath as IndexPath) as! matchingCellPoster
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == tblRoster
        {
            if strFrom == "Applied Job"
            {
                return
            }
            let dd: NSDictionary = arrOfRoster.object(at: indexPath.row) as! NSDictionary
            let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
            if dictMutable.object(forKey: "IsSelected") as! Bool == false
            {
                dictMutable.setValue(true, forKey: "IsSelected")
                arrOfSelectedRoster.add(dd.object(forKey: "RosterID") ?? 0)
            }
            else
            {
                dictMutable.setValue(false, forKey: "IsSelected")
                arrOfSelectedRoster.remove((dd.object(forKey: "RosterID") ?? 0))
            }
            arrOfRoster.replaceObject(at: indexPath.row, with: dictMutable)
            tblRoster.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if tblRoster == tableView
        {
            return 60
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if tblRoster == tableView
        {
            let headerView = NSKeyedArchiver.archivedData(withRootObject: viewTblRosterHeader)
            let newView = NSKeyedUnarchiver.unarchiveObject(with: headerView) as! UIView
            newView.frame = CGRect.init(x: 0, y: 0, width: newView.frame.size.width, height: 60)
            newView.isHidden = false
            
            for case let lbl as UILabel in newView.subviews
            {
                lbl.font = UIFont.init(name: font_openSans_regular, size: 17)
                if lbl.tag == 1
                {
                    if let val = DictPostDetail["CategoryID"]
                    {
                        if DictPostDetail.object(forKey: "CategoryID") as! Int == 0
                        {
                            lbl.text = String(format: "%@ (%@)", DictPostDetail.object(forKey: "Title") as! String,DictPostDetail.object(forKey: "CategoryName") as! String)
                        }
                        else
                        {
                            lbl.text = DictPostDetail.object(forKey: "Title") as? String
                        }
                    }
                    else
                    {
                        lbl.text = DictPostDetail.object(forKey: "Title") as? String
                    }
                    
                }
            }
            for case let btn as UIButton in newView.subviews
            {
                btn.titleLabel?.font = UIFont.init(name: font_openSans_Italic, size: 12)
                if btn.tag == 3
                {
                    btn.addTarget(self, action: #selector(self.btnReload(_:)), for: UIControlEvents.touchUpInside)
                }
                if btn.tag == 2
                {
                    btn.setTitle(DictPostDetail.object(forKey: "LocationName") as? String, for: UIControlState.normal)
                    btn.addTarget(self, action: #selector(self.btnAddress(_:)), for: UIControlEvents.touchUpInside)
                }
            }
            
            return newView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblRating
        {
            let dd: NSDictionary = arrofRating.object(at: indexPath.row) as! NSDictionary
            let str: String = dd.object(forKey: "Review") as! String
            var h: CGFloat = 32
            h = h + CGFloat(API.HieghtForText(text:str , font: UIFont.init(name: font_openSans_regular, size: 14)!, maxSize: CGSize(width: (223 * UIScreen.main.bounds.size.width)/320, height: 90000)))
            h = h + 7
            if h < 60
            {
                h = 60
            }
            return h
        }
        else
        {
            let dd: NSDictionary = arrOfRoster.object(at: indexPath.row) as! NSDictionary
            if dd.object(forKey: "IsBreak") as! Bool == false
            {
                return 78
            }
            return 93
        }
    }
    @IBAction func btnReload(_ sender: Any)
    {
        getMatchingDetail()
    }
    @IBAction func btnAddress(_ sender: Any)
    {
        let lati: Double = Double(DictPostDetail.object(forKey: "Latitude") as! String)!
        let longi: Double = Double(DictPostDetail.object(forKey: "Longitude") as! String)!
        API.openMapForPlace(lat: lati, longi: longi, dd: DictPostDetail)
    }
    //MARK:- Set Detail
    func setDetail()
    {
        viewLable.isHidden = true
        if strFrom == "Applied Job"
        {
            viewButtons.isHidden = true
            viewButtonInvited.isHidden = true
            scrMain.frame = CGRect.init(x: scrMain.frame.origin.x, y: scrMain.frame.origin.y, width: scrMain.frame.size.width, height: scrMain.frame.size.height + viewButtons.frame.size.height)
        }
        else if strFrom == "Invited"
        {
            viewButtons.isHidden = true
            viewButtonInvited.isHidden = false
        }
        else if strFrom == "otherJob"
        {
            viewButtons.isHidden = true
            viewButtonInvited.isHidden = true
            viewLable.isHidden = false
        }
        else if strFrom == "Matching" || strFrom == "savedJob"
        {
            viewButtons.isHidden = false
            viewButtonInvited.isHidden = true
        }
        scrMain.isHidden = false
        arrOfCerti = NSMutableArray()
        let acerti: NSArray = DictPostDetail.object(forKey: "Certificate") as! NSArray
        for item in acerti
        {
            let dd: NSDictionary = item as! NSDictionary
            let dictMutable = NSMutableDictionary.init(dictionary: dd)
            arrOfCerti.add(dictMutable)
        }
        
        arrOfSkill = NSMutableArray()
        let aSkill: NSArray = DictPostDetail.object(forKey: "CoreSkill") as! NSArray
        for item in aSkill
        {
            let dd: NSDictionary = item as! NSDictionary
            let dictMutable = NSMutableDictionary.init(dictionary: dd)
            arrOfSkill.add(dictMutable)
        }
        
        let aReview: NSArray = DictPostDetail.object(forKey: "Review") as! NSArray
        arrofRating = NSMutableArray.init(array: aReview)
        
        arrOfRoster = NSMutableArray()
        let aRRoster: NSArray = DictPostDetail.object(forKey: "Roster") as! NSArray
        for item in aRRoster
        {
            let dd: NSDictionary = item as! NSDictionary
            let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
            arrOfRoster.add(dictMutable)
        }
        
        manageTagCerti(arrTag: arrOfCerti)
        manageTagSkill(arrTag: arrOfSkill)
        
        imgCompanyPhoto.sd_setImage(with: NSURL.init(string: (DictPostDetail.object(forKey: "ProfilePic") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGestureRecognizer:)))
        imgCompanyPhoto.isUserInteractionEnabled = true
        imgCompanyPhoto.addGestureRecognizer(tapGestureRecognizer)
        
        lblCompanyName.text = DictPostDetail.object(forKey: "Name")as? String
        lblHireTillDate.text = String(format: "Hired till date %d", DictPostDetail.object(forKey: "TotalHire") as! Int)
        viewRating.value = DictPostDetail.object(forKey: "ProfileRating") as! CGFloat
        
        let dictUserr: NSDictionary = API.getLoggedUserData()
        let strFromLat: String = dictUserr.object(forKey: "Latitude") as! String
        let strFromLong: String = dictUserr.object(forKey: "Longitude") as! String
        
        let strLatitude: String = DictPostDetail.object(forKey: "Latitude") as! String
        let strLongitude: String = DictPostDetail.object(forKey: "Longitude") as! String
        
        let strDistance: String = API.getDistance(strToLate: strLatitude, strToLong: strLongitude, strFromLat: strFromLat, strFromLong: strFromLong)
        btnKm.setTitle(String(format:"%@",strDistance), for: UIControlState.normal)
        
        btnKm.titleLabel?.adjustsFontSizeToFitWidth = true
        
        //btnKm.setTitle(String(format:"%@",DictPostDetail.object(forKey: "Distance") as! String), for: UIControlState.normal)
        btnRate.setTitle(String(format:"%@",DictPostDetail.object(forKey: "HourlyRate") as! String), for: UIControlState.normal)
        if DictPostDetail.object(forKey: "TotalJobs") as! Int == 1 || DictPostDetail.object(forKey: "TotalJobs") as! Int == 0
        {
            btnTotalJobs.setTitle(String(format:"%d Job",DictPostDetail.object(forKey: "TotalJobs") as! Int), for: UIControlState.normal)
        }
        else
        {
            btnTotalJobs.setTitle(String(format:"%d Jobs",DictPostDetail.object(forKey: "TotalJobs") as! Int), for: UIControlState.normal)
        }
        
        arrangeView()
        tblRating.reloadData()
        tblRoster.reloadData()
    }
    //MARK:- GO TO SEEKER PROFILE
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let obj: posterProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "posterProfileClass") as! posterProfileClass
        obj.userId = DictPostDetail.object(forKey: "UserID") as! String
        self.navigationController!.pushViewController(obj, animated: true)
    }
    //MARK:- TagList Method Certificate
    func manageTagCerti(arrTag: NSMutableArray)
    {
        for case let vv as CustomViewSingleButton in self.scrCertifiactes.subviews
        {
            vv.removeFromSuperview()
        }
        if arrTag.count == 0
        {
            return
        }
        var i: Int = 0
        for item in arrTag
        {
            let dd: NSDictionary = item as! NSDictionary
            
            var strCheckImageName: String = ""
            var strSelectedUser: String = ""
            if dd.object(forKey: "IsSelected") as! Bool == false
            {
                strSelectedUser = "certificationUnCheck"
            }
            else
            {
                strSelectedUser = "certificationCheck"
            }
            if dd.object(forKey: "IsRequired") as! Bool == false
            {
                strCheckImageName = "certificationUnCheck"
            }
            else
            {
                strCheckImageName = "certificationCheck"
            }
            let view1 : CustomViewSingleButton = CustomViewSingleButton.init(s: dd.object(forKey: "Name") as! String, image1name: strCheckImageName, image2name: strSelectedUser, viewBorderColor: API.themeColorBlue(), viewBackColor: API.lightBlueColor())
            
            view1.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width - 40, height: view1.lblText.frame.size.height + 5)
            view1.tag = 4000 + i
            
            
            view1.backgroundColor = API.lightBlueColor()
            view1.layer.borderColor = API.themeColorBlue().cgColor
            view1.layer.borderWidth = 1
            view1.clipsToBounds = true
            
            view1.btnSecondOutlet.tag = i
            view1.btnSecondOutlet.addTarget(self, action: #selector(self.btnAddTagToSelectedCerti(_:)), for: UIControlEvents.touchUpInside)
            scrCertifiactes.addSubview(view1)
            self.view.layoutIfNeeded()
            arrangeTags(scr: scrCertifiactes)
             i = i + 1
        }
    }
    func arrangeTags(scr: UIScrollView)
    {
        var prevViewWidth : CGFloat = 20
        var prevViewY : CGFloat = 35
        var lastViewFrame : CGFloat = 0
        for v in scr.subviews
        {
            print(v.tag)
            if(v.tag >= 4000 && v.tag < 99999)
            {
                if(v is CustomViewSingleButton)
                {
                    let cv : CustomViewSingleButton = v as! CustomViewSingleButton
                    
                    if(scr.subviews.contains(cv))
                    {
                        if(((prevViewWidth + (cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2)) <= scr.frame.size.width - 20))
                        {
                            cv.frame = CGRect.init(x: prevViewWidth, y: prevViewY, width: cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2, height: cv.lblText.frame.size.height + 5)
                        }
                        else
                        {
                            prevViewWidth = 10
                            cv.frame = CGRect.init(x: prevViewWidth, y: prevViewY, width: cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2, height: cv.lblText.frame.size.height + 5)
                        }
                        
                        let start : Int = (v.tag - 4000) + 1
                        var nextTag : Int = 4000+start
                        
                        for j in start..<arrOfCerti.count
                        {
                            nextTag = 4000 + j
                            break
                        }
                        
                        
                        if(self.view.viewWithTag(nextTag) != nil)
                        {
                            let nextView : CustomViewSingleButton = self.view.viewWithTag(nextTag) as! CustomViewSingleButton
                            
                            if(!((prevViewWidth + (cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2) + (nextView.btnSecondOutlet.frame.origin.x + nextView.btnSecondOutlet.frame.size.width + 2)) <= scr.frame.size.width - 20))
                            {
                                prevViewY = cv.frame.origin.y + cv.frame.size.height + 5
                            }
                        }
                        lastViewFrame = cv.frame.size.height
                        cv.layer.cornerRadius = 13//cv.frame.size.height / 2
                        cv.clipsToBounds = true
                        prevViewWidth = cv.frame.size.width + cv.frame.origin.x + 2
                    }
                }
            }
        }
        scrCertifiactes.frame = CGRect.init(x: scrCertifiactes.frame.origin.x, y: scrCertifiactes.frame.origin.y, width: scrCertifiactes.frame.size.width, height: prevViewY + lastViewFrame)
    }
    @IBAction func btnAddTagToSelectedCerti(_ sender: Any)
    {
        if strFrom == "Applied Job"
        {
            return
        }
        let dd: NSDictionary = arrOfCerti.object(at: (sender as AnyObject).tag) as! NSDictionary
        let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        if dictMutable.object(forKey: "IsSelected") as! Bool == false
        {
            dictMutable.setValue(true, forKey: "IsSelected")
            arrOfSelectedCerti.add(dd.object(forKey: "ID") ?? 0)
        }
        else
        {
            dictMutable.setValue(false, forKey: "IsSelected")
            arrOfSelectedCerti.remove(dd.object(forKey: "ID") ?? 0)
        }
        arrOfCerti.replaceObject(at: (sender as AnyObject).tag, with: dictMutable)
        manageTagCerti(arrTag: arrOfCerti)
        
    }
    
    //MARK:- TagList Method Skill
    func manageTagSkill(arrTag: NSMutableArray)
    {
        for case let vv as CustomViewSingleButton in self.scrCoreSkills.subviews
        {
            vv.removeFromSuperview()
        }
        if arrTag.count == 0
        {
            return
        }
        var i: Int = 0
        for item in arrTag
        {
            let dd: NSDictionary = item as! NSDictionary
            var strSelectedUser: String = ""
            if dd.object(forKey: "IsSelected") as! Bool == false
            {
                strSelectedUser = "certificationUnCheck"
            }
            else
            {
                strSelectedUser = "certificationCheck"
            }
            
            let view1 : CustomViewSingleButton = CustomViewSingleButton.init(s: dd.object(forKey: "Name") as! String, image1name: "", image2name: strSelectedUser, viewBorderColor: API.themeColorBlue(), viewBackColor: API.lightBlueColor())
            
            view1.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width - 40, height: view1.lblText.frame.size.height + 5)
            view1.tag = 2000 + i
            
            
            view1.backgroundColor = API.lightBlueColor()
            view1.layer.borderColor = API.themeColorBlue().cgColor
            view1.layer.borderWidth = 1
            view1.clipsToBounds = true
            
            view1.btnSecondOutlet.tag = i
            
            view1.btnSecondOutlet.addTarget(self, action: #selector(self.btnAddTagToSelectedSkill(_:)), for: UIControlEvents.touchUpInside)
            scrCoreSkills.addSubview(view1)
            self.view.layoutIfNeeded()
            
            
            arrangeTagsSkill(scr: scrCoreSkills)
            i = i + 1
        }
    }
    func arrangeTagsSkill(scr: UIScrollView)
    {
        var prevViewWidth : CGFloat = 20
        var prevViewY : CGFloat = 35
        var lastViewFrame : CGFloat = 0
        for v in scr.subviews
        {
            print(v.tag)
            if(v.tag >= 2000 && v.tag < 3999)
            {
                if(v is CustomViewSingleButton)
                {
                    let cv : CustomViewSingleButton = v as! CustomViewSingleButton
                    
                    if(scr.subviews.contains(cv))
                    {
                        if(((prevViewWidth + (cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2)) <= scr.frame.size.width - 20))
                        {
                            cv.frame = CGRect.init(x: prevViewWidth, y: prevViewY, width: cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2, height: cv.lblText.frame.size.height + 5)
                        }
                        else
                        {
                            prevViewWidth = 10
                            cv.frame = CGRect.init(x: prevViewWidth, y: prevViewY, width: cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2, height: cv.lblText.frame.size.height + 5)
                        }
                        
                        let start : Int = (v.tag - 2000) + 1
                        var nextTag : Int = 2000+start
                        
                        for j in start..<arrOfSkill.count
                        {
                            nextTag = 2000 + j
                            break
                        }
                        
                        
                        if(self.view.viewWithTag(nextTag) != nil)
                        {
                            let nextView : CustomViewSingleButton = self.view.viewWithTag(nextTag) as! CustomViewSingleButton
                            
                            if(!((prevViewWidth + (cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2) + (nextView.btnSecondOutlet.frame.origin.x + nextView.btnSecondOutlet.frame.size.width + 2)) <= scr.frame.size.width - 20))
                            {
                                prevViewY = cv.frame.origin.y + cv.frame.size.height + 5
                            }
                        }
                        lastViewFrame = cv.frame.size.height
                        cv.layer.cornerRadius = 13//cv.frame.size.height / 2
                        cv.clipsToBounds = true
                        prevViewWidth = cv.frame.size.width + cv.frame.origin.x + 2
                    }
                }
            }
        }
        scrCoreSkills.frame = CGRect.init(x: scrCoreSkills.frame.origin.x, y: scrCoreSkills.frame.origin.y, width: scrCoreSkills.frame.size.width, height: prevViewY + lastViewFrame)
    }
    @IBAction func btnAddTagToSelectedSkill(_ sender: Any)
    {
        if strFrom == "Applied Job"
        {
            return
        }
        let dd: NSDictionary = arrOfSkill.object(at: (sender as AnyObject).tag) as! NSDictionary
        let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        if dictMutable.object(forKey: "IsSelected") as! Bool == false
        {
            dictMutable.setValue(true, forKey: "IsSelected")
            arrOfSelectedSkill.add(dd.object(forKey: "ID") ?? 0)
        }
        else
        {
            dictMutable.setValue(false, forKey: "IsSelected")
            arrOfSelectedSkill.remove(dd.object(forKey: "ID") ?? 0)
        }
        arrOfSkill.replaceObject(at: (sender as AnyObject).tag, with: dictMutable)
        manageTagSkill(arrTag: arrOfSkill)
        
    }
    //MARK:- Arrange Views
    func arrangeView()
    {
        yOffset = viewCompanyInfo.frame.size.height + viewCompanyInfo.frame.origin.y + 8
        
        lblJobRoster.frame = CGRect.init(x: lblJobRoster.frame.origin.x, y: yOffset, width: lblJobRoster.frame.size.width, height: lblJobRoster.frame.size.height)
        yOffset = lblJobRoster.frame.size.height + lblJobRoster.frame.origin.y + 8
        
        var tblRosterHieght: CGFloat = 0
        for item in arrOfRoster
        {
            let dd: NSDictionary = item as! NSDictionary
            if dd.object(forKey: "IsBreak") as! Bool == false
            {
                tblRosterHieght = tblRosterHieght + 78
            }
            else
            {
                tblRosterHieght = tblRosterHieght + 93
            }
        }
        tblRoster.frame = CGRect.init(x: tblRoster.frame.origin.x, y: yOffset, width: tblRoster.frame.size.width, height: tblRosterHieght + 60)
        yOffset = tblRoster.frame.size.height + tblRoster.frame.origin.y + 8
        
        scrCoreSkills.frame = CGRect.init(x: scrCoreSkills.frame.origin.x, y: yOffset, width: scrCoreSkills.frame.size.width, height: scrCoreSkills.frame.size.height)
        yOffset = scrCoreSkills.frame.size.height + scrCoreSkills.frame.origin.y + 8
        
        scrCertifiactes.frame = CGRect.init(x: scrCertifiactes.frame.origin.x, y: yOffset, width: scrCertifiactes.frame.size.width, height: scrCertifiactes.frame.size.height)
        yOffset = scrCertifiactes.frame.size.height + scrCertifiactes.frame.origin.y + 8
        
        lblRatingAndReview.frame = CGRect.init(x: lblRatingAndReview.frame.origin.x, y: yOffset, width: lblRatingAndReview.frame.size.width, height: lblRatingAndReview.frame.size.height)
        yOffset = lblRatingAndReview.frame.size.height + lblRatingAndReview.frame.origin.y + 8
        
        var tblratingHieght: CGFloat = 0
        for item in arrofRating
        {
            let dd: NSDictionary = item as! NSDictionary
            let str: String = dd.object(forKey: "Review") as! String
            var h: CGFloat = 32
            h = h + CGFloat(API.HieghtForText(text:str , font: UIFont.init(name: font_openSans_regular, size: 14)!, maxSize: CGSize(width: (223 * UIScreen.main.bounds.size.width)/320, height: 90000)))
            h = h + 7
            if h < 60
            {
                h = 60
            }
            tblratingHieght = tblratingHieght + h
        }
        tblRating.frame = CGRect.init(x: tblRating.frame.origin.x, y: yOffset, width: tblRating.frame.size.width, height: tblratingHieght)
        yOffset = tblRating.frame.size.height + tblRating.frame.origin.y + 8
        
        scrMain.contentSizeToFit()
    }

    //MARK:- Call API
    func getMatchingDetail()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(dictPost.object(forKey: "UserID"), forKey: "UserID")
        parameter.setValue(dictPost.object(forKey: "JobPostID"), forKey: "PostID")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        parameter.setValue(API.getUserId(), forKey: "LoginUserID")
        parameter.setValue(IsApplied, forKey: "IsApplied")
        print(parameter)
        API.callApiPOST(strUrl: API_JobPostProfile,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let result: NSArray = response.object(forKey: "Data") as! NSArray
                if result.count != 0
                {
                    let dd: NSDictionary = result.object(at: 0) as! NSDictionary
                    self.DictPostDetail = NSMutableDictionary.init(dictionary: dd)
                    self.setDetail()
                }
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
    func saveProfile(status:Bool)
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(dictPost.object(forKey: "UserID"), forKey: "PosterID")
        parameter.setValue(dictPost.object(forKey: "JobPostID"), forKey: "PostID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(status, forKey: "Status")
        print(parameter)
        API.callApiPOST(strUrl: API_SavePosterJobProfile,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
//            if status == true
//            {
//                self.btnSave.setTitle("Remove", for: UIControlState.normal)
//            }
//            else
//            {
//                self.btnSave.setTitle("Save", for: UIControlState.normal)
//            }
            
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
    func apply(status: Bool)
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "SeekerID")
        parameter.setValue(dictPost.object(forKey: "JobPostID"), forKey: "PostID")
        parameter.setValue(arrOfSelectedRoster.componentsJoined(by: ","), forKey: "RosterID")
        parameter.setValue(arrOfSelectedSkill.componentsJoined(by: ","), forKey: "SkillID")
        parameter.setValue(arrOfSelectedCerti.componentsJoined(by: ","), forKey: "CertificateID")
        parameter.setValue(status, forKey: "Status")
        print(parameter)
        API.callApiPOST(strUrl: API_AppliedJob,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                if self.strFrom == "savedJob"
                {
//                    self.objSaved.arrOfSavedJob.removeObject(at: self.objSaved.removedTag)
//                    self.objSaved.tblSavedProfile.reloadData()
//                    if self.objSaved.arrOfSavedJob.count == 0
//                    {
//                        self.objSaved.contentMsg.isHidden = false
//                    }
                }
                else
                {
//                    if self.objMatching.arrOfMatchingProfile.count != 0
//                    {
//                        self.objMatching.arrOfMatchingProfile.removeObject(at: self.objMatching.selectedIndex)
//                        self.objMatching.lblMatchingCnt.text = String(format: "%d", self.objMatching.arrOfMatchingProfile.count)
//                        self.objMatching.tblMtching.reloadData()
//                        self.objMatching.dropAllPins()
//                        if self.objMatching.arrOfMatchingProfile.count == 0
//                        {
//                            self.objMatching.contentMsg.isHidden = false
//                        }
//                    }
                }
                _ = self.navigationController?.popViewController(animated: true)
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
    func accept(status: Bool)
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "SeekerID")
        parameter.setValue(dictPost.object(forKey: "JobPostID"), forKey: "PostID")
        parameter.setValue(arrOfSelectedRoster.componentsJoined(by: ","), forKey: "RosterID")
        parameter.setValue(arrOfSelectedSkill.componentsJoined(by: ","), forKey: "SkillID")
        parameter.setValue(arrOfSelectedCerti.componentsJoined(by: ","), forKey: "CertificateID")
        parameter.setValue(status, forKey: "Status")
        print(parameter)
        API.callApiPOST(strUrl: API_AcceptJob,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                if API.isFromNotification() == true
                {
                    API.setIsFromNotification(type: false)
                }
                else
                {
//                    if self.objMatching.arrOfInvitedProfile.count != 0
//                    {
//                        self.objMatching.arrOfInvitedProfile.removeObject(at: self.objMatching.selectedIndex)
//                        self.objMatching.lblInvitedCnt.text = String(format: "%d", self.objMatching.arrOfInvitedProfile.count)
//                        self.objMatching.tblMtching.reloadData()
//                        self.objMatching.dropAllPins()
//                        if self.objMatching.arrOfInvitedProfile.count == 0
//                        {
//                            self.objMatching.contentMsg.isHidden = false
//                        }
//                    }
                }
                _ = self.navigationController?.popViewController(animated: true)
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                API.setIsFromNotification(type: false)
            }
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            API.setIsFromNotification(type: false)
        })
    }
    
}
