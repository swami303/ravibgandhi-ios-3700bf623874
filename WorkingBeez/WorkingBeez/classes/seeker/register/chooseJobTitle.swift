//
//  chooseJobTitle.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/26/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class chooseJobTitle: UIViewController,UITextFieldDelegate
{
    
    //MARK:- Outlet
    @IBOutlet weak var lblStep1: cLable!
    @IBOutlet weak var lblStep2: cLable!
    @IBOutlet weak var lblStep3: cLable!
    @IBOutlet weak var lblStep4: cLable!
    @IBOutlet weak var lblStep5: cLable!
    @IBOutlet weak var lblSelectedStep: cLable!
    
    @IBOutlet weak var viewStep: UIView!
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!
    @IBOutlet weak var lblLine4: UILabel!
    
    
    @IBOutlet weak var txtSearch: paddingTextField!
    
    @IBOutlet weak var scrTop: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var scrBottom: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var scrMain: TPKeyboardAvoidingScrollView!
    
    var arrSearch: NSMutableArray = NSMutableArray()
    var strWhichStep: String = "1"
    var arrOfJobTitle: NSMutableArray = NSMutableArray()
    var arrOfSelectedJobTitle: NSMutableArray = NSMutableArray()
    var arrOfSelectedName: NSMutableArray = NSMutableArray()
    
    var deleObj: AppDelegate!
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        txtSearch.delegate = self
        txtSearch.returnKeyType = UIReturnKeyType.done
        self.navigationController?.navigationBar.isTranslucent = false
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        
        if deleObj.isForSeekerEdit == true
        {
            viewStep.isHidden = true
            scrMain.frame = CGRect.init(x: scrMain.frame.origin.x, y: scrMain.frame.origin.y - 30, width: scrMain.frame.size.width, height: scrMain.frame.size.height + 30)
        }
        else
        {
            
        }
        if deleObj.dictOfCategories.value(forKey: "CategoryID") as! Int == 0
        {
            txtSearch.placeholder = "Type job title & tap on '+' to add"
            txtSearch.placeHolderColor = API.blackColor()
            if let val = deleObj.dictOfCategories["TitleNames"]
            {
                let strTitle: String = deleObj.dictOfCategories.object(forKey: "TitleNames") as! String
                let arrTitle = strTitle.components(separatedBy: ",")
                var i: Int = 0
                for str in arrTitle
                {
                    if str == ""
                    {
                        
                    }
                    else
                    {
                        arrOfSelectedName.add(str)
                        arrOfSelectedJobTitle.add(0)
                        let dictMutable: NSMutableDictionary = NSMutableDictionary()
                        dictMutable.setValue(i, forKey: "index")
                        dictMutable.setValue("1", forKey: "isSelected")
                        dictMutable.setValue(str, forKey: "Name")
                        dictMutable.setValue(0, forKey: "ID")
                        self.arrOfJobTitle.add(dictMutable)
                        i = i + 1
                    }
                }
            }
            else
            {
                
            }
            manageTag(arrTag: arrOfJobTitle)
        }
        else
        {
            txtSearch.placeholder = "Search &/or click tap on '+' to add"
            getAllJobTitle()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    
    @IBAction func btnNext(_ sender: Any)
    {
        if arrOfSelectedJobTitle.count == 0
        {
            custObj.alertMessage("Please add atleast one job title")
            return
        }
        let strJobIDs = arrOfSelectedJobTitle.componentsJoined(by: ",")
        let strJobNames = arrOfSelectedName.componentsJoined(by: ",")
        deleObj.dictOfCategories.setValue(strJobIDs, forKey: "TitleIDs")
        deleObj.dictOfCategories.setValue(strJobNames, forKey: "TitleNames")
        let obj: chooseCertification = self.storyboard?.instantiateViewController(withIdentifier: "chooseCertification") as! chooseCertification
        self.navigationController!.pushViewController(obj, animated: true)
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
                        
                        for j in start..<arrOfJobTitle.count
                        {
                            let dd: NSDictionary = (arrOfJobTitle.object(at: j) as! NSDictionary)
                            
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
        let dd: NSDictionary = arrOfJobTitle.object(at: tag) as! NSDictionary
        let dictTag: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        dictTag.setValue("1", forKey: "isSelected")
        arrOfJobTitle.replaceObject(at: tag, with: dictTag)
        manageTag(arrTag: arrOfJobTitle)
        arrOfSelectedJobTitle.add(dictTag.value(forKey: "ID") ?? 0)
        arrOfSelectedName.add(dictTag.value(forKey: "Name") ?? 0)
    }
    @IBAction func btnRemoveTagFromSelected(_ sender: Any)
    {
        let tag: Int = (sender as AnyObject).tag
        let dd: NSDictionary = arrOfJobTitle.object(at: tag) as! NSDictionary
        let dictTag: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        dictTag.setValue("0", forKey: "isSelected")
        arrOfJobTitle.replaceObject(at: tag, with: dictTag)
        manageTag(arrTag: arrOfJobTitle)
        arrOfSelectedJobTitle.remove(dictTag.value(forKey: "ID") ?? 0)
        arrOfSelectedName.remove(dictTag.value(forKey: "Name") ?? 0)
        //arrOfSelectedName.removeObject(at: tag)
        //arrOfSelectedJobTitle.removeObject(at: tag)
    }
    //MARK:- textField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if deleObj.dictOfCategories.value(forKey: "CategoryID") as! Int == 0
        {
            return true
        }
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
                for item in arrOfJobTitle
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    if dd.object(forKey: "isSelected") as! String == "0" || dd.object(forKey: "isSelected") as! String == "3" || dd.object(forKey: "isSelected") as! String == "2"
                    {
                        dictMutable.setValue("0", forKey: "isSelected")
                    }
                    arrSearch.add(dictMutable)
                }
                arrOfJobTitle = NSMutableArray.init(array: arrSearch)
                manageTag(arrTag: arrOfJobTitle)
            }
            else
            {
                
                arrSearch = NSMutableArray()
                for item in arrOfJobTitle
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    if dd.object(forKey: "isSelected") as! String == "0" || dd.object(forKey: "isSelected") as! String == "3" || dd.object(forKey: "isSelected") as! String == "2"
                    {
                        dictMutable.setValue("0", forKey: "isSelected")
                    }
                    arrSearch.add(dictMutable)
                }
                arrOfJobTitle = NSMutableArray.init(array: arrSearch)
                arrSearch = NSMutableArray()
                for item in arrOfJobTitle
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
                arrOfJobTitle = NSMutableArray.init(array: arrSearch)
                manageTag(arrTag: arrOfJobTitle)
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if deleObj.dictOfCategories.value(forKey: "CategoryID") as! Int == 0
        {
            if txtSearch.text == ""
            {
                view.endEditing(true)
                return true
            }
            if (txtSearch.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)!
            {
                view.endEditing(true)
                return true
            }
            let dictMutable: NSMutableDictionary = NSMutableDictionary()
            dictMutable.setValue(arrOfJobTitle.count, forKey: "index")
            dictMutable.setValue("0", forKey: "isSelected")
            dictMutable.setValue(txtSearch.text, forKey: "Name")
            dictMutable.setValue(0, forKey: "ID")
            self.arrOfJobTitle.add(dictMutable)
            manageTag(arrTag: arrOfJobTitle)
            txtSearch.text = ""
            view.endEditing(true)
            return true
        }
        view.endEditing(true)
        return true
    }
    //MARK:- Call API
    func getAllJobTitle()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(deleObj.dictOfCategories.value(forKey: "CategoryID"), forKey: "CategoryID")
        print(parameter)
        API.callApiPOST(strUrl: API_GET_ALL_JOB_TITLE,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                var i: Int = 0
                self.arrOfJobTitle = NSMutableArray()
                for item in arr
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    
                    if self.deleObj.isForCatEdit == false
                    {
                        dictMutable.setValue(i, forKey: "index")
                        dictMutable.setValue("0", forKey: "isSelected")
                        self.arrOfJobTitle.add(dictMutable)
                    }
                    else
                    {
                        var arrTitle: NSMutableArray = NSMutableArray()
                        let str: String = self.deleObj.dictOfCategories.object(forKey: "TitleIDs") as! String
                        let sepStr = str.components(separatedBy: ",")
                        let arr: NSArray = sepStr as NSArray
                        arrTitle = NSMutableArray.init(array: arr)
                        if arrTitle.contains(String(format: "%d", dictMutable.object(forKey: "ID") as! Int))
                        {
                            dictMutable.setValue(i, forKey: "index")
                            dictMutable.setValue("1", forKey: "isSelected")
                            self.arrOfSelectedJobTitle.add(dictMutable.object(forKey: "ID") ?? 0)
                            self.arrOfSelectedName.add(dictMutable.object(forKey: "Name") ?? 0)
                        }
                        else
                        {
                            dictMutable.setValue(i, forKey: "index")
                            dictMutable.setValue("0", forKey: "isSelected")
                        }
                        self.arrOfJobTitle.add(dictMutable)
                    }
                    i = i + 1
                }
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.manageTag(arrTag: self.arrOfJobTitle)
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
}
