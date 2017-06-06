//
//  calendarPosterClass.swift
//  WorkingBeez
//
//  Created by Swami on 3/8/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class calendarPosterClass: UIViewController,FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, UITableViewDataSource, UITableViewDelegate
{
    var bottomView : UIView!
    @IBOutlet weak var btnCal: UIButton!
    
    private weak var calendar: FSCalendar!
    var activeCell : FSCalendarCell = FSCalendarCell()
    var activeDate : Date = Date()
    var tblCalendarJob : UITableView!
    var selectedDate: String = ""
    var selectedMonth: Int = 0
    var selectedYear: Int = 0
    var isAccepted: Bool = true
//    let fillDefaultColors = ["9/3/2017": "1", "25/12/2017": "2"]
    var arrOfDateOnly: NSMutableArray = NSMutableArray()
    var arrOfCalender: NSMutableArray = NSMutableArray()
    var arrOfCalenderDetail: NSMutableArray = NSMutableArray()
    var contentMsg: ContentMessageView!
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        btnCal.isHidden = true
        contentMsg = ContentMessageView.CreateView(self.view, strMessage: "No records found", strImageName: "WB_Font", color: UIColor.lightGray)
        contentMsg.isHidden = true
        view.backgroundColor = API.appBackgroundColor()
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "M"
        var strM: String = df.string(from: Date())
        selectedMonth = Int(strM)!
        df.dateFormat = "yyyy"
        strM = df.string(from: Date())
        selectedYear = Int(strM)!
        getCalender()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    override func loadView()
    {
        let view = UIView(frame: UIScreen.main.bounds)
        view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.backgroundColor = API.appBackgroundColor()
        self.view = view
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 64))
        
        bottomView = UIView.init(frame: CGRect.init(x: 0, y: calendar.frame.origin.y + calendar.frame.size.height, width: self.view.bounds.width, height: 0))
        bottomView.backgroundColor = UIColor.clear
        bottomView.clipsToBounds = true
        
        let imgBlue : UILabel = UILabel.init(frame: CGRect.init(x: 20, y: 15, width: 20, height: 20))
        imgBlue.backgroundColor = API.themeColorBlue()
        imgBlue.layer.cornerRadius = imgBlue.frame.size.width / 2
        imgBlue.clipsToBounds = true
        imgBlue.text = ""
        bottomView.addSubview(imgBlue)
        
        let imgBlueText : UILabel = UILabel.init(frame: CGRect.init(x: imgBlue.frame.size.width + imgBlue.frame.origin.x + 10, y: 15, width: 100, height: 20))
        imgBlueText.backgroundColor = UIColor.clear
        imgBlueText.text = "Completed Job"
        imgBlueText.font = UIFont.init(name: "OpenSans", size: 14)
        bottomView.addSubview(imgBlueText)
        
        let imgPink : UILabel = UILabel.init(frame: CGRect.init(x: imgBlueText.frame.size.width + imgBlueText.frame.origin.x + 20, y: 15, width: 20, height: 20))
        imgPink.backgroundColor = API.themeColorPink()
        imgPink.layer.cornerRadius = imgPink.frame.size.width / 2
        imgPink.clipsToBounds = true
        imgPink.text = ""
        bottomView.addSubview(imgPink)
        
        let imgPinkText : UILabel = UILabel.init(frame: CGRect.init(x: imgPink.frame.size.width + imgPink.frame.origin.x + 10, y: 15, width: 100, height: 20))
        imgPinkText.backgroundColor = UIColor.clear
        imgPinkText.text = "Post Job"
        imgPinkText.font = UIFont.init(name: "OpenSans", size: 14)
        bottomView.addSubview(imgPinkText)
        
        self.view.addSubview(bottomView)
        
        
        tblCalendarJob = UITableView(frame: CGRect.init(x: 7, y: bottomView.frame.size.height + bottomView.frame.origin.y + 8, width: self.view.bounds.width - 14, height: 0), style: UITableViewStyle.plain)
        tblCalendarJob.register(UINib(nibName: "CellCalenderPoster", bundle: nil), forCellReuseIdentifier: "CellCalenderPoster")
        tblCalendarJob.backgroundColor = UIColor.clear
        self.view.addSubview(tblCalendarJob)
        
        tblCalendarJob.dataSource = self
        tblCalendarJob.delegate = self
        tblCalendarJob.separatorStyle = UITableViewCellSeparatorStyle.none
        tblCalendarJob.reloadData()
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.titleTodayColor = UIColor.black
        calendar.appearance.selectionColor = UIColor.clear
        calendar.appearance.titleSelectionColor = UIColor.black
        calendar.appearance.eventDefaultColor = API.onlineColor()
        calendar.allowsMultipleSelection = false
        calendar.appearance.headerTitleColor = UIColor.darkGray
        calendar.appearance.weekdayTextColor = API.themeColorPink()
        calendar.appearance.titleFont = UIFont.init(name: "OpenSans", size: 14)
        calendar.appearance.headerTitleFont = UIFont.init(name: "OpenSans", size: 16)
        calendar.appearance.weekdayFont = UIFont.init(name: "OpenSans", size: 15)
        calendar.appearance.titleSelectionColor = UIColor.white
        
        calendar.appearance.titleOffset = CGPoint.init(x: 0, y: 5)
        self.calendar = calendar
        self.view.addSubview(calendar)
        
        self.calendar.setScope(.month, animated: false)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool)
    {
        self.calendar.frame = CGRect.init(x: calendar.frame.origin.x, y: calendar.frame.origin.y, width: calendar.frame.size.width, height: bounds.size.height)
        bottomView.frame = CGRect.init(x: 0, y: calendar.frame.origin.y + calendar.frame.size.height, width: self.view.bounds.width, height: 0)
        tblCalendarJob.frame = CGRect.init(x: 8, y: bottomView.frame.origin.y + bottomView.frame.size.height + 8, width: self.view.bounds.width - 16, height: self.view.frame.size.height - (bottomView.frame.origin.y + bottomView.frame.size.height) - 8)

        self.view.layoutIfNeeded()
    }
    
    //MARK:- calendar View Delgate
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell
    {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        
        cell.titleLabel.center = cell.center
        cell.titleLabel.backgroundColor = UIColor.clear
        
        cell.subtitleLabel.isHidden = false
        
        return cell
    }
    func calendarCurrentMonthDidChange(_ calendar: FSCalendar)
    {
        print(calendar.currentPage)
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "M"
        var strM: String = df.string(from: calendar.currentPage)
        selectedMonth = Int(strM)!
        df.dateFormat = "yyyy"
        strM = df.string(from: calendar.currentPage)
        selectedYear = Int(strM)!
        getCalender()
    }
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String?
    {
        return ""
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        selectedDate = self.dateFormatter1.string(from: date)
        calendar.appearance.selectionColor = UIColor.clear
        calendar.appearance.titleSelectionColor = UIColor.black
        calendar.appearance.eventSelectionColor = API.onlineColor()
        
    
        let key: String = self.dateFormatter1.string(from: date)
        if arrOfDateOnly.contains(key)
        {
            let index: Int = arrOfDateOnly.index(of: key)
            
            let dd: NSDictionary = arrOfCalender.object(at: index) as! NSDictionary
            if dd.object(forKey: "IsCompleted") as! Bool == true && dd.object(forKey: "IsAccepeted") as! Bool == true
            {
                calendar.appearance.titleSelectionColor = UIColor.white
                calendar.appearance.selectionColor = API.blackColor()
                isAccepted = false
            }
            else if dd.object(forKey: "IsCompleted") as! Bool == true
            {
                calendar.appearance.titleSelectionColor = UIColor.white
                calendar.appearance.selectionColor = API.themeColorBlue()
                isAccepted = false
            }
            else if dd.object(forKey: "IsAccepeted") as! Bool == true
            {
                calendar.appearance.titleSelectionColor = UIColor.white
                calendar.appearance.selectionColor = API.themeColorPink()
                isAccepted = true
            }
            
        }
        

        
        if(self.calendar.scope == .month)
        {
            self.calendar.setScope(.week, animated: true)
            btnCal.isHidden = false
        }
        getCalenderDetail()
        print(calendar.frame)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.none
    }
    
    var datesWithEvent:[NSDate] = []
    func calendar(_ calendar: FSCalendar, hasEventFor date: Date) -> Bool
    {
        return datesWithEvent.contains(Date() as NSDate)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
        let df : DateFormatter = DateFormatter()
        let ddd : Date = Date()
        df.dateFormat = "yyyy-MM-dd"
        
        let strDate : String = df.string(from: ddd)
        
        let dd : Date = df.date(from: strDate)!
        
        if(dd.compare(date) == ComparisonResult.orderedSame)
        {
            return 1
        }
        
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor?
    {
        let key: String = self.dateFormatter1.string(from: date)
        /*{
            Date = "7/4/2017";
            DayOfWeek = 5;
            IsAccepeted = 0;
            IsCompleted = 1;
        }*/
        
        if arrOfDateOnly.contains(key)
        {
            let index: Int = arrOfDateOnly.index(of: key)
            
            let dd: NSDictionary = arrOfCalender.object(at: index) as! NSDictionary
            if dd.object(forKey: "IsCompleted") as! Bool == true && dd.object(forKey: "IsAccepeted") as! Bool == true
            {
                return API.blackColor()
            }
            else if dd.object(forKey: "IsCompleted") as! Bool == true
            {
                return API.themeColorBlue()
            }
            else if dd.object(forKey: "IsAccepeted") as! Bool == true
            {
                return API.themeColorPink()
            }
        }
        return nil
//        if let color = self.fillDefaultColors[key]
//        {
//            if(color == "1")
//            {
//                return API.themeColorPink()
//            }
//            else
//            {
//                return API.themeColorBlue()
//            }
//        }
//        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor?
    {
//        let key = self.dateFormatter1.string(from: date)
//        if let color = self.fillDefaultColors[key]
//        {
//            return UIColor.white
//        }
        let key: String = self.dateFormatter1.string(from: date)
        /*{
         Date = "7/4/2017";
         DayOfWeek = 5;
         IsAccepeted = 0;
         IsCompleted = 1;
         }*/
        
        if arrOfDateOnly.contains(key)
        {
            return UIColor.white
        }
        return nil
    }
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yyyy"
        return formatter
    }()

    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfCalenderDetail.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCalenderPoster", for: indexPath as IndexPath) as! CellCalenderPoster
        let dd: NSDictionary = arrOfCalenderDetail.object(at: indexPath.row) as! NSDictionary
        
        cell.btnInfo.isHidden = true
        if dd.object(forKey: "StatusID") as! Int == 4
        {
            cell.lblCompleted.isHidden = true
            cell.lblRemainTime.isHidden = false
            cell.lblTotalHired.isHidden = false
            cell.imgHireIcon.tintColor = API.themeColorBlue()
            cell.lblRosterTotalPayment.text = String(format: "%@/hr", dd.object(forKey: "HourlyRate") as! String)
            cell.lblTotalHired.text = String(format: "%@", dd.object(forKey: "NoOfHire") as! String)
            cell.lblRemainTime.text = String(format: "%@", dd.object(forKey: "JobTimePeriod") as! String)
            cell.lblTotalHired.textColor = API.themeColorPink()
            cell.imgHireIcon.image = UIImage.init(named: "group")
        }
        else
        {
            cell.lblRemainTime.isHidden = true
            cell.lblCompleted.isHidden = false
            cell.lblCompleted.text = dd.object(forKey: "Status") as? String
            cell.imgHireIcon.tintColor = API.themeColorBlue()
            cell.imgHireIcon.image = UIImage.init(named: "dollar_small")
            cell.lblTotalHired.text = String(format: "%@", dd.object(forKey: "HourlyRate") as! String)
            cell.lblTotalHired.textColor = API.blackColor()
        }
        
        cell.btnNext.isUserInteractionEnabled = false
        let arrImage: NSArray = dd.object(forKey: "SeekerProfiles") as! NSArray
        var xOffset: Int = 0
        var i: Int = 0
        for case let vv as UIButton in cell.scrUsers.subviews
        {
            vv.removeFromSuperview()
        }
        for case let vv as UIImageView in cell.scrUsers.subviews
        {
            vv.removeFromSuperview()
        }
        for item in arrImage
        {
            let dd: NSDictionary = item as! NSDictionary
            let strImageUrl: String = dd.object(forKey: "ImagePath") as! String
            
            var btn: UIButton!
            btn = UIButton.init(frame: CGRect.init(x: xOffset, y: 0, width: 40, height: 40))
            btn.backgroundColor = UIColor.clear
            var imgHiredUser: UIImageView!
            imgHiredUser = UIImageView.init(frame: CGRect.init(x: xOffset, y: 0, width: 40, height: 40))
            imgHiredUser.layer.cornerRadius = 20
            imgHiredUser.clipsToBounds = true
            imgHiredUser.image = UIImage.init(named: "userPlaceholder")
            imgHiredUser.sd_setImage(with: NSURL.init(string: strImageUrl) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
            cell.scrUsers.addSubview(imgHiredUser)
            cell.scrUsers.addSubview(btn)
            xOffset = xOffset + 45
            btn.tag = i
            i = i + 1
            btn.addTarget(self, action: #selector(self.btnViewSeekerProfile(_:)), for: UIControlEvents.touchUpInside)
        }
        cell.scrUsers.contentSize = CGSize.init(width: xOffset, height: 40)
        cell.scrUsers.tag = indexPath.row
        //cell.scrUsers.contentSizeToFit()
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
            if dd.object(forKey: "StatusID") as! Int == 4
            {
                cell.lblRosterDate.text = String(format: "%@ to %@", API.convertDateToString(strDate: dd.object(forKey: "FromDate") as! String, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy"),API.convertDateToString(strDate: dd.object(forKey: "ToDate") as! String, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy"))
            }
            else
            {
                cell.lblRosterDate.text = API.convertDateToString(strDate: dd.object(forKey: "FromDate") as! String, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy")
            }
            //cell.lblRosterDate.text = String(format: "%@ to %@", API.convertDateToString(strDate: dd.object(forKey: "FromDate") as! String, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy"),API.convertDateToString(strDate: dd.object(forKey: "ToDate") as! String, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy"))
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
        
        cell.lblJobTitle.text = dd.object(forKey: "JobPostTitle") as? String
        cell.lblNoteId.text = String(format: "Job ID: %d", dd.object(forKey: "JobPostID") as! Int)
        cell.lblRosterTime.text = String(format: "%@ - %@", dd.object(forKey: "FromTime") as! String,dd.object(forKey: "ToTime") as! String)
        
        //cell.lblJobId.text = String(format: "Job ID: %d", dd.object(forKey: "JobPostID") as! Int)
        cell.btnAddress.setTitle(dd.object(forKey: "LocationName") as? String, for: UIControlState.normal)
        cell.btnAddress.titleLabel?.adjustsFontSizeToFitWidth = true
        cell.btnInfo.tag = indexPath.row
        cell.btnNote.tag = indexPath.row
        cell.btnInfo.addTarget(self, action: #selector(self.btnInfo(_:)), for: UIControlEvents.touchUpInside)
        cell.btnNote.addTarget(self, action: #selector(self.btnNote(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dd: NSDictionary = arrOfCalenderDetail.object(at: indexPath.row) as! NSDictionary
        if dd.object(forKey: "StatusID") as! Int == 4
        {
            let obj: allJobStatusPoster = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusPoster") as! allJobStatusPoster
            obj.strNavTitle = "Accepted Job"
            self.navigationController!.pushViewController(obj, animated: true)
        }
        else
        {
            let obj: completedJobPoster = self.storyboard?.instantiateViewController(withIdentifier: "completedJobPoster") as! completedJobPoster
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 190
    }
    
    //MARK:- PRIVATE METHOD
    @IBAction func btnInfo(_ sender: Any)
    {
        custObj.alertMessage(SEEKER_PAY_INOF)
    }
    @IBAction func btnNote(_ sender: Any)
    {
        let tag: Int = (sender as AnyObject).tag
        let obj: calendarNotesClass = self.storyboard?.instantiateViewController(withIdentifier: "calendarNotesClass") as! calendarNotesClass
        obj.dictFrom = arrOfCalenderDetail.object(at: tag) as! NSDictionary
        self.present(obj, animated: true, completion: nil)
    }
    @IBAction func btnCal(_ sender: Any)
    {
        btnCal.isHidden = true
        self.calendar.setScope(.month, animated: true)
    }
    @IBAction func btnViewSeekerProfile(_ sender: Any)
    {
        let btn: UIButton = sender as! UIButton
        let superViewTag: Int = (btn.superview?.tag)!
        let tag: Int = btn.tag
        print(tag)
        print(superViewTag)
        
        var ddSuper: NSDictionary = NSDictionary()
        ddSuper = arrOfCalenderDetail.object(at: superViewTag) as! NSDictionary
        let aa: NSArray = ddSuper.object(forKey: "SeekerProfiles") as! NSArray
        let dd: NSDictionary = aa.object(at: tag) as! NSDictionary
        let obj: seekerProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "seekerProfileClass") as! seekerProfileClass
        obj.userId = dd.object(forKey: "SeekerID") as! String
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    //MARK:- Call API
    func getCalender()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(selectedMonth, forKey: "Month")
        parameter.setValue(selectedYear, forKey: "Year")
        parameter.setValue(false, forKey: "IsAll")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        print(parameter)
        API.callApiPOST(strUrl: API_GetCalender,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let aa: NSArray = response.object(forKey: "Data") as! NSArray
                self.arrOfCalender = NSMutableArray.init(array: aa)
                self.arrOfDateOnly = NSMutableArray()
                for item in aa
                {
                    let dd: NSDictionary = item as! NSDictionary
                    self.arrOfDateOnly.add(dd.object(forKey: "Date") ?? "")
                }
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.calendar.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    func getCalenderDetail()
    {
        custObj.showSVHud("Loading")
        self.arrOfCalenderDetail = NSMutableArray()
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(selectedDate, forKey: "Date")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        print(parameter)
        API.callApiPOST(strUrl: API_GetRosterCalender,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let aa: NSArray = response.object(forKey: "Data") as! NSArray
                self.arrOfCalenderDetail = NSMutableArray.init(array: aa)
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.tblCalendarJob.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.arrOfCalenderDetail = NSMutableArray()
            self.tblCalendarJob.reloadData()
        })
    }
}
