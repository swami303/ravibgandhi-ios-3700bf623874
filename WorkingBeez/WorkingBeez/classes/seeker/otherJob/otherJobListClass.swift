//
//  otherJobListClass.swift
//  WorkingBeez
//
//  Created by Swami on 3/8/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class otherJobListClass: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var tblOtherJobList: UITableView!
    
    var dictFrom: NSDictionary!
    var arrOfOtherJobList: NSMutableArray = NSMutableArray()
    let custObj: customClassViewController = customClassViewController()
    var contentMsg: ContentMessageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.title = dictFrom.object(forKey: "Name") as? String
        contentMsg = ContentMessageView.CreateView(self.view, strMessage: "No records found", strImageName: "WB_Font", color: UIColor.lightGray)
        contentMsg.isHidden = true
        self.tblOtherJobList.dataSource = self
        self.tblOtherJobList.delegate = self
        tblOtherJobList.register(UINib(nibName: "CellOtherJobList", bundle: nil), forCellReuseIdentifier: "CellOtherJobList")
        tblOtherJobList.register(UINib(nibName: "matchingJobCellSeeker", bundle: nil), forCellReuseIdentifier: "matchingJobCellSeeker")
        
        view.backgroundColor = API.appBackgroundColor()
        getJobHubList()

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfOtherJobList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dd: NSDictionary = arrOfOtherJobList.object(at: indexPath.row) as! NSDictionary
        if dictFrom.object(forKey: "Name") as! String == "Other" || dictFrom.object(forKey: "Name") as! String == "Others" || dictFrom.object(forKey: "Name") as! String == "other"
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellOtherJobList", for: indexPath as IndexPath) as! CellOtherJobList
            
            cell.lblJobTitle.text = dd.object(forKey: "JobPostTitle")as? String
            cell.lblCateName.text = dd.object(forKey: "CategoryName")as? String
            cell.lblCompanyName.text = dd.object(forKey: "CompanyName")as? String
            cell.lblHiredTillDate.text = String(format: "Hired till date %d", dd.object(forKey: "TotalHiredJobs") as! Int)
            cell.viewCompanyRating.value = dd.object(forKey: "Rating") as! CGFloat
            cell.lblTotalApplied.text = String(format: "%d applied", dd.object(forKey: "TotalAppliedJobs") as! Int)
            
            cell.btnTotalPayment.setTitle(String(format:"%@",dd.object(forKey: "HourlyRate") as! String), for: UIControlState.normal)
            
            
            let dictUserr: NSDictionary = API.getLoggedUserData()
            let strFromLat: String = dictUserr.object(forKey: "Latitude") as! String
            let strFromLong: String = dictUserr.object(forKey: "Longitude") as! String
            
            let strLatitude: String = dd.object(forKey: "PosterLat") as! String
            let strLongitude: String = dd.object(forKey: "PosterLong") as! String
            
            let strDistance: String = API.getDistance(strToLate: strLatitude, strToLong: strLongitude, strFromLat: strFromLat, strFromLong: strFromLong)
            cell.btnTotalKm.setTitle(String(format:"%@",strDistance), for: UIControlState.normal)
            
            cell.btnTotalKm.titleLabel?.adjustsFontSizeToFitWidth = true
            //cell.btnTotalKm.setTitle(String(format:"%@",dd.object(forKey: "Distance") as! String), for: UIControlState.normal)
            
            if dd.object(forKey: "TotalJobs") as! Int == 1 || dd.object(forKey: "TotalJobs") as! Int == 0
            {
                cell.btnTotalJobs.setTitle(String(format:"%d Job",dd.object(forKey: "TotalJobs") as! Int), for: UIControlState.normal)
            }
            else
            {
                cell.btnTotalJobs.setTitle(String(format:"%d Jobs",dd.object(forKey: "TotalJobs") as! Int), for: UIControlState.normal)
            }
            
            cell.imgCompanyPhoto.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
            cell.imgCompanyPhoto.tag = indexPath.row
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGestureRecognizer:)))
            cell.imgCompanyPhoto.isUserInteractionEnabled = true
            cell.imgCompanyPhoto.addGestureRecognizer(tapGestureRecognizer)
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "matchingJobCellSeeker", for: indexPath as IndexPath) as! matchingJobCellSeeker
            
            cell.btnRemainTimeToApplied.isHidden = true
            cell.lblJobTitle.text = dd.object(forKey: "JobPostTitle")as? String
            cell.lblCompanyName.text = dd.object(forKey: "CompanyName")as? String
            cell.lblHiredTillDate.text = String(format: "Hired till date %d", dd.object(forKey: "TotalHiredJobs") as! Int)
            cell.viewCompanyRating.value = dd.object(forKey: "Rating") as! CGFloat
            cell.lblTotalApplied.text = String(format: "%d applied", dd.object(forKey: "TotalAppliedJobs") as! Int)
            
            cell.btnTotalPayment.setTitle(String(format:"%@",dd.object(forKey: "HourlyRate") as! String), for: UIControlState.normal)
            
            
            let dictUserr: NSDictionary = API.getLoggedUserData()
            let strFromLat: String = dictUserr.object(forKey: "Latitude") as! String
            let strFromLong: String = dictUserr.object(forKey: "Longitude") as! String
            
            let strLatitude: String = dd.object(forKey: "PosterLat") as! String
            let strLongitude: String = dd.object(forKey: "PosterLong") as! String
            
            let strDistance: String = API.getDistance(strToLate: strLatitude, strToLong: strLongitude, strFromLat: strFromLat, strFromLong: strFromLong)
            cell.btnTotalKm.setTitle(String(format:"%@",strDistance), for: UIControlState.normal)
            
            cell.btnTotalKm.titleLabel?.adjustsFontSizeToFitWidth = true
            //cell.btnTotalKm.setTitle(String(format:"%@",dd.object(forKey: "Distance") as! String), for: UIControlState.normal)
            
            if dd.object(forKey: "TotalJobs") as! Int == 1 || dd.object(forKey: "TotalJobs") as! Int == 0
            {
                cell.btnTotalJobs.setTitle(String(format:"%d Job",dd.object(forKey: "TotalJobs") as! Int), for: UIControlState.normal)
            }
            else
            {
                cell.btnTotalJobs.setTitle(String(format:"%d Jobs",dd.object(forKey: "TotalJobs") as! Int), for: UIControlState.normal)
            }
            
            cell.imgCompanyPhoto.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
            cell.imgCompanyPhoto.tag = indexPath.row
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGestureRecognizer:)))
            cell.imgCompanyPhoto.isUserInteractionEnabled = true
            cell.imgCompanyPhoto.addGestureRecognizer(tapGestureRecognizer)
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let obj: appliedDetailSeeker = self.storyboard?.instantiateViewController(withIdentifier: "appliedDetailSeeker") as! appliedDetailSeeker
        obj.strFrom = "otherJob"
        let dd: NSDictionary = arrOfOtherJobList.object(at: indexPath.row) as! NSDictionary
        obj.dictPost = NSMutableDictionary.init(dictionary: dd)
        self.navigationController!.pushViewController(obj, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if dictFrom.object(forKey: "Name") as! String == "Other"
        {
            return 139
        }
        return 119
    }
    //MARK:- GO TO SEEKER PROFILE
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tag: Int = (tapGestureRecognizer.view?.tag)!
        var dd: NSDictionary = NSDictionary()
        dd = arrOfOtherJobList.object(at: tag) as! NSDictionary
        
        let obj: posterProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "posterProfileClass") as! posterProfileClass
        obj.userId = dd.object(forKey: "UserID") as! String
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    //AMRK:- API CALL
    func getJobHubList()
    {
        arrOfOtherJobList = NSMutableArray()
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "SeekerID")
        parameter.setValue(dictFrom.object(forKey: "CategoryID"), forKey: "CategoryID")
        print(parameter)
        API.callApiPOST(strUrl: API_GetOtherJobDetail,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                self.arrOfOtherJobList = NSMutableArray.init(array: arr)
                self.contentMsg.isHidden = true
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.contentMsg.isHidden = false
            }
            self.tblOtherJobList.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.contentMsg.isHidden = false
        })
    }

}
