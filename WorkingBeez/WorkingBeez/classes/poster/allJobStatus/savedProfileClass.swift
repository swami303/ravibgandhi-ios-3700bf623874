//
//  savedProfileClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/25/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class savedProfileClass: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    //MARK:- Outlet
    @IBOutlet weak var tblSavedProfile: UITableView!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    
    var contentMsg: ContentMessageView!
    var removedTag: Int = 0
    var arrOfSavedProfile: NSMutableArray = NSMutableArray()
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
        tblSavedProfile.register(UINib(nibName: "saveProfileCell", bundle: nil), forCellReuseIdentifier: "saveProfileCell")
        getSavedProfile()
        self.navigationItem.rightBarButtonItem = nil
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
        let dd: NSDictionary = arrOfSavedProfile.object(at: removedTag) as! NSDictionary
        removeProfile(dd: dd)
    }
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfSavedProfile.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "saveProfileCell", for: indexPath as IndexPath) as! saveProfileCell
        
        let dd: NSDictionary = arrOfSavedProfile.object(at: indexPath.row) as! NSDictionary
        
        cell.btnRemoveSavedProfile.isHidden = false
        cell.btnInviteToSavedProfile.isHidden = true
        
        cell.lblJobTitle.text = dd.object(forKey: "JobPostTitle") as? String
        cell.lblSeekerName.text = dd.object(forKey: "Name") as? String
        cell.viewSeekerRating.value = dd.object(forKey: "Rating") as! CGFloat
        cell.lblJobCompleted.text = String(format: "Job Completed %d", dd.object(forKey: "TotalCompletedJobs") as! Int)
        
        let strFromLat: String = dd.object(forKey: "PosterLat") as! String
        let strFromLong: String = dd.object(forKey: "PosterLong") as! String
        
        let strLatitude: String = dd.object(forKey: "Latitude1") as! String
        let strLongitude: String = dd.object(forKey: "Longitude1") as! String
        let strDistance: String = API.getDistance(strToLate: strLatitude, strToLong: strLongitude, strFromLat: strFromLat, strFromLong: strFromLong)
        
        cell.btnSeekerKm.setTitle(String(format:"%@",strDistance), for: UIControlState.normal)
        
        cell.btnSeekerKm.titleLabel?.adjustsFontSizeToFitWidth = true
        
        //cell.btnSeekerKm.setTitle(String(format:"%@",dd.object(forKey: "Distance") as! String), for: UIControlState.normal)
        cell.btnSeekerExp.setTitle(String(format:"%0.2f Yr",dd.object(forKey: "TotalExperienced") as! CGFloat), for: UIControlState.normal)
        //cell.btnTotalAmount.setTitle(String(format:"%@",dd.object(forKey: "TotalCharge") as! String), for: UIControlState.normal)
        
        if dd.object(forKey: "IsVehicle") as! Bool == true
        {
            cell.btnSeekerHaveVehicle.isSelected = false
        }
        else
        {
            cell.btnSeekerHaveVehicle.isSelected = true
        }
        cell.btnRemoveSavedProfile.tag = indexPath.row
        cell.btnRemoveSavedProfile.addTarget(self, action: #selector(self.btnRemoveSavedProfile(_:)), for: UIControlEvents.touchUpInside)
        cell.imgSeekerPhoto.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
        cell.imgSeekerPhoto.tag = indexPath.row
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGestureRecognizer:)))
        cell.imgSeekerPhoto.isUserInteractionEnabled = true
        cell.imgSeekerPhoto.addGestureRecognizer(tapGestureRecognizer)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let tag: Int = indexPath.row
        let dd: NSDictionary = arrOfSavedProfile.object(at: tag) as! NSDictionary
        let obj: completedJobDetailPoster = self.storyboard?.instantiateViewController(withIdentifier: "completedJobDetailPoster") as! completedJobDetailPoster
        obj.dictPost = NSMutableDictionary.init(dictionary: dd)
        obj.fromWhere = "save"
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
        dd = arrOfSavedProfile.object(at: tag) as! NSDictionary
        
        let obj: seekerProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "seekerProfileClass") as! seekerProfileClass
        obj.userId = dd.object(forKey: "UserID") as! String
        self.navigationController!.pushViewController(obj, animated: true)
    }
    //MARK:- Call API
    func getSavedProfile()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(false, forKey: "IsGetOnlyTotalCounts")
        print(parameter)
        API.callApiPOST(strUrl: API_GetAllSaveProfiles,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                self.arrOfSavedProfile = NSMutableArray.init(array: arr)
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
        parameter.setValue(dd.object(forKey: "UserID"), forKey: "SeekerID")
        parameter.setValue(dd.object(forKey: "JobPostID"), forKey: "PostID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(false, forKey: "Status")
        print(parameter)
        API.callApiPOST(strUrl: API_SaveProfile,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.arrOfSavedProfile.removeObject(at: self.removedTag)
                self.tblSavedProfile.reloadData()
                if self.arrOfSavedProfile.count == 0
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
