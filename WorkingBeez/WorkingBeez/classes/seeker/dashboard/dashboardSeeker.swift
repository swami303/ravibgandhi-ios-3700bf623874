//
//  dashboardSeeker.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/22/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit
import XMPPFramework

class dashboardSeeker: UIViewController,UIAlertViewDelegate,CLLocationManagerDelegate
{
    //MARK:- Outlet
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewPostJobWav: UIView!
    @IBOutlet weak var imgPostJobCircle: UIImageView!
    @IBOutlet weak var lblSavedProfileBack: cLable!
    @IBOutlet weak var lblPostCalenderBack: cLable!
    @IBOutlet weak var lblSavedCnt: cLable!
    @IBOutlet weak var lblJobHubCnt: cLable!
    @IBOutlet weak var lblJobCalenderCnt: cLable!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUserPhoto: cImageView!
    @IBOutlet weak var viewRating: HCSStarRatingView!
    @IBOutlet weak var viewPendingPaymentWav: UIView!
    @IBOutlet weak var lblEarnedTillDate: UILabel!
    @IBOutlet weak var lblPendingEarning: UILabel!
    @IBOutlet weak var lblResponseRate: UILabel!
    @IBOutlet weak var btnAvailability: UISwitch!
    @IBOutlet weak var lblPostHistoryBack: cLable!
    @IBOutlet weak var lblMatchingCnt: UILabel!
    @IBOutlet weak var lblAppliedCnt: UILabel!
    @IBOutlet weak var lblAcceptedCnt: UILabel!
    @IBOutlet weak var lblRunningCnt: UILabel!
    @IBOutlet weak var lblPTCnt: UILabel!
    @IBOutlet weak var lblCompletedCnt: UILabel!
    @IBOutlet weak var lblProfileRating: KAProgressLabel!
    
    //@IBOutlet weak var lblPostHistoryBack: cLable!
    
    var deleObj: AppDelegate!
    var timerForLocationUpdate: Timer!
    var onlyOnce: Int = 0
    var firstTime: Int = 0
    var locationManager: CLLocationManager!
    var strLat: String = ""
    var strLong: String = ""
    var timerForDashboard: Timer!
    var PPWav = PulsingHaloLayer()
    var postJobWav:PulsingHaloLayer = PulsingHaloLayer()
    var arrOfSlice: NSMutableArray = NSMutableArray()
    var dictUserData: NSMutableDictionary = NSMutableDictionary()
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //0 = Normal
        //1 = chat
        //2 = both matching
        //3 = invited by poster
        //4 = aplied by seeker
        //5 = job started
        //6 = pending Payment - poster
        //7 = Completed  - seeker
        
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        if API.isFromNotification() == true
        {
            let dd: NSMutableDictionary = NSMutableDictionary.init(dictionary: API.getNotiDict())
            if dd.object(forKey: "NotificationType") as! String == "1"
            {
                API.setIsFromNotification(type: false)
                dd.setValue(dd.value(forKey: "AcceptedID"), forKey: "ID")
                dd.setValue(dd.value(forKey: "FromUserName"), forKey: "CompanyName")
                dd.setValue(dd.value(forKey: "FromUserName"), forKey: "Name")
                dd.setValue(dd.value(forKey: "ProfilePic"), forKey: "ProfilePicPath")
                dd.setValue(dd.value(forKey: "FromUserID"), forKey: "UserID")
                dd.setValue(dd.value(forKey: "FromJID"), forKey: "JID")
                print(dd)
                let obj: chatDetail = self.storyboard?.instantiateViewController(withIdentifier: "chatDetail") as! chatDetail
                obj.dictFrom = dd
                self.navigationController!.pushViewController(obj, animated: true)
            }
            else if dd.object(forKey: "NotificationType") as! String == "2"
            {
                API.setIsFromNotification(type: false)
                let obj: allJobStatusSeeker = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusSeeker") as! allJobStatusSeeker
                obj.strNavTitle = "Matching Job"
                self.navigationController!.pushViewController(obj, animated: true)
            }
            else if dd.object(forKey: "NotificationType") as! String == "3"
            {
                let obj: appliedDetailSeeker = self.storyboard?.instantiateViewController(withIdentifier: "appliedDetailSeeker") as! appliedDetailSeeker
                obj.dictPost = NSMutableDictionary.init(dictionary: dd)
                obj.strFrom = "Invited"
                self.navigationController!.pushViewController(obj, animated: true)
            }
            else if dd.object(forKey: "NotificationType") as! String == "5"
            {
                API.setIsFromNotification(type: false)
                let obj: allJobStatusSeeker = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusSeeker") as! allJobStatusSeeker
                obj.strNavTitle = "Running Job"
                self.navigationController!.pushViewController(obj, animated: true)
            }
            else if dd.object(forKey: "NotificationType") as! String == "7"
            {
                API.setIsFromNotification(type: false)
                let obj: completedJobSeeker = self.storyboard?.instantiateViewController(withIdentifier: "completedJobSeeker") as! completedJobSeeker
                self.navigationController!.pushViewController(obj, animated: true)
            }
            else if dd.object(forKey: "NotificationType") as! String == "8"
            {
                API.setIsFromNotification(type: false)
                let obj: allJobStatusSeeker = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusSeeker") as! allJobStatusSeeker
                obj.strNavTitle = "Accepted Job"
                self.navigationController!.pushViewController(obj, animated: true)
            }
        }
        
