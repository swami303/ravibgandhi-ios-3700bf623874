//
//  savedJobClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/27/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class savedJobClass: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    //MARK:- Outlet
    @IBOutlet weak var tblSavedProfile: UITableView!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    var contentMsg: ContentMessageView!
    var arrOfSavedJob: NSMutableArray = NSMutableArray()
    
    var timerForMatching: Timer!
    var removedTag: Int = 0
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        contentMsg = ContentMessageView.CreateView(self.view, strMessage: "No records found", strImageName: "WB_Font", color: UIColor.lightGray)
        contentMsg.isHidden = true
        view.backgroundColor = API.appBackgroundColor()
        self.tblSavedProfile.dataSource = self
        self.tblSavedProfile.delegate = self
        tblSavedProfile.register(UINib(nibName: "savedJobsCell", bundle: nil), forCellReuseIdentifier: "savedJobsCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        timerForMatching = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(matchingTimer), userInfo: nil, repeats: true)
        getSavedJob()
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        timerForMatching.invalidate()
        timerForMatching = nil
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    func matchingTimer()
    {
        getSavedJob()
    }
    //MARK:- Action Zone
    @IBAction func btnMap(_ sender: Any)
    {
    }
    @IBAction func btnFilter(_ sender: Any)
    {
    }
    //MARK:- PRIVATE METHOD
    @IBAction func btnRemoveSavedProfile(_ sender: Any)
    {
        removedTag = (sender as AnyObject).tag
        let dd: NSDictionary = arrOfSavedJob.object(at: removedTag) as! NSDictionary
        removeProfile(dd: dd)
    }
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfSavedJob.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedJobsCell", for: indexPath as IndexPath) as! savedJobsCell
        
        let dd: NSDictionary = arrOfSavedJob.object(at: indexPath.row) as! NSDictionary
        cell.lblJobTitle.text = dd.object(forKey: "JobPostTitle")as? String
        cell.lblCompanyName.text = dd.object(forKey: "CompanyName")as? String
        cell.lblHiredTillDate.text = String(format: "Hired till date %d", dd.object(forKey: "TotalHiredJobs") as! Int)
        cell.viewCompanyRating.value = dd.object(forKey: "Rating") as! CGFloat
        cell.lblTotalApplied.text = String(format: "%d applied", dd.object(forKey: "TotalAppliedJobs") as! Int)
        
        
        if (dd.object(forKey: "Time") as! String) == "0"
        {
            cell.btnTotalTimeToApplied.setTitle("🏃", for: UIControlState.normal)
        }
        else
        {
            cell.btnTotalTimeToApplied.setTitle(String(format:"%@",dd.object(forKey: "Time") as! String), for: UIControlState.normal)
        }
        
        cell.btnTotalPayment.setTitle(String(format:"%@",dd.object(forKey: "HourlyRate") as! String), for: UIControlState.normal)
        
        
        let dictUserr: NSDictionary = API.getLoggedUserData()
        let strFromLat: String = dictUserr.object(forKey: "Latitude") as! String
        let strFromLong: String = dictUserr.object(forKey: "Longitude") as! String
        
        let strLatitude: String = dd.object(forKey: "Latitude") as! String
        let strLongitude: String = dd.object(forKey: "Longitude") as! String
        
        let strDistance: String = API.getDistance(strToLate: strLatitude, strToLong: strLongitude, strFromLat: strFromLat, strFromLong: strFromLong)
        cell.btnTotalKm.setTitle(String(format:"%@",strDistance), for: UIControlState.normal)
        
        
        cell.btnTotalKm.titleLabel?.adjustsFontSizeToFitWidth = true
        
        //cell.btnTotalKm.setTitle(String(format:"%@",dd.object(forKey: "Distance") as! String), for: UIControlState.normal)
        cell.btnTotalTimeToApplied.setTitle(String(format:"%@",dd.object(forKey: "Time") as! String), for: UIControlState.normal)
        if dd.object(forKey: "TotalJobs") as! Int == 1 || dd.object(forKey: "TotalJobs") as! Int == 0
        {
            cell.btnTotalJobs.setTitle(String(format:"%d Job",dd.object(forKey: "TotalJobs") as! Int), for: UIControlState.normal)
        }
        else
        {
            cell.btnTotalJobs.setTitle(String(format:"%d Jobs",dd.object(forKey: "TotalJobs") as! Int), for: UIControlState.normal)
        }
        cell.btnDeleteSavedJob.tag = indexPath.row
        cell.btnDeleteSavedJob.addTarget(self, action: #selector(self.btnRemoveSavedProfile(_:)), for: UIControlEvents.touchUpInside)
        cell.imgCompanyPhoto.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
        cell.imgCompanyPhoto.tag = indexPath.row
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGestureRecognizer:)))
        cell.imgCompanyPhoto.isUserInteractionEnabled = true
        cell.imgCompanyPhoto.addGestureRecognizer(tapGestureRecognizer)
        
        cell.btnTotalTimeToApplied.tintColor = API.themeColorPink()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        removedTag = indexPath.row
        let obj: appliedDetailSeeker = self.storyboard?.instantiateViewController(withIdentifier: "appliedDetailSeeker") as! appliedDetailSeeker
        
        let dd: NSDictionary = arrOfSavedJob.object(at: indexPath.row) as! NSDictionary
        if dd.object(forKey: "IsApplied") as! Bool == true
        {
            obj.strFrom = "Applied Job"
        }
        else
        {
            obj.strFrom = "savedJob"
        }
        obj.dictPost = NSMutableDictionary.init(dictionary: dd)
        obj.objSaved = self
        self.navigationController!.pushViewController(obj, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 119
    }
    //MARK:- GO TO SEEKER PROFILE
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tag: Int = (tapGestureRecognizer.view?.tag)!
        var dd: NSDictionary = NSDictionary()
        dd = arrOfSavedJob.object(at: tag) as! NSDictionary
        
        let obj: posterProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "posterProfileClass") as! posterProfileClass
        obj.userId = dd.object(forKey: "UserID") as! String
        self.navigationController!.pushViewController(obj, animated: true)
    }
    //MARK:- Call API
    func getSavedJob()
    {
        arrOfSavedJob = NSMutableArray()
        tblSavedProfile.reloadData()
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(false, forKey: "IsGetOnlyTotalCounts")
        print(parameter)
        API.callApiPOST(strUrl: API_GetAllSaveJobProfiles,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                self.arrOfSavedJob = NSMutableArray.init(array: arr)
                self.contentMsg.isHidden = true
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.contentMsg.isHidden = false
            }
            self.tblSavedProfile.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.contentMsg.isHidden = false
        })
    }
    func removeProfile(dd: NSDictionary)
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(dd.object(forKey: "UserID"), forKey: "PosterID")
        parameter.setValue(dd.object(forKey: "JobPostID"), forKey: "PostID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(false, forKey: "Status")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        print(parameter)
        API.callApiPOST(strUrl: API_SavePosterJobProfile,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.arrOfSavedJob.removeObject(at: self.removedTag)
                self.tblSavedProfile.reloadData()
                if self.arrOfSavedJob.count == 0
                {
                    self.contentMsg.isHidden = false
                }
                else
                {
                    self.contentMsg.isHidden = true
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
}
