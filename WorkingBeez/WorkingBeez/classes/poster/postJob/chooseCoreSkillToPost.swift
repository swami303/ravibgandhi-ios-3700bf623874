//
//  chooseCoreSkillToPost.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/26/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class chooseCoreSkillToPost: UIViewController,UITextViewDelegate
{
    
    //MARK:- Outlet
    @IBOutlet weak var lblStep1: cLable!
    @IBOutlet weak var lblStep2: cLable!
    @IBOutlet weak var lblStep3: cLable!
    @IBOutlet weak var lblStep4: cLable!
    @IBOutlet weak var lblStep5: cLable!
    
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!
    @IBOutlet weak var lblLine4: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewStep: UIView!
    @IBOutlet weak var viewBottomStep: UIView!
    
    var fromWhere: String = ""
    var objHistoryEdit: postHisDetail!
    @IBOutlet weak var scrMain: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var viewCertification: UIView!
    @IBOutlet weak var tvAddCertificate: placeholderTextView!
    @IBOutlet weak var lblCharLeft: cLable!
    @IBOutlet weak var scrCertiTopm: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var scrCertiBottom: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var lblCertiSelectedtext: cLable!
    @IBOutlet weak var lblCateHowManyText: cLable!
    
    var arrOfCoreSkill: NSMutableArray = NSMutableArray()
    var arrOfSkillName: NSMutableArray = NSMutableArray()
    var arrOfSelectedCoreSkill: NSMutableArray = NSMutableArray()
    var strWhichStep: String = "1"
    var deleObj: AppDelegate!
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        tvAddCertificate.layer.cornerRadius = 15
        tvAddCertificate.clipsToBounds = true
        if deleObj.dictPosJob.value(forKey: "CategoryID") as! Int == 0
        {
            tvAddCertificate.placeholder = "Type required skills & tap '+' to add"
            if fromWhere == "objPostHisEdit"
            {
                var i: Int = 0
                for item in objHistoryEdit.arrOfSkill
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let DictselectedCerti: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    DictselectedCerti.setValue("1", forKey: "isSelected")
                    DictselectedCerti.setValue(i, forKey: "index")
                    self.arrOfCoreSkill.add(DictselectedCerti)
                    self.arrOfSelectedCoreSkill.add(DictselectedCerti)
                    i = i + 1
                }
                manageTag(arrTag: arrOfCoreSkill)
            }
        }
        else
        {
            tvAddCertificate.placeholder = "Choose from below list by tapping '+' or type yours"
            getAllSkills()
        }
        lblCertiSelectedtext.text = String(format: "Selected core skills %d/8", arrOfSelectedCoreSkill.count)
        if fromWhere == "objPostHisEdit"
        {
            btnNext.setTitle("Done", for: UIControlState.normal)
            viewStep.isHidden = true
            scrMain.frame = CGRect.init(x: scrMain.frame.origin.x, y: scrMain.frame.origin.y - 30, width: scrMain.frame.size.width, height: scrMain.frame.size.height + 30)
        }
        tvAddCertificate.delegate = self
        tvAddCertificate.returnKeyType = UIReturnKeyType.done
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnNext(_ sender: Any)
    {
        if arrOfSelectedCoreSkill.count == 0
        {
            custObj.alertMessage("Please select atleast one core skill")
            return
        }
        if fromWhere == "objPostHisEdit"
        {
            objHistoryEdit.arrOfSkill = NSMutableArray.init(array: arrOfSelectedCoreSkill)
            objHistoryEdit.manageTag(arrTag: objHistoryEdit.arrOfSkill, scr: objHistoryEdit.scrCoreSkill)
            _ = self.navigationController?.popViewController(animated: true)
        }
        else
        {
            let strJobIDs = arrOfSelectedCoreSkill.componentsJoined(by: ",")
            let strJobNames = arrOfSkillName.componentsJoined(by: ",")
            deleObj.dictPosJob.setValue(strJobIDs, forKey: "SkillIDs")
            deleObj.dictPosJob.setValue(strJobNames, forKey: "SkillNames")
            let obj: setExpToPost = self.storyboard?.instantiateViewController(withIdentifier: "setExpToPost") as! setExpToPost
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    
    //MARK:- TagList Method
    func manageTag(arrTag: NSMutableArray)
    {
        lblCertiSelectedtext.text = String(format: "Selected core skills %d/8", arrOfSelectedCoreSkill.count)
        for case let vv as CustomViewSingleButton in self.scrCertiTopm.subviews
        {
            vv.removeFromSuperview()
        }
        if arrTag.count == 0
        {
            return
        }
        for case let vv as CustomViewSingleButton in self.scrCertiBottom.subviews
        {
            vv.removeFromSuperview()
        }
        
        var i: Int = 0
        for item in arrTag
        {
            print(arrTag)
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
                scrCertiTopm.addSubview(view1)
                self.view.layoutIfNeeded()
                
                
            }
            else
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
                scrCertiBottom.addSubview(view1)
                self.view.layoutIfNeeded()
            }
            i = i + 1
        }
        arrangeTags(scr: scrCertiTopm)
        arrangeTags(scr: scrCertiBottom)
        
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
                        
                        for j in start..<arrOfCoreSkill.count
                        {
                            let dd: NSDictionary = (arrOfCoreSkill.object(at: j) as! NSDictionary)
                            
                            if(scr == self.scrCertiTopm)
                            {
                                if dd.object(forKey: "isSelected") as! String == "0"  || dd.object(forKey: "isSelected") as! String == "2"
                                {
                                    nextTag = 2000 + j
                                    break
                                }
                            }
                            else if(scr == self.scrCertiBottom)
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
        if arrOfSelectedCoreSkill.count == 8
        {
            custObj.alertMessage("You can select maximum 8 core skills")
            return
        }
        let tag: Int = (sender as AnyObject).tag
        let dd: NSDictionary = arrOfCoreSkill.object(at: tag) as! NSDictionary
        let dictTag: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        dictTag.setValue("1", forKey: "isSelected")
        arrOfCoreSkill.replaceObject(at: tag, with: dictTag)
        manageTag(arrTag: arrOfCoreSkill)
        if self.fromWhere == "objPostHisEdit"
        {
            arrOfSelectedCoreSkill.add(dictTag)
            if dictTag.object(forKey: "ID") as! Int == 0
            {
                arrOfSkillName.add(dictTag.value(forKey: "Name") ?? 0)
            }
        }
        else
        {
            arrOfSelectedCoreSkill.add(dictTag.value(forKey: "ID") ?? 0)
            if dictTag.object(forKey: "ID") as! Int == 0
            {
                arrOfSkillName.add(dictTag.value(forKey: "Name") ?? 0)
            }
        }
        
        lblCertiSelectedtext.text = String(format: "Selected core skills %d/8", arrOfSelectedCoreSkill.count)
    }
    @IBAction func btnRemoveTagFromSelected(_ sender: Any)
    {
        let tag: Int = (sender as AnyObject).tag
        let dd: NSDictionary = arrOfCoreSkill.object(at: tag) as! NSDictionary
        let dictTag: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        
        if self.fromWhere == "objPostHisEdit"
        {
            arrOfSelectedCoreSkill.remove(dictTag)
            print(arrOfSelectedCoreSkill)
            arrOfSkillName.remove(dictTag.value(forKey: "Name") ?? 0)
        }
        else
        {
            arrOfSelectedCoreSkill.remove(dictTag.value(forKey: "ID") ?? 0)
            if dictTag.object(forKey: "ID") as! Int == 0
            {
                arrOfSkillName.remove(dictTag.value(forKey: "Name") ?? 0)
            }
        }
        dictTag.setValue("0", forKey: "isSelected")
        arrOfCoreSkill.replaceObject(at: tag, with: dictTag)
        manageTag(arrTag: arrOfCoreSkill)
        lblCertiSelectedtext.text = String(format: "Selected core skills %d/8", arrOfSelectedCoreSkill.count)
    }
    //MARK:- TextView delegate
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if textView == tvAddCertificate
        {
            var serachText = ""
            if tvAddCertificate.text?.characters.count == 0
            {
                serachText = text
            }
            else if range.location > 0 && range.length == 1 && text.characters.count == 0 {
                serachText = (tvAddCertificate.text?.substring(to: (tvAddCertificate.text?.index((tvAddCertificate.text?.startIndex)!, offsetBy: (tvAddCertificate.text?.characters.count)! - 1))!))!
            }
            else if text.characters.count == 0 && tvAddCertificate.text?.characters.count == 1 {
                serachText = ""
            }
            else if text.characters.count == 0 && (tvAddCertificate.text?.characters.count)! > 1
            {
                serachText = ""
            }
            else
            {
                serachText = (tvAddCertificate.text?.appending(text))!
            }
            if text == "\n"
            {
                if serachText == "\n"
                {
                    view.endEditing(true)
                    return true
                }
                let dictMutable: NSMutableDictionary = NSMutableDictionary()
                dictMutable.setValue(textView.text, forKey: "Name")
                dictMutable.setValue(arrOfCoreSkill.count - 1, forKey: "index")
                dictMutable.setValue("0", forKey: "isSelected")
                dictMutable.setValue(0, forKey: "ID")
                self.arrOfCoreSkill.insert(dictMutable, at: 0)
                manageTag(arrTag: arrOfCoreSkill)
                view.endEditing(true)
                tvAddCertificate.text = ""
                return true
            }
            
            if serachText.length >= 101
            {
                return false
            }
            
            //print(serachText.length)
        }
        return true
    }
    func textViewDidChangeSelection(_ textView: UITextView)
    {
        lblCharLeft.text = String(format: "%d Left", 100 - textView.text.length)
    }
    //MARK:- Call API
    func getAllSkills()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        if self.fromWhere == "objPostHisEdit"
        {
            parameter.setValue(objHistoryEdit.dictPost.value(forKey: "TitleID"), forKey: "TitleIDs")
        }
        else
        {
            parameter.setValue(deleObj.dictPosJob.value(forKey: "JobTitleID"), forKey: "TitleIDs")
        }
        print(parameter)
        API.callApiPOST(strUrl: API_GET_ALL_SKILLS,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                var i: Int = 0
                self.arrOfCoreSkill = NSMutableArray()
                for item in arr
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    
                    if self.fromWhere == "objPostHisEdit"
                    {
                        var flag: Bool = false
                        var d: NSDictionary!
                        for certi in self.objHistoryEdit.arrOfSkill
                        {
                            d = certi as! NSDictionary
                            if d.object(forKey: "ID") as! Int == dictMutable.object(forKey: "ID") as! Int
                            {
                                flag = true
                                break
                            }
                        }
                        if flag == true
                        {
                            dictMutable.setValue(i, forKey: "index")
                            dictMutable.setValue("1", forKey: "isSelected")
                            let DictselectedCerti: NSMutableDictionary = NSMutableDictionary.init(dictionary: d)
                            DictselectedCerti.setValue(dictMutable.value(forKey: "ID"), forKey: "ID")
                            DictselectedCerti.setValue(dictMutable.value(forKey: "Name"), forKey: "Name")
                            DictselectedCerti.setValue(i, forKey: "index")
                            DictselectedCerti.setValue("1", forKey: "isSelected")
                            
                            self.arrOfSelectedCoreSkill.add(DictselectedCerti)
                        }
                        else
                        {
                            dictMutable.setValue(i, forKey: "index")
                            dictMutable.setValue("0", forKey: "isSelected")
                        }
                        self.arrOfCoreSkill.add(dictMutable)
                    }
                    else
                    {
                        dictMutable.setValue(i, forKey: "index")
                        dictMutable.setValue("0", forKey: "isSelected")
                        self.arrOfCoreSkill.add(dictMutable)
                    }
                    i = i + 1
                }
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            print(self.arrOfCoreSkill)
            self.manageTag(arrTag: self.arrOfCoreSkill)
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
}