        //timerForLocationUpdate = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(getCurrentLocation), userInfo: nil, repeats: true)
        //getCurrentLocation()
        self.navigationController?.navigationBar.isTranslucent = false
        let logo = UIImage(named: "dashboardLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        lblPostHistoryBack.layer.cornerRadius = (40*UIScreen.main.bounds.size.width)/320
        lblPostHistoryBack.clipsToBounds = true
        
        lblSavedProfileBack.layer.cornerRadius = (40*UIScreen.main.bounds.size.width)/320
        lblSavedProfileBack.clipsToBounds = true
        
        lblPostCalenderBack.layer.cornerRadius = (40*UIScreen.main.bounds.size.width)/320
        lblPostCalenderBack.clipsToBounds = true
        
        lblJobHubCnt.layer.cornerRadius = (10*UIScreen.main.bounds.size.width)/320
        lblJobHubCnt.clipsToBounds = true
        
        lblSavedCnt.layer.cornerRadius = (10*UIScreen.main.bounds.size.width)/320
        lblSavedCnt.clipsToBounds = true
        
        lblJobCalenderCnt.layer.cornerRadius = (10*UIScreen.main.bounds.size.width)/320
        lblJobCalenderCnt.clipsToBounds = true
        
        lblJobCalenderCnt.backgroundColor = API.counterBackColor()
        lblSavedCnt.backgroundColor = API.counterBackColor()
        lblJobHubCnt.backgroundColor = API.counterBackColor()
        
        imgUserPhoto.layer.cornerRadius = (42*UIScreen.main.bounds.size.width)/320
        imgUserPhoto.clipsToBounds = true
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: API.blackColor(), NSFontAttributeName: UIFont(name: font_openSans_regular, size: 14)!]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = API.NavigationbarColor()
        
        
        let dd: NSDictionary = API.getLoggedUserData()
        dictUserData = NSMutableDictionary.init(dictionary: dd)
        setDashBoard(dictDashboard: dictUserData)
        
