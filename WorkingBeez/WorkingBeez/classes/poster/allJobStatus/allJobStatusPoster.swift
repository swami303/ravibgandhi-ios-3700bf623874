//
//  allJobStatusPoster.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/24/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class allJobStatusPoster: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate
{

    //MARK:- Outlet
    @IBOutlet weak var btnMatchingProfile: UIButton!
    @IBOutlet weak var btnAppliedJob: UIButton!
    @IBOutlet weak var btnAcceptedJob: UIButton!
    @IBOutlet weak var btnRunningJob: UIButton!
    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var scrMain: UIScrollView!
    @IBOutlet weak var tblMtching: UITableView!
    @IBOutlet weak var sgmtMatching: UISegmentedControl!
    @IBOutlet weak var lblTotalShared: UILabel!
    @IBOutlet weak var lblTotalView: UILabel!
    @IBOutlet weak var lblInvitedCnt: cLable!
    @IBOutlet weak var lblMatchingCnt: cLable!
    @IBOutlet weak var viewMatching: UIView!
    @IBOutlet weak var viewApplied: UIView!
    @IBOutlet weak var viewAccepted: UIView!
    @IBOutlet weak var viewRunning: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var viewMatchingTop: UIView!
    
    
    @IBOutlet weak var tblApplied: UITableView!
    @IBOutlet weak var tblAccepted: UITableView!
    @IBOutlet weak var tblRunning: UITableView!
    
    var timerForRunning: Timer!
    var selectedIndex: Int = 0
    var dictViewShared: NSMutableDictionary = NSMutableDictionary()
    var arrOfMatchingProfile: NSMutableArray = NSMutableArray()
    var arrOfInvitedProfile: NSMutableArray = NSMutableArray()
    var arrOfAppliedProfile: NSMutableArray = NSMutableArray()
    var arrOfAccepted: NSMutableArray = NSMutableArray()
    var arrOfRunning: NSMutableArray = NSMutableArray()
    var deleObj: AppDelegate!
    var currentContentOffScrMain: CGFloat = 0.0
    var strNavTitle: String = ""
    var isMatching: Bool = true
    
    var contentMsg: ContentMessageView!
    
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        contentMsg = ContentMessageView.CreateView(self.view, strMessage: "No records found", strImageName: "WB_Font", color: UIColor.lightGray)
        contentMsg.isHidden = true
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        
        
        API.resetFilter()
        
        
        view.backgroundColor = API.appBackgroundColor()
        scrMain.contentSize = CGSize.init(width: scrMain.frame.width*4, height: 0)
        scrMain.delegate = self
        
        self.tblMtching.dataSource = self
        self.tblMtching.delegate = self
        tblMtching.register(UINib(nibName: "matchingCellPoster", bundle: nil), forCellReuseIdentifier: "matchingCellPoster")
        
        
        self.tblApplied.dataSource = self
        self.tblApplied.delegate = self
        tblApplied.register(UINib(nibName: "matchingCellPoster", bundle: nil), forCellReuseIdentifier: "matchingCellPoster")
        
        self.tblAccepted.dataSource = self
        self.tblAccepted.delegate = self
        tblAccepted.register(UINib(nibName: "acceptedCellPoster", bundle: nil), forCellReuseIdentifier: "acceptedCellPoster")
        
        self.tblRunning.dataSource = self
        self.tblRunning.delegate = self
        tblRunning.register(UINib(nibName: "runningJobCellPoster", bundle: nil), forCellReuseIdentifier: "runningJobCellPoster")
        
        lblMatchingCnt.backgroundColor = API.counterBackColor()
        lblInvitedCnt.backgroundColor = API.counterBackColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.startCalling), name: NSNotification.Name(rawValue: "reloadJobsPoster"), object: nil)
        
        self.navigationItem.title = strNavTitle
        lblMatchingCnt.text = "0"
        lblInvitedCnt.text = "0"
        lblTotalView.text = "0"
        lblTotalShared.text = "0"
        let attr = NSDictionary(object: UIFont(name: font_openSans_regular, size: 14)!, forKey: NSFontAttributeName as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        map.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadAcceptedPoster), name: NSNotification.Name(rawValue: "reloadAcceptedPoster"), object: nil)
        map.delegate = self
    }
    override func viewWillAppear(_ animated: Bool)
    {
        startCalling()
        timerForRunning = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(runningTimer), userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        timerForRunning.invalidate()
        timerForRunning = nil
    }
    func runningTimer()
    {
        getRunning(show: false)
    }
    //MARK:- call Initiallly
    func startCalling()
    {
        getInvitedProfile()
        if strNavTitle == "Matching Profile"
        {
            btnMatchingProfile(self)
            scrMain.contentOffset.x = 0
        }
        else if strNavTitle == "Applied Job"
        {
            btnAppliedJob(self)
            scrMain.contentOffset.x = UIScreen.main.bounds.size.width
        }
        else if strNavTitle == "Accepted Job"
        {
            btnAcceptedJob(self)
            scrMain.contentOffset.x = UIScreen.main.bounds.size.width*2
        }
        else if strNavTitle == "Running Job"
        {
            btnRunningJob(self)
            scrMain.contentOffset.x = UIScreen.main.bounds.size.width*3
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //MARK:- POST NOTIFICATION
    func reloadAcceptedPoster()
    {
        getAccepted(show: false)
    }
    //MARK:- Action Zone
    @IBAction func btnMatchingProfile(_ sender: Any)
    {
        self.contentMsg.isHidden = true
        currentContentOffScrMain = 0
        btnMatchingProfile.isSelected = true
        btnAppliedJob.isSelected = false
        btnAcceptedJob.isSelected = false
        btnRunningJob.isSelected = false
        //setDividerFrame(xx: btnMatchingProfile.frame.origin.x)
        strNavTitle = "Matching Profile"
        self.navigationItem.title = strNavTitle
        scrMain.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        if isMatching == true
        {
            getMatchingProfile()
        }
        else
        {
            getInvitedProfile()
        }
        self.dropAllPins()
    }
    @IBAction func btnAppliedJob(_ sender: Any)
    {
        self.contentMsg.isHidden = true
        currentContentOffScrMain = UIScreen.main.bounds.size.width
        btnMatchingProfile.isSelected = false
        btnAppliedJob.isSelected = true
        btnAcceptedJob.isSelected = false
        btnRunningJob.isSelected = false
        //setDividerFrame(xx: btnAppliedJob.frame.origin.x)
        strNavTitle = "Applied Job"
        self.navigationItem.title = strNavTitle
        scrMain.setContentOffset(CGPoint.init(x: UIScreen.main.bounds.size.width, y: 0), animated: true)
        getApplied()
        self.dropAllPins()
    }
    @IBAction func btnAcceptedJob(_ sender: Any)
    {
        self.contentMsg.isHidden = true
        currentContentOffScrMain = UIScreen.main.bounds.size.width*2
        btnMatchingProfile.isSelected = false
        btnAppliedJob.isSelected = false
        btnAcceptedJob.isSelected = true
        btnRunningJob.isSelected = false
        //setDividerFrame(xx: btnAcceptedJob.frame.origin.x)
        strNavTitle = "Accepted Job"
        self.navigationItem.title = strNavTitle
        scrMain.setContentOffset(CGPoint.init(x: UIScreen.main.bounds.size.width*2, y: 0), animated: true)
        if arrOfAccepted.count == 0
        {
            getAccepted(show: true)
        }
        else
        {
            getAccepted(show: false)
        }
        self.dropAllPins()
    }
    @IBAction func btnRunningJob(_ sender: Any)
    {
        self.contentMsg.isHidden = true
        currentContentOffScrMain = UIScreen.main.bounds.size.width*3
        btnMatchingProfile.isSelected = false
        btnAppliedJob.isSelected = false
        btnAcceptedJob.isSelected = false
        btnRunningJob.isSelected = true
        //setDividerFrame(xx: btnRunningJob.frame.origin.x)
        strNavTitle = "Running Job"
        self.navigationItem.title = strNavTitle
        scrMain.setContentOffset(CGPoint.init(x: UIScreen.main.bounds.size.width*3, y: 0), animated: true)
//        if arrOfRunning.count == 0
//        {
//            getRunning(show: true)
//        }
//        else
//        {
//            getRunning(show: false)
//        }
        getRunning(show: true)
        self.dropAllPins()
    }
    @IBAction func btnMap(_ sender: Any)
    {
        if btnMap.isSelected == true
        {
            btnMap.isSelected = false
            scrMain.isHidden = false
            map.isHidden = true
        }
        else
        {
            btnMap.isSelected = true
            scrMain.isHidden = true
            map.isHidden = false
        }
        dropAllPins()
    }
    @IBAction func btnFilter(_ sender: Any)
    {
        let obj: filterPoster = self.storyboard?.instantiateViewController(withIdentifier: "filterPoster") as! filterPoster
        obj.objPoster = self
        obj.fromWhere = "allJobPoster"
        self.present(obj, animated: true, completion: nil)
    }
    @IBAction func sgmtMatching(_ sender: Any)
    {
        self.contentMsg.isHidden = true
        if(sgmtMatching.selectedSegmentIndex == 0)
        {
            isMatching = true
            getMatchingProfile()
        }
        else
        {
            isMatching = false
            getInvitedProfile()
        }
    }
    @IBAction func btnAbort(_ sender: Any)
    {
        selectedIndex = (sender as AnyObject).tag
        let uiAlert = UIAlertController(title: ABORT_JOB_MESSAGE, message: poster_abort, preferredStyle: UIAlertControllerStyle.alert)
        uiAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let obj: abortJobClass = self.storyboard?.instantiateViewController(withIdentifier: "abortJobClass") as! abortJobClass
            obj.objRunning = self
            obj.fromWhere = "runningPoster"
            obj.dictFromRunning = NSMutableDictionary.init(dictionary: self.arrOfRunning.object(at: self.selectedIndex) as! NSDictionary)
            self.present(obj, animated: true, completion: nil)
        }))
        
        uiAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
        }))
        self.present(uiAlert, animated: true, completion: nil)
    }
    @IBAction func btnChat(_ sender: Any)
    {
        let dd: NSDictionary = arrOfAccepted.object(at: (sender as AnyObject).tag) as! NSDictionary
        let obj: chatDetail = self.storyboard?.instantiateViewController(withIdentifier: "chatDetail") as! chatDetail
        obj.dictFrom = NSMutableDictionary.init(dictionary: dd)
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnExtend(_ sender: Any)
    {
        selectedIndex = (sender as AnyObject).tag
        let obj: extendTimeClass = self.storyboard?.instantiateViewController(withIdentifier: "extendTimeClass") as! extendTimeClass
        obj.objRunning = self
        obj.dictFromRunning = NSMutableDictionary.init(dictionary: arrOfRunning.object(at: selectedIndex) as! NSDictionary)
        self.present(obj, animated: true, completion: nil)
    }
    
    func setDividerFrame(xx:CGFloat)
    {
        var animDuration: CGFloat = 0.0
        animDuration = 0.2;
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(TimeInterval(animDuration))
        
        self.lblDivider.frame=CGRect.init(x: xx , y: self.lblDivider.frame.origin.y, width: self.lblDivider.frame.size.width, height: self.lblDivider.frame.size.height)
        UIView.commitAnimations()
    }
    
    //MARK:- ScrllView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrMain == scrollView
        {
            let contentOffsetX: CGFloat = scrollView.contentOffset.x
            if contentOffsetX >= 0 && contentOffsetX <= UIScreen.main.bounds.size.width*3
            {
                setDividerFrame(xx: contentOffsetX/4)
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView == scrMain
        {
            print(scrMain.contentOffset)
            if scrollView.contentOffset.x == 0
            {
                if currentContentOffScrMain != scrollView.contentOffset.x
                {
                    btnMatchingProfile(self)
                }
            }
            else if scrollView.contentOffset.x == UIScreen.main.bounds.size.width
            {
                if currentContentOffScrMain != scrollView.contentOffset.x
                {
                    btnAppliedJob(self)
                }
            }
            else if scrollView.contentOffset.x == UIScreen.main.bounds.size.width*2
            {
                if currentContentOffScrMain != scrollView.contentOffset.x
                {
                    btnAcceptedJob(self)
                }
            }
            else if scrollView.contentOffset.x == UIScreen.main.bounds.size.width*3
            {
                if currentContentOffScrMain != scrollView.contentOffset.x
                {
                    btnRunningJob(self)
                }
            }
        }
    }
    
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblMtching
        {
            if isMatching == true
            {
                return arrOfMatchingProfile.count
            }
            else
            {
                return arrOfInvitedProfile.count
            }
        }
        else if tableView == tblApplied
        {
            return arrOfAppliedProfile.count
        }
        else if tableView == tblAccepted
        {
            return arrOfAccepted.count
        }
        else if tableView == tblRunning
        {
            return arrOfRunning.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblMtching
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "matchingCellPoster", for: indexPath as IndexPath) as! matchingCellPoster
            let dd: NSDictionary!
            if isMatching == true
            {
                dd = arrOfMatchingProfile.object(at: indexPath.row) as! NSDictionary
            }
            else
            {
                dd = arrOfInvitedProfile.object(at: indexPath.row) as! NSDictionary
            }
            cell.lblJobTitle.text = dd.object(forKey: "JobPostTitle") as? String
            cell.lblSeekerName.text = dd.object(forKey: "Name") as? String
            cell.viewSeekerRating.value = dd.object(forKey: "Rating") as! CGFloat
            cell.lblJobCompleted.text = String(format: "Job Completed %d", dd.object(forKey: "TotalCompletedJobs") as! Int)
            
            let strFromLat: String = dd.object(forKey: "Latitude") as! String
            let strFromLong: String = dd.object(forKey: "Longitude") as! String
            
            let strLatitude: String = dd.object(forKey: "Latitude1") as! String
            let strLongitude: String = dd.object(forKey: "Longitude1") as! String
            let strDistance: String = API.getDistance(strToLate: strLatitude, strToLong: strLongitude, strFromLat: strFromLat, strFromLong: strFromLong)
            
            cell.btnSeekerKm.setTitle(String(format:"%@",strDistance), for: UIControlState.normal)
            
            cell.btnSeekerKm.titleLabel?.adjustsFontSizeToFitWidth = true
            
            
            cell.btnSeekerExp.setTitle(String(format:"%0.2f Yr",dd.object(forKey: "TotalExperienced") as! CGFloat), for: UIControlState.normal)
            cell.btnTotalAmount.setTitle(String(format:"%@",dd.object(forKey: "HourlyRate") as! String), for: UIControlState.normal)
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
            cell.imgSeekerPhoto.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
            cell.imgSeekerPhoto.tag = indexPath.row
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGestureRecognizer:)))
            cell.imgSeekerPhoto.isUserInteractionEnabled = true
            cell.imgSeekerPhoto.addGestureRecognizer(tapGestureRecognizer)
            cell.lblJobPostID.isHidden = false
            cell.lblJobPostID.text = String(format: "Job ID: %d", dd.object(forKey: "JobPostID") as! Int)
            return cell
        }
        else if tableView == tblApplied
        {
            let dd: NSDictionary = arrOfAppliedProfile.object(at: indexPath.row) as! NSDictionary
            let cell = tableView.dequeueReusableCell(withIdentifier: "matchingCellPoster", for: indexPath as IndexPath) as! matchingCellPoster
            
            cell.lblJobTitle.text = dd.object(forKey: "JobPostTitle") as? String
            cell.lblSeekerName.text = dd.object(forKey: "Name") as? String
            cell.viewSeekerRating.value = dd.object(forKey: "Rating") as! CGFloat
            cell.lblJobCompleted.text = String(format: "Job Completed %d", dd.object(forKey: "TotalCompletedJobs") as! Int)
            
            let strFromLat: String = dd.object(forKey: "Latitude") as! String
            let strFromLong: String = dd.object(forKey: "Longitude") as! String
            
            let strLatitude: String = dd.object(forKey: "Latitude1") as! String
            let strLongitude: String = dd.object(forKey: "Longitude1") as! String
            let strDistance: String = API.getDistance(strToLate: strLatitude, strToLong: strLongitude, strFromLat: strFromLat, strFromLong: strFromLong)
            
            cell.btnSeekerKm.setTitle(String(format:"%@",strDistance), for: UIControlState.normal)
            cell.btnSeekerKm.titleLabel?.adjustsFontSizeToFitWidth = true
            //cell.btnSeekerKm.setTitle(String(format:"%@",dd.object(forKey: "Distance") as! String), for: UIControlState.normal)
            cell.btnSeekerExp.setTitle(String(format:"%0.2f Yr",dd.object(forKey: "TotalExperienced") as! CGFloat), for: UIControlState.normal)
            cell.btnTotalAmount.setTitle(String(format:"%@",dd.object(forKey: "HourlyRate") as! String), for: UIControlState.normal)
            
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
            cell.imgSeekerPhoto.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
            cell.imgSeekerPhoto.tag = indexPath.row
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGestureRecognizer:)))
            cell.imgSeekerPhoto.isUserInteractionEnabled = true
            cell.imgSeekerPhoto.addGestureRecognizer(tapGestureRecognizer)
            cell.lblJobPostID.isHidden = false
            cell.lblJobPostID.text = String(format: "Job ID: %d", dd.object(forKey: "JobPostID") as! Int)
            return cell
        }
        else if tableView == tblAccepted
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "acceptedCellPoster", for: indexPath as IndexPath) as! acceptedCellPoster
            let dd: NSDictionary = arrOfAccepted.object(at: indexPath.row) as! NSDictionary
            
            cell.lblSeekerName.text = dd.object(forKey: "Name") as? String
            cell.viewSeekerRating.value = dd.object(forKey: "Rating") as! CGFloat
            cell.lblJobCompleted.text = String(format: "Job Completed %d", dd.object(forKey: "TotalCompletedJobs") as! Int)
            
            
            let strFromLat: String = dd.object(forKey: "Latitude") as! String
            let strFromLong: String = dd.object(forKey: "Longitude") as! String
            
            let strLatitude: String = dd.object(forKey: "Latitude1") as! String
            let strLongitude: String = dd.object(forKey: "Longitude1") as! String
            let strDistance: String = API.getDistance(strToLate: strLatitude, strToLong: strLongitude, strFromLat: strFromLat, strFromLong: strFromLong)
            
            cell.btnSeekerKm.setTitle(String(format:"%@",strDistance), for: UIControlState.normal)
            cell.btnSeekerKm.titleLabel?.adjustsFontSizeToFitWidth = true
            //cell.btnSeekerKm.setTitle(String(format:"%@",dd.object(forKey: "Distance") as! String), for: UIControlState.normal)
            
            cell.btnSeekerTotalPayment.setTitle(String(format:"%@",dd.object(forKey: "HourlyRate") as! String), for: UIControlState.normal)
            
            if dd.object(forKey: "TotalJobs") as! Int == 1 || dd.object(forKey: "TotalJobs") as! Int == 0
            {
                cell.btnSeekerTotalJobs.setTitle(String(format:"%d Job",dd.object(forKey: "TotalJobs") as! Int), for: UIControlState.normal)
            }
            else
            {
                cell.btnSeekerTotalJobs.setTitle(String(format:"%d Jobs",dd.object(forKey: "TotalJobs") as! Int), for: UIControlState.normal)
            }
            
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
            cell.btnChat.tag = indexPath.row
            cell.btnChat.addTarget(self, action: #selector(self.btnChat(_:)), for: UIControlEvents.touchUpInside)
            cell.imgSeekerPhoto.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
            cell.imgSeekerPhoto.tag = indexPath.row
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGestureRecognizer:)))
            cell.imgSeekerPhoto.isUserInteractionEnabled = true
            cell.imgSeekerPhoto.addGestureRecognizer(tapGestureRecognizer)
            //cell.btnChat.isHidden = true
            return cell
        }
        else if tableView == tblRunning
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "runningJobCellPoster", for: indexPath as IndexPath) as! runningJobCellPoster
            let dd: NSDictionary = arrOfRunning.object(at: indexPath.row) as! NSDictionary
            cell.lblSeekerName.text = dd.object(forKey: "Name") as? String
            cell.lblJobTitle.text = dd.object(forKey: "JobPostTitle") as? String
            cell.btnSeekerLocation.setTitle(dd.object(forKey: "Location") as? String, for: UIControlState.normal)
            cell.btnSeekerLocation.titleLabel?.adjustsFontSizeToFitWidth = true
            cell.lblRunningRemainingTime.text = dd.object(forKey: "JobTimePeriod") as? String
            cell.lblRunningTotalPayment.text = dd.object(forKey: "HourlyRate") as? String
            cell.lblRunningTime.text = String(format: "%@ - %@", dd.object(forKey: "FromTime") as! String,dd.object(forKey: "ToTime") as! String)
            
            
            cell.imgSeekerPhoto.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
            cell.imgSeekerPhoto.tag = indexPath.row
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGestureRecognizer:)))
            cell.imgSeekerPhoto.isUserInteractionEnabled = true
            cell.imgSeekerPhoto.addGestureRecognizer(tapGestureRecognizer)
            
            cell.lblSeekerStatus.isHidden = false
            if dd.object(forKey: "IsAvailable") as! Bool == true
            {
                cell.lblSeekerStatus.backgroundColor = API.onlineColor()
            }
            else
            {
                cell.lblSeekerStatus.backgroundColor = API.offline()
            }
            if dd.object(forKey: "IsBreak") as! Bool == false
            {
                cell.lblRunningBreak.text = "No Break"
                cell.lblRunningBreakPaid.isHidden = true
            }
            else
            {
                cell.lblRunningBreak.text = "Break"
                cell.lblRunningBreakPaid.isHidden = false
                
                if dd.object(forKey: "IsBreakPaid") as! Bool == true
                {
                    cell.lblRunningBreakPaid.text = String(format: "(%d min - Paid)", dd.object(forKey: "BreakMin") as! Int)
                }
                else
                {
                    cell.lblRunningBreakPaid.text = String(format: "(%d min - Unpaid)", dd.object(forKey: "BreakMin") as! Int)
                }
            }
            if dd.object(forKey: "IsRepete") as! Bool == false
            {
                cell.lblRunningDate.text = String(format: "%@", dd.object(forKey: "FromDate") as! String)
                cell.viewDays.isHidden = true
                cell.lblRunningRepeatStatus.isHidden = false
            }
            else
            {
                cell.viewDays.isHidden = false
                cell.lblRunningRepeatStatus.isHidden = true
                //cell.lblRunningDate.text = String(format: "%@ to %@", dd.object(forKey: "FromDate") as! String,dd.object(forKey: "ToDate") as! String)
                cell.lblRunningDate.text = String(format: "%@", dd.object(forKey: "FromDate") as! String)
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
            
            cell.imgTimerIcon.tintColor = API.themeColorPink()
            cell.btnAbort.tag = indexPath.row
            cell.btnExtend.tag = indexPath.row
            cell.btnAbort.addTarget(self, action: #selector(self.btnAbort(_:)), for: UIControlEvents.touchUpInside)
            cell.btnExtend.addTarget(self, action: #selector(self.btnExtend(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchingCellPoster", for: indexPath as IndexPath) as! matchingCellPoster
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedIndex = indexPath.row
        if tableView == tblMtching
        {
            let obj: matchingDetailPoster = self.storyboard?.instantiateViewController(withIdentifier: "matchingDetailPoster") as! matchingDetailPoster
            if isMatching == true
            {
                obj.strFrom = "Matching"
                let dd: NSDictionary = arrOfMatchingProfile.object(at: indexPath.row) as! NSDictionary
                obj.dictPost = NSMutableDictionary.init(dictionary: dd)
            }
            else
            {
                obj.strFrom = "Invited"
                let dd: NSDictionary = arrOfInvitedProfile.object(at: indexPath.row) as! NSDictionary
                obj.dictPost = NSMutableDictionary.init(dictionary: dd)
            }
            obj.objMatching = self
            self.navigationController!.pushViewController(obj, animated: true)
        }
        else if tableView == tblApplied
        {
            let obj: appliedDetailPoster = self.storyboard?.instantiateViewController(withIdentifier: "appliedDetailPoster") as! appliedDetailPoster
            let dd: NSDictionary = arrOfAppliedProfile.object(at: indexPath.row) as! NSDictionary
            obj.dictPost = NSMutableDictionary.init(dictionary: dd)
            obj.objMatching = self
            obj.IsApplied = true
            self.navigationController!.pushViewController(obj, animated: true)
        }
        else if tableView == tblAccepted
        {
            let obj: acceptedDetailSeeker = self.storyboard?.instantiateViewController(withIdentifier: "acceptedDetailSeeker") as! acceptedDetailSeeker
            let dd: NSDictionary = arrOfAccepted.object(at: indexPath.row) as! NSDictionary
            obj.dictFrom = NSMutableDictionary.init(dictionary: dd)
            self.navigationController!.pushViewController(obj, animated: true)
        }
        else if tableView == tblRunning
        {
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblMtching
        {
            return 119
        }
        else if tableView == tblApplied
        {
            return 119
        }
        else if tableView == tblAccepted
        {
            return 109
        }
        else if tableView == tblRunning
        {
            let dd: NSDictionary = arrOfRunning.object(at: indexPath.row) as! NSDictionary
            if dd.object(forKey: "IsBreak") as! Bool == false
            {
                return 157
            }
            else
            {
                return 170
            }
        }
        return 140
    }
    //MARK:- MapView
    func dropAllPins()
    {
        self.map.removeAnnotations(self.map.annotations)
        var arrMap: NSMutableArray = NSMutableArray()
        if strNavTitle == "Matching Profile"
        {
            if isMatching == true
            {
                arrMap = NSMutableArray.init(array: arrOfMatchingProfile)
            }
            else
            {
                arrMap = NSMutableArray.init(array: arrOfInvitedProfile)
            }
        }
        else if strNavTitle == "Applied Job"
        {
            arrMap = NSMutableArray.init(array: arrOfAppliedProfile)
        }
        else if strNavTitle == "Accepted Job"
        {
            arrMap = NSMutableArray.init(array: arrOfAccepted)
        }
        else if strNavTitle == "Running Job"
        {
            arrMap = NSMutableArray.init(array: arrOfRunning)
        }
        var i: Int = 0
        for item in arrMap
        {
            let dd: NSDictionary = item as! NSDictionary
            let lati: String = dd.object(forKey: "Latitude1") as! String
            let longi: String = dd.object(forKey: "Longitude1") as! String
            
            var lt: Double = Double(lati)!
            var lg: Double = Double(longi)!
            lt = lt + 0.00068
            lg = lg + 0.00068
            
//            let strFromLat: String = dd.object(forKey: "Latitude") as! String
//            let strFromLong: String = dd.object(forKey: "Longitude") as! String
//            
//            let strLatitude: String = String(format: "%f", lt)
//            let strLongitude: String = String(format: "%f", lg)
//            let strDistance: String = API.getDistance(strToLate: strLatitude, strToLong: strLongitude, strFromLat: strFromLat, strFromLong: strFromLong)
//            print(strDistance)
            
            
            
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lt, lg)
            
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = location
            dropPin.title = dd.object(forKey: "JobPostTitle") as? String
            dropPin.subtitle = dd.object(forKey: "Name") as? String
            dropPin.accessibilityValue = String(format: "%d", i)
            
            self.map.addAnnotation(dropPin)
            i = i + 1
        }
        zoomPin()
    }
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKPointAnnotation
        {
            let pin: MKPointAnnotation = annotation as! MKPointAnnotation
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.pinColor = .red
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.rightCalloutAccessoryView = UIButton.init(type: UIButtonType.detailDisclosure)
            pinAnnotationView.isEnabled = true
            pinAnnotationView.animatesDrop = true
            pinAnnotationView.accessibilityValue = pin.accessibilityValue
            return pinAnnotationView
        }
        return nil
    }
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        print(view.accessibilityValue ?? 5)
        selectedIndex = Int(view.accessibilityValue!)!
        if strNavTitle == "Matching Profile"
        {
            let obj: matchingDetailPoster = self.storyboard?.instantiateViewController(withIdentifier: "matchingDetailPoster") as! matchingDetailPoster
            if isMatching == true
            {
                obj.strFrom = "Matching"
                let dd: NSDictionary = arrOfMatchingProfile.object(at: selectedIndex) as! NSDictionary
                obj.dictPost = NSMutableDictionary.init(dictionary: dd)
            }
            else
            {
                obj.strFrom = "Invited"
                let dd: NSDictionary = arrOfInvitedProfile.object(at: selectedIndex) as! NSDictionary
                obj.dictPost = NSMutableDictionary.init(dictionary: dd)
            }
            obj.objMatching = self
            self.navigationController!.pushViewController(obj, animated: true)
        }
        else if strNavTitle == "Applied Job"
        {
            let obj: appliedDetailPoster = self.storyboard?.instantiateViewController(withIdentifier: "appliedDetailPoster") as! appliedDetailPoster
            let dd: NSDictionary = arrOfAppliedProfile.object(at: selectedIndex) as! NSDictionary
            obj.dictPost = NSMutableDictionary.init(dictionary: dd)
            obj.objMatching = self
            obj.IsApplied = true
            self.navigationController!.pushViewController(obj, animated: true)
        }
        else if strNavTitle == "Accepted Job"
        {
            let obj: acceptedDetailSeeker = self.storyboard?.instantiateViewController(withIdentifier: "acceptedDetailSeeker") as! acceptedDetailSeeker
            let dd: NSDictionary = arrOfAccepted.object(at: selectedIndex) as! NSDictionary
            obj.dictFrom = NSMutableDictionary.init(dictionary: dd)
            self.navigationController!.pushViewController(obj, animated: true)
        }
        else if strNavTitle == "Running Job"
        {
            btnMap.isSelected = false
            scrMain.isHidden = false
            map.isHidden = true
        }
    }
    func zoomPin()
    {
        self.map.showAnnotations(map.annotations, animated: true)
    }
    //MARK:- GO TO SEEKER PROFILE
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tag: Int = (tapGestureRecognizer.view?.tag)!
        var dd: NSDictionary = NSDictionary()
        if strNavTitle == "Matching Profile"
        {
            if isMatching == true
            {
                dd = arrOfMatchingProfile.object(at: tag) as! NSDictionary
            }
            else
            {
                dd = arrOfInvitedProfile.object(at: tag) as! NSDictionary
            }
        }
        else if strNavTitle == "Applied Job"
        {
            dd = arrOfAppliedProfile.object(at: tag) as! NSDictionary
        }
        else if strNavTitle == "Accepted Job"
        {
            dd = arrOfAccepted.object(at: tag) as! NSDictionary
        }
        else if strNavTitle == "Running Job"
        {
            dd = arrOfRunning.object(at: tag) as! NSDictionary
        }
        
        let obj: seekerProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "seekerProfileClass") as! seekerProfileClass
        obj.userId = dd.object(forKey: "UserID") as! String
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    //MARK:- Call API
    func getMatchingProfile()
    {
        arrOfMatchingProfile = NSMutableArray()
        tblMtching.reloadData()
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(false, forKey: "IsGetOnlyTotalCounts")
        
        
        parameter.setValue(deleObj.dictFilter.object(forKey: "CategoryID"), forKey: "CategoryID")
        parameter.setValue(deleObj.dictFilter.object(forKey: "TitleID"), forKey: "TitleID")
        parameter.setValue(deleObj.dictFilter.object(forKey: "RatingFrom"), forKey: "RatingFrom")
        parameter.setValue(deleObj.dictFilter.object(forKey: "RatingTo"), forKey: "RatingTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "ExpFrom"), forKey: "ExpFrom")
        parameter.setValue(deleObj.dictFilter.object(forKey: "ExpTo"), forKey: "ExpTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "IsVehicle"), forKey: "IsVehicle")
        parameter.setValue(deleObj.dictFilter.object(forKey: "DistanceTo"), forKey: "DistanceTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "DistanceFrom"), forKey: "DistanceFrom")
        
        
        print(parameter)
        API.callApiPOST(strUrl: API_GetPosterMatchingJobs,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                if arr.count != 0
                {
                    let dd: NSDictionary = arr.object(at: 0) as! NSDictionary
                    self.dictViewShared = NSMutableDictionary.init(dictionary: dd)
                    self.arrOfMatchingProfile = NSMutableArray.init(array: arr)
                    self.arrOfMatchingProfile.removeObject(at: 0)
                    
//                    if self.deleObj.dictFilter.object(forKey: "DistanceFrom") as! String == "-1" || self.deleObj.dictFilter.object(forKey: "DistanceTo") as! String == "-1"
//                    {
//                        
//                    }
//                    else
//                    {
//                        self.arrOfMatchingProfile = self.filterByDistance(arr: self.arrOfMatchingProfile)
//                    }
                    self.lblTotalShared.text = String(format: "%d", self.dictViewShared.object(forKey: "TotalSent") as! Int)
                    self.lblTotalView.text = String(format: "%d", self.dictViewShared.object(forKey: "TotalView") as! Int)
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
                self.contentMsg.isHidden = false
            }
            self.lblMatchingCnt.text = String(format: "%d", self.arrOfMatchingProfile.count)
            self.tblMtching.reloadData()
            self.dropAllPins()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.contentMsg.isHidden = false
        })
    }
    func getInvitedProfile()
    {
        arrOfInvitedProfile = NSMutableArray()
        tblMtching.reloadData()
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(false, forKey: "IsGetOnlyTotalCounts")
        
        
        parameter.setValue(deleObj.dictFilter.object(forKey: "CategoryID"), forKey: "CategoryID")
        parameter.setValue(deleObj.dictFilter.object(forKey: "TitleID"), forKey: "TitleID")
        parameter.setValue(deleObj.dictFilter.object(forKey: "RatingFrom"), forKey: "RatingFrom")
        parameter.setValue(deleObj.dictFilter.object(forKey: "RatingTo"), forKey: "RatingTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "ExpFrom"), forKey: "ExpFrom")
        parameter.setValue(deleObj.dictFilter.object(forKey: "ExpTo"), forKey: "ExpTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "IsVehicle"), forKey: "IsVehicle")
        parameter.setValue(deleObj.dictFilter.object(forKey: "DistanceTo"), forKey: "DistanceTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "DistanceFrom"), forKey: "DistanceFrom")
        
        print(parameter)
        API.callApiPOST(strUrl: API_GetPosterInvitedJobs,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                self.arrOfInvitedProfile = NSMutableArray.init(array: arr)
                self.contentMsg.isHidden = true
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                if self.isMatching == false
                {
                    self.contentMsg.isHidden = false
                }
            }
            self.tblMtching.reloadData()
            self.lblInvitedCnt.text = String(format: "%d", self.arrOfInvitedProfile.count)
            self.dropAllPins()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.contentMsg.isHidden = false
        })
    }
    func getApplied()
    {
        arrOfAppliedProfile = NSMutableArray()
        tblApplied.reloadData()
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(false, forKey: "IsGetOnlyTotalCounts")
        
        
        parameter.setValue(deleObj.dictFilter.object(forKey: "CategoryID"), forKey: "CategoryID")
        parameter.setValue(deleObj.dictFilter.object(forKey: "TitleID"), forKey: "TitleID")
        parameter.setValue(deleObj.dictFilter.object(forKey: "RatingFrom"), forKey: "RatingFrom")
        parameter.setValue(deleObj.dictFilter.object(forKey: "RatingTo"), forKey: "RatingTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "ExpFrom"), forKey: "ExpFrom")
        parameter.setValue(deleObj.dictFilter.object(forKey: "ExpTo"), forKey: "ExpTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "IsVehicle"), forKey: "IsVehicle")
        parameter.setValue(deleObj.dictFilter.object(forKey: "DistanceTo"), forKey: "DistanceTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "DistanceFrom"), forKey: "DistanceFrom")
        
        print(parameter)
        API.callApiPOST(strUrl: API_GetPosterAppliedJobs,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                self.arrOfAppliedProfile = NSMutableArray.init(array: arr)
                self.contentMsg.isHidden = true
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.contentMsg.isHidden = false
            }
            self.tblApplied.reloadData()
            self.dropAllPins()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.contentMsg.isHidden = false
        })
    }
    func getAccepted(show:Bool)
    {
        arrOfAccepted = NSMutableArray()
        tblAccepted.reloadData()
        if show == true
        {
            custObj.showSVHud("Loading")
        }
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(false, forKey: "IsGetOnlyTotalCounts")
        
        
        parameter.setValue(deleObj.dictFilter.object(forKey: "CategoryID"), forKey: "CategoryID")
        parameter.setValue(deleObj.dictFilter.object(forKey: "TitleID"), forKey: "TitleID")
        parameter.setValue(deleObj.dictFilter.object(forKey: "RatingFrom"), forKey: "RatingFrom")
        parameter.setValue(deleObj.dictFilter.object(forKey: "RatingTo"), forKey: "RatingTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "ExpFrom"), forKey: "ExpFrom")
        parameter.setValue(deleObj.dictFilter.object(forKey: "ExpTo"), forKey: "ExpTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "IsVehicle"), forKey: "IsVehicle")
        parameter.setValue(deleObj.dictFilter.object(forKey: "DistanceTo"), forKey: "DistanceTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "DistanceFrom"), forKey: "DistanceFrom")
        
        print(parameter)
        API.callApiPOST(strUrl: API_GetPosterAcceptedJobs,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                self.arrOfAccepted = NSMutableArray.init(array: arr)
                self.contentMsg.isHidden = true
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.contentMsg.isHidden = false
            }
            self.tblAccepted.reloadData()
            self.dropAllPins()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.contentMsg.isHidden = false
        })
    }
    func getRunning(show:Bool)
    {
        arrOfRunning = NSMutableArray()
        tblRunning.reloadData()
        if show == true
        {
            custObj.showSVHud("Loading")
        }
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(false, forKey: "IsGetOnlyTotalCounts")
        
        parameter.setValue(deleObj.dictFilter.object(forKey: "CategoryID"), forKey: "CategoryID")
        parameter.setValue(deleObj.dictFilter.object(forKey: "TitleID"), forKey: "TitleID")
        parameter.setValue(deleObj.dictFilter.object(forKey: "RatingFrom"), forKey: "RatingFrom")
        parameter.setValue(deleObj.dictFilter.object(forKey: "RatingTo"), forKey: "RatingTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "ExpFrom"), forKey: "ExpFrom")
        parameter.setValue(deleObj.dictFilter.object(forKey: "ExpTo"), forKey: "ExpTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "IsVehicle"), forKey: "IsVehicle")
        parameter.setValue(deleObj.dictFilter.object(forKey: "DistanceTo"), forKey: "DistanceTo")
        parameter.setValue(deleObj.dictFilter.object(forKey: "DistanceFrom"), forKey: "DistanceFrom")
        
        print(parameter)
        API.callApiPOST(strUrl: API_GetPosterRunningJobs,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                self.arrOfRunning = NSMutableArray.init(array: arr)
                self.contentMsg.isHidden = true
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                if self.strNavTitle == "Running Job"
                {
                    self.contentMsg.isHidden = false
                }
            }
            self.tblRunning.reloadData()
            self.dropAllPins()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            if self.strNavTitle == "Running Job"
            {
                self.contentMsg.isHidden = false
            }
        })
    }
    func filterByDistance(arr: NSMutableArray) -> NSMutableArray
    {
        let arrTemp: NSMutableArray = NSMutableArray()
        for item in arr
        {
            let dd: NSDictionary = item as! NSDictionary
            let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
            let strFromLat: String = dd.object(forKey: "Latitude") as! String
            let strFromLong: String = dd.object(forKey: "Longitude") as! String
            
            let strLatitude: String = dd.object(forKey: "Latitude1") as! String
            let strLongitude: String = dd.object(forKey: "Longitude1") as! String
            let strDistance: String = API.getDistance(strToLate: strLatitude, strToLong: strLongitude, strFromLat: strFromLat, strFromLong: strFromLong)
            var disMain: CGFloat = 0
            var disFrom: CGFloat = 0
            var disTo: CGFloat = 0
            if let n = NumberFormatter().number(from: strDistance) {
                disMain = CGFloat(n)
            }
            let strDFrom: String = self.deleObj.dictFilter.object(forKey: "DistanceFrom") as! String
            let strDTo: String = self.deleObj.dictFilter.object(forKey: "DistanceTo") as! String
            
            if let n = NumberFormatter().number(from: strDFrom) {
                disFrom = CGFloat(n)
            }
            
            if let n = NumberFormatter().number(from: strDTo) {
                disTo = CGFloat(n)
            }
            
            if disMain >= disFrom && disMain <= disTo
            {
                arrTemp.add(dictMutable)
            }
        }
        return arrTemp
    }
}
