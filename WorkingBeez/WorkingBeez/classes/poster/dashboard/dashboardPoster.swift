//
//  dashboardPoster.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/22/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit
import XMPPFramework
class dashboardPoster: UIViewController
{
    //MARK:- Outlet
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewPostJobWav: UIView!
    @IBOutlet weak var imgPostJobCircle: UIImageView!
    @IBOutlet weak var lblSavedProfileBack: cLable!
    @IBOutlet weak var lblPostCalenderBack: cLable!
    @IBOutlet weak var lblSavedCnt: cLable!
    @IBOutlet weak var lblPostHistoryCnt: cLable!
    @IBOutlet weak var lblPostCalenderCnt: cLable!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgUserPhoto: cImageView!
    @IBOutlet weak var viewRating: HCSStarRatingView!
    @IBOutlet weak var viewPendingPaymentWav: UIView!
    @IBOutlet weak var lblProfileRating: KAProgressLabel!
    
    @IBOutlet weak var lblPostHistoryBack: cLable!
    @IBOutlet weak var lblMatchingCnt: UILabel!
    @IBOutlet weak var lblAppliedCnt: UILabel!
    @IBOutlet weak var lblAcceptedCnt: UILabel!
    @IBOutlet weak var lblRunningCnt: UILabel!
    @IBOutlet weak var lblPPCnt: UILabel!
    @IBOutlet weak var lblCompletedCnt: UILabel!
    
