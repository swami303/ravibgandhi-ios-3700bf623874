//
//  chooseCertification.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/26/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class chooseCertification: UIViewController,UITextFieldDelegate
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
    
    var deleObj: AppDelegate!

    var arrSearch: NSMutableArray = NSMutableArray()
    var strWhichStep: String = "1"
    var arrOfCerti: NSMutableArray = NSMutableArray()
    var arrOfSelectedCerti: NSMutableArray = NSMutableArray()
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        self.navigationController?.navigationBar.isTranslucent = false
        
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
            txtSearch.placeholder = "Type qualification & tap on '+' to add"
            txtSearch.placeHolderColor = API.blackColor()
            if let val = deleObj.dictOfCategories["CerficateFile"]
            {
                let aa: NSArray = deleObj.dictOfCategories.object(forKey: "CerficateFile") as! NSArray
                for item in aa
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    arrOfSelectedCerti.add(dictMutable)
                    print(dictMutable)
                    dictMutable.setValue("1", forKey: "isSelected")
                    dictMutable.setValue(dictMutable.object(forKey: "CertificateName"), forKey: "Name")
                    dictMutable.setValue(dictMutable.object(forKey: "CertificateID"), forKey: "ID")
                    arrOfCerti.add(dictMutable)
                }
                manageTag(arrTag: arrOfCerti)
            }
            else
            {
                
            }
        }
        else
        {
            txtSearch.placeholder = "Search &/or click tap on '+' to add"
            getAllCertificates()
        }
        lblSelectedStep.text = String(format: "Selected Certification %d/8", arrOfSelectedCerti.count)
        txtSearch.delegate = self
        txtSearch.returnKeyType = UIReturnKeyType.done
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
        deleObj.dictOfCategories.setValue(arrOfSelectedCerti, forKey: "CerficateFile")
        let obj: uploadCertiClass = self.storyboard?.instantiateViewController(withIdentifier: "uploadCertiClass") as! uploadCertiClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    //MARK:- TagList Method
    func manageTag(arrTag: NSMutableArray)
    {
        lblSelectedStep.text = String(format: "Selected Certification %d/8", arrOfSelectedCerti.count)
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
                
                
                //arrangeTags(scr: scrTop)
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
                
                //arrangeTags(scr: scrTop)
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
                //arrangeTags(scr: scrBottom)
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
                        
                        for j in start..<arrOfCerti.count
                        {
                            let dd: NSDictionary = (arrOfCerti.object(at: j) as! NSDictionary)
                            
                            if(scr == self.scrTop)
                            {
                                if dd.object(forKey: "isSelected") as! String == "0"  || dd.object(forKey: "isSelected") as! String == "2"
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
        print(arrOfSelectedCerti)
        let DictselectedCerti: NSMutableDictionary = NSMutableDictionary()
        DictselectedCerti.setValue(dictTag.value(forKey: "ID"), forKey: "CertificateID")
        DictselectedCerti.setValue(dictTag.value(forKey: "Name"), forKey: "CertificateName")
        DictselectedCerti.setValue(dictTag.value(forKey: "IsRequired"), forKey: "IsRequired")
        
        arrOfSelectedCerti.add(DictselectedCerti)
        print(arrOfSelectedCerti)
        manageTag(arrTag: arrOfCerti)
        
        lblSelectedStep.text = String(format: "Selected Certification %d/8", arrOfSelectedCerti.count)
        //txtSearch.text = ""
        view.endEditing(true)
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
            if dd.object(forKey: "CertificateID") as! Int == dictTag.object(forKey: "ID") as! Int
            {
                break
            }
            i = i + 1
        }
//        let DictselectedCerti: NSMutableDictionary = NSMutableDictionary()
//        DictselectedCerti.setValue(dictTag.value(forKey: "ID"), forKey: "CertificateID")
//        DictselectedCerti.setValue(dictTag.value(forKey: "Name"), forKey: "CertificateName")
        
        
        arrOfSelectedCerti.removeObject(at: i)
        manageTag(arrTag: arrOfCerti)
        lblSelectedStep.text = String(format: "Selected Certification %d/8", arrOfSelectedCerti.count)
        txtSearch.text = ""
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
                for item in arrOfCerti
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    if dd.object(forKey: "isSelected") as! String == "0" || dd.object(forKey: "isSelected") as! String == "3" || dd.object(forKey: "isSelected") as! String == "2"
                    {
                        dictMutable.setValue("0", forKey: "isSelected")
                    }
                    arrSearch.add(dictMutable)
                }
                arrOfCerti = NSMutableArray.init(array: arrSearch)
                manageTag(arrTag: arrOfCerti)
            }
            else
            {
                
                arrSearch = NSMutableArray()
                for item in arrOfCerti
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    if dd.object(forKey: "isSelected") as! String == "0" || dd.object(forKey: "isSelected") as! String == "3" || dd.object(forKey: "isSelected") as! String == "2"
                    {
                        dictMutable.setValue("0", forKey: "isSelected")
                    }
                    arrSearch.add(dictMutable)
                }
                arrOfCerti = NSMutableArray.init(array: arrSearch)
                arrSearch = NSMutableArray()
                for item in arrOfCerti
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
                arrOfCerti = NSMutableArray.init(array: arrSearch)
                print(arrOfCerti)
                manageTag(arrTag: arrOfCerti)
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
            dictMutable.setValue(arrOfCerti.count, forKey: "index")
            dictMutable.setValue("0", forKey: "isSelected")
            dictMutable.setValue(txtSearch.text, forKey: "Name")
            dictMutable.setValue(0, forKey: "ID")
            dictMutable.setValue(false, forKey: "IsRequired")
            
            self.arrOfCerti.add(dictMutable)
            manageTag(arrTag: arrOfCerti)
            txtSearch.text = ""
            view.endEditing(true)
            return true
        }
        view.endEditing(true)
        return true
    }
    //MARK:- Call API
    func getAllCertificates()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(deleObj.dictOfCategories.value(forKey: "TitleIDs"), forKey: "TitleIDs")
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
                    
                    if self.deleObj.isForCatEdit == false
                    {
                        dictMutable.setValue(i, forKey: "index")
                        dictMutable.setValue("0", forKey: "isSelected")
                        self.arrOfCerti.add(dictMutable)
                    }
                    else
                    {
                        var flag: Bool = false
                        var arrCerti: NSMutableArray = NSMutableArray()
                        let arr: NSArray = self.deleObj.dictOfCategories.object(forKey: "CerficateFile") as! NSArray
                        arrCerti = NSMutableArray.init(array: arr)
                        var d: NSDictionary!
                        for certi in arrCerti
                        {
                             d = certi as! NSDictionary
                            if d.object(forKey: "CertificateID") as! Int == dictMutable.object(forKey: "ID") as! Int
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
                            DictselectedCerti.setValue(dictMutable.value(forKey: "ID"), forKey: "CertificateID")
                            DictselectedCerti.setValue(dictMutable.value(forKey: "Name"), forKey: "CertificateName")
                            
                            self.arrOfSelectedCerti.add(DictselectedCerti)
                            print(self.arrOfSelectedCerti)
                        }
                        else
                        {
                            dictMutable.setValue(i, forKey: "index")
                            dictMutable.setValue("0", forKey: "isSelected")
                        }
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
            print(self.arrOfCerti)
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
}

