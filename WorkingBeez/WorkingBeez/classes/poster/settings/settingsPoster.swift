//
//  settingsPoster.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/23/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class settingsPoster: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    //MARK:- Outlet
    @IBOutlet weak var tblSettings: UITableView!
    @IBOutlet weak var srcSettings: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var tblLocation: UITableView!
    @IBOutlet weak var lblManageNoti: UILabel!
    @IBOutlet weak var lblLocationSetting: UILabel!
    
    var indexSwitch: Int = 0
    var dictSetting: NSDictionary!
    var arrOfLocation: NSMutableArray = NSMutableArray()
    var arrOfNotification: NSMutableArray = NSMutableArray()
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblSettings.delegate = self
        tblSettings.dataSource = self
        
        tblLocation.delegate = self
        tblLocation.dataSource = self
        
        
        self.tblSettings.isHidden = true
        self.tblLocation.isHidden = true
        
        lblLocationSetting.isHidden = true
        lblManageNoti.isHidden = true
        
        tblSettings.isScrollEnabled = false
        tblLocation.isScrollEnabled = false
        lblManageNoti.frame = CGRect.init(x: lblManageNoti.frame.origin.x, y: tblLocation.frame.size.height + tblLocation.frame.origin.y + 8, width: lblManageNoti.frame.size.width, height: lblManageNoti.frame.size.height)
        tblSettings.frame = CGRect.init(x: tblSettings.frame.origin.x, y: lblManageNoti.frame.size.height + lblManageNoti.frame.origin.y + 8, width: tblSettings.frame.size.width, height: tblSettings.frame.size.height)
        
        srcSettings.contentSizeToFit()
        
        tblSettings.layer.cornerRadius = (10*UIScreen.main.bounds.size.width)/320
        tblSettings.layer.borderWidth = 1
        tblSettings.layer.borderColor = API.dividerColor().cgColor
        tblSettings.clipsToBounds = true
        
        
        tblLocation.layer.cornerRadius = (10*UIScreen.main.bounds.size.width)/320
        tblLocation.layer.borderWidth = 1
        tblLocation.layer.borderColor = API.dividerColor().cgColor
        tblLocation.clipsToBounds = true
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
        
        dictSetting = arrOfNotification.object(at: indexSwitch) as! NSDictionary
        setOnOff()
    }
    
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblLocation
        {
            return arrOfLocation.count
        }
        return arrOfNotification.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblLocation
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! customCellSwift
            
            let dd: NSDictionary = arrOfLocation.object(at: indexPath.row) as! NSDictionary
            cell.lblLocationName.text = dd.object(forKey: "BaseName") as? String
            cell.lblActualAddress.text = dd.object(forKey: "LocationName") as? String
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellNoti", for: indexPath as IndexPath) as! customCellSwift
            let dd: NSDictionary = arrOfNotification.object(at: indexPath.row) as! NSDictionary
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
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == tblLocation
        {
            let obj: addLocationClass = self.storyboard?.instantiateViewController(withIdentifier: "addLocationClass") as! addLocationClass
            obj.dictFromSetting = arrOfLocation.object(at: indexPath.row) as! NSDictionary
            obj.fromWhere = "setting"
            obj.objSetting = self
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (44*UIScreen.main.bounds.size.height)/568
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if tableView == tblLocation
        {
            let dd: NSDictionary = arrOfLocation.object(at: indexPath.row) as! NSDictionary
            if dd.object(forKey: "ID") as! Int == -1 || indexPath.row == 0
            {
                return false
            }
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let dd: NSDictionary = arrOfLocation.object(at: indexPath.row) as! NSDictionary
            deletLocation(dd: dd)
        }
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
                let arrLoc: NSArray = response.object(forKey: "Location") as! NSArray
                self.arrOfLocation = NSMutableArray.init(array: arrLoc)
                if self.arrOfLocation.count < 4
                {
                    let dict: NSMutableDictionary = NSMutableDictionary()
                    dict.setValue("Add more", forKey: "BaseName")
                    dict.setValue(-1, forKey: "ID")
                    dict.setValue("", forKey: "Latitude")
                    dict.setValue("", forKey: "Longitude")
                    dict.setValue("", forKey: "LocationName")
                    self.arrOfLocation.add(dict)
                }
                
                let arrNoti: NSArray = response.object(forKey: "ManageNotifications") as! NSArray
                self.arrOfNotification = NSMutableArray.init(array: arrNoti)
                self.tblSettings.isHidden = false
                self.tblLocation.isHidden = false
                self.lblLocationSetting.isHidden = false
                self.lblManageNoti.isHidden = false
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.tblSettings.reloadData()
            self.tblLocation.reloadData()
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
                self.arrOfNotification.replaceObject(at: self.indexSwitch, with: dictMutable)
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
    func deletLocation(dd: NSDictionary)
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(dd.object(forKey: "ID"), forKey: "LocationID")
        
        print(parameter)
        API.callApiPOST(strUrl: API_DeletePosterLocation,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.arrOfLocation.remove(dd)
                self.tblLocation.reloadData()
                self.setFrame()
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
        let dict: NSMutableDictionary = NSMutableDictionary()
        dict.setValue("Add more", forKey: "BaseName")
        dict.setValue(-1, forKey: "ID")
        dict.setValue("", forKey: "Latitude")
        dict.setValue("", forKey: "Longitude")
        dict.setValue("", forKey: "LocationName")
        if self.arrOfLocation.count < 4 && !arrOfLocation.contains(dict)
        {
            self.arrOfLocation.add(dict)
        }
        tblLocation.frame = CGRect.init(x: tblLocation.frame.origin.x, y: tblLocation.frame.origin.y, width: tblLocation.frame.size.width, height: CGFloat(arrOfLocation.count)*((44*UIScreen.main.bounds.size.height)/568) - 1)
        lblManageNoti.frame = CGRect.init(x: lblManageNoti.frame.origin.x, y: tblLocation.frame.origin.y + tblLocation.frame.size.height + 8, width: lblManageNoti.frame.size.width, height: lblManageNoti.frame.size.height)
        tblSettings.frame = CGRect.init(x: tblSettings.frame.origin.x, y: lblManageNoti.frame.origin.y + lblManageNoti.frame.size.height + 8, width: tblSettings.frame.size.width, height: CGFloat(arrOfNotification.count)*((44*UIScreen.main.bounds.size.height)/568) - 1)
        srcSettings.contentSizeToFit()
        tblLocation.reloadData()
    }
}
