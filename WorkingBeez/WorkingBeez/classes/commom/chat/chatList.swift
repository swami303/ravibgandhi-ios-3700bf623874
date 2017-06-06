//
//  chatList.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/22/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class chatList: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    @IBOutlet weak var tblChat: UITableView!
    var contentMsg: ContentMessageView!

    var arrOfChatList: NSMutableArray = NSMutableArray()
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        contentMsg = ContentMessageView.CreateView(self.view, strMessage: "No chat found", strImageName: "WB_Font", color: UIColor.lightGray)
        contentMsg.isHidden = true
        tblChat.delegate = self
        tblChat.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool)
    {
        getChatList()
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
        return arrOfChatList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath as IndexPath) as! customCellSwift
        let dd: NSDictionary = arrOfChatList.object(at: indexPath.row) as! NSDictionary
        cell.lblLastMessage.text = dd.object(forKey: "MessageText") as? String
        cell.lblMessageTime.text = dd.object(forKey: "DateText") as? String
        
        if API.getRoleName().lowercased() == "Poster".lowercased()
        {
            cell.lblUserName.text = dd.object(forKey: "Name") as? String
            cell.lblUserStatus.isHidden = false
            if dd.object(forKey: "IsAvailable") as! Bool == true
            {
                cell.lblUserStatus.backgroundColor = API.onlineColor()
            }
            else
            {
                cell.lblUserStatus.backgroundColor = API.offline()
            }
        }
        else
        {
            cell.lblUserName.text = dd.object(forKey: "CompanyName") as? String
            cell.lblUserStatus.isHidden = true
        }
        cell.imgUserImage.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
        cell.imgUserImage.tag = indexPath.row
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGestureRecognizer:)))
        cell.imgUserImage.isUserInteractionEnabled = true
        cell.imgUserImage.addGestureRecognizer(tapGestureRecognizer)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dd: NSDictionary = arrOfChatList.object(at: indexPath.row) as! NSDictionary
        let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        let obj: chatDetail = self.storyboard?.instantiateViewController(withIdentifier: "chatDetail") as! chatDetail
        obj.dictFrom = dictMutable
        self.navigationController!.pushViewController(obj, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 76
    }
    //MARK:- GO TO SEEKER PROFILE
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tag: Int = (tapGestureRecognizer.view?.tag)!
        var dd: NSDictionary = NSDictionary()
        dd = arrOfChatList.object(at: tag) as! NSDictionary
        if API.getRoleName().lowercased() == "Seeker".lowercased()
        {
            let obj: posterProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "posterProfileClass") as! posterProfileClass
            obj.userId = dd.object(forKey: "UserID") as! String
            self.navigationController!.pushViewController(obj, animated: true)
        }
        else
        {
            let obj: seekerProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "seekerProfileClass") as! seekerProfileClass
            obj.userId = dd.object(forKey: "UserID") as! String
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    //MARK:- Call API
    func getChatList()
    {
        arrOfChatList = NSMutableArray()
        tblChat.reloadData()
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        print(parameter)
        API.callApiPOST(strUrl: API_GetMessageList,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                for item in arr
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    self.arrOfChatList.add(dictMutable)
                }
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            if self.arrOfChatList.count == 0
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
