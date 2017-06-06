//
//  notificationClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/4/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class notificationClass: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    @IBOutlet weak var tblChat: UITableView!
    var contentMsg: ContentMessageView!
    
    var arrOfNoti: NSMutableArray = NSMutableArray()
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblChat.delegate = self
        tblChat.dataSource = self
        
        contentMsg = ContentMessageView.CreateView(self.view, strMessage: "No records found", strImageName: "WB_Font", color: UIColor.lightGray)
        contentMsg.isHidden = true
        getNotiList()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action zone
    
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfNoti.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath as IndexPath) as! customCellSwift
        cell.lblUserStatus.isHidden = true
        let dd: NSDictionary = arrOfNoti.object(at: indexPath.row) as! NSDictionary
        cell.lblUserName.text = ""//"WorkingBeez"//dd.object(forKey: "Name") as? String
        cell.lblLastMessage.text = dd.object(forKey: "Text") as? String
        cell.lblMessageTime.text = dd.object(forKey: "DateText") as? String
        cell.imgUserImage.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 76
    }
    
    //MARK:- Call API
    func getNotiList()
    {
        arrOfNoti = NSMutableArray()
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        print(parameter)
        API.callApiPOST(strUrl: API_GetNotificationList,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                for item in arr
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    self.arrOfNoti.add(dictMutable)
                }
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            if self.arrOfNoti.count == 0
            {
                self.contentMsg.isHidden = false
            }
            else
            {
                self.contentMsg.isHidden = true
            }
            self.tblChat.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.contentMsg.isHidden = false
        })
    }
}
