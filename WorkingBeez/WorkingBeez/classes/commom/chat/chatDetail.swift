//
//  chatDetail.swift
//  RatherMe
//
//  Created by Swami on 1/2/17.
//  Copyright © 2017 brainstorm. All rights reserved.
//

import UIKit
import XMPPFramework
import FirebaseMessaging
class chatDetail: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{
    //MARK:- Outlet
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var viewSend: UIView!
    @IBOutlet weak var txtMessage: paddingTextField!
   
    var dictLoggedUser: NSDictionary!
    var strFrom: String = ""
    var strToUserId: String = ""
    var strToXMPPZabbarID: String = ""
    var strToUserName: String = ""
    var strFromUserName: String = ""
    var strFromUserID: String = ""
    
    var deleObj: AppDelegate!
    var dictFrom: NSMutableDictionary = NSMutableDictionary()
    var fromWhere: String = ""
    var contentMsg: ContentMessageView!
    var arrOfMsg: NSMutableArray = NSMutableArray()
    //MARK:- View Cycle
     let custObj: customClassViewController = customClassViewController()
    override func viewDidLoad()
    {
        super.viewDidLoad()

        dictLoggedUser = NSMutableDictionary.init(dictionary: API.getLoggedUserData())
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        dictLoggedUser = NSMutableDictionary.init(dictionary: API.getLoggedUserData())
        contentMsg = ContentMessageView.CreateView(self.view, strMessage: "No records found", strImageName: "WB_Font", color: UIColor.lightGray)
        contentMsg.isHidden = true
        
        self.tblChat.dataSource = self
        self.tblChat.delegate = self
        tblChat.register(UINib(nibName: "recieverCell", bundle: nil), forCellReuseIdentifier: "recieverCell")
        tblChat.register(UINib(nibName: "senderCell", bundle: nil), forCellReuseIdentifier: "senderCell")
        self.tblChat.rowHeight = UITableViewAutomaticDimension
        self.tblChat.estimatedRowHeight = 50
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let logo = UIImage(named: "userPlaceholder")
        let userImage = UIImageView(image:logo)
        userImage.frame = CGRect.init(x: 0, y: 4, width: 36, height: 36)
        userImage.layer.cornerRadius = 18
        userImage.clipsToBounds = true
        
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = API.themeColorBlue().cgColor
        
        let headerView: UIView = UIView()
        headerView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
        headerView.addSubview(userImage)
        let lblUserName: UILabel = UILabel()
        
        lblUserName.frame = CGRect.init(x: 40, y: 0, width: 200, height: 44)
        lblUserName.font = UIFont.init(name: font_openSans_regular, size: 14)
        lblUserName.numberOfLines = 2
        lblUserName.lineBreakMode = NSLineBreakMode.byWordWrapping
        if API.getRoleName().lowercased() == "Poster".lowercased()
        {
            lblUserName.text = dictFrom.object(forKey: "Name") as! String?
            strToUserName = lblUserName.text!
            userImage.sd_setImage(with: NSURL.init(string: (dictFrom.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
            
            if dictLoggedUser.object(forKey: "NameOfBusiness") as! String == ""
            {
                strFromUserName = String(format: "%@ %@", dictLoggedUser.object(forKey: "FirstName") as! String,dictLoggedUser.object(forKey: "LastName") as! String)
            }
            else
            {
                strFromUserName = String(format: "%@", dictLoggedUser.object(forKey: "NameOfBusiness") as! String)
            }
        }
        else
        {
            lblUserName.text = dictFrom.object(forKey: "CompanyName") as! String?
            strToUserName = lblUserName.text!
            userImage.sd_setImage(with: NSURL.init(string: (dictFrom.object(forKey: "ProfilePicPath") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
            strFromUserName = String(format: "%@ %@", dictLoggedUser.object(forKey: "FirstName") as! String,dictLoggedUser.object(forKey: "LastName") as! String)
        }
        
        strToUserId = dictFrom.object(forKey: "UserID") as! String
        strFromUserID = dictLoggedUser.object(forKey: "UserID") as! String
        
        lblUserName.textColor = API.blackColor()
        headerView.addSubview(lblUserName)
        
        self.navigationItem.titleView = headerView
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadMsg), name: NSNotification.Name(rawValue: "reloadMsg"), object: nil)
        txtMessage.delegate = self
        
        deleObj.currentUserIdForChat = strToUserId
        
        getChatDetail()
//        if API.getRoleName().lowercased() == "seeker"
//        {
//            self.navigationItem.rightBarButtonItem = nil
//        }
        self.navigationItem.rightBarButtonItem = nil
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        deleObj.currentUserIdForChat = ""
    }
    //MARK:- POST NOTIFICATION
    func reloadMsg(n: NSNotification)
    {
        let dd: NSDictionary = n.object as! NSDictionary
        
        print(dd)
        arrOfMsg.add(dd)
        tblChat.reloadData()
        self.tblChat.scrollToRow(at: IndexPath(row: self.arrOfMsg.count - 1, section: 0), at: .top, animated: false)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSend(_ sender: Any)
    {
        if custObj.checkInternet() == false
        {
            return
        }
        if txtMessage.text == ""
        {
            return
        }
        if (txtMessage.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)!
        {
            return
        }
        print(dictFrom)
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "dd MMM yyyy hh:mm a"
        let dictToSend: NSMutableDictionary = NSMutableDictionary()
        dictToSend.setValue(API.getToken(), forKey: "Token")
        dictToSend.setValue(API.getDeviceToken(), forKey: "DeviceID")
        dictToSend.setValue(dictFrom.object(forKey: "ID"), forKey: "AcceptedID")
        dictToSend.setValue(df.string(from: Date()), forKey: "DateText")
        dictToSend.setValue(API.getUserId(), forKey: "FromUserID")
        dictToSend.setValue(strFromUserName, forKey: "FromUserName")
        dictToSend.setValue(0, forKey: "MessageId")
        dictToSend.setValue((dictLoggedUser.object(forKey: "ProfilePic")), forKey: "ProfilePic")
        dictToSend.setValue(txtMessage.text, forKey: "MessageText")
        dictToSend.setValue(strToUserId, forKey: "ToUserID")
        dictToSend.setValue(strToUserName, forKey: "ToUserName")
        dictToSend.setValue(API.getXMPPUSER(), forKey: "FromJID")
        dictToSend.setValue(dictFrom.object(forKey: "JID"), forKey: "ToJID")
        dictToSend.setValue(dictLoggedUser.object(forKey: "MobileNo"), forKey: "MobileNo")
        
        print(dictToSend)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: dictToSend, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        print(jsonString)
        
        
        let body = DDXMLElement.element(withName: "body") as! DDXMLElement
        body.stringValue = jsonString
        
        let message = DDXMLElement.element(withName: "message") as! DDXMLElement
        
        message.addAttribute(withName: "type", stringValue: "chat")
        message.addAttribute(withName: "to", stringValue: dictFrom.object(forKey: "JID") as! String)
        message.addChild(body)
        
        AppDelegate.sharedDelegate().xmppControllerr.xmppStream.send(message)
        txtMessage.text = ""
        
        sendPush(dict: dictToSend)
    }
    @IBAction func btnCall(_ sender: Any)
    {
        let number: String = dictFrom.object(forKey: "MobileNo") as! String
        if let url = URL(string:"tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfMsg.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dd: NSDictionary = arrOfMsg.object(at: indexPath.row) as! NSDictionary
        if dd.object(forKey: "FromUserID") as! String == API.getUserId()
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as! senderCell
            cell.lblMsg.text = dd.object(forKey: "MessageText") as? String
            cell.lblMsgBackground.layer.cornerRadius = 10
            cell.lblMsgBackground.clipsToBounds = true
            cell.btnMsgTime.setTitle(dd.object(forKey: "DateText") as? String, for: UIControlState.normal)
            cell.imgRightTail.tintColor = API.themeColorBlue()
            cell.lblMsgBackground.backgroundColor = API.themeColorBlue()
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recieverCell", for: indexPath) as! recieverCell
            cell.lblMsg.text = dd.object(forKey: "MessageText") as? String
            cell.lblMsgBackground.layer.cornerRadius = 10
            cell.lblMsgBackground.clipsToBounds = true
            cell.lblMsgTime.text = dd.object(forKey: "DateText") as? String
            
            cell.imgleftTail.tintColor = UIColor.init(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
            cell.lblMsgBackground.backgroundColor = UIColor.init(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.view.endEditing(true)
    }
    
    
    //MARK:- set chat setting
    func keyboardWillShow(pnotification:NSNotification)
    {
        // Get the size of the keyboard.
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.20)
        
        var height: CGFloat = 0.0
        
        if let userInfo = pnotification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
                // ...
                height = keyboardSize.height
                
            } else {
                // no UIKeyboardFrameBeginUserInfoKey entry in userInfo
            }
        } else {
            // no userInfo dictionary in notification
        }
        viewSend.frame = CGRect(x: 0, y: viewSend.frame.origin.y-height, width: viewSend.frame.size.width, height: viewSend.frame.size.height)
        tblChat.frame = CGRect(x: tblChat.frame.origin.x, y: tblChat.frame.origin.y, width: tblChat.frame.size.width, height: tblChat.frame.height-height)
        UIView.commitAnimations()
        if self.arrOfMsg.count > 0
        {
            self.tblChat.scrollToRow(at: IndexPath(row: self.arrOfMsg.count - 1, section: 0), at: .top, animated: false)
        }
    }
    
    func keyboardWillHide(pnotification:NSNotification)
    {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.20)
        
        var height: CGFloat = 0.0
        
        if let userInfo = pnotification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
                // ...
                height = keyboardSize.height
                
            } else {
                // no UIKeyboardFrameBeginUserInfoKey entry in userInfo
            }
        } else {
        }
        
        viewSend.frame = CGRect(x: 0, y: view.frame.size.height-viewSend.frame.size.height, width: viewSend.frame.size.width, height: viewSend.frame.size.height)
        tblChat.frame = CGRect(x: tblChat.frame.origin.x, y: tblChat.frame.origin.y, width: tblChat.frame.size.width, height: tblChat.frame.height+height)
        
        UIView.commitAnimations()
        if self.arrOfMsg.count > 0
        {
            self.tblChat.scrollToRow(at: IndexPath(row: self.arrOfMsg.count - 1, section: 0), at: .top, animated: false)
        }
    }

    //MARK:- Call API
    func getChatDetail()
    {
        arrOfMsg = NSMutableArray()
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(dictFrom.object(forKey: "ID"), forKey: "AcceptedID")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        print(parameter)
        API.callApiPOST(strUrl: API_GetMessageDetailList,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                for item in arr
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    self.arrOfMsg.add(dictMutable)
                }
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.tblChat.reloadData()
            if self.arrOfMsg.count > 0
            {
                self.tblChat.scrollToRow(at: IndexPath(row: self.arrOfMsg.count - 1, section: 0), at: .top, animated: false)
            }
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.contentMsg.isHidden = false
        })
    }
    func sendPush(dict:NSMutableDictionary)
    {
        API.callApiPOST(strUrl: API_SaveMesaage,parameter: dict, success: { (response) in
            
            self.custObj.hideSVHud()
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
}