        do {
            try AppDelegate.sharedDelegate().xmppControllerr = XMPPController(hostName: XMPP_HOST,
                                                                              userJIDString: String(format:"%@",API.getXMPPUSER()),
                                                                              password: API.getXMPPPWD())
            AppDelegate.sharedDelegate().xmppControllerr.xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
            AppDelegate.sharedDelegate().xmppControllerr.connect()
        } catch {
            print("Something went wrong")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.connectToXMPP), name: NSNotification.Name(rawValue: "connectToXMPP"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.disConnectToXMPP), name: NSNotification.Name(rawValue: "disConnectToXMPP"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getDashboardData), name: NSNotification.Name(rawValue: "reloadDashboardSeeker"), object: nil)
        
    }
    func connectToXMPP()
    {
        AppDelegate.sharedDelegate().xmppControllerr.connect()
    }
    func disConnectToXMPP()
    {
        AppDelegate.sharedDelegate().xmppControllerr.disConnect()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        getDashboardData()
        timerForDashboard = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(getDashboardData), userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        timerForDashboard.invalidate()
        timerForDashboard = nil
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnSavedJob(_ sender: Any)
    {
        let obj: savedJobClass = self.storyboard?.instantiateViewController(withIdentifier: "savedJobClass") as! savedJobClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnJobHub(_ sender: Any)
    {
        let obj: otherJobClass = self.storyboard?.instantiateViewController(withIdentifier: "otherJobClass") as! otherJobClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnJobCalender(_ sender: Any)
    {
        let obj: calendarSeekerClass = self.storyboard?.instantiateViewController(withIdentifier: "calendarSeekerClass") as! calendarSeekerClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnShare(_ sender: Any)
    {
        let textToShare =  [SHARE_TEXT]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.popoverPresentationController?.sourceRect = self.view.bounds
        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func btnChat(_ sender: Any)
    {
        let obj: chatList = self.storyboard?.instantiateViewController(withIdentifier: "chatList") as! chatList
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnMenu(_ sender: Any)
    {
        let obj: menuClass = self.storyboard?.instantiateViewController(withIdentifier: "menuClass") as! menuClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnAvailability(_ sender: Any)
    {
        setAvailability()
    }
    
    
    // MARK:- Job Action
    @IBAction func btnMatchingProfile(_ sender: Any)
    {
        let obj: allJobStatusSeeker = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusSeeker") as! allJobStatusSeeker
        obj.strNavTitle = "Matching Job"
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnAppliedJob(_ sender: Any)
    {
        let obj: allJobStatusSeeker = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusSeeker") as! allJobStatusSeeker
        obj.strNavTitle = "Applied Job"
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnAcceptedJob(_ sender: Any)
    {
        let obj: allJobStatusSeeker = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusSeeker") as! allJobStatusSeeker
        obj.strNavTitle = "Accepted Job"
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnRunningJob(_ sender: Any)
    {
        let obj: allJobStatusSeeker = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusSeeker") as! allJobStatusSeeker
        obj.strNavTitle = "Running Job"
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnPendingPayment(_ sender: Any)
    {
        let obj: pendingTimesheetClass = self.storyboard?.instantiateViewController(withIdentifier: "pendingTimesheetClass") as! pendingTimesheetClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnCompletedJob(_ sender: Any)
    {
        let obj: completedJobSeeker = self.storyboard?.instantiateViewController(withIdentifier: "completedJobSeeker") as! completedJobSeeker
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    //MARK:- Set Dashboard
    func setDashBoard(dictDashboard: NSMutableDictionary)
    {
        print(dictDashboard)
        API.setRoleName(role: dictUserData.object(forKey: "RoleName") as! String)
        lblName.text = String(format: "%@ %@", dictDashboard.object(forKey: "FirstName") as! String,dictDashboard.object(forKey: "LastName") as! String)
        viewRating.value = CGFloat(dictDashboard.object(forKey: "ProfileRating") as! CGFloat)
        
        lblSavedCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalSavedJob") as! Int)
        lblJobHubCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalJobHub") as! Int)
        lblJobCalenderCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalJobCalender") as! Int)
        
        lblMatchingCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalMatch") as! Int)
        lblAppliedCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalAppliedJob") as! Int)
        lblAcceptedCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalAcceptedJob") as! Int)
        lblRunningCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalRunningJob") as! Int)
        lblPTCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalPendingTimeSheet") as! Int)
        lblCompletedCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalCompletedJob") as! Int)
        lblEarnedTillDate.text = String(format: "%@", dictDashboard.object(forKey: "YearEarn") as! String)
        lblPendingEarning.text = String(format: "%@", dictDashboard.object(forKey: "PendingEarn") as! String)
        
        let str: String = "%"
        lblResponseRate.text = String(format: "%d %@", dictDashboard.object(forKey: "ProfileResponseRate") as! Int,str)
//        let myMutableString: NSMutableAttributedString = NSMutableAttributedString(string: lblResponseRate.text!, attributes: [NSFontAttributeName:UIFont(name: font_openSans_regular, size: 14)!])
//        
//        myMutableString.addAttribute(NSForegroundColorAttributeName, value: API.starRatingColor(), range: NSRange(location:(lblResponseRate.text?.length)! - 1,length:0))
//        lblResponseRate.attributedText = myMutableString
        
        imgUserPhoto.sd_setImage(with: NSURL.init(string: (dictDashboard.object(forKey: "ProfilePic") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
        
        let ProfileCompletion: Int = dictDashboard.object(forKey: "ProfileCompletion") as! Int
        let strPer: String = "%"
        lblProfileRating.progressWidth = (2*UIScreen.main.bounds.size.height)/504
        lblProfileRating.startDegree = 0
        lblProfileRating.endDegree = 100
        lblProfileRating.progress = CGFloat(ProfileCompletion) / 100
        lblProfileRating.progressColor = API.trackerColor()
        lblProfileRating.trackColor = UIColor.clear
        lblProfileRating.endLabel.text = String(format: "%d%@", ProfileCompletion,strPer)
        lblProfileRating.roundedCornersWidth = 15
        
        
        //imgUserPhoto.isHidden = true
        postJobWav.removeFromSuperlayer()
        PPWav.removeFromSuperlayer()
        if dictDashboard.object(forKey: "IsAvailable") as! Bool == true
        {
            btnAvailability.setOn(true, animated: false)
            postJobWav = PulsingHaloLayer()
            postJobWav.position = CGPoint.init(x: (52*UIScreen.main.bounds.size.width)/320 + 1, y: (52*UIScreen.main.bounds.size.height)/568 + 1)
            postJobWav.haloLayerNumber = 6
            postJobWav.radius = (52*UIScreen.main.bounds.size.width)/320
            postJobWav.animationDuration = 6
            postJobWav.backgroundColor = API.themeColorBlue().cgColor
            viewPostJobWav.layer.addSublayer(postJobWav)
            postJobWav.start()
        }
        else
        {
            btnAvailability.setOn(false, animated: false)
            postJobWav.removeFromSuperlayer()
        }
        if lblPTCnt.text != "0"
        {
            PPWav = PulsingHaloLayer()
            PPWav.position = CGPoint.init(x: (25*UIScreen.main.bounds.size.width)/320, y: (25*UIScreen.main.bounds.size.height)/568 + 1)
            PPWav.haloLayerNumber = 6
            PPWav.radius = (25*UIScreen.main.bounds.size.width)/320
            PPWav.animationDuration = 6
            PPWav.backgroundColor = UIColor.red.cgColor
            viewPendingPaymentWav.layer.addSublayer(PPWav)
            PPWav.start()
        }
        else
        {
            PPWav.removeFromSuperlayer()
        }
        
    }
    
    //MARK:- Call API
    func getDashboardData()
    {
        if API.getIsLogin() == false
        {
            return
        }
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(dictUserData.object(forKey: "RoleName"), forKey: "RoleName")
        print(parameter)
        API.callApiPOST(strUrl: API_GET_DASHBOARD_DATA,parameter: parameter, success: { (response) in
            
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let firstObj: NSArray = response.object(forKey: "Data") as! NSArray
                let result: NSDictionary = firstObj.object(at: 0) as! NSDictionary
                let dictData: NSMutableDictionary = NSMutableDictionary.init(dictionary: result)
                //let dictData: NSMutableDictionary = self.custObj.dictionaryByReplacingNulls(withStrings:result.mutableCopy() as! NSMutableDictionary)
                self.setDashBoard(dictDashboard: dictData)
                API.setXMPPUSER(type: dictData.object(forKey: JID) as! String)
                API.setXMPPPWD(type: dictData.object(forKey: "JPassword") as! String)
                API.setLoggedUserData(dict: dictData)
                API.setUserId(user_id: dictData.object(forKey: "UserID") as! String)
                if dictData.object(forKey: "IsFeedback") as! Bool == true
                {
                    if self.deleObj.isInCompleted == false
                    {
                        let obj: completedJobSeeker = self.storyboard?.instantiateViewController(withIdentifier: "completedJobSeeker") as! completedJobSeeker
                        self.navigationController!.pushViewController(obj, animated: true)
                    }
                }
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
        }, error: { (error) in
            print(error)
            //self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    func setAvailability()
    {
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "seekerID")
        if btnAvailability.isOn == true
        {
            parameter.setValue(true, forKey: "Status")
        }
        else
        {
            parameter.setValue(false, forKey: "Status")
        }
        print(parameter)
        API.callApiPOST(strUrl: API_SetSeekerAvailability,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
//                print(self.dictUserData)
//                self.dictUserData.setValue(self.btnAvailability.isOn, forKey: "IsAvailable")
//                print(self.dictUserData)
//                self.setDashBoard(dictDashboard: self.dictUserData)
                if self.btnAvailability.isOn == false
                {
                    self.postJobWav.removeFromSuperlayer()
                }
                else
                {
                    self.postJobWav = PulsingHaloLayer()
                    self.postJobWav.position = CGPoint.init(x: (52*UIScreen.main.bounds.size.width)/320 + 1, y: (52*UIScreen.main.bounds.size.height)/568 + 1)
                    self.postJobWav.haloLayerNumber = 6
                    self.postJobWav.radius = (52*UIScreen.main.bounds.size.width)/320
                    self.postJobWav.animationDuration = 6
                    self.postJobWav.backgroundColor = API.themeColorBlue().cgColor
                    self.viewPostJobWav.layer.addSublayer(self.postJobWav)
                    self.postJobWav.start()
                }
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                if self.btnAvailability.isOn == true
                {
                    self.btnAvailability.isOn = false
                }
                else
                {
                    self.btnAvailability.isOn = true
                }
            }
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            if self.btnAvailability.isOn == true
            {
                self.btnAvailability.isOn = false
            }
            else
            {
                self.btnAvailability.isOn = true
            }
        })
    }
    
    //MARK:- Update Location
    func updateLocation(strLocation: String)
    {
        if strLocation == "" || strLat == "" || strLong == ""
        {
            return
        }
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        parameter.setValue(strLat, forKey: "Latitute")
        parameter.setValue(strLong, forKey: "Longitute")
        parameter.setValue(strLocation, forKey: "LocationName")
        
        print(parameter)
        API.callApiPOST(strUrl: API_SetUserLocation,parameter: parameter, success: { (response) in
            
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
    func setUsersClosestCity()
    {
        if custObj.checkInternet() == false
        {
            return
        }
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(GoogleAutocompleteKey, forKey: "key")
        parameter.setValue(String(format: "%@,%@",strLat,strLong), forKey: "latlng")
        var manager: AFHTTPRequestOperationManager!
        manager = AFHTTPRequestOperationManager(baseURL: URL(string: "https://maps.googleapis.com/maps/api/"))
        manager?.get("geocode/json", parameters: parameter,
                     success: { (op, response) -> Void in
                        
                        let dict: NSDictionary!
                        dict = response as! NSDictionary
                        print(dict)
                        let arrResult: NSArray = dict.object(forKey: "results") as! NSArray
                        if arrResult.count != 0
                        {
                            print((arrResult.object(at: 0) as AnyObject).object(forKey:"formatted_address") ?? "Not found")
                            self.updateLocation(strLocation: (arrResult.object(at: 0) as AnyObject).object(forKey:"formatted_address") as! String)
                        }
        },failure: { (op, fault) -> Void in
            print(op?.error ?? 0)
        })
        
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
        setUsersClosestCity()
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
                    let errorAlert: UIAlertView = UIAlertView(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Your location service is disable, We need your location", comment: ""), delegate: self, cancelButtonTitle: NSLocalizedString("Settings", comment: ""), otherButtonTitles: NSLocalizedString("No", comment: ""))
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
}
extension dashboardSeeker: XMPPStreamDelegate {
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!)
    {
        print("xmppStreamDidAuthenticate")
    }
    
    func xmppStream(_ sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        print("Wrong password or username")
    }
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!)
    {
        print("Did receive message \(message)")
        
    }
    
    func xmppStream(_ sender: XMPPStream!, didSend message: XMPPMessage!)
    {
        print("Did send message \(message)")
        
    }
}
