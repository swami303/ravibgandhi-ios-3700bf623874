//
//  chooseCertiToPost.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/26/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class chooseCertiToPost: UIViewController,UITextViewDelegate
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
    @IBOutlet weak var viewStep: UIView!
    @IBOutlet weak var viewBottomStep: UIView!
    @IBOutlet weak var btnNext: UIButton!
    
    
    @IBOutlet weak var scrMain: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var viewCertification: UIView!
    @IBOutlet weak var tvAddCertificate: placeholderTextView!
    @IBOutlet weak var lblCharLeft: cLable!
    @IBOutlet weak var scrCertiTopm: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var scrCertiBottom: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var lblCertiSelectedtext: cLable!
    @IBOutlet weak var lblCateHowManyText: cLable!
    
    var fromWhere: String = ""
    var objHistoryEdit: postHisDetail!
    var strWhichStep: String = "1"
    var deleObj: AppDelegate!
    var arrOfCerti: NSMutableArray = NSMutableArray()
    var arrOfSelectedCerti: NSMutableArray = NSMutableArray()
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
            tvAddCertificate.placeholder = "Type required Qualification & tap '+' to add"
            if fromWhere == "objPostHisEdit"
            {
                var i: Int = 0
                for item in objHistoryEdit.arrOfCerti
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let DictselectedCerti: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    DictselectedCerti.setValue("1", forKey: "isSelected")
                    DictselectedCerti.setValue(i, forKey: "index")
                    self.arrOfSelectedCerti.add(DictselectedCerti)
                    self.arrOfCerti.add(DictselectedCerti)
                    i = i + 1
                }
                manageTag(arrTag: arrOfCerti)
            }
        }
        else
        {
            tvAddCertificate.placeholder = "Choose from below list by tapping '+' or type yours"
            getAllCertificates()
        }
        lblCertiSelectedtext.text = String(format: "Selected Certification %d/8", arrOfSelectedCerti.count)
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
        if arrOfSelectedCerti.count == 0
        {
            custObj.alertMessage("Please select atleast one certificate")
            return
        }
        if fromWhere == "objPostHisEdit"
        {
            objHistoryEdit.arrOfCerti = NSMutableArray.init(array: arrOfSelectedCerti)
            objHistoryEdit.manageTag(arrTag: objHistoryEdit.arrOfCerti, scr: objHistoryEdit.scrCerti)
            _ = self.navigationController?.popViewController(animated: true)
        }
        else
        {
            deleObj.dictPosJob.setValue(arrOfSelectedCerti, forKey: "CertificateIDs")
            let obj: chooseCoreSkillToPost = self.storyboard?.instantiateViewController(withIdentifier: "chooseCoreSkillToPost") as! chooseCoreSkillToPost
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    
    //MARK:- TagList Method
    func manageTag(arrTag: NSMutableArray)
    {
        lblCertiSelectedtext.text = String(format: "Selected Certification %d/8", arrOfSelectedCerti.count)
        for case let vv as CustomView in self.scrCertiTopm.subviews
        {
            vv.removeFromSuperview()
        }
        if arrTag.count == 0
        {
            return
        }
        for case let vv as CustomView in self.scrCertiBottom.subviews
        {
            vv.removeFromSuperview()
        }
        
        var i: Int = 0
        for item in arrTag
        {
            let dd: NSDictionary = item as! NSDictionary
            if dd.object(forKey: "isSelected") as! String == "0"
            {
                var strCheckImageName: String = ""
                if dd.object(forKey: "IsRequired") as! Bool == false
                {
                    strCheckImageName = "certificationUnCheck"
                }
                else
                {
                    strCheckImageName = "certificationCheck"
                }
                let view1 : CustomView = CustomView.init(s: dd.object(forKey: "Name") as! String, image1name: strCheckImageName, image2name: "add", viewBorderColor: API.themeColorBlue(), viewBackColor: API.lightBlueColor())
                
                view1.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width - 40, height: view1.lblText.frame.size.height + 5)
                view1.tag = 2000 + i
                
                
                view1.backgroundColor = API.lightBlueColor()
                view1.layer.borderColor = API.themeColorBlue().cgColor
                view1.layer.borderWidth = 1
                view1.clipsToBounds = true
                
                view1.btnSecondOutlet.tag = i
                view1.btnFirstOutlet.tag = i
                view1.btnFirstOutlet.tintColor = API.themeColorBlue()
                view1.btnSecondOutlet.addTarget(self, action: #selector(self.btnAddTagToSelected(_:)), for: UIControlEvents.touchUpInside)
                view1.btnFirstOutlet.addTarget(self, action: #selector(self.btnAddToMendatory(_:)), for: UIControlEvents.touchUpInside)
                scrCertiTopm.addSubview(view1)
                self.view.layoutIfNeeded()
            }
            else
            {
                var strCheckImageName: String = ""
                if dd.object(forKey: "IsRequired") as! Bool == false
                {
                    strCheckImageName = "certificationUnCheck"
                }
                else
                {
                    strCheckImageName = "certificationCheck"
                }
                //let view1 : CustomViewSingleButton = CustomViewSingleButton.init(s: dd.object(forKey: "tag") as! String, image1name: "", image2name: "remove")
                let view1 : CustomView = CustomView.init(s: dd.object(forKey: "Name") as! String, image1name: strCheckImageName, image2name: "remove", viewBorderColor: API.lightPinkColor(), viewBackColor: API.lightPinkColor())
                
                view1.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width - 40, height: view1.lblText.frame.size.height + 5)
                view1.tag = 2000 + i
                
                view1.backgroundColor = API.lightPinkColor()
                view1.layer.borderColor = API.themeColorPink().cgColor
                view1.layer.borderWidth = 1
                view1.clipsToBounds = true
                
                view1.btnSecondOutlet.tag = i
                view1.btnFirstOutlet.tag = i
                
                view1.btnSecondOutlet.addTarget(self, action: #selector(self.btnRemoveTagFromSelected(_:)), for: UIControlEvents.touchUpInside)
                view1.btnFirstOutlet.addTarget(self, action: #selector(self.btnAddToMendatory(_:)), for: UIControlEvents.touchUpInside)
                view1.btnFirstOutlet.tintColor = API.themeColorPink()
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
                if(v is CustomView)
                {
                    let cv : CustomView = v as! CustomView
                    
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
                        
                        for j in start..<arrOfCerti.count
                        {
                            let dd: NSDictionary = (arrOfCerti.object(at: j) as! NSDictionary)
                            
                            if(scr == self.scrCertiTopm)
                            {
                                if dd.object(forKey: "isSelected") as! String == "0" || dd.object(forKey: "isSelected") as! String == "2"
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
                            let nextView : CustomView = self.view.viewWithTag(nextTag) as! CustomView
                            
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
        if arrOfSelectedCerti.count == 8
        {
            custObj.alertMessage("You can select maximum 8 certificates")
            return
        }
        let tag: Int = (sender as AnyObject).tag
        let dd: NSDictionary = arrOfCerti.object(at: tag) as! NSDictionary
        let dictTag: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        dictTag.setValue("1", forKey: "isSelected")
        arrOfCerti.replaceObject(at: tag, with: dictTag)
        
        let DictselectedCerti: NSMutableDictionary = NSMutableDictionary()
        if fromWhere == "objPostHisEdit"
        {
            DictselectedCerti.setValue(dictTag.value(forKey: "ID"), forKey: "ID")
            DictselectedCerti.setValue(dictTag.value(forKey: "Name"), forKey: "Name")
            DictselectedCerti.setValue(dictTag.value(forKey: "IsRequired"), forKey: "IsRequired")
        }
        else
        {
            DictselectedCerti.setValue(dictTag.value(forKey: "ID"), forKey: "CertificateID")
            DictselectedCerti.setValue(dictTag.value(forKey: "Name"), forKey: "Name")
            DictselectedCerti.setValue(dictTag.value(forKey: "IsRequired"), forKey: "IsRequired")
        }
        
        
        arrOfSelectedCerti.add(DictselectedCerti)
        manageTag(arrTag: arrOfCerti)
        
        lblCertiSelectedtext.text = String(format: "Selected Certification %d/8", arrOfSelectedCerti.count)
    }
    @IBAction func btnAddToMendatory(_ sender: Any)
    {
        let tag: Int = (sender as AnyObject).tag
        let dd: NSDictionary = arrOfCerti.object(at: tag) as! NSDictionary
        let dictTag: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        if dictTag.object(forKey: "IsRequired") as! Bool == false
        {
            dictTag.setValue(true, forKey: "IsRequired")
        }
        else
        {
            dictTag.setValue(false, forKey: "IsRequired")
        }
        arrOfCerti.replaceObject(at: tag, with: dictTag)
        manageTag(arrTag: arrOfCerti)
        
        var i: Int = 0
        for item in arrOfSelectedCerti
        {
            let dd: NSDictionary = item as! NSDictionary
            if fromWhere == "objPostHisEdit"
            {
                if dd.object(forKey: "ID") as! Int == dictTag.object(forKey: "ID") as! Int
                {
                    arrOfSelectedCerti.replaceObject(at: i, with: dictTag)
                    break
                }
            }
            else
            {
                if dd.object(forKey: "CertificateID") as! Int == dictTag.object(forKey: "ID") as! Int
                {
                    dictTag.setValue(dictTag.object(forKey: "ID"), forKey: "CertificateID")
                    arrOfSelectedCerti.replaceObject(at: i, with: dictTag)
                    break
                }
            }
            i = i + 1
        }
    }
    @IBAction func btnRemoveTagFromSelected(_ sender: Any)
    {
        let tag: Int = (sender as AnyObject).tag
        let dd: NSDictionary = arrOfCerti.object(at: tag) as! NSDictionary
        let dictTag: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        dictTag.setValue("0", forKey: "isSelected")
        arrOfCerti.replaceObject(at: tag, with: dictTag)
        
        var i: Int = 0
        for item in arrOfSelectedCerti
        {
            let dd: NSDictionary = item as! NSDictionary
            if fromWhere == "objPostHisEdit"
            {
                if dd.object(forKey: "ID") as! Int == dictTag.object(forKey: "ID") as! Int
                {
                    break
                }
            }
            else
            {
                if dd.object(forKey: "CertificateID") as! Int == dictTag.object(forKey: "ID") as! Int
                {
                    break
                }
            }
            i = i + 1
        }
        //        let DictselectedCerti: NSMutableDictionary = NSMutableDictionary()
        //        DictselectedCerti.setValue(dictTag.value(forKey: "ID"), forKey: "CertificateID")
        //        DictselectedCerti.setValue(dictTag.value(forKey: "Name"), forKey: "CertificateName")
        
        
        arrOfSelectedCerti.removeObject(at: i)
        manageTag(arrTag: arrOfCerti)
        lblCertiSelectedtext.text = String(format: "Selected Certification %d/8", arrOfSelectedCerti.count)
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
                dictMutable.setValue(arrOfCerti.count - 1, forKey: "index")
                dictMutable.setValue("0", forKey: "isSelected")
                dictMutable.setValue(false, forKey: "IsRequired")
                dictMutable.setValue(0, forKey: "ID")
                self.arrOfCerti.insert(dictMutable, at: 0)
                manageTag(arrTag: arrOfCerti)
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
    func getAllCertificates()
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
        API.callApiPOST(strUrl: API_GET_ALL_CERTIFICATES,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                var i: Int = 0
                self.arrOfCerti = NSMutableArray()
                for item in arr
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    
                    if self.fromWhere == "objPostHisEdit"
                    {
                        var flag: Bool = false
                        var d: NSDictionary!
                        for certi in self.objHistoryEdit.arrOfCerti
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
                            dictMutable.setValue(d.value(forKey: "IsRequired"), forKey: "IsRequired")
                            let DictselectedCerti: NSMutableDictionary = NSMutableDictionary.init(dictionary: d)
                            DictselectedCerti.setValue(dictMutable.value(forKey: "ID"), forKey: "ID")
                            DictselectedCerti.setValue(dictMutable.value(forKey: "Name"), forKey: "Name")
                            DictselectedCerti.setValue(d.value(forKey: "IsRequired"), forKey: "IsRequired")
                            
                            self.arrOfSelectedCerti.add(DictselectedCerti)
                        }
                        else
                        {
                            dictMutable.setValue(i, forKey: "index")
                            dictMutable.setValue("0", forKey: "isSelected")
                        }
                        self.arrOfCerti.add(dictMutable)
                    }
                    else
                    {
                        dictMutable.setValue(i, forKey: "index")
                        dictMutable.setValue("0", forKey: "isSelected")
                        dictMutable.setValue(false, forKey: "IsRequired")
                        self.arrOfCerti.add(dictMutable)
                    }
                    i = i + 1
                }
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.manageTag(arrTag: self.arrOfCerti)
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
}
