//
//  regCategoryClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/23/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class regCategoryClass: UIViewController,UITextFieldDelegate
{

    //MARK:- Outlet
    @IBOutlet weak var txtSearch: paddingTextField!
    @IBOutlet weak var scrTop: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var scrBottom: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var scrMain: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var btnFinish: UIButton!
    @IBOutlet weak var viewStep: UIView!
    
    var arrSearch: NSMutableArray = NSMutableArray()
    var isFromMyProfile: Bool = false
    var arrOfCategory: NSMutableArray = NSMutableArray()
    var arrOfSelectedCategory: NSMutableArray = NSMutableArray()
    var arrOfMyProfileCategory: NSMutableArray = NSMutableArray()
    var deleObj: AppDelegate!
    let custObj: customClassViewController = customClassViewController()
   //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        txtSearch.placeholder = "Search &/or click tap on '+' to add"
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        getAllCategories()
        
        if isFromMyProfile == true
        {
            btnFinish.setTitle("Save", for: UIControlState.normal)
            viewStep.isHidden = true
            scrMain.frame = CGRect.init(x: scrMain.frame.origin.x, y: scrMain.frame.origin.y - 30, width: scrMain.frame.size.width, height: scrMain.frame.size.height + 30)
        }
        txtSearch.delegate = self
        txtSearch.returnKeyType = UIReturnKeyType.done
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnFinish(_ sender: Any)
    {
        if arrOfSelectedCategory.count == 0
        {
            custObj.alertMessage("Please select atleast one category")
            return
        }
        if isFromMyProfile == false
        {
            let strCatIDs = arrOfSelectedCategory.componentsJoined(by: ",")
            deleObj.dictPosterReg.setValue(strCatIDs, forKey: "Category")
            posterRegister()
        }
        else
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCategoryProfilePoster"), object: arrOfMyProfileCategory)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- TagList Method
    func manageTag(arrTag: NSMutableArray)
    {
        for case let vv as CustomViewSingleButton in self.scrTop.subviews
        {
            vv.removeFromSuperview()
        }
        if arrTag.count == 0
        {
            return
        }
        for case let vv as CustomViewSingleButton in self.scrBottom.subviews
        {
            vv.removeFromSuperview()
        }
        
        var i: Int = 0
        for item in arrTag
        {
            let dd: NSDictionary = item as! NSDictionary
            if dd.object(forKey: "isSelected") as! String == "0"
            {
                let view1 : CustomViewSingleButton = CustomViewSingleButton.init(s: dd.object(forKey: "Name") as! String, image1name: "", image2name: "add", viewBorderColor: API.themeColorBlue(), viewBackColor: API.lightBlueColor())
                
                view1.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width - 40, height: view1.lblText.frame.size.height + 5)
                view1.tag = 2000 + i
                
                
                view1.backgroundColor = API.lightBlueColor()
                view1.layer.borderColor = API.themeColorBlue().cgColor
                view1.layer.borderWidth = 1
                view1.clipsToBounds = true
                
                view1.btnSecondOutlet.tag = i
                
                view1.btnSecondOutlet.addTarget(self, action: #selector(self.btnAddTagToSelected(_:)), for: UIControlEvents.touchUpInside)
                scrTop.addSubview(view1)
                self.view.layoutIfNeeded()
                
                
            }
            if dd.object(forKey: "isSelected") as! String == "2"
            {
                let view1 : CustomViewSingleButton = CustomViewSingleButton.init(s: dd.object(forKey: "Name") as! String, image1name: "", image2name: "add", viewBorderColor: API.themeColorBlue(), viewBackColor: API.lightBlueColor())
                
                view1.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width - 40, height: view1.lblText.frame.size.height + 5)
                view1.tag = 2000 + i
                
                
                view1.backgroundColor = API.lightBlueColor()
                view1.layer.borderColor = API.themeColorBlue().cgColor
                view1.layer.borderWidth = 1
                view1.clipsToBounds = true
                
                view1.btnSecondOutlet.tag = i
                
                view1.btnSecondOutlet.addTarget(self, action: #selector(self.btnAddTagToSelected(_:)), for: UIControlEvents.touchUpInside)
                scrTop.addSubview(view1)
                self.view.layoutIfNeeded()
            }
            if dd.object(forKey: "isSelected") as! String == "1"
            {
                //let view1 : CustomViewSingleButton = CustomViewSingleButton.init(s: dd.object(forKey: "tag") as! String, image1name: "", image2name: "remove")
                let view1 : CustomViewSingleButton = CustomViewSingleButton.init(s: dd.object(forKey: "Name") as! String, image1name: "", image2name: "remove", viewBorderColor: API.lightPinkColor(), viewBackColor: API.lightPinkColor())
                
                view1.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width - 40, height: view1.lblText.frame.size.height + 5)
                view1.tag = 2000 + i
                
                view1.backgroundColor = API.lightPinkColor()
                view1.layer.borderColor = API.themeColorPink().cgColor
                view1.layer.borderWidth = 1
                view1.clipsToBounds = true
                
                view1.btnSecondOutlet.tag = i
                
                view1.btnSecondOutlet.addTarget(self, action: #selector(self.btnRemoveTagFromSelected(_:)), for: UIControlEvents.touchUpInside)
                scrBottom.addSubview(view1)
                self.view.layoutIfNeeded()
            }
            i = i + 1
        }
        arrangeTags(scr: scrTop)
        arrangeTags(scr: scrBottom)
    }
    func arrangeTags(scr: TPKeyboardAvoidingScrollView)
    {
        var prevViewWidth : CGFloat = 10
        var prevViewY : CGFloat = 10
        
        for v in scr.subviews
        {
            print(v.tag)
            if(v.tag >= 2000 && v.tag < 99999)
            {
                if(v is CustomViewSingleButton)
                {
                    let cv : CustomViewSingleButton = v as! CustomViewSingleButton
                    
                    if(scr.subviews.contains(cv))
                    {
                        if(((prevViewWidth + (cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2)) <= scr.frame.size.width - 20))
                        {
                            cv.frame = CGRect.init(x: prevViewWidth, y: prevViewY, width: cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2, height: cv.lblText.frame.size.height + 5)
                        }
                        else
                        {
                            prevViewWidth = 10
                            cv.frame = CGRect.init(x: prevViewWidth, y: prevViewY, width: cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2, height: cv.lblText.frame.size.height + 5)
                        }
                        
                        let start : Int = (v.tag - 2000) + 1
                        var nextTag : Int = 2000+start
                        
                        for j in start..<arrOfCategory.count
                        {
                            let dd: NSDictionary = (arrOfCategory.object(at: j) as! NSDictionary)
                            
                            if(scr == self.scrTop)
                            {
                                if dd.object(forKey: "isSelected") as! String == "0" || dd.object(forKey: "isSelected") as! String == "2"
                                {
                                    nextTag = 2000 + j
                                    break
                                }
                            }
                            else if(scr == self.scrBottom)
                            {
                                if dd.object(forKey: "isSelected") as! String == "1"
                                {
                                    nextTag = 2000 + j
                                    break
                                }
                            }
                        }
                        
                        
                        if(self.view.viewWithTag(nextTag) != nil)
                        {
                            let nextView : CustomViewSingleButton = self.view.viewWithTag(nextTag) as! CustomViewSingleButton
                            
                            if(!((prevViewWidth + (cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2) + (nextView.btnSecondOutlet.frame.origin.x + nextView.btnSecondOutlet.frame.size.width + 2)) <= scr.frame.size.width - 20))
                            {
                                prevViewY = cv.frame.origin.y + cv.frame.size.height + 5
                            }
                        }
                        
                        cv.layer.cornerRadius = 13//cv.frame.size.height / 2
                        cv.clipsToBounds = true
                        prevViewWidth = cv.frame.size.width + cv.frame.origin.x + 2
                    }
                }
            }
        }
        scr.contentSizeToFit()
    }
    @IBAction func btnAddTagToSelected(_ sender: Any)
    {
        let tag: Int = (sender as AnyObject).tag
        let dd: NSDictionary = arrOfCategory.object(at: tag) as! NSDictionary
        let dictTag: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        dictTag.setValue("1", forKey: "isSelected")
        arrOfCategory.replaceObject(at: tag, with: dictTag)
        manageTag(arrTag: arrOfCategory)
        arrOfSelectedCategory.add(dictTag.value(forKey: "ID") ?? 0)
        print(arrOfSelectedCategory)
        if isFromMyProfile == true
        {
            arrOfMyProfileCategory.add(dictTag)
        }
    }
    @IBAction func btnRemoveTagFromSelected(_ sender: Any)
    {
        let tag: Int = (sender as AnyObject).tag
        let dd: NSDictionary = arrOfCategory.object(at: tag) as! NSDictionary
        let dictTag: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        dictTag.setValue("0", forKey: "isSelected")
        arrOfCategory.replaceObject(at: tag, with: dictTag)
        manageTag(arrTag: arrOfCategory)
        arrOfSelectedCategory.remove(dictTag.value(forKey: "ID") ?? 0)
        if isFromMyProfile == true
        {
            for item in arrOfMyProfileCategory
            {
                let dd = item as! NSDictionary
                if dd.object(forKey: "ID") as! Int == dictTag.value(forKey: "ID") as! Int
                {
                    arrOfMyProfileCategory.remove(dd)
                    break
                }
            }
        }
    }
    //MARK:- Call API
    func getAllCategories()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        print(parameter)
        API.callApiPOST(strUrl: API_GET_ALL_CATEGPRY,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                var i: Int = 0
                self.arrOfCategory = NSMutableArray()
                for item in arr
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    
                    if self.isFromMyProfile == false
                    {
                        dictMutable.setValue(i, forKey: "index")
                        dictMutable.setValue("0", forKey: "isSelected")
                        self.arrOfCategory.add(dictMutable)
                    }
                    else
                    {
                        var dictCate: NSDictionary!
                        var flag: Bool = false
                        for item1 in self.arrOfMyProfileCategory
                        {
                            dictCate = item1 as! NSDictionary
                            if dictCate.object(forKey: "ID") as! Int == dictMutable.object(forKey: "ID") as! Int
                            {
                                flag = true
                                break
                            }
                        }
                        if flag == true
                        {
                            dictMutable.setValue(i, forKey: "index")
                            dictMutable.setValue("1", forKey: "isSelected")
                            self.arrOfSelectedCategory.add(dictMutable.object(forKey: "ID") ?? 0)
                        }
                        else
                        {
                            dictMutable.setValue(i, forKey: "index")
                            dictMutable.setValue("0", forKey: "isSelected")
                        }
                        self.arrOfCategory.add(dictMutable)
                    }
                    i = i + 1
                }
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.manageTag(arrTag: self.arrOfCategory)
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    //MARK:- textField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtSearch
        {
            var serachText = ""
            if txtSearch.text?.characters.count == 0
            {
                serachText = string
            }
            else if range.location > 0 && range.length == 1 && string.characters.count == 0 {
                serachText = (txtSearch.text?.substring(to: (txtSearch.text?.index((txtSearch.text?.startIndex)!, offsetBy: (txtSearch.text?.characters.count)! - 1))!))!
            }
            else if string.characters.count == 0 && txtSearch.text?.characters.count == 1 {
                serachText = ""
            }
            else if string.characters.count == 0 && (txtSearch.text?.characters.count)! > 1
            {
                serachText = ""
            }
            else
            {
                serachText = (txtSearch.text?.appending(string))!
            }
            if serachText.length == 0
            {
                txtSearch.text = ""
                arrSearch = NSMutableArray()
                for item in arrOfCategory
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    if dd.object(forKey: "isSelected") as! String == "0" || dd.object(forKey: "isSelected") as! String == "3" || dd.object(forKey: "isSelected") as! String == "2"
                    {
                        dictMutable.setValue("0", forKey: "isSelected")
                    }
                    arrSearch.add(dictMutable)
                }
                arrOfCategory = NSMutableArray.init(array: arrSearch)
                manageTag(arrTag: arrOfCategory)
            }
            else
            {
                
                arrSearch = NSMutableArray()
                for item in arrOfCategory
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    if dd.object(forKey: "isSelected") as! String == "0" || dd.object(forKey: "isSelected") as! String == "3" || dd.object(forKey: "isSelected") as! String == "2"
                    {
                        dictMutable.setValue("0", forKey: "isSelected")
                    }
                    arrSearch.add(dictMutable)
                }
                arrOfCategory = NSMutableArray.init(array: arrSearch)
                arrSearch = NSMutableArray()
                for item in arrOfCategory
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    if dd.object(forKey: "isSelected") as! String == "0" || dd.object(forKey: "isSelected") as! String == "3"
                    {
                        let str: String = dd.object(forKey: "Name") as! String
                        if str.lowercased().contains(serachText.lowercased())
                        {
                            //arrSearch.add(dd)
                            dictMutable.setValue("2", forKey: "isSelected")
                        }
                        else
                        {
                            dictMutable.setValue("3", forKey: "isSelected")
                        }
                    }
                    arrSearch.add(dictMutable)
                }
                arrOfCategory = NSMutableArray.init(array: arrSearch)
                manageTag(arrTag: arrOfCategory)
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        view.endEditing(true)
        return true
    }
    //MARK:- Call API
    func posterRegister()
    {
        print(deleObj.dictPosterReg)
        custObj.showSVHud("Loading")
        
        API.callApiPOST(strUrl: API_POSTER_REGISTER,parameter: deleObj.dictPosterReg, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let firstObj: NSArray = response.object(forKey: "Data") as! NSArray
                let result: NSDictionary = firstObj.object(at: 0) as! NSDictionary
                let dictData: NSMutableDictionary = NSMutableDictionary.init(dictionary: result)
                //let dictData: NSMutableDictionary = self.custObj.dictionaryByReplacingNulls(withStrings:result.mutableCopy() as! NSMutableDictionary)
                
                API.setXMPPUSER(type: dictData.object(forKey: JID) as! String)
                API.setXMPPPWD(type: dictData.object(forKey: "JPassword") as! String)
                API.setLoggedUserData(dict: dictData)
                API.setUserId(user_id: dictData.object(forKey: "UserID") as! String)
                API.setIsLogin(type: true)
                let dashboard: dashboardPoster = self.storyboard!.instantiateViewController(withIdentifier: "dashboardPoster") as! dashboardPoster
                let homeNavigation = UINavigationController(rootViewController: dashboard)
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
}
