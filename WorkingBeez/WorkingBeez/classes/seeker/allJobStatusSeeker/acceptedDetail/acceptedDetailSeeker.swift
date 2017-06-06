//
//  acceptedDetailSeeker.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/5/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class acceptedDetailSeeker: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIAlertViewDelegate
{

    //MARK:- Outlet
    @IBOutlet weak var tblAcceoted: UITableView!
    
    var timerForAccepetd: Timer!
    var onlyOnce: Int = 0
    var firstTime: Int = 0
    var locationManager: CLLocationManager!
    var strLat: String = ""
    var strLong: String = ""
    var contentMsg: ContentMessageView!
    var arrOfRoster: NSMutableArray = NSMutableArray()
    var dictFrom: NSMutableDictionary = NSMutableDictionary()
    var dictStartJob: NSMutableDictionary = NSMutableDictionary()
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        contentMsg = ContentMessageView.CreateView(self.view, strMessage: "No records found", strImageName: "WB_Font", color: UIColor.lightGray)
        contentMsg.isHidden = true
        
        view.backgroundColor = API.appBackgroundColor()
        tblAcceoted.delegate = self
        tblAcceoted.dataSource = self
        tblAcceoted.register(UINib(nibName: "cellAcceptedNoRepeat", bundle: nil), forCellReuseIdentifier: "cellAcceptedNoRepeat")
        tblAcceoted.register(UINib(nibName: "cellAcceptedWithRepeat", bundle: nil), forCellReuseIdentifier: "cellAcceptedWithRepeat")
        if API.getRoleName().lowercased() == "Seeker".lowercased()
        {
            getCurrentLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        getAcceptedDetail()
        timerForAccepetd = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(getAcceptedDetail), userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        timerForAccepetd.invalidate()
        timerForAccepetd = nil
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnAddress(_ sender: Any)
    {
        let dd: NSDictionary = arrOfRoster.object(at: (sender as AnyObject).tag) as! NSDictionary
        let lati: Double = Double(dd.object(forKey: "Latitude") as! String)!
        let longi: Double = Double(dd.object(forKey: "Longitude") as! String)!
        API.openMapForPlace(lat: lati, longi: longi, dd: dd)
    }
    @IBAction func btnStartJob(_ sender: Any)
    {
        let tag: Int = (sender as AnyObject).tag
        let dd: NSDictionary = arrOfRoster.object(at: tag) as! NSDictionary
        if dd.object(forKey: "IsPlay") as! Bool == false
        {
            if API.getRoleName().lowercased() == "Seeker".lowercased()
            {
                custObj.alertMessage("You can start the job (a) when you reach at the job location and (b) at job scheduled start time.")
            }
            else
            {
                custObj.alertMessage("Start button will be activated 15 mins. before the scheduled start time.")
            }
            return
        }
        if API.getRoleName().lowercased() == "Seeker".lowercased()
        {
            if strLat == "" || strLong == ""
            {
                let errorAlert: UIAlertView = UIAlertView(title: NSLocalizedString("Location", comment: ""), message: NSLocalizedString(location_message, comment: ""), delegate: self, cancelButtonTitle: NSLocalizedString("Settings", comment: ""), otherButtonTitles: NSLocalizedString("No", comment: ""))
                errorAlert.show()
            }
            else
            {
                let coordinateDesti = CLLocation(latitude: Double(self.strLat)!, longitude: Double(self.strLong)!)
                let coordinateSource = CLLocation(latitude: Double(dd.object(forKey: "Latitude") as! String)!, longitude: Double(dd.object(forKey: "Longitude") as! String)!)
                let distance: Double = coordinateDesti.distance(from: coordinateSource)
                print(distance)
//                if distance > 50000
//                {
//                    custObj.alertMessage("You can not start the job at this time")
//                    return
//                }
            }
        }
        
        let uiAlert = UIAlertController(title: ALERT_TITLE, message: START_JOB_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        uiAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.startJob(dd: dd)
        }))
        
        uiAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
        }))
        self.present(uiAlert, animated: true, completion: nil)
    }
    @IBAction func btnCancelJob(_ sender: Any)
    {
        let tag: Int = (sender as AnyObject).tag
        let dd: NSDictionary = arrOfRoster.object(at: tag) as! NSDictionary
        dictStartJob = NSMutableDictionary.init(dictionary: dd)
        if dd.object(forKey: "IsCancel") as! Bool == false
        {
            custObj.alertMessage("You can not cancel job at this time")
            return
        }
        if API.getRoleName().lowercased() == "Poster".lowercased()
        {
            let uiAlert = UIAlertController(title: CANCEL_JOB_MESSAGE, message: poster_Cancel, preferredStyle: UIAlertControllerStyle.alert)
            uiAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                let obj: abortJobClass = self.storyboard?.instantiateViewController(withIdentifier: "abortJobClass") as! abortJobClass
                obj.objAccepted = self
                obj.fromWhere = "Accepted"
                self.present(obj, animated: true, completion: nil)
            }))
            
            uiAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            }))
            self.present(uiAlert, animated: true, completion: nil)
        }
        else
        {
            let uiAlert = UIAlertController(title: CANCEL_JOB_MESSAGE, message: seeker_Cancel, preferredStyle: UIAlertControllerStyle.alert)
            uiAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                let obj: abortJobClass = self.storyboard?.instantiateViewController(withIdentifier: "abortJobClass") as! abortJobClass
                obj.objAccepted = self
                obj.fromWhere = "Accepted"
                self.present(obj, animated: true, completion: nil)
            }))
            
            uiAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            }))
            self.present(uiAlert, animated: true, completion: nil)
        }
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
        if dd.object(forKey: "IsRepete") as! Bool == false
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellAcceptedNoRepeat", for: indexPath as IndexPath) as! cellAcceptedNoRepeat
            
            if API.getRoleName().lowercased() == "Seeker".lowercased()
            {
                cell.btnAddress.isSelected = true
            }
            else
            {
                cell.btnAddress.isSelected = false
            }
            cell.lblJobTitle.text = dd.object(forKey: "JobPostTitle") as? String
            cell.btnAddress.setTitle(dd.object(forKey: "Location") as? String, for: UIControlState.normal)
            cell.btnAddress.titleLabel?.adjustsFontSizeToFitWidth = true
            cell.lblRosterDate.text = dd.object(forKey: "FromDate") as? String
            cell.lblRosterTime.text = String(format: "%@ - %@", dd.object(forKey: "FromTime") as! String,dd.object(forKey: "ToTime") as! String)
            cell.lblRosterTimePeriod.text = dd.object(forKey: "JobTimePeriod") as? String
            //cell.lblRosterTotalPayment.text = dd.object(forKey: "HourlyRate") as? String
            cell.lblRosterTotalPayment.text = String(format: "%@", dd.object(forKey: "HourlyRate") as! String)
            
            if dd.object(forKey: "IsCancel") as! Bool == true
            {
                cell.btnCancel.alpha = 1
            }
            else
            {
                cell.btnCancel.alpha = 0.5
            }
            if dd.object(forKey: "IsPlay") as! Bool == true
            {
                cell.btnStart.alpha = 1
            }
            else
            {
                cell.btnStart.alpha = 0.5
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
            
            cell.imgWatchIcon.tintColor = API.themeColorPink()
            cell.btnCancel.tag = indexPath.row
            cell.btnStart.tag = indexPath.row
            cell.btnAddress.tag = indexPath.row
            cell.btnCancel.addTarget(self, action: #selector(self.btnCancelJob(_:)), for: UIControlEvents.touchUpInside)
            cell.btnStart.addTarget(self, action: #selector(self.btnStartJob(_:)), for: UIControlEvents.touchUpInside)
            cell.btnAddress.addTarget(self, action: #selector(self.btnAddress(_:)), for: UIControlEvents.touchUpInside)
            
            cell.viewDays.isHidden = true
            cell.lblRosterRepeatStatus.isHidden = false
            cell.lblJobId.isHidden = false
            cell.lblJobId.text = String(format: "Job ID: %d", dd.object(forKey: "JobPostID") as! Int)
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellAcceptedWithRepeat", for: indexPath as IndexPath) as! cellAcceptedWithRepeat
            if API.getRoleName().lowercased() == "Seeker".lowercased()
            {
                cell.btnAddress.isSelected = true
            }
            else
            {
                cell.btnAddress.isSelected = false
            }
            cell.lblJobTitle.text = dd.object(forKey: "JobPostTitle") as? String
            cell.btnAddress.setTitle(dd.object(forKey: "Location") as? String, for: UIControlState.normal)
            cell.btnAddress.titleLabel?.adjustsFontSizeToFitWidth = true
            cell.lblRosterDate.text = String(format: "%@ to %@", dd.object(forKey: "FromDate") as! String,dd.object(forKey: "ToDate") as! String)
            cell.lblRosterTime.text = String(format: "%@ - %@", dd.object(forKey: "FromTime") as! String,dd.object(forKey: "ToTime") as! String)
            cell.lblRosterTotalPayment.text = String(format: "%@/hr", dd.object(forKey: "HourlyRate") as! String)
            cell.lblTotalShift.text = dd.object(forKey: "TotalShift") as? String
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
            cell.lblJobPostId.isHidden = false
            cell.lblJobPostId.text = String(format: "Job ID: %d", dd.object(forKey: "JobPostID") as! Int)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dd: NSDictionary = arrOfRoster.object(at: indexPath.row) as! NSDictionary
        if dd.object(forKey: "IsRepete") as! Bool == true
        {
            let obj: acceptedDetailInnerSeeker = self.storyboard?.instantiateViewController(withIdentifier: "acceptedDetailInnerSeeker") as! acceptedDetailInnerSeeker
            obj.dictFromDetail = NSMutableDictionary.init(dictionary: dd)
            obj.dictFromMain = dictFrom
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let dd: NSDictionary = arrOfRoster.object(at: indexPath.row) as! NSDictionary
        if dd.object(forKey: "IsBreak") as! Bool == false
        {
            return 135
        }
        else
        {
            return 147
        }
    }
    //MARK:- Get Current Location
    func getCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=kCLDistanceFilterNone;
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        NSLog("didUpdateToLocation: %@", locations)
        
        let currentLocation: CLLocation = locations[0]
        locationManager.stopUpdatingLocation()
        strLat = String(format: "%.8f", currentLocation.coordinate.latitude)
        strLong = String(format: "%.8f", currentLocation.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        if onlyOnce == 0
        {
            if CLLocationManager.locationServicesEnabled()
            {
                switch(CLLocationManager.authorizationStatus())
                {
                case .notDetermined, .restricted, .denied:
                    let errorAlert: UIAlertView = UIAlertView(title: NSLocalizedString("Location", comment: ""), message: NSLocalizedString(location_message, comment: ""), delegate: self, cancelButtonTitle: NSLocalizedString("Settings", comment: ""), otherButtonTitles: NSLocalizedString("No", comment: ""))
                    errorAlert.show()
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                }
            }
            else
            {
                let errorAlert: UIAlertView = UIAlertView(title: NSLocalizedString("Error" ,comment: ""), message: NSLocalizedString("Failed to Get Your Location", comment: ""), delegate: nil, cancelButtonTitle: NSLocalizedString("Ok", comment: ""), otherButtonTitles: "")
                errorAlert.show()
            }
            onlyOnce = onlyOnce + 1
        }
    }
    
    //MARK:- Alert Delegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        //UIApplicationLaunchOptionsLocationKey
        if buttonIndex == 0
        {
            if UIApplication.shared.canOpenURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
            {
                UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
            }
            else
            {
                NSLog("Cant open")
            }
        }
        else
        {
        }
    }
    //MARK:- API Call
    func getAcceptedDetail()
    {
        custObj.showSVHud("Loading")
        arrOfRoster = NSMutableArray()
        tblAcceoted.reloadData()
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        parameter.setValue(dictFrom.object(forKey: "JobPostID"), forKey: "JobPostID")
        parameter.setValue(dictFrom.object(forKey: "ID"), forKey: "AcceptedID")
        print(parameter)
        API.callApiPOST(strUrl: API_GetRosterDetails,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                self.arrOfRoster = NSMutableArray.init(array: arr)
                self.contentMsg.isHidden = true
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.contentMsg.isHidden = false
            }
            self.tblAcceoted.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.contentMsg.isHidden = false
        })
    }
    func startJob(dd: NSDictionary)
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        parameter.setValue(dd.object(forKey: "RosterDateID"), forKey: "RosterDateID")
        parameter.setValue(dd.object(forKey: "RosterID"), forKey: "RosterID")
        parameter.setValue(dd.object(forKey: "AcceptedID"), forKey: "AcceptedID")
        print(parameter)
        API.callApiPOST(strUrl: API_PlayJob,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.arrOfRoster.remove(dd)
                if self.arrOfRoster.count == 0
                {
                    self.contentMsg.isHidden = false
                }
                else
                {
                    self.contentMsg.isHidden = true
                }
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.tblAcceoted.reloadData()
//                if API.getRoleName().lowercased() == "Poster".lowercased()
//                {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadAcceptedPoster"), object: nil)
//                }
//                else
//                {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadAcceptedSeeker"), object: nil)
//                }
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.tblAcceoted.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
}
