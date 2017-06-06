//
//  settingsSeeker.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/23/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class settingsSeeker: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    //MARK:- Outlet
    @IBOutlet weak var tblSettings: UITableView!
    @IBOutlet weak var srcSettings: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var lblManageNoti: UILabel!
    
    var indexSwitch: Int = 0
    var dictSetting: NSDictionary!
    var arrOfSetting: NSMutableArray = NSMutableArray()
    
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tblSettings.delegate = self
        tblSettings.dataSource = self
        print(((44*UIScreen.main.bounds.size.height)/568))
        print(UIScreen.main.bounds.size.height)
        
        
        tblSettings.layer.cornerRadius = (10*UIScreen.main.bounds.size.width)/320
        tblSettings.layer.borderWidth = 1
        tblSettings.layer.borderColor = API.dividerColor().cgColor
        tblSettings.clipsToBounds = true
        tblSettings.isHidden = true
        lblManageNoti.isHidden = true
        getUSerSetting()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnLogout(_ sender: Any)
    {
        logout()
    }
    @IBAction func swSeekerOptions(_ sender: Any)
    {
        indexSwitch = (sender as AnyObject).tag
        
        dictSetting = arrOfSetting.object(at: indexSwitch) as! NSDictionary
        setOnOff()
    }
    
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfSetting.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! customCellSwift
        let dd: NSDictionary = arrOfSetting.object(at: indexPath.row) as! NSDictionary
        cell.lblSeekerSettingOptions.text = dd.object(forKey: "SettingName") as? String
        if dd.object(forKey: "Status") as! Bool == true
        {
            cell.swSeekerSettings.isOn = true
        }
        else
        {
            cell.swSeekerSettings.isOn = false
        }
        cell.swSeekerSettings.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (44*UIScreen.main.bounds.size.height)/568
    }
    //MARK:- APi Call
    func getUSerSetting()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        print(parameter)
        API.callApiPOST(strUrl: API_GetUserSettings,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arrNoti: NSArray = response.object(forKey: "ManageNotifications") as! NSArray
                self.arrOfSetting = NSMutableArray.init(array: arrNoti)
                self.tblSettings.isHidden = false
                self.lblManageNoti.isHidden = false
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.tblSettings.reloadData()
            self.setFrame()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    func setOnOff()
    {
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        parameter.setValue(dictSetting.object(forKey: "SettingID"), forKey: "SettingID")
        if dictSetting.object(forKey: "Status") as! Bool == false
        {
            parameter.setValue(true, forKey: "Status")
        }
        else
        {
            parameter.setValue(false, forKey: "Status")
        }
        print(parameter)
        API.callApiPOST(strUrl: API_SetUserSettings,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: self.dictSetting)
                dictMutable.setValue(parameter.object(forKey: "Status"), forKey: "Status")
                self.arrOfSetting.replaceObject(at: self.indexSwitch, with: dictMutable)
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.tblSettings.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    func logout()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        
        print(parameter)
        API.callApiPOST(strUrl: API_Logout,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                if AppDelegate.sharedDelegate().xmppControllerr != nil
                {
                    AppDelegate.sharedDelegate().xmppControllerr.disConnect()
                }
                API.setIsLogin(type: false)
                let obj: landingClass = self.storyboard!.instantiateViewController(withIdentifier: "landingClass") as! landingClass
                let homeNavigation = UINavigationController(rootViewController: obj)
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = homeNavigation
                UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: nil, completion: nil)
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
    func setFrame()
    {
        tblSettings.frame = CGRect.init(x: tblSettings.frame.origin.x, y: tblSettings.frame.origin.y, width: tblSettings.frame.size.width, height: CGFloat(arrOfSetting.count)*((44*UIScreen.main.bounds.size.height)/568) - 1)
        tblSettings.isScrollEnabled = false
        srcSettings.contentSizeToFit()
    }
}
