//
//  acceptedDetailInnerSeeker.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/5/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class acceptedDetailInnerSeeker: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIAlertViewDelegate
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
    var dictFromDetail: NSMutableDictionary = NSMutableDictionary()
    var dictFromMain: NSMutableDictionary = NSMutableDictionary()
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
        tblAcceoted.register(UINib(nibName: "cellAcceptedInnerCell", bundle: nil), forCellReuseIdentifier: "cellAcceptedInnerCell")
        getRosterDetail()
        if API.getRoleName().lowercased() == "Seeker".lowercased()
        {
            getCurrentLocation()
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        timerForAccepetd = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(getRosterDetail), userInfo: nil, repeats: true)
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
                obj.objAcceptedInner = self
                obj.fromWhere = "AcceptedInner"
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
                obj.objAcceptedInner = self
                obj.fromWhere = "AcceptedInner"
                self.present(obj, animated: true, completion: nil)
            }))
            
            uiAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            }))
            self.present(uiAlert, animated: true, completion: nil)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAcceptedInnerCell", for: indexPath as IndexPath) as! cellAcceptedInnerCell
        cell.imgWatchIcon.tintColor = API.themeColorPink()
        
        let dd: NSDictionary = arrOfRoster.object(at: indexPath.row) as! NSDictionary
        cell.lblRosterDate.text = dd.object(forKey: "Date") as? String
        cell.lblRosterTime.text = String(format: "%@ - %@", dd.object(forKey: "FromTime") as! String,dd.object(forKey: "ToTime") as! String)
        cell.lblRemainTime.text = dd.object(forKey: "JobTimePeriod") as? String
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
        
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(self.btnCancelJob(_:)), for: UIControlEvents.touchUpInside)
        cell.btnStart.tag = indexPath.row
        cell.btnStart.addTarget(self, action: #selector(self.btnStartJob(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    //MARK:- Get Current Location
    func getCurrentLocation()
    {
        if API.getIsLogin() == false || API.getRoleName().lowercased() == "Poster".lowercased()
        {
            //timerForDashboard.invalidate()
            //timerForDashboard = nil
            return
        }
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
    func getRosterDetail()
    {
        custObj.showSVHud("Loading")
        arrOfRoster = NSMutableArray()
        tblAcceoted.reloadData()
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(dictFromDetail.object(forKey: "RosterID"), forKey: "RosterID")
        parameter.setValue(dictFromDetail.object(forKey: "AcceptedID"), forKey: "AcceptedID")
        print(parameter)
        API.callApiPOST(strUrl: API_GetRosterDateDetails,parameter: parameter, success: { (response) in
            
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
        parameter.setValue(dd.object(forKey: "ID"), forKey: "RosterDateID")
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