    var timerForDashboard: Timer!
    var PPWav = PulsingHaloLayer()
    var deleObj: AppDelegate!
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
                let obj: allJobStatusPoster = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusPoster") as! allJobStatusPoster
                obj.strNavTitle = "Matching Profile"
                self.navigationController!.pushViewController(obj, animated: true)
            }
            else if dd.object(forKey: "NotificationType") as! String == "4"
            {
                let obj: appliedDetailPoster = self.storyboard?.instantiateViewController(withIdentifier: "appliedDetailPoster") as! appliedDetailPoster
                obj.dictPost = NSMutableDictionary.init(dictionary: dd)
                obj.IsApplied = true
                self.navigationController!.pushViewController(obj, animated: true)
            }
            else if dd.object(forKey: "NotificationType") as! String == "5"
            {
                API.setIsFromNotification(type: false)
                let obj: allJobStatusPoster = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusPoster") as! allJobStatusPoster
                obj.strNavTitle = "Running Job"
                self.navigationController!.pushViewController(obj, animated: true)
            }
            else if dd.object(forKey: "NotificationType") as! String == "6"
            {
                API.setIsFromNotification(type: false)
                let obj: pendingPaymentClass = self.storyboard?.instantiateViewController(withIdentifier: "pendingPaymentClass") as! pendingPaymentClass
                self.navigationController!.pushViewController(obj, animated: true)
            }
            else if dd.object(forKey: "NotificationType") as! String == "7"
            {
                API.setIsFromNotification(type: false)
                let obj: completedJobPoster = self.storyboard?.instantiateViewController(withIdentifier: "completedJobPoster") as! completedJobPoster
                self.navigationController!.pushViewController(obj, animated: true)
            }
            else if dd.object(forKey: "NotificationType") as! String == "8"
            {
                API.setIsFromNotification(type: false)
                let obj: allJobStatusPoster = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusPoster") as! allJobStatusPoster
                obj.strNavTitle = "Accepted Job"
                self.navigationController!.pushViewController(obj, animated: true)
            }
        }
        
        
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
        
        lblPostHistoryCnt.layer.cornerRadius = (10*UIScreen.main.bounds.size.width)/320
        lblPostHistoryCnt.clipsToBounds = true
        
        lblSavedCnt.layer.cornerRadius = (10*UIScreen.main.bounds.size.width)/320
        lblSavedCnt.clipsToBounds = true
        
        lblPostCalenderCnt.layer.cornerRadius = (10*UIScreen.main.bounds.size.width)/320
        lblPostCalenderCnt.clipsToBounds = true
        
        lblPostCalenderCnt.backgroundColor = API.counterBackColor()
        lblSavedCnt.backgroundColor = API.counterBackColor()
        lblPostCalenderCnt.backgroundColor = API.counterBackColor()
        
        imgUserPhoto.layer.cornerRadius = (45*UIScreen.main.bounds.size.width)/320
        imgUserPhoto.clipsToBounds = true
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: API.blackColor(), NSFontAttributeName: UIFont(name: font_openSans_regular, size: 14)!]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = API.NavigationbarColor()
        
        let dd: NSDictionary = API.getLoggedUserData()
        dictUserData = NSMutableDictionary.init(dictionary: dd)
        //API.setXMPPUSER(type: "admin")
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.getDashboardData), name: NSNotification.Name(rawValue: "reloadDashboardPoster"), object: nil)
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
        let postJobWav = PulsingHaloLayer()
        postJobWav.position = CGPoint.init(x: (52*UIScreen.main.bounds.size.width)/320 + 1, y: (52*UIScreen.main.bounds.size.height)/568 + 1)
        postJobWav.haloLayerNumber = 6
        postJobWav.radius = (52*UIScreen.main.bounds.size.width)/320
        postJobWav.animationDuration = 6
        postJobWav.backgroundColor = API.themeColorBlue().cgColor
        viewPostJobWav.layer.addSublayer(postJobWav)
        postJobWav.start()
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
    @IBAction func btnSavedProfile(_ sender: Any)
    {
        let obj: savedProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "savedProfileClass") as! savedProfileClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnPostHistory(_ sender: Any)
    {
        let obj: postHistoryClass = self.storyboard?.instantiateViewController(withIdentifier: "postHistoryClass") as! postHistoryClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnPostCalender(_ sender: Any)
    {
        let obj: calendarPosterClass = self.storyboard?.instantiateViewController(withIdentifier: "calendarPosterClass") as! calendarPosterClass
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
    @IBAction func btnPostJob(_ sender: Any)
    {
        deleObj.dictPosJob = NSMutableDictionary()
        deleObj.arrOfRoster = NSMutableArray()
        let obj: chooseLocationToPost = self.storyboard?.instantiateViewController(withIdentifier: "chooseLocationToPost") as! chooseLocationToPost
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    // MARK:- Job Action
    @IBAction func btnMatchingProfile(_ sender: Any)
    {
        let obj: allJobStatusPoster = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusPoster") as! allJobStatusPoster
        obj.strNavTitle = "Matching Profile"
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnAppliedJob(_ sender: Any)
    {
        let obj: allJobStatusPoster = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusPoster") as! allJobStatusPoster
        obj.strNavTitle = "Applied Job"
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnAcceptedJob(_ sender: Any)
    {
        let obj: allJobStatusPoster = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusPoster") as! allJobStatusPoster
        obj.strNavTitle = "Accepted Job"
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnRunningJob(_ sender: Any)
    {
        let obj: allJobStatusPoster = self.storyboard?.instantiateViewController(withIdentifier: "allJobStatusPoster") as! allJobStatusPoster
        obj.strNavTitle = "Running Job"
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnPendingPayment(_ sender: Any)
    {
        let obj: pendingPaymentClass = self.storyboard?.instantiateViewController(withIdentifier: "pendingPaymentClass") as! pendingPaymentClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnCompletedJob(_ sender: Any)
    {
        let obj: completedJobPoster = self.storyboard?.instantiateViewController(withIdentifier: "completedJobPoster") as! completedJobPoster
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    
    //MARK:- Set Dashboard
    func setDashBoard(dictDashboard: NSMutableDictionary)
    {
        API.setRoleName(role: dictUserData.object(forKey: "RoleName") as! String)
        if dictDashboard.object(forKey: "NameOfBusiness") as! String == ""
        {
            lblName.text = String(format: "%@ %@", dictDashboard.object(forKey: "FirstName") as! String,dictDashboard.object(forKey: "LastName") as! String)
        }
        else
        {
            lblName.text = String(format: "%@", dictDashboard.object(forKey: "NameOfBusiness") as! String)
        }
        lblAddress.text = dictDashboard.object(forKey: "LocationName") as? String
        viewRating.value = CGFloat(dictDashboard.object(forKey: "ProfileRating") as! CGFloat)
        
        lblSavedCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalSavedProfile") as! Int)
        lblPostHistoryCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalPostHistory") as! Int)
        lblPostCalenderCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalPostCalender") as! Int)
        lblMatchingCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalMatch") as! Int)
        lblAppliedCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalAppliedJob") as! Int)
        lblAcceptedCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalAcceptedJob") as! Int)
        lblRunningCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalRunningJob") as! Int)
        lblPPCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalPendingPayment") as! Int)
        lblCompletedCnt.text = String(format: "%d", dictDashboard.object(forKey: "TotalCompletedJob") as! Int)
        
        imgUserPhoto.sd_setImage(with: NSURL.init(string: (dictDashboard.object(forKey: "ProfilePic") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
        
        PPWav.removeFromSuperlayer()
        if lblPPCnt.text != "0"
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
                        let obj: completedJobPoster = self.storyboard?.instantiateViewController(withIdentifier: "completedJobPoster") as! completedJobPoster
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
}
extension dashboardPoster: XMPPStreamDelegate {
    
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
